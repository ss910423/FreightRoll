//
//  String.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 3/28/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation
import UIKit

extension String {
    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "$1 $2 $3", options: .regularExpression, range: nil)
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    // Title Case Extension for Swift 4
    // https://gist.github.com/sgbasaraner/1faaf48418f0b8a127410ba9af1e0ad0
    func titlecased() -> String {
        if self.count <= 1 {
            return self.uppercased()
        }
        
        let regex = try! NSRegularExpression(pattern: "(?=\\S)[A-Z]", options: [])
        let range = NSMakeRange(1, self.count - 1)
        var titlecased = regex.stringByReplacingMatches(in: self, range: range, withTemplate: " $0")
        
        for i in titlecased.indices {
            if i == titlecased.startIndex || titlecased[titlecased.index(before: i)] == " " {
                titlecased.replaceSubrange(i...i, with: String(titlecased[i]).uppercased())
            }
        }
        return titlecased
    }
}
