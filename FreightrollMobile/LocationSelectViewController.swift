//
//  LocationSelectViewController.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/12/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//


import UIKit
import MapKit

protocol LocationSelectViewControllerDelegate: class {
    func locationSet(sender: String, location: String, coord: CLLocationCoordinate2D)
}

class LocationSelectViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigationSearch: UINavigationBar!
    
    weak var delegate: LocationSelectViewControllerDelegate?
    
    fileprivate var locationAnnotation: MKPointAnnotation?
    var locationLatKey = ""
    var locationLngKey = ""
    var locationKey = ""
    var city: String?
    var sender: String?
    
    var searchController: UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pinAnnotationView:MKPinAnnotationView!
    
    static func instance(delegate: LocationSelectViewControllerDelegate? = nil) -> LocationSelectViewController {
        let vc = LocationSelectViewController(nibName: "LocationSelectViewController", bundle: Bundle.main)
        vc.delegate = delegate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = false
        
        if sender == "pickup"{
            self.title = "DESIRED PICKUP"
            
            let button:UIButton = UIButton(frame: CGRect(x: Int(UIScreen.main.bounds.width) - 130, y: 70, width: 120, height: 35))
            button.setTitle("My Location", for: .normal)
            button.setImage(UIImage(named: "directionArrow"), for: .normal)
            button.backgroundColor = UIColor(hex: "0xfcfbf9")
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(hex: "0xe5e5e5").cgColor
            button.titleLabel?.font =  UIFont.systemFont(ofSize: 14)
            button.setTitleColor(UIColor(hex: "0x2490c4"), for: .normal)
            button.tag = 557
            button.contentHorizontalAlignment = .left
            button.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
            button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
            button.addTarget(self, action:#selector(self.myLocationButton), for: .touchUpInside)
            self.view.addSubview(button)
            
            locationLatKey = "heading_to_lat"
            locationLngKey = "heading_to_lng"
            locationKey = "heading_to"
        }
        else{
            self.title = "DESIRED DESTINATION"
            locationLatKey = "destination_lat"
            locationLngKey = "destination_lng"
            locationKey = "destination"
            

        }

        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor(hex:"0xffffff")
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "0x000000")
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(hex: "0x2490c4")
        let saveButton = UIBarButtonItem(image: UIImage(named: "save"), style: .plain, target: self, action: #selector(self.save))
        self.navigationItem.rightBarButtonItem = saveButton
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dropPin(_:)))
        
        mapView.addGestureRecognizer(tapGesture)
        
        let defaults = UserDefaults.standard
        
        if defaults.double(forKey: locationLatKey) != 0.0 && defaults.double(forKey: locationLngKey) != 0.0 {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: defaults.double(forKey: locationLatKey), longitude: defaults.double(forKey: locationLngKey))
            self.city = defaults.string(forKey: locationKey)
            locationLabel.text = self.city
            self.locationAnnotation = annotation
            mapView.addAnnotation(locationAnnotation!)
        }
        else{
            self.locationAnnotation = MKPointAnnotation()
            locationLabel.text = "Select a pickup point"
            locationLabel.textColor = UIColor(hex: "0xe5e5e5")
            if let userLocation = LocationManager.shared.location {
                 if sender == "pickup"{
                    setAnnotation(point: userLocation.coordinate)
                    locationAnnotation?.coordinate = userLocation.coordinate
                    mapView.addAnnotation(locationAnnotation!)
                }
            }
        }
        let location = CLLocationCoordinate2DMake((locationAnnotation?.coordinate.latitude)!, (locationAnnotation?.coordinate.longitude)!)
        let viewRegion = MKCoordinateRegionMakeWithDistance(location, 300000, 300000)
        mapView.setRegion(viewRegion, animated: false)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor.white
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.setShowsCancelButton(false, animated: false)
        
        self.navigationSearch.topItem?.titleView = self.searchController.searchBar
        for subView in searchController.searchBar.subviews {
            for subViewOne in subView.subviews {
                if let textField = subViewOne as? UITextField {
                    subViewOne.backgroundColor = UIColor(hex: "0xf5f5f5")
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {       
        if let _ = LocationManager.shared.location {
            if sender == "destination"{
                let coord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(39.999733, -98.678503)
                let USRegion = MKCoordinateRegionMakeWithDistance(coord, 3000000, 3000000)
                mapView.setRegion(USRegion, animated: true)
            }
        }
        else{
            let coord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(39.999733, -98.678503)
            let USRegion = MKCoordinateRegionMakeWithDistance(coord, 3000000, 3000000)
            mapView.setRegion(USRegion, animated: true)
        }
    }
    //http://sweettutos.com/2015/04/24/swift-mapkit-tutorial-series-how-to-search-a-place-address-or-poi-in-the-map/
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
            
        }
        if let locationAnnotation = locationAnnotation {
            mapView.removeAnnotation(locationAnnotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.locationAnnotation = MKPointAnnotation()
            self.locationAnnotation?.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: (self.locationAnnotation?.coordinate.latitude)!, longitude: (self.locationAnnotation?.coordinate.longitude)!)
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                
                // City
                if let city = placeMark.addressDictionary!["City"] as? String {
                    if let state = placeMark.addressDictionary!["State"] as? String {
                        self.city = city + ", " + state
                        self.locationLabel.text = self.city
                        self.locationLabel.textColor = UIColor.black
                    }
                    else{
                        self.city = city
                    }
                    print(city)
                }
            })
            self.mapView.centerCoordinate = (self.locationAnnotation?.coordinate)!
            self.mapView.addAnnotation(self.locationAnnotation!)
        }
    }
    
    @objc func myLocationButton(_ button: Any?){
       
        if let userLocation = LocationManager.shared.location {
            setAnnotation(point: userLocation.coordinate)
            self.mapView.setCenter(userLocation.coordinate, animated: true)
        }
        else{
            let alert = UIAlertController(title: "Unable to access Location",
                                          message: "To enable access, go to Settings > Privacy > Location Services and turn on Location access for this app.",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                // Take the user to Settings app to possibly change permission.
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        // Finished opening URL
                    })
                }
            })
            alert.addAction(settingsAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func save(_ button: Any?) {
        
        if self.city != nil{
            self.delegate?.locationSet(sender: self.sender!, location: self.city!, coord: (locationAnnotation?.coordinate)!)
        }
        self.searchController.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func willMove(toParentViewController parent: UIViewController?)
    {
        if parent == nil
        {
            self.searchController.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func dropPin(_ gesture: UILongPressGestureRecognizer) {
        self.mapView.showsUserLocation = false
        let point = mapView.convert(gesture.location(in: self.mapView), toCoordinateFrom: self.mapView)
        setAnnotation(point: point)
    }
    
    func setAnnotation(point: CLLocationCoordinate2D){
        if let locationAnnotation = locationAnnotation {
            mapView.removeAnnotation(locationAnnotation)
        }
        
        self.locationAnnotation = MKPointAnnotation()
        print("lat: ", point.latitude)
        print("long: ", point.longitude)
        
        locationAnnotation?.coordinate = point
        mapView.addAnnotation(locationAnnotation!)
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: point.latitude, longitude: point.longitude)
        print("location",location)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            if let city = placeMark.addressDictionary?["City"] as? String {
                if let state = placeMark.addressDictionary!["State"] as? String {
                    self.city = city + ", " + state
                    self.locationLabel.text = self.city
                    self.locationLabel.textColor = UIColor.black
                }
                else{
                    self.city = city
                }
                print(city)
            }
            print(placeMark.debugDescription)
            
        })
        
    }
}

extension LocationSelectViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0))
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if sender == "pickup"{
            view.pinTintColor = .red
        } else {
            view.pinTintColor = .green
        }
        return view
    }
}

