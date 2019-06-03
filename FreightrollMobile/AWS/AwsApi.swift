//
//  AwsApi.swift
//  FreightrollMobile
//
//  Created by Freight Roll on 2/8/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation
import Alamofire
import UIKit


protocol AwsAPI {
    func postToS3(presign:Presign, image:UIImage, delegate: PostToS3Delegate?)
}

protocol PostToS3Delegate: APIErrorDelegate {
    func postToS3Success(presign: Presign, fileSize: Int)
}

func getAwsAPI() -> AwsAPI {
    guard let api = HttpAwsAPI.shared else {
        HttpAwsAPI.shared = HttpAwsAPI()
        return HttpAwsAPI.shared!
    }
    return api
}

class HttpAwsAPI: AwsAPI {
    
    static var shared: HttpAwsAPI?
    
    internal var sessionManager: Alamofire.SessionManager
    
    init() {
        sessionManager = Alamofire.SessionManager()
    }
    
    func postToS3(presign: Presign, image: UIImage, delegate: PostToS3Delegate?) {
        performUpload(image:image , presign:presign, delegate: delegate)
    }
    
    private func performUpload(image: UIImage, presign: Presign, delegate: PostToS3Delegate?) {
        if let imageData = UIImageJPEGRepresentation(image, 0.1) {
            
            let rawImageData: NSData = NSData(data:imageData)
            
            sessionManager.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(presign.key!.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "key")
                multipartFormData.append(presign.policy!.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "policy")
                multipartFormData.append(presign.credential!.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "x-amz-credential")
                multipartFormData.append(presign.algorithm!.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "x-amz-algorithm")
                multipartFormData.append(presign.date!.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "x-amz-date")
                multipartFormData.append(presign.signature!.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "x-amz-signature")
                multipartFormData.append(imageData, withName: "file")
            }, usingThreshold: UInt64.init(),
               to: presign.url!,
               method: .post,
               encodingCompletion: { result in
                switch result {
                case .success(_, _, _):
                    delegate?.postToS3Success(presign: presign, fileSize: rawImageData.length)
                case .failure(let error):
                    delegate?.apiError(code: nil, message: error.localizedDescription)
                }
            })
        }
    }
}
