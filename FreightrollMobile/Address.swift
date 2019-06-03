//
//  Address.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/3/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import MapKit

class Address: NSObject, Mappable {
    required init?(map: Map) {

    }
    var title: String?
    var street: String?
    var city: String?
    var state: String?
    var postalCode: String?
    var region: CLCircularRegion? {
        return nil
    }
    var lat: String?
    var lng: String?
    var geofenceRadius: Double?
    var appointmentNeeded: Bool?

    func mapping(map: Map) {
        street <- map["address"]
        city <- map["city"]
        state <- map["state"]
        postalCode <- map["zip_code"]

        lat <- map["lat"]
        lng <- map["lon"]
        
        geofenceRadius <- (map["geofencing.geofencing_radius", nested:true])
        appointmentNeeded <- map["appointment_needed"]
    }

    var destination: String? {
        if let city = self.city, let state = self.state {
            return "\(city), \(state)"
        }

        if let postalCode = self.postalCode {
            return postalCode
        }

        return nil
    }

    var location: CLLocation? {
        if self.coordinate.latitude == 0.0 && self.coordinate.longitude == 0.0 {
            return nil
        }
        
        return CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
}

extension Address: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        guard let lats = self.lat, let lngs = self.lng, let lat = Double(lats), let lng = Double(lngs) else {
            return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }

        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }

  

    var subtitle: String? {
        return nil
    }
}
