//
//  NSObject.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 9/27/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation

extension NSObject {
    @objc public var className: String {
        return type(of: self).className
    }

    @objc public static var className: String {
        return stringFromClass(self)
    }

    @objc public static func stringFromClass(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
}
