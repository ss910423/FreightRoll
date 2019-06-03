//
//  ClientTokenAdapter.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/12/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation
import Alamofire

class ClientTokenAdapter: RequestAdapter {
    fileprivate var clientID = "77ngxng42vb4k7pdzc89nn"
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        urlRequest.setValue(clientID, forHTTPHeaderField: "X-Freightroll-Client-ID")
        
        return urlRequest
    }
}

