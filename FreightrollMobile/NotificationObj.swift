//
//  NotificationObj.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/19/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation

class NotificationObj: NSObject {
    
    var shipment: Shipment?
    var title: String?
    var body: String?
    var isMessage = false
    var isNew = true
    var id: Int
    var timeTag = 0
    
    required init(t: String, b:String, ship: Shipment, time: Int) {
        id = ship.id!
        title = t
        body = b
        timeTag = time
    }

    required init(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeObject(forKey: "id") as! Int
        title = aDecoder.decodeObject(forKey: "title") as! String
        body = aDecoder.decodeObject(forKey: "body") as! String
        timeTag = aDecoder.decodeObject(forKey: "timeTag") as! Int
    }

    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(body, forKey: "body")
        aCoder.encode(timeTag, forKey: "timeTag")
        
    }
    
}
