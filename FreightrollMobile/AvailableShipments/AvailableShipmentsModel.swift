//
//  AvailableShipmentsModel.swift
//  FreightrollMobile
//
//  Created by Yevgeniy Motov on 4/20/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

enum AvailableShipmentCell {
    case available(isAvailable: Bool)
    case map
    case shipment(shipment: Shipment)
    case headingTo(label: String?)
    case desiredDestination(label: String?)
    case deadhead(label: String?)
    case noShipments
    case empty
    case spacing
    case field(label: String?)
    
    func cellHeight(tableViewHeight: CGFloat, mainScreenWidth: CGFloat) -> CGFloat {
        let isAvailable = UserDefaults.standard.bool(forKey: "isAvailable")
        
        switch self {
        case .available:
            return tableViewHeight * 5/64
        case .map:
            return isAvailable ? mainScreenWidth : tableViewHeight * 25/32
        case .shipment:
            return isAvailable ? 110 : 0
        case .headingTo:
            return 0
        case .desiredDestination:
            return 0
        case .deadhead:
            return 0
        case .noShipments:
            return isAvailable ? tableViewHeight * 7/64 : tableViewHeight * 9/64
        case .empty:
            return 150
        case .spacing:
            return 10
        case .field:
            return 40
        }
    }
}

class AvailableShipmentsModel {
    enum Sort: String {
        case byRelevance = "By Relevance"
        case byRate = "By Rate"
        case byDistance = "By Distance"
        case byPickupDate = "By Pickup Date"
        case byDeliveryDate = "By Delivery Date"
        
        static var defaultSort: Sort {
            return .byRelevance
        }
    }
    
    init() {}
    
    var shipmentsSortedCallback: () -> () = {}
    
    var shipments: [Shipment] = [] {
        didSet {
            sortShipments()
        }
    }
    var sortedShipments: [Shipment] = []
    
    var numberOfShipments: Int {
        return shipments.count
    }
    
    var  dates = [Date: [Shipment]]()
    var cells: [AvailableShipmentCell] = []
    
    var numberOfCells: Int {
        return cells.count
    }
    
    var headingToAnnotation: MKPointAnnotation? // currently part of VC.. revisit
    
    var sortBy: Sort {
        get {
            let sortByRaw = UserDefaults.standard.string(forKey: "sortBy") ?? ""
            return Sort(rawValue: sortByRaw) ?? Sort.defaultSort
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "sortBy")
        }
    }
    
    var sortByToggle: Bool {
        get {
            // if 'sortByToggle' isn't set -> return default value as True
            if UserDefaults.standard.object(forKey: "sortByToggle") == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: "sortByToggle")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "sortByToggle")
            sortShipments()
        }
    }
    
    func cellHeight(at index: Int, tableViewHeight: CGFloat, mainScreenWidth: CGFloat) -> CGFloat {
        return cells[index].cellHeight(tableViewHeight: tableViewHeight, mainScreenWidth: mainScreenWidth)
    }
    
    func sortShipments(){
        sortedShipments = shipments
        
        dates.removeAll()
        var desiredDate = Date()
        if let date = UserDefaults.standard.string(forKey: "desired_date") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            desiredDate = dateFormatter.date(from: date)!
        }
        sortedShipments = self.shipments.filter { $0.pickupAtLatest! > desiredDate}
        if let truck = UserDefaults.standard.string(forKey: "truckType") {
            if truck != "Show All"{
                sortedShipments = sortedShipments.filter { $0.truck == TruckType(rawValue: truck) }
            }
        }
        
        switch (sortBy) {
        case .byRelevance:
            sortedShipments = sortedShipments.sorted(by: { (a, b) -> Bool in
                if let shipmentA = a.pickup?.location, let shipmentB = b.pickup?.location, let headingToLoc = self.headingToAnnotation?.coordinate {
                    let loc = CLLocation(latitude: shipmentA.coordinate.latitude, longitude: shipmentA.coordinate.longitude)
                    let loc2 = CLLocation(latitude: shipmentB.coordinate.latitude, longitude: shipmentB.coordinate.longitude)
                    let desiredLoc = CLLocation(latitude: headingToLoc.latitude, longitude: headingToLoc.longitude)
                    let distanceA = (loc.distance(from: desiredLoc) / 1609.34)
                    let distanceB = (loc2.distance(from: desiredLoc) / 1609.34)
                    
                    return distanceA < distanceB
                }
                else{
                    return a.id! < b.id!
                }         
            })
        case .byRate:
            sortedShipments = sortedShipments.sorted(by: { (a, b) -> Bool in
                return Double(a.rate!)! < Double(b.rate!)!
            })
        case .byDistance:
            sortedShipments = sortedShipments.sorted(by: { (a, b) -> Bool in
                return a.distance! < b.distance!
            })
        case .byPickupDate:
            sortedShipments = sortedShipments.sorted(by: { (a, b) -> Bool in
                return a.pickupAt! < b.pickupAt!
            })
        case .byDeliveryDate:
            sortedShipments = sortedShipments.sorted(by: { (a, b) -> Bool in
                return a.dropoffAt! < b.dropoffAt!
            })
        }
        
        cells = setupCells(shipments: sortByToggle ? sortedShipments : sortedShipments.reversed())
        
        shipmentsSortedCallback()
    }
    
    func setupCells(shipments: [Shipment]) -> [AvailableShipmentCell] {
        var cells: [AvailableShipmentCell] = []
        
        cells.append(.map)
        cells.append(.available(isAvailable: AppDelegate.sharedAppDelegate().appCurrentState.userAvailable))
        
        cells.append(.noShipments)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("EEE, MMM d")
        var date = ""
        for shipment in shipments {
            if sortBy == Sort.byPickupDate{
                if dateFormatter.string(for: shipment.pickupAt) != date{
                    date = dateFormatter.string(for: shipment.pickupAt)!
                    cells.append(.spacing)
                    cells.append(.field(label: date))
                }
            }
            if sortBy == Sort.byDeliveryDate{
                if dateFormatter.string(for: shipment.dropoffAt) != date{
                    date = dateFormatter.string(for: shipment.dropoffAt)!
                    cells.append(.spacing)
                    cells.append(.field(label: date))
                }
            }
            cells.append(.shipment(shipment: shipment))
        }
        if shipments.isEmpty{
            cells.append(.empty)
        }
        
        return cells
    }
    
    func updateCells() {
        cells = setupCells(shipments: shipments)
    }
}

extension AvailableShipmentsModel: SortByAlertViewDelegate {
    func sortTapped(selectedOption: String) {
        sortBy = Sort(rawValue: selectedOption) ?? Sort.defaultSort
        
        sortShipments()
    }
}
