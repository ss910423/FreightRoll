//
//  File.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/3/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import ObjectMapper
import UIKit

enum TruckType: String {
    case flatbed = "flatbed"
    case dryVan = "dry_van"
    case stepDeck = "step_deck"
    case LTL = "ltl"
    
    var readable: String {
        switch self {
        case .flatbed:
            return "Flatbed"
        case .dryVan:
            return "Dry Van"
        case .stepDeck:
            return "Step Deck"
        case .LTL:
            return "LTL"
        }
    }
}

class Shipment: Mappable {

    init(id: Int) {
        self.id = id
    }

    required init?(map: Map) {}

    enum Status: String {
        case accepted = "truck_found"
        case inTransit = "in_transit"
        case delivered = "delivered"
        case jammed = "jammed"
        case canceled = "canceled"
        case finished = "finished"
        case available = "waiting"
        case awaitingConfirm = "awaiting_confirmation"
        case dispatcherConfirm = "dispatcher_confirm"
    }

    var id: Int?
    var distance: Int?
    var pickup: Address?
    var pickupAt: Date?
    var pickupAtLatest: Date?
    var pickupAppointment: Bool?
    var pickupInstructions: String?
    var dropoff: Address?
    var dropoffAt: Date?
    var dropoffAtLatest: Date?
    var dropoffAppointment: Bool?
    var dropoffInstructions: String?
    var dropoffCompany: String?
    var dropoffPerson: String?
    var dropoffEmail: String?
    var dropoffPhone: String?
    var truck: TruckType?
    var rate: String?
    var weight: Int?
    var status: Status = .available
    var commodity: String?
    var pickupCompany: String?
    var pickupPerson: String?
    var pickupEmail: String?
    var pickupPhone: String?
    var additionalServices: [AdditionalService]?


    func stringDisplay() -> String {
        let idString: String = String(describing: self.id!)
        let dropoffDestinationString: String = String(describing: self.dropoff!.destination!)
        
        let stringDisplay: String = idString + " " + dropoffDestinationString
        
        return stringDisplay
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        distance <- map["distance"]
        pickup <- map["pickup"]
        dropoff <- map["dropoff"]
        truck <- map["truck_type"]
        commodity <- map["commodity"]
        rate <- map["rate"]
        weight <- map["weight"]
        pickupAt <- (map["pickup.date", nested: true], DateFormatterTransform(dateFormatter: DateFormatter(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", locale: "en_US_POSIX")))
        pickupAtLatest <- (map["pickup.latest_date", nested: true], DateFormatterTransform(dateFormatter: DateFormatter(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", locale: "en_US_POSIX")))
        dropoffAt <- (map["dropoff.date", nested: true], DateFormatterTransform(dateFormatter: DateFormatter(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", locale: "en_US_POSIX")))
        dropoffAtLatest <- (map["dropoff.latest_date", nested: true], DateFormatterTransform(dateFormatter: DateFormatter(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", locale: "en_US_POSIX")))
        status <- map["status"]
        pickupCompany <- (map["pickup.company_name", nested: true])
        pickupPerson <- (map["pickup.contact_person", nested: true])
        pickupEmail <- (map["pickup.email", nested: true])
        pickupPhone <- (map["pickup.phone", nested: true])
        pickupAppointment <- (map["pickup.appointment_needed", nested: true])
        pickupInstructions <- (map["pickup.other_instructions", nested: true])
        dropoffAppointment <- (map["dropoff.appointment_needed", nested: true])
        dropoffInstructions <- (map["dropoff.other_instructions", nested: true])
        dropoffCompany <- (map["dropoff.company_name", nested: true])
        dropoffPerson <- (map["dropoff.contact_person", nested: true])
        dropoffPhone <- (map["dropoff.phone", nested: true])
        dropoffEmail <- (map["dropoff.email", nested: true])
        additionalServices <- map["additional_services"]



    }
}
