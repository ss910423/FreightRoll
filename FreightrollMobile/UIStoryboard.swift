//
//  UIStoryboard+Extension.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 9/22/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import UIKit

public enum Storyboard: String {
    case login = "Login"
    case app = "App"
    case shipmentInfo = "ShipmentInfo"
}

extension UIStoryboard {

    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }

    func instantiateViewController<T: UIViewController>() -> T {
        let optionalViewController = self.instantiateViewController(withIdentifier: T.storyboardId)

        guard let viewController = optionalViewController as? T  else {
            fatalError("Couldn’t instantiate view controller with identifier \(T.storyboardId)")
        }

        return viewController
    }

}

