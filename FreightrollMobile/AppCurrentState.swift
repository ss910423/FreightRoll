//
//  AppCurrentState.swift
//  FreightrollMobile
//
//  Created by Yevgeniy Motov on 4/18/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation

// In memory application state.
struct AppCurrentState {
    var userAvailable: Bool = false
    var liveShipments: [Shipment] = []
}
