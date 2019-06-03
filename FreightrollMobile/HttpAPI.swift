//
//  HttpAPI.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/3/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import CoreLocation

class HttpAPI: API {

    static var shared: HttpAPI?

    internal var sessionManager: Alamofire.SessionManager

    init(authToken: String?) {

        sessionManager = Alamofire.SessionManager()
        if let token = authToken {
            sessionManager.adapter = AccessTokenAdapter(token: token)
            //sessionManager.adapter = ClientTokenAdapter()
        }
    }

    func signIn(user: User, delegate: SigninDelegate?) {
        sessionManager.request(ApiRequests.signIn(user: user)).validate().responseJSON { (response: Alamofire.DataResponse<Any>) -> Void in
            switch response.result {
            case .success(let value):
                // todo: use ObjectMapper or Codable protocol for deserializing json
                guard let json = value as? [String: Any], let authToken = json["auth_token"] as? String else {
                    delegate?.apiError(code: nil, message: "Cannot decode uath token")
                    return
                }

                user.authToken = authToken
                delegate?.signInSuccess(user: user)
            case .failure(let err):
                delegate?.apiError(code: nil, message: err.localizedDescription)
            }
        }
    }

    func getUser(delegate: GetUserDelegate?) {
        sessionManager.request(ApiRequests.user).validate().responseJSON { (response: Alamofire.DataResponse<Any>) -> Void in
            print("user", response)
            switch response.result {
            case .success(let value):
                guard let user = Mapper<User>().map(JSONObject: value) else {
                    delegate?.apiError(code: nil, message: "Cannot decode user")
                    return
                }

                delegate?.getUserSuccess(user: user)
            case .failure(let err):
                delegate?.apiError(code: nil, message: err.localizedDescription)
            }
        }
    }

    func updateUserLocation(location: CLLocation, event: GpsEvent, delegate: UpdateUserLocationDelegate?) {


        sessionManager.request(ApiRequests.updateLocation(
            lat: String(location.coordinate.latitude),
            lng: String(location.coordinate.longitude),
            speed: Double(location.speed),
            accuracy: Double(location.horizontalAccuracy),
            event: event.rawValue,
            localTimestamp: Int64(floor(location.timestamp.timeIntervalSince1970)))
            ).validate().responseJSON { (response: Alamofire.DataResponse<Any>) -> Void in
            switch response.result {
            case .success:
                delegate?.updateUserLocationSuccess()
            case .failure(let err):
                delegate?.apiError(code: nil, message: err.localizedDescription)
            }
        }
    }

    func getAvailableShipments(delegate: GetAvailableShipmentsDelegate?) {
        sessionManager.request(ApiRequests.liveShipments).validate().responseJSON { (response: Alamofire.DataResponse<Any>) -> Void in
            print("response", response)
            switch response.result {
            case .success(let value):
                guard let shipments = Mapper<Shipment>().mapArray(JSONObject: value) else {
                    delegate?.apiError(code: nil, message: "Cannot decode shipments")
                    return
                }

                delegate?.getAvailableShipmentsSuccess(shipments: shipments)
            case .failure(let err):
                delegate?.apiError(code: nil, message: err.localizedDescription)
            }
        }
    }

    func accept(shipment: Shipment, delegate: AcceptShipmentDelegate?) {
        sessionManager.request(ApiRequests.accept(shipment: shipment)).validate().responseJSON { (response: Alamofire.DataResponse<Any>) -> Void in
            switch response.result {
            case .success(let value):
                guard let shipment = Mapper<Shipment>().map(JSONObject: value), let shipmentId = shipment.id else {
                    delegate?.apiError(code: nil, message: "Cannot decode shipments")
                    return
                }

                UserDefaults.standard.set(shipmentId, forKey: Const.liveShipId)

                delegate?.acceptShipmentSuccess(shipment: shipment)
            case .failure(let err):
                delegate?.apiError(code: nil, message: err.localizedDescription)
            }
        }
    }

    func pickup(shipment: Shipment, delegate: PickupShipmentDelegate?) {
        sessionManager.request(ApiRequests.pickup(shipment: shipment)).validate().responseJSON { (response: Alamofire.DataResponse<Any>) -> Void in
            switch response.result {
            case .success(let value):
                guard let shipment = Mapper<Shipment>().map(JSONObject: value) else {
                    delegate?.apiError(code: nil, message: "Cannot decode shipments")
                    return
                }

                delegate?.pickupShipmentSuccess(shipment: shipment)
            case .failure(let err):
                delegate?.apiError(code: nil, message: err.localizedDescription)
            }
        }
    }

