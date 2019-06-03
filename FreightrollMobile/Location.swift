//
//  Location.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/3/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import ObjectMapper

// NOTE: These need to match the values defined in gps_event.rb
enum GpsEvent: Int {
    case unknown = 0
    case ping = 1
    case geofence_enter = 2
    case geofence_exit = 3    
}

class Location: Mappable {
    required init?(map: Map) {

    }

    var lat: String?
    var lng: String?

    func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
}
