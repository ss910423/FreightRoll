//
//  AboutViewController.swift
//  FreightrollMobile
//
//  Created by Nick Forte on 8/27/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit
import UserNotifications

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    @IBAction func generateShipmentNotification(_ sender: UIButton) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Alert"
        content.body = "You've been dispatched a load."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
        
        let request = UNNotificationRequest(identifier: "dispatchedNotification", content: content, trigger: trigger)
        center.add(request)
    }
}
