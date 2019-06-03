//
//  UIApplication.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/15/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    #if !APP_EXTENSION
    /// Returns the current screen orientation.
    @objc public static var screenOrientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    #endif

    #if !APP_EXTENSION
    /// Returns the height of the status bar.
    @objc public static var screenStatusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    #endif

    /**
     Helper method that returns the documents directory path.

     - returns: Documents directory path as NSString
     */
    @objc public static func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }

    #if !APP_EXTENSION
    @objc public static func notificationsEnabled() -> Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    #endif

    @objc func remoteNotificationsEnabled() -> Bool {
        var notificationsEnabled = false
        if let userNotificationSettings = currentUserNotificationSettings {
            notificationsEnabled = userNotificationSettings.types.contains(.alert)
        }
        return notificationsEnabled
    }

    /// Returns the application display name.
    @objc public static var appDisplayName: String {
        if let name1 = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return name1
        }

        if let name2 = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return name2
        }

        return ""
    }

    /// Returns the application version number.
    @objc public static var appVersion: String {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            return version
        }

        return ""
    }

    /// Returns the application build number.
    @objc public static var appBuild: String {
        if let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String {
            return build
        }

        return ""
    }

    /// Returns both the application version and build numnber.
    @objc public static var appVersionAndBuild: String {
        let version = appVersion, build = appBuild
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }

    /// Returns the top most VC (useful for custom popups or alerts).
    #if !APP_EXTENSION
    @objc public static var topMostVC: UIViewController? {
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }

        if presentedVC == nil {
            print("EZSwiftExtensions Error: You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
        }
        return presentedVC
    }
    #endif
}
