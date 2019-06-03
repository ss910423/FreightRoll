//
//  UIViewController.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 9/22/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardIdentifiable {
    static var storyboardId: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {

    static var storyboardId: String {
        return String(describing: self)
    }

    func showAlert(title: String, message: String?, okTapped: (() -> Void)?) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)

        vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            okTapped?()
        }))

        self.present(vc, animated: true, completion: nil)
    }
}

extension UIViewController: APIErrorDelegate {
    func apiError(code: Int?, message: String) {
        showAlert(title: "Error", message: message, okTapped: nil)
    }
}

extension UIViewController: StoryboardIdentifiable {}

extension UIViewController {
    func setupCommonAppearance() {
        navigationController?.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIColor.white.as1ptImage(), for: .default)
        // Set the shadow color.
        navigationController?.navigationBar.shadowImage = UIColor.app_lightGrey.as1ptImage()
    }
}

