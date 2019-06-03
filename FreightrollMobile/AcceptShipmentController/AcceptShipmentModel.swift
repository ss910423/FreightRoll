//
//  AcceptShipmentModel.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/21/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation
import UIKit

final class AcceptShipmentModel{
    
    enum Cell {
        case field(label: String, value: String?)
        case bid
        case map
        case available(isAvailable: Bool)
        case waiting
        case pickup
        case delivered
        case uploadPOD
        case heading(label: String)
        case description(label: String, value: String?)
        case serviceDescription(label: String, value: String?, info: String?)
        case spacing
        
        var cellHeight: CGFloat {
            switch self {
            case .map:
                return CGFloat(accountViewMapHeight)
            case .bid:
                // return 108 // with submit bid button
                return 70
            case .field:
                return 50
            case .available:
                return 30
            case .waiting:
                return 70
            case .pickup:
                return 80
            case .delivered:
                return 80
            case .uploadPOD:
                return 80
            case .heading:
                return 40
            case .description:
                return 0
            case .serviceDescription:
                return UITableViewAutomaticDimension
            case .spacing:
                return 20
            }
        }
    }
    
    var cells: [Cell] = []
    
    var numberOfCells: Int {
        return cells.count
    }
    func cellHeight(at index: Int) -> CGFloat {
        return cells[index].cellHeight
    }
    
    func loadData(shipment: Shipment){
        cells = getCells(shipment: shipment)
    }

