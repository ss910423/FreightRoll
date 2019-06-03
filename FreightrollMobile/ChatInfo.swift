//
//  ChatInfo.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/18/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit

class ChatInfo: NSObject, NSCoding {
    
    var id: Int?
    var messageCount:Int?
    
    required init(n:Int, a:Int) {
        
        id = n
        messageCount = a
    }
    
    
    required init(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeObject(forKey: "id") as! Int
        messageCount = aDecoder.decodeObject(forKey: "messageCount") as! Int
    }
    
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(messageCount, forKey: "messageCount")
        
    }
}
