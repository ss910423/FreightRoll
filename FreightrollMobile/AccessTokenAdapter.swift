//
//  AccessTokenAdapter.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 12/26/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import Alamofire

class AccessTokenAdapter: RequestAdapter {
    fileprivate var token: String

    init(token: String) {
        self.token = token
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        urlRequest.setValue(self.token, forHTTPHeaderField: "X-Freightroll-Token")
        urlRequest.setValue("77ngxng42vb4k7pdzc89nn", forHTTPHeaderField: "X-Freightroll-Client-ID")

        return urlRequest
    }
}
