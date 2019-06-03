//
//  Presign.swift
//  FreightrollMobile
//
//  Created by Freight Roll on 2/8/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation
import ObjectMapper
import MapKit

class Presign: NSObject, Mappable {
    required init?(map:Map) {
        
    }
    
    var key: String?
    var policy: String?
    var algorithm: String?
    var credential: String?
    var date: String?
    var signature: String?
    var id: String?
    var url: String?
    
    func mapping(map: Map){
        key <- (map["fields.key", nested:true])
        policy <- (map["fields.policy", nested:true])
        algorithm <- (map["fields.x-amz-algorithm", nested:true])
        credential <- (map["fields.x-amz-credential", nested:true])
        date <- (map["fields.x-amz-date", nested:true])
        signature <- (map["fields.x-amz-signature", nested:true])
        id <- (map["id"])
        url <- (map["url"])
    }
}
