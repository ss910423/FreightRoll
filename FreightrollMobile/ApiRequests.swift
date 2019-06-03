//
//  ApiRequests.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 12/26/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import Alamofire

enum ApiRequests: URLRequestConvertible {
    case signIn(user: User)
    case liveShipments
    case user
    case accept(shipment: Shipment)
    case delivered(shipment: Shipment)
    case pickup(shipment: Shipment)
    case updateLocation(lat: String, lng: String, speed: Double, accuracy: Double, event: Int, localTimestamp: Int64)
    case shipments
    case shipmentChat(shipment: Shipment)
    case shipmentChatMessage(chat: Chat, message: String)
    case presign
    case proofOfDelivery(shipment: Shipment, presign: Presign, fileSize: Int)
    case availability(available: Bool)

//    static let baseURLString = "https://www.freightroll.com/api"
    // static let baseURLString = "https://staging.freightroll.com/api"
    static let baseURLString = "https://freightroll-demo.herokuapp.com/api"
    // static let baseURLString = "https://freightroll-alt.test/api"

    var method: HTTPMethod {
        switch self {
        case .signIn:
            return .post
        case .liveShipments:
            return .get
        case .user:
            return .get
        case .accept:
            return .post
        case .updateLocation:
            return .post
        case .delivered:
            return .post
        case .pickup:
            return .post
        case .shipments:
            return .get
        case .shipmentChat:
            return .get
        case .shipmentChatMessage:
            return .post
        case .presign:
            return .get
        case .proofOfDelivery:
            return .post
        case .availability:
            return .put
        }
    }

    var path: String {
        switch self {
        case .signIn:
            return "/sign_in"
        case .liveShipments:
            return "/shipments/live"
        case .user:
            return "/user"
        case .accept(let shipment):
            return "/shipments/\(shipment.id!)/accept"
        case .delivered(let shipment):
            return "/shipments/\(shipment.id!)/delivered"
        case .pickup(let shipment):
            return "/shipments/\(shipment.id!)/pick_up"
        case .updateLocation:
            return "/user/location"
        case .shipments:
            return "/shipments"
        case .shipmentChat(let shipment):
            return "/shipments/\(shipment.id!)/collaboration"
        case .shipmentChatMessage(let chat, _):
            return ""
        case .presign:
            return "/attachments/cache/presign"
        case .proofOfDelivery(let shipment, let presign, let fileSize):
            return "/shipments/\(shipment.id!)/pod"
        case .availability(let available):
            return "/user/availability"
        }
    }

    var params: Parameters {
        switch self {
        case .signIn(let user):
            // this pattern will get unwiedely, in the future opt for a presenter that returns
            // the parameters given a model or models
            guard let email = user.email, let pass = user.password else {
                break
            }

            return ["email": email, "password": pass]

        case .updateLocation(let lat, let lng, let speed, let accuracy, let event, let localTimestamp):
            return ["lat": lat, "lng": lng, "speed": speed, "accuracy": accuracy, "event": event, "ts:": localTimestamp]

        case .shipmentChatMessage(let chat, let message):
            return ["message": ["body": message]] //, "chatroom_id": chat.id!]]

        case .proofOfDelivery(let shipment, let presign, let fileSize):
            return [
                "upload": [
                    "id": presign.id!,
                    "filename": presign.id!,
                    "content_type": "image/jpeg",
                    "size": fileSize
                ]
            ]
        case .availability(let available):
            return ["available": available]
        default:
            break
        }

        return [:]
    }

    var forceUrl: URL? {
        switch self {
        case .shipmentChatMessage(let chat, _):
            return chat.postUrl!
        default:
            return nil
        }
    }

    func asURLRequest() throws -> URLRequest {
        var url = try ApiRequests.baseURLString.asURL()

        if let forceUrl = self.forceUrl {
            url = forceUrl
        }

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .signIn, .updateLocation, .shipmentChatMessage, .proofOfDelivery, .availability:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: self.params)
        case .liveShipments, .user, .accept, .delivered, .pickup, .shipments, .shipmentChat, .presign:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: nil)
        }

        return urlRequest
    }

}

