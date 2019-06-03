//
//  File.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/3/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

protocol APIErrorDelegate {
    func apiError(code: Int?, message: String)
}

protocol SigninDelegate: APIErrorDelegate {
    func signInSuccess(user: User)
}

protocol GetUserDelegate: APIErrorDelegate {
    func getUserSuccess(user: User)
}

protocol UpdateUserLocationDelegate: APIErrorDelegate {
    func updateUserLocationSuccess()
}

protocol GetAvailableShipmentsDelegate: APIErrorDelegate {
    func getAvailableShipmentsSuccess(shipments: [Shipment])
}

protocol AcceptShipmentDelegate: APIErrorDelegate {
    func acceptShipmentSuccess(shipment: Shipment)
}

protocol PickupShipmentDelegate: APIErrorDelegate {
    func pickupShipmentSuccess(shipment: Shipment)
}

protocol DeliveredShipmentDelegate: APIErrorDelegate {
    func deliveredShipmentSuccess(shipment: Shipment)
}

protocol GetShipmentsDelegate: APIErrorDelegate {
    func getShipmentsSuccess(shipments: [Shipment])
}

protocol GetShipmentChatDelegate: APIErrorDelegate {
    func getShipmentChatSuccess(chat: Chat)
}

protocol PostShipmentChatDelegate: APIErrorDelegate {
    func postShipmentChatSuccess(chat: Chat, message: String)
}

protocol GetPresignDelegate: APIErrorDelegate {
    func getPresignSuccess(presign: Presign)
}

protocol PostProofOfDeliveryDelegate: APIErrorDelegate {
    func postProofOfDeliverySuccess()
    func postProofOfDeliveryFailed()
}

protocol AvailabilityDelegate: APIErrorDelegate {
    func availabilitySuccess()
}

protocol SendCustomEventDelegate: APIErrorDelegate {
    func sendCustomEventSuccess()
}

protocol API {
    func signIn(user: User, delegate: SigninDelegate?)

    func getUser(delegate: GetUserDelegate?)

    func updateUserLocation(location: CLLocation, event: GpsEvent, delegate: UpdateUserLocationDelegate?)

    func getAvailableShipments(delegate: GetAvailableShipmentsDelegate?)

    func pickup(shipment: Shipment, delegate: PickupShipmentDelegate?)

    func accept(shipment: Shipment, delegate: AcceptShipmentDelegate?)

    func delivered(shipment: Shipment, delegate: DeliveredShipmentDelegate?)

    func getShipments(delegate: GetShipmentsDelegate?)

    func getShipmentChat(shipment: Shipment, delegate: GetShipmentChatDelegate?)

    func postShipmentChat(chat: Chat, message: String, delegate: PostShipmentChatDelegate?)
    
    func getPresign(delegate: GetPresignDelegate?)
    
    func postProofOfDelivery(presign: Presign, shipment: Shipment, fileSize: Int, delegate: PostProofOfDeliveryDelegate?)
    
    func availability(available: Bool, delegate: AvailabilityDelegate?)
}

func getAPI(authToken: String? = nil) -> API {
    if let authToken = authToken {
        print("auth token = \(authToken)")
        HttpAPI.shared = HttpAPI(authToken: authToken)
    }

    guard let api = HttpAPI.shared else {
        fatalError("cannot get shared API instance")
    }

    return api
}
