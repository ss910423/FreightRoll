//
//  MapViewController.swift
//  FreightrollMobile
//
//  Created by Nick Forte on 8/24/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        mapView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
//        mapView.layer.borderWidth = 1.0
//        mapView.layer.borderColor = UIColor.black.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: Actions
    
    @IBAction func showSearchMenu(_ sender: UIButton) {
        let ac = UIAlertController(title: "Search", message: nil, preferredStyle: .actionSheet)
        
        let searchTerms = ["Parking", "Truck Stop", "Weight", "Gas", "Food", "Hotels"]
       
        for term in searchTerms {
            ac.addAction(UIAlertAction(title: term, style: .default) { action in
                ac.dismiss(animated: true, completion: nil)
            })
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            ac.dismiss(animated: true, completion: nil)
        })
        present(ac, animated: true)
    }
}

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            let span = MKCoordinateSpanMake(0.05, 0.05)
//            let region = MKCoordinateRegion(center: location.coordinate, span: span)
//            mapView.setRegion(region, animated: true)
//        }
//        
//        if let location = locations.first {
//            print("location:: (location)")
//        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
}

