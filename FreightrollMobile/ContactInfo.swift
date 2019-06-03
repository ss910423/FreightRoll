//
//  PersonInfo.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/3/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import ObjectMapper

class ContactInfo: Address {
    required init?(map: Map) {
        super.init(map: map)
    }

    var companyName: String?
    var personName: String?
    var email: String?
    var phone: String?
    var phoneExt: String?

    override func mapping(map: Map) {
        super.mapping(map: map)

        companyName <- map["company_name"]
        personName <- map["contact_person"]
        email <- map["email"]
        phone <- map["phone"]
        phoneExt <- map["phone_ext"]
    }
}