    func delivered(shipment: Shipment, delegate: DeliveredShipmentDelegate?) {
        sessionManager.request(ApiRequests.delivered(shipment: shipment)).validate().responseJSON { (response: Alamofire.DataResponse<Any>) -> Void in
            switch response.result {
            case .success:
                UserDefaults.standard.set(nil, forKey: Const.liveShipId)
                delegate?.deliveredShipmentSuccess(shipment: shipment)
            case .failure(let err):
                delegate?.apiError(code: nil, message: err.localizedDescription)
            }
        }
    }

    func getShipments(delegate: GetShipmentsDelegate?) {
        sessionManager.request(ApiRequests.shipments).validate().responseJSON { (response: Alamofire.DataResponse<Any>) -> Void in
            print("shipments", response)
            switch response.result {
            case .success(let value):
                guard let shipments = Mapper<Shipment>().mapArray(JSONObject: value) else {
                    delegate?.apiError(code: nil, message: "Cannot decode shipments")
                    return
                }

                print("received shipments = \(shipments)")

                delegate?.getShipmentsSuccess(shipments: shipments)
            case .failure(let err):
                delegate?.apiError(code: nil, message: err.localizedDescription)
            }
        }
    }

    func getShipmentChat(shipment: Shipment, delegate: GetShipmentChatDelegate?) {
        sessionManager.request(ApiRequests.shipmentChat(shipment: shipment)).validate().responseJSON { (response: Alamofire.DataResponse<Any>) -> Void in
            switch response.result {
            case .success(let value):
                guard let chat = Mapper<Chat>().map(JSONObject: value) else {
                    delegate?.apiError(code: nil, message: "Cannot decode shipment chat")
                    return
                }

                print("received chat = \(chat)")

                delegate?.getShipmentChatSuccess(chat: chat)
            case .failure(let err):
                delegate?.apiError(code: nil, message: err.localizedDescription)
            }
        }
    }

    func postShipmentChat(chat: Chat, message: String, delegate: PostShipmentChatDelegate?) {
        sessionManager.request(ApiRequests.shipmentChatMessage(chat: chat, message: message)).validate().responseJSON { (response: Alamofire.DataResponse<Any>) -> Void in
            switch response.result {
            case .success:
                delegate?.postShipmentChatSuccess(chat: chat, message: message)
            case .failure(let err):
                delegate?.apiError(code: nil, message: err.localizedDescription)
            }
        }
    }

    func getPresign(delegate: GetPresignDelegate?) {
        sessionManager.request(ApiRequests.presign).validate().responseJSON { (response: Alamofire.DataResponse<Any>) -> Void in
            switch response.result {
                case .success(let value):
                    guard let presign = Mapper<Presign>().map(JSONObject: value) else {
                        delegate?.apiError(code: nil, message: "Cannot decode presign response")
                        return
                    }
                    print("Success! Presign Response: ", value)
                    delegate?.getPresignSuccess(presign: presign)
                    return
                case .failure(let err):
                    print("Error! Error Description: ", err.localizedDescription)
            }
        }
    }

    func postProofOfDelivery(presign: Presign, shipment: Shipment, fileSize: Int, delegate: PostProofOfDeliveryDelegate?) {
        let urlRequest = ApiRequests.proofOfDelivery(shipment: shipment, presign: presign, fileSize: fileSize)
        // TODO: remove workaround when POD back-end has been updated
        sleep(5)
        // Server is returning an empty response, which is correct per standards.
        // We don't try to parse out JSON as it will cause a serialization error.
        sessionManager.request(urlRequest).validate().responseString { response in
            switch response.result {
            case .success(let value):
                print("Success! Proof Of Delivery Response: ", value)
                delegate?.postProofOfDeliverySuccess()
                return
            case .failure(let error):
                print("Error upload POD to FreightRoll! Error Description: ", error.localizedDescription)
                delegate?.postProofOfDeliveryFailed()
            }
        }
    }

    func availability(available: Bool, delegate: AvailabilityDelegate?) {

        let urlRequest = ApiRequests.availability(available: available)

        sessionManager.request(urlRequest).validate().responseJSON { (response: Alamofire.DataResponse<Any>) -> Void in
            switch response.result {
            case .success:
                delegate?.availabilitySuccess()
            case .failure(let err):
                print("Error! Error Description: ", err.localizedDescription)
            }
        }
    }
}
