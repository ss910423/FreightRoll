//
//  Chat.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 12/18/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import ObjectMapper

class Chat: Mappable {
    required init?(map: Map) {}

    var id: Int?
    var createdAt: Date?
    var updatedAt: Date?
    var postUrl: URL?
    var wssUrl: URL?
    var name: String?
    var shipmentId: Int?
    var users: [User] = []
    var messages: [Message] = []

    func mapping(map: Map) {
        id <- map["id"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        postUrl <- (map["post_url"], URLTransform())
        wssUrl <- (map["wss_url"], URLTransform())
        name <- map["name"]
        shipmentId <- map["shipment_id"]
        users <- map["users"]
        messages <- map["messages"]
    }

    func user(message: Message) -> User? {
        for user in self.users {
            guard let userId = user.id, let messageUserId = message.userId, userId == messageUserId else { continue }

            return user
        }

        return nil
    }
}
