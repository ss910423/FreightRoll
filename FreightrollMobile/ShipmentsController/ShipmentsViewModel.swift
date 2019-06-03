//
//  ShipmentsViewModel.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/20/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation

final class ShipmentsViewModel {
    enum Cell {
        case shipment(shipment: Shipment)
        case noShipments
        
        var cellHeight: Double {
            return 110
        }
    }
    
    private var shipments: [Shipment]?
    
    var didFetchShipmentsHandler: () -> () = {}
    
    var cells: [Cell] = []
    
    var numberOfCells: Int {
        return cells.count
    }
    func cellHeight(at index: Int) -> Double {
        return cells[index].cellHeight
    }
    
    func loadData() {
        getAPI().getShipments(delegate: self)
    }
    
    func getCells() -> [Cell] {
        var cells: [Cell] = []
        
        //cells.append(.map)
        if shipments?.count == 0 {
            cells.append(.noShipments)
            return cells
        }
        
        for shipment in shipments! {
            cells.append(.shipment(shipment: shipment))
        }
        
        return cells
    }
}
extension ShipmentsViewModel: GetShipmentsDelegate {
    func getShipmentsSuccess(shipments: [Shipment]) {
        self.shipments = shipments
        self.cells = getCells()
        
        didFetchShipmentsHandler()
    }
    func apiError(code: Int?, message: String) {
        
    }
    
}
