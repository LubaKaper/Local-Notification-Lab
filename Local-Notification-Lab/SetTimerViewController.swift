//
//  SetTimerViewController.swift
//  Local-Notification-Lab
//
//  Created by Liubov Kaper  on 2/23/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit

protocol SetTimerControllerDelegate: AnyObject {
    func didCreateTimer(_ setTimerController: SetTimerViewController)
}

class SetTimerViewController: UIViewController {

    
    @IBOutlet weak var messageTextField: UITextField!
    
    
    @IBOutlet weak var timerPicker: UIDatePicker!
    
    weak var delegate: SetTimerControllerDelegate?
    
    private var timeInterval: TimeInterval = Date().timeIntervalSinceNow + 5
        
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    private func createLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = messageTextField.text ?? "no title"
        //content.body = "\(timeInterval.description) minutes"
        content.subtitle = " \((timeInterval / 60).description) minutes"
        content.sound = .default
        
        
        let identifier = UUID().uuidString
        
        if let imageURL = Bundle.main.url(forResource: "IMG_0279", withExtension: "JPG") {
            do {
               let attachment = try UNNotificationAttachment(identifier: identifier, url: imageURL, options: nil)
                content.attachments = [attachment]
            } catch {
                print("error with attachment \(error)")
            }
        } else {
            print("image resource could not be found")
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("error adding request \(error)")
            } else {
                print("request was successfully added")
            }
        }
    }
    
    
    
    @IBAction func timeChange(_ sender: UIDatePicker) {
//            guard sender.date > Date() else { return }
                       // timeintervalsincenow creates a time stamp of the exact date
        //               timeInterval = sender.date.timeIntervalSinceNow
                timeInterval = sender.countDownDuration//date.timeIntervalSinceNow
        //        print(sender.countDownDuration)
    }
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
       
        createLocalNotification()
        
        delegate?.didCreateTimer(self)
        dismiss(animated: true)
    }
    
    
    @IBAction func startButtonPressed(_ sender: Any) {
        
        
    }
    
}

