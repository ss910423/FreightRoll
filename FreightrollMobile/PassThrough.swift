//
//  PassThrough.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 3/26/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation
import UIKit

class PassThroughView: UIView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}
