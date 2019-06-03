//
//  ArchiveUtil.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/18/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//
//  https://stackoverflow.com/questions/19720611/attempt-to-set-a-non-property-list-object-as-an-nsuserdefaults
//

import UIKit

class ArchiveUtil {
    
    private static let ChatKey = "ChatKey"
    private static let NotificationKey = "NotificationKey"
    
    private static func archiveChat(chat : [ChatInfo]) -> NSData {
        
        return NSKeyedArchiver.archivedData(withRootObject: chat as NSArray) as NSData
    }
    
    static func loadChat() -> [ChatInfo]? {
        
        if let unarchivedObject = UserDefaults.standard.object(forKey: ChatKey) as? Data {
            
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? [ChatInfo]
        }
        
        return nil
    }
    
    static func saveChat(chat : [ChatInfo]?) {
        
        let archivedObject = archiveChat(chat: chat!)
        UserDefaults.standard.set(archivedObject, forKey: ChatKey)
        UserDefaults.standard.synchronize()
    }
    
    private static func archiveNotification(notification : [NotificationObj]) -> NSData {
        
        return NSKeyedArchiver.archivedData(withRootObject: notification as NSArray) as NSData
    }
    
    static func loadNotification() -> [NotificationObj]? {
        
        if let unarchivedObject = UserDefaults.standard.object(forKey: NotificationKey) as? Data {
            
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? [NotificationObj]
        }
        
        return nil
    }
    
    static func saveNotification(notification : [NotificationObj]?) {
        
        let archivedObject = archiveNotification(notification: notification!)
        UserDefaults.standard.set(archivedObject, forKey: NotificationKey)
        UserDefaults.standard.synchronize()
    }
    
}