    func getCells(shipment: Shipment) -> [Cell] {
        var cells: [Cell] = []
        var confirmed = false

        /*
         if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
         cells.append(Cell.available(isAvailable: appDelegate.userAvailable))
         }
         */
        
        cells.append(Cell.map)
        
        /*
        let statusLabel = UILabel( frame: CGRect(x: 15, y: (Int(tableView.bounds.height / 2)) - 110, width: 100, height: 22))
        statusLabel.layer.zPosition = 1
        statusLabel.layer.cornerRadius = 11
        statusLabel.layer.borderWidth = 1
        statusLabel.font = UIFont.systemFont(ofSize: 15)
        statusLabel.textAlignment = .center
        statusLabel.textColor = UIColor.white
        */
        if shipment.status == .awaitingConfirm || shipment.status == .dispatcherConfirm{
            cells.append(.waiting)
            
        }
        else{
            confirmed = true
        }
        
        if shipment.status == .accepted {
            cells.append(.pickup)
        }
        
        if shipment.status == .inTransit {
            cells.append(.delivered)
            /*
            statusLabel.text = "Picked Up"
            statusLabel.layer.backgroundColor = UIColor.app_orange.cgColor
            statusLabel.layer.borderColor = UIColor(red:1, green:0.58, blue:0, alpha:1).cgColor
            tableView.addSubview(statusLabel)
 */
            
        }
        if shipment.status == .delivered {
            cells.append(.uploadPOD)
            /*
            statusLabel.text = "Delivered"
            statusLabel.layer.backgroundColor = UIColor(red:0, green:0.8, blue:0, alpha:1).cgColor
            statusLabel.layer.borderColor = UIColor(red:0, green:0.8, blue:0, alpha:1).cgColor
            tableView.addSubview(statusLabel)
 */
            
        }
        cells.append(Cell.field(label: "Rate", value: "$\(shipment.rate ?? "not provided")" ))

        cells.append(Cell.field(label: "Commodity", value: shipment.commodity?.capitalized))
        
        cells.append(Cell.field(label: "Truck Type", value: shipment.truck?.readable))
        
        cells.append(Cell.field(label: "Weight", value: "\(Int.unwrapStr(shipment.weight))lbs"))
        
        if shipment.status == .available {
            cells.append(Cell.bid)
            confirmed = false
        }
        
        if let services = shipment.additionalServices {
            if services.count > 0 {
                cells.append(Cell.spacing)
                cells.append(Cell.heading(label: "Additional Services"))
            }
            
            for service in services {
                if let description = service.description {
                    cells.append(Cell.serviceDescription(label: "\(service.name ?? "")", value: "\(description)", info: "\(service.quantity ?? 0)\(service.unitLabel ?? "")"))
                }
                else {
                    if let unit = service.unitLabel{
                        cells.append(Cell.field(label: service.name ?? "", value: "\(service.quantity ??  0) \(service.quantity == 1 ? unit : "\(unit)s")"))
                    }
                    else {
                        cells.append(Cell.field(label: service.name ?? "", value: "✓" ))
                    }
                }
            }
        }

        cells.append(Cell.spacing)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM dd")
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US")
        timeFormatter.timeZone = TimeZone(identifier: "US/Eastern")
        timeFormatter.setLocalizedDateFormatFromTemplate("HH:mm zzz")
        
        cells.append(Cell.heading(label: "Pickup Information"))
        
        if confirmed {
            cells.append(Cell.description(label: "Company", value: "\(shipment.pickupCompany ?? "")\n\(shipment.pickupPerson ?? "" )\(shipment.pickupPerson == "" ? "" : "\n")\(shipment.pickupPhone?.toPhoneNumber() ?? "")\n" ))
            
            cells.append(Cell.description(label: "Location", value: "\(shipment.pickup?.street != nil ? "\(shipment.pickup?.street ?? "")\n" : "")\(shipment.pickup?.city ?? "") \(shipment.pickup?.state ?? "") \(shipment.pickup?.postalCode ?? "")\n"))
        }
        else {
            cells.append(Cell.description(label: "Address", value: "\(shipment.pickup?.city ?? ""), \(shipment.pickup?.state ?? "") \(shipment.pickup?.postalCode ?? "")\n"))
        }
        cells.append(Cell.description(label: "Appointment", value: shipment.pickupAppointment! ? "Yes\n" : "No\n"))

        cells.append(Cell.description(label: "Date Range", value: "\(dateFormatter.string(for: shipment.pickupAt) ?? "") - \(dateFormatter.string(for: shipment.pickupAtLatest) ?? "")\n"))
        cells.append(Cell.description(label: "Shipping Hours", value: "\(timeFormatter.string(for: shipment.pickupAt ) ?? "") - \(timeFormatter.string(for: shipment.pickupAtLatest) ?? "")\n"))
        cells.append(Cell.description(label: "Pickup Instructions", value: "\(shipment.pickupInstructions ?? "")\n"))
        cells.append(Cell.spacing)
        
        cells.append(Cell.heading(label: "Dropoff Information"))
        
        if confirmed {
            cells.append(Cell.description(label: "Company", value: "\(shipment.dropoffCompany ?? "")\n\(shipment.dropoffPerson ?? "" )\(shipment.pickupPerson == "" ? "" : "\n")\(shipment.dropoffPhone?.toPhoneNumber() ?? "")\n" ))
            
            cells.append(Cell.description(label: "Address", value: "\(shipment.dropoff?.street != nil  ? "\(shipment.dropoff?.street ?? "")\n" : "")\(shipment.dropoff?.city ?? "") \(shipment.dropoff?.state ?? "not provided") \(shipment.dropoff?.postalCode ?? "")\n"))
        }
        else {
            cells.append(Cell.description(label: "Address", value: "\(shipment.dropoff?.city ?? ""), \(shipment.dropoff?.state ?? "") \(shipment.dropoff?.postalCode ?? "")\n"))
        }
        cells.append(Cell.description(label: "Appointment", value: shipment.dropoffAppointment! ? "Yes\n" : "No\n"))
        cells.append(Cell.description(label: "Date Range", value: "\(dateFormatter.string(for: shipment.dropoffAt) ?? "") - \(dateFormatter.string(for: shipment.dropoffAtLatest) ?? "")\n"))
        cells.append(Cell.description(label: "Shipping Hours", value: "\(timeFormatter.string(for: shipment.dropoffAt) ?? "") - \(timeFormatter.string(for: shipment.dropoffAtLatest) ?? "")\n"))
        cells.append(Cell.description(label: "Dropoff Instructions", value: "\(shipment.dropoffInstructions ?? "")\n"))
        cells.append(Cell.spacing)

        return cells
    }
    
}
