//
//  LocalNotificationsHandler.swift
//  FreightrollMobile
//
//  Created by Yevgeniy Motov on 4/18/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationsHandler {
    private let center = UNUserNotificationCenter.current()
    
    func setup(delegate: UNUserNotificationCenterDelegate) {
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        center.delegate = delegate
    }
    
    func sendNotificationRequest(title: String,
                                 body: String,
                                 identifier: String,
                                 triggerInterval: TimeInterval,
                                 repeats: Bool = false)
    {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey:title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey:body, arguments: nil)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerInterval, repeats: repeats)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
