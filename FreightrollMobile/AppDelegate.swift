//
//  AppDelegate.swift
//  FreightrollMobile
//
//  Created by Nick Forte on 7/26/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit
import UserNotifications
import AirshipKit

struct Const {
    static let tokenKey = "authToken"
    static let liveShipId = "liveShipId"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var api: API?

    var appCurrentState = AppCurrentState()
    static let kCustomURLScheme = "freightroll://"

    class func sharedAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        addObservers()

        // This must be called synchronously here
        let config: UAConfig = UAConfig.default()
        UAirship.takeOff(config)

        let locationManager = LocationManager.shared

        locationManager.checkAuthStatus()

        NotificationsHandler().setup(delegate: self)

        if let token = UserDefaults.standard.string(forKey: Const.tokenKey) {
            self.setup(token: token)
            // ChatManager.shared.connect(token: token)
        } else {
            // Don't setup the location manager until the user has auth'd
        }

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("printing url", url.absoluteString)
        let urlPathArr = url.absoluteString.split(separator: "/")
        if urlPathArr.count > 1 {
            let urlPath = urlPathArr[1]
            if urlPath == "login"{
                self.showLoginScreen(false)
            }
        }
        
        return true
    }

    func openCustomURLScheme(customURLScheme: String) -> Bool {
        let customURL = URL(string: customURLScheme)!
        if UIApplication.shared.canOpenURL(customURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(customURL)
            } else {
                UIApplication.shared.openURL(customURL)
            }
        return true
        }
    
        return false
    }

    func setup(token: String) {
        self.api = getAPI(authToken: token)

        let storyboard = UIStoryboard(storyboard: .app)
        let controller = storyboard.instantiateInitialViewController()
        self.window?.rootViewController = controller
        LocationManager.shared.setup()
        LocationManager.shared.setStarted(started: true)

        // Get user details so we can register the user with UrbanAirship
        self.api?.getUser(delegate: self)
    }

    func showLoginScreen(_ animated:Bool) {
        let controller: LoginViewController = UIStoryboard(storyboard: .login).instantiateViewController()

        let rootController = self.window!.rootViewController as! UINavigationController
        self.window?.makeKeyAndVisible()
        rootController.present(controller, animated: animated, completion: nil)
    }
}

extension AppDelegate: GetUserDelegate {
    func apiError(code: Int?, message: String) {
        print("GetUser failed")
        print(code ?? "")
        print(message)
    }

    internal func getUserSuccess(user: User) {
        let pushManager: UAPush = UAirship.push()
        pushManager.userPushNotificationsEnabled = true
        pushManager.defaultPresentationOptions = [.alert, .badge, .sound]
        UAirship.namedUser().identifier = String(describing: user.id!)
        pushManager.updateRegistration()
    }
}

extension AppDelegate: AvailabilityDelegate {
    func availabilitySuccess() {
        print("Availability sent")
    }
}

extension AppDelegate {
    fileprivate func addObservers() {
        NotificationCenter.default.addObserver(forName:  Notification.Name(rawValue:"completeLogin"), object: nil, queue: nil) { (notification) in
            guard let user = notification.object as? User, let token = user.authToken else {
                fatalError("Something has gone terribly wrong")
            }
            UserDefaults.standard.set(token, forKey: Const.tokenKey)
            self.setup(token: token)
        }

        NotificationCenter.default.addObserver(forName: AvailabilityBar.AvailabilityChangeNotification, object: nil, queue: nil) { (notification) in
            guard let userAvailable = notification.object as? Bool else { return }

            self.api?.availability(available: userAvailable, delegate: self)
            // TODO: This should ping the backend whether they're available or not rather than start/stop GPS updates.
            // LocationManager.shared.setStarted(started: userAvailable)

            self.appCurrentState.userAvailable = userAvailable
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler(UNNotificationPresentationOptions.alert)
    }
}



