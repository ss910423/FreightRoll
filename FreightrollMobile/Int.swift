//
//  Int.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/14/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation

extension Int {
    public static func unwrap (_ i: Int?, d: Int = 0) -> Int {
        guard let val = i else { return d }
        return val
    }

    public static func unwrapStr (_ i: Int?, d: String = "--") -> String {
        guard let val = i else { return d }
        return String(val)
    }
}
