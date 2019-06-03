//
//  LocationManager.swift
//  FreightrollMobile
//
//  Created by Yevgeniy Motov on 4/18/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    static let shared = LocationManager()
    
    static let locationAvailableNotif = Notification.Name(rawValue: "LocationAvailableNotification")
    
    private let locationManager = CLLocationManager()
    
    private let GPS_UPDATE_INTERVAL : TimeInterval = 60 * 15 // Value is in seconds
    private let GPS_UPDATE_RATE_LIMIT_INTERVAL : TimeInterval = 60 * 15
    
    private var lastLocationUpdate : Date!
    private var updateLocationTimer : Timer!
//    private var debug_geofence = true

    private override init() {
        super.init()
    }
    
    var locationServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    var authStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    var location: CLLocation? {
        return locationManager.location
    }
    
    func setup() {

        configureSettings()
    }
    
    func setStarted(started: Bool) {
        lastLocationUpdate = nil

        if started {
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        }
        else {
            locationManager.stopUpdatingLocation()
        }
        
        // if debug_geofence {
        //     debug_gps_event()
        //     debug_geofence = false
        // }
    }
    
    // func debug_gps_event() {
    //     let pickupLat = 42.24758629999999
    //     let pickupLng = -83.8260884
    //     let radius = 500.0
        
    //     let regionIdentifier = String("-1") + "::pickup"
        
    //     LocationManager.shared.addGeofence(lat: pickupLat, lng: pickupLng, geofenceRadius: radius, regionIdentifier: regionIdentifier)
        
    // }
    
    

    func addGeofence(lat: Double, lng: Double, geofenceRadius: Double, regionIdentifier: String) {
        let geofenceRegionCenter = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: geofenceRadius, identifier: regionIdentifier)
        
        locationManager.startMonitoring(for: geofenceRegion)
    }
    
    func clearPreviousGeofencingRegions() {
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }
    
    func checkAuthStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .denied:
            print("locationServiceDenied")
        case .restricted:
            print("locationServiceRestricted")
        case .authorizedAlways, .authorizedWhenInUse:
            print("locationServiceAllowed")
        }
    }

    
    private func configureSettings() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.activityType = CLActivityType.automotiveNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.distanceFilter = 1000 // kCLDistanceFilterNone
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var okToStart = false
        switch status {
        case .notDetermined, .denied, .restricted:
            print("Location services disabled for \(status)")
        case .authorizedAlways, .authorizedWhenInUse:
            okToStart = true
        }
        
        setStarted(started: okToStart)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
//        let locationTime = location.timestamp
        var sendLocationUpdate = false
        
        let userAvailable = AppDelegate.sharedAppDelegate().appCurrentState.userAvailable
        if userAvailable {
            //getAPI().updateUserLocation(location: location, delegate: self)
        }

        //
        // If this is the first update or if the elapsed amount of time has passed (rate limit)
        // then send a location update
        //
        if self.lastLocationUpdate == nil {
            sendLocationUpdate = true
        } else {
            // let elapsed = locationTime.timeIntervalSince(self.lastLocationUpdate)
            // let elapsed =
            // if elapsed > GPS_UPDATE_INTERVAL {
            // let elapsed = self.lastLocationUpdate.timeIntervalSinceNow
            let elapsed = Date().timeIntervalSince(self.lastLocationUpdate)
            if elapsed > GPS_UPDATE_INTERVAL {
                sendLocationUpdate = true
                self.updateLocationTimer.invalidate()
                self.updateLocationTimer = nil
            }
        }
        
        if sendLocationUpdate {
            self.lastLocationUpdate = Date()
            getAPI().updateUserLocation(location: location, event: GpsEvent.ping, delegate: self)
            self.updateLocationTimer = Timer.scheduledTimer(timeInterval: GPS_UPDATE_RATE_LIMIT_INTERVAL, target: self, selector: #selector(requestLocationUpdate), userInfo: nil, repeats: false)
        }
        
        NotificationCenter.default.post(name: LocationManager.locationAvailableNotif, object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let shipmentForRegion = findMatchingShipmentForRegion(region: region);

        if shipmentForRegion != nil {
            getAPI().updateUserLocation(location: manager.location!, event: GpsEvent.geofence_enter, delegate: self)
            parseLocationEnterEvent(title: "Arrived at ", shipment: shipmentForRegion!, region: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let shipmentForRegion = findMatchingShipmentForRegion(region: region);
        
        if shipmentForRegion != nil {
            getAPI().updateUserLocation(location: manager.location!, event: GpsEvent.geofence_exit, delegate: self)
            parseLocationExitEvent(title: "Leaving ", shipment: shipmentForRegion!, region: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("paused!")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("resumed!")
    }
    
    @objc private func requestLocationUpdate() {
        setStarted(started: false)
        setStarted(started: true)
    }
    
    private func findMatchingShipmentForRegion(region:CLRegion) -> Shipment? {
        let liveShipments = AppDelegate.sharedAppDelegate().appCurrentState.liveShipments
        
        let regionIdParts = region.identifier.split(separator: ":").map(String.init)
        
        guard let shipmentId = regionIdParts.first else {
            return nil
        }
        
        return liveShipments.filter({shipmentId == String(describing:$0.id ?? 0)}).first
    }
    
    private func parseLocationEnterEvent(title: String, shipment: Shipment, region: CLRegion) {
        let regionIdParts = region.identifier.split(separator: ":").map(String.init)
        if let pickupOrDropoffIdentifier = regionIdParts.last{
            switch pickupOrDropoffIdentifier {
            case "pickup":
                if (withinTimeFrameToTriggerNotification(shipmentRelatedDate: shipment.pickupAt!)) {
                    sendNotificationRequest(title: title + "Pick Up", body: shipment.pickup?.street ?? "")
                }
            case "dropoff":
                if (withinTimeFrameToTriggerNotification(shipmentRelatedDate: shipment.dropoffAt!)) {
                    sendNotificationRequest(title: title + "Drop Off", body: shipment.dropoff?.street ?? "")
                }
            default:
                return
            }
        }
    }
    
    private func parseLocationExitEvent(title: String, shipment: Shipment, region: CLRegion) {
        let regionIdParts = region.identifier.split(separator: ":").map(String.init)
        if let pickupOrDropoffIdentifier = regionIdParts.last{
            switch pickupOrDropoffIdentifier {
            case "pickup":
                if (withinTimeFrameToTriggerNotification(shipmentRelatedDate: shipment.pickupAt!)) {
                    sendNotificationRequest(title: title + "Pick Up", body: "Please remember to confirm Pick Up")
                }
            case "dropoff":
                if (withinTimeFrameToTriggerNotification(shipmentRelatedDate: shipment.dropoffAt!)) {
                    sendNotificationRequest(title: title + "Drop Off", body: "Please remember to upload Proof of Delivery")
                }
            default:
                return
            }
        }
    }
    
    private func sendNotificationRequest(title: String, body: String) {
        NotificationsHandler().sendNotificationRequest(title: title, body: body, identifier: "GeofenceAlarm", triggerInterval: 5)
    }
    
    private func withinTimeFrameToTriggerNotification(shipmentRelatedDate: Date) -> Bool {
        return Calendar.current.isDateInToday(shipmentRelatedDate)
    }
}

extension LocationManager: UpdateUserLocationDelegate {
    func updateUserLocationSuccess() {
        print("Location Sent")
    }
    
    func apiError(code: Int?, message: String) {
        print(message)
    }
}

