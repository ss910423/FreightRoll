//
//  Message.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 12/18/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import ObjectMapper

class Message: Mappable {
    required init?(map: Map) {}

    var id: Int?
    var body: String?
    var createdAt: Date?
    var updatedAt: Date?
    var userId: Int?
    func mapping(map: Map) {
        id <- map["id"]
        body <- map["body"]
        createdAt <- (map["created_at"], DateFormatterTransform(dateFormatter: DateFormatter(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", locale: "en_US_POSIX")))
        updatedAt <- (map["updated_at"], DateFormatterTransform(dateFormatter: DateFormatter(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", locale: "en_US_POSIX")))
        userId <- map["user_id"]
    }
}
