//
//  PendingNotification.swift
//  Local-Notification-Lab
//
//  Created by Liubov Kaper  on 2/23/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import Foundation
import UserNotifications

class PendingNotification {
    public func getPandingNotifications(completion: @escaping ([UNNotificationRequest]) -> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print("There are \(requests.count) pending requests")
            completion(requests)
        }
    }
}
