//
//  User.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/3/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    required init?(map: Map) {

    }

    init() {}

    var id: Int?
    var firstName: String?
    var lastName: String?
    var displayName: String?
    var image: URL?
    var about: String?
    var email: String?
    var password: String?
    var authToken: String?
    var role: String?
    var canBook: Bool?

    var billingInfo: ContactInfo?
    var shippingInfo: ContactInfo?
    var personalInfo: ContactInfo?

    var fullName : String {
        get {
            return " \(firstName ?? "") \(lastName ?? "")"
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]

        if id == nil {
            id <- map["user_id"]
        }

        firstName <- map["first_name"]
        lastName <- map["last_name"]
        displayName <- map["display_name"]
        image <- map["image"]
        about <- map["about_me"]
        email <- map["email"]
        password <- map["password"]
        authToken <- map["auth_token"]
        billingInfo <- map["billing_info"]
        shippingInfo <- map["shipping_info"]
        personalInfo <- map["personal_info"]
        role <- map["user_type"]
        canBook <- map["can_book"]
    }
}
