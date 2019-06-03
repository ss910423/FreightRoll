//
//  UIView.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 9/27/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @objc public func instanceFromNib() -> UIView {
        if let view = UINib(nibName: self.className, bundle: Bundle.main).instantiate(withOwner: self, options: nil)[0] as? UIView {
            return view
        }

        return UIView()
    }
}
