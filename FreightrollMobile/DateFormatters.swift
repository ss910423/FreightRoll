//
//  DateFormatters.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/24/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation

class ShortDateFormatter {
    static let formatter: DateFormatter = {
        let instance = DateFormatter()
        instance.dateFormat = "MMMM d"
        instance.timeZone = Foundation.TimeZone.autoupdatingCurrent
        return instance
    }()
    fileprivate init() {}
}
