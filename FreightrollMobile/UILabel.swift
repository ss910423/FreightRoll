//
//  UILabel.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/13/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    var fontSize: CGFloat {
        get {
            if adjustsFontSizeToFitWidth {
                var currentFont: UIFont = font
                let originalFontSize = currentFont.pointSize
                var currentSize: CGSize = (text! as NSString).size(withAttributes: [NSAttributedStringKey.font: currentFont])
                
                while currentSize.width > frame.size.width && currentFont.pointSize > (originalFontSize * minimumScaleFactor) {
                    currentFont = currentFont.withSize(currentFont.pointSize - 1)
                    currentSize = (text! as NSString).size(withAttributes: [NSAttributedStringKey.font: currentFont])
                    print("running")
                }
                
                return currentFont.pointSize
            }
            
            return font.pointSize
        }
    }
}
