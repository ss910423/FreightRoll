//
//  File.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/15/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import UIKit

extension UIScreen {
    #if !APP_EXTENSION
    /// Returns the screen height without the status bar height.
    @objc public static var screenHeightWithoutStatusBar: CGFloat {
        if UIInterfaceOrientationIsPortrait(UIApplication.screenOrientation) {
            return UIScreen.main.bounds.size.height - UIApplication.screenStatusBarHeight
        } else {
            return UIScreen.main.bounds.size.width - UIApplication.screenStatusBarHeight
        }
    }
    #endif

    #if !APP_EXTENSION
    /// Returns the current screen height.
    @objc public static var height: CGFloat {
        if UIInterfaceOrientationIsPortrait(UIApplication.screenOrientation) {
            return UIScreen.main.bounds.size.height
        } else {
            return UIScreen.main.bounds.size.width
        }
    }
    #endif

    #if !APP_EXTENSION
    /// Returns the current screen width.
    @objc public static var width: CGFloat {
        if UIInterfaceOrientationIsPortrait(UIApplication.screenOrientation) {
            return UIScreen.main.bounds.size.width
        } else {
            return UIScreen.main.bounds.size.height
        }
    }
    #endif
}
