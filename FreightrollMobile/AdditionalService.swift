//
//  AdditionalService.swift
//  FreightrollMobile
//
//  Created by Alexander Cyr on 8/13/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation
import ObjectMapper

class AdditionalService: Mappable {
    required init?(map: Map) {}

    var name: String?
    var description: String?
    var unitLabel: String?
    var quantity: Int?
    var price: Double?
    
    func mapping(map: Map) {
        name <- map["name"]
        description <- map["description"]
        unitLabel <- map["unit_label"]
        quantity <- map["quantity"]
        price <- map["price_per_unit"]
    }
}

