//
//  ViewController.swift
//  Local-Notification-Lab
//
//  Created by Liubov Kaper  on 2/21/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit
import UserNotifications

class ManageTimersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var notifications = [UNNotificationRequest]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let center = UNUserNotificationCenter.current()
    
    private let pendingNotification = PendingNotification()
    
    private var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        configureRefreshControl()
        checkForNotificationAuthorization()
        loadNotifications()
        center.delegate = self
        
    }

    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadNotifications), for: .valueChanged)
    }
    
    @objc private func loadNotifications() {
        pendingNotification.getPandingNotifications { (requests) in
            self.notifications = requests
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navVC = segue.destination as? UINavigationController, let setTimerVC = navVC.viewControllers.first as? SetTimerViewController else {
            fatalError("could not downcast to SetTimerViewController")
        }
        setTimerVC.delegate = self
    }
    
    private func checkForNotificationAuthorization() {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("app is authorized for notifications")
            } else {
                self.requestNotificationPermission()
            }
        }
    }
    
    private func requestNotificationPermission() {
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("error requesting authorization \(error)")
                return
            }
            if granted {
                print("access was granted")
            } else {
                print("access denied")
            }
        }
    }
}

extension ManageTimersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        let notification = notifications[indexPath.row]
        cell.textLabel?.text = notification.content.title
        cell.detailTextLabel?.text = notification.content.body
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeNotification(atIndexPath: indexPath)
        }
    }
    
    private func removeNotification(atIndexPath indaxPath: IndexPath) {
        let notification = notifications[indaxPath.row]
        let identifiewr = notification.identifier
        
        center.removePendingNotificationRequests(withIdentifiers: [identifiewr])
        notifications.remove(at: indaxPath.row)
        tableView.deleteRows(at: [indaxPath], with: .automatic)
    }
}

extension ManageTimersViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

extension ManageTimersViewController: SetTimerControllerDelegate {
    func didCreateTimer(_ setTimerController: SetTimerViewController) {
        loadNotifications()
    }
    
    
}
