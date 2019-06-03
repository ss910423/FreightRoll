//
//  LoadBoardViewController.swift
//  FreightrollMobile
//
//  Created by Nick Forte on 8/27/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications

class AvailableShipmentsViewController: UIViewController {

    let headingToKey = "heading_to"
    let headingToLatKey = "heading_to_lat"
    let headingToLngKey = "heading_to_lng"
    let dateKey = "desired_date"
    let destinationLatKey = "destination_lat"
    let destinationLngKey = "destination_lng"
    let deadheadKey = "deadheadlet"
    let truckTypeKey = "truckType"
    let setDateButton = UIButton()
    var toggle = false

    @IBOutlet weak var tableView: UITableView!

    let distance = ["25", "50", "100", "150", "200", "250", "300"]
    let destinations = ["Select by touching map", "Los Angeles CA, 90210"]

    let notifications = NotificationListBuilder()

    fileprivate var deadhead: Int = 0 {
        didSet {
            UserDefaults.standard.set(deadhead, forKey: deadheadKey)
            shipmentsModel.updateCells()
            self.tableView.reloadData()
        }
    }
    
    fileprivate var truckType: String = "Show All"
    
    fileprivate let shipmentsModel = AvailableShipmentsModel()
    
    fileprivate var headingTo: String?
    fileprivate var desiredDate: String?
    fileprivate var headingToAnnotation: MKPointAnnotation? {
        didSet {
            shipmentsModel.headingToAnnotation = headingToAnnotation
        }
    }
    fileprivate var destinationAnnotation: MKPointAnnotation?
    fileprivate var backgroundMapView = MapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        view.endEditing(true)
        self.view.isUserInteractionEnabled = true
        self.navigationItem.title = "LOAD BOARD"
        
        notifications.setup()
        shipmentsModel.shipmentsSortedCallback = { [weak self] in
            self?.tableView.reloadData()
            if let coord = self?.headingToAnnotation {
                self?.backgroundMapView.addHeading(point: coord, deadhead: self?.deadhead ?? 0)
            }
            self?.backgroundMapView.configure(with: (self?.shipmentsModel.sortedShipments)!)
        }

        let defaults = UserDefaults.standard
        var desiredPickup = "Desired Pickup"

        let supportButton = UIBarButtonItem(image: UIImage(named: "phone_small"), style: .plain, target: self, action: #selector(self.callSupport)) 
        self.navigationItem.leftBarButtonItem  = supportButton
        
 
        if let headingTo = defaults.string(forKey: headingToKey) {
            desiredPickup = headingTo
        }
        

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        desiredDate = dateFormatter.string(from: Date())
        defaults.set(desiredDate, forKey: dateKey)
        
        
        self.toggle = UserDefaults.standard.bool(forKey: "isAvailable")

        if defaults.double(forKey: headingToLatKey) != 0.0 && defaults.double(forKey: headingToLngKey) != 0.0 {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: defaults.double(forKey: headingToLatKey), longitude: defaults.double(forKey: headingToLngKey))
            self.headingToAnnotation = annotation
        }

        if defaults.integer(forKey: deadheadKey) != 0 {
            self.deadhead = defaults.integer(forKey: deadheadKey)
        }
        var readableTruckType = "Show All"
        if let truck = defaults.string(forKey: truckTypeKey) {
            self.truckType = truck
            if truck != "Show All"{
                readableTruckType = (TruckType(rawValue: truck)?.readable)!
            }
        }
        else {
            defaults.set("Show All", forKey: truckTypeKey)
        }

      
        tableView.backgroundColor = .app_lightestGrey
        tableView.bounces = false
        tableView.alwaysBounceVertical = false
        self.automaticallyAdjustsScrollViewInsets = false
      
        tableView.register(GestureForwardingCell.self, forCellReuseIdentifier: "GestureForwardingCell")
        tableView.register(UINib(nibName: "LoadBoardCell", bundle: Bundle.main), forCellReuseIdentifier: "LoadBoardCell")
        tableView.register(UINib(nibName: "MapCell", bundle: Bundle.main), forCellReuseIdentifier: "MapCell")
        tableView.register(UINib(nibName: "AvailabilityCell", bundle: Bundle.main), forCellReuseIdentifier: "AvailabilityCell")
        tableView.register(UINib(nibName: "DeadheadCell", bundle: Bundle.main), forCellReuseIdentifier: "DeadheadCell")
        tableView.register(UINib(nibName: "DesiredPickup", bundle: Bundle.main), forCellReuseIdentifier: "DesiredPickup")
        tableView.register(UINib(nibName: "DesiredDestination", bundle: Bundle.main), forCellReuseIdentifier: "DesiredDestination")

        shipmentsModel.updateCells()
        tableView.reloadData()
        setupNotifications()
        
        
        let deadheadButton = UIButton(frame: CGRect(x: 10, y: 10, width: 100, height: 40))
        deadheadButton.backgroundColor = .app_beige
        deadheadButton.setImage(UIImage(named: "deadhead"), for: .normal)
        deadheadButton.layer.cornerRadius = 5
        deadheadButton.layer.borderWidth = 1
        deadheadButton.layer.borderColor = UIColor.app_lightGrey.cgColor
        deadheadButton.setTitle(" \(self.deadhead)mi", for: .normal)
        deadheadButton.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        deadheadButton.setTitleColor(.black, for: .normal)
        deadheadButton.tag = 555
        deadheadButton.addTarget(self, action:#selector(self.deadheadButtonClick), for: .touchUpInside)
        deadheadButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        deadheadButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
        deadheadButton.contentHorizontalAlignment = .left
        tableView.addSubview(deadheadButton)
        
        let truckTypeButton = UIButton(frame: CGRect(x: (Int(UIScreen.main.bounds.width) - 140), y: 10, width: 130, height: 40))
        truckTypeButton.backgroundColor = .app_beige
        truckTypeButton.setImage(UIImage(named: "truck-icon"), for: .normal)
        truckTypeButton.layer.cornerRadius = 5
        truckTypeButton.layer.borderWidth = 1
        truckTypeButton.layer.borderColor = UIColor.app_lightGrey.cgColor
        truckTypeButton.setTitle(" \(readableTruckType)", for: .normal)
        truckTypeButton.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        truckTypeButton.setTitleColor(.black, for: .normal)
        truckTypeButton.tag = 554
        truckTypeButton.addTarget(self, action:#selector(self.truckTypeButtonClick), for: .touchUpInside)
        truckTypeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        truckTypeButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
        truckTypeButton.contentHorizontalAlignment = .left
        tableView.addSubview(truckTypeButton)
        
        let setPickupButton:UIButton = UIButton(frame: CGRect(x: 10, y: (Int(tableView.bounds.height * 25)/32) - 60, width:(Int(UIScreen.main.bounds.width)/2) - 12, height: 35))
        setPickupButton.frame.origin.y = self.tableView.bounds.height * 25/32 - 60

        setPickupButton.setImage(UIImage(named: "pickup-location"), for: .normal)
        setPickupButton.backgroundColor = .app_beige
        setPickupButton.layer.cornerRadius = 5
        setPickupButton.layer.borderWidth = 1
        setPickupButton.layer.borderColor = UIColor.app_lightGrey.cgColor
        setPickupButton.setTitle("\(desiredPickup)", for: .normal)
        setPickupButton.titleLabel?.font =  UIFont.systemFont(ofSize: 14)
        setPickupButton.titleLabel?.numberOfLines = 1
        setPickupButton.titleLabel?.adjustsFontSizeToFitWidth = true
        setPickupButton.titleLabel?.lineBreakMode = .byClipping
        setPickupButton.setTitleColor(.black, for: .normal)
        setPickupButton.tag = 556
        setPickupButton.addTarget(self, action:#selector(self.pickupButtonClick), for: .touchUpInside)
        setPickupButton.contentHorizontalAlignment = .left
        setPickupButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        setPickupButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
        tableView.addSubview(setPickupButton)
        

        setDateButton.frame = CGRect(x: (Int(UIScreen.main.bounds.width)/2) + 2, y: (Int(tableView.bounds.height * 25)/32) - 60, width:(Int(UIScreen.main.bounds.width)/2) - 12, height: 35)
        setDateButton.frame.origin.y = self.tableView.bounds.height * 25/32 - 60

        setDateButton.setImage(UIImage(named: "calendar-icon"), for: .normal)
        setDateButton.backgroundColor = .app_beige
        setDateButton.layer.cornerRadius = 5
        setDateButton.layer.borderWidth = 1
        setDateButton.layer.borderColor = UIColor.app_lightGrey.cgColor
        setDateButton.setTitle("\(desiredDate!)", for: .normal)
        setDateButton.titleLabel?.numberOfLines = 1
        setDateButton.titleLabel?.adjustsFontSizeToFitWidth = true
        setDateButton.titleLabel?.lineBreakMode = .byClipping
        setDateButton.titleLabel?.font =  UIFont.systemFont(ofSize: 14)
        setDateButton.setTitleColor(.black, for: .normal)
        setDateButton.tag = 557
        setDateButton.addTarget(self, action:#selector(self.dateButtonClick), for: .touchUpInside)
        setDateButton.contentHorizontalAlignment = .left
        setDateButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        setDateButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
        tableView.addSubview(setDateButton)
        
        let curvedTab:UIView = UIView(frame: CGRect(x: -1, y: 0, width:Int(UIScreen.main.bounds.width) + 2, height: 20))
        curvedTab.frame.origin.y = self.tableView.bounds.height * 25/32 - 10

        curvedTab.layer.cornerRadius = 10
        curvedTab.backgroundColor = .white
        curvedTab.layer.borderColor = UIColor.app_blueGrey.cgColor
        curvedTab.frame.insetBy( dx: -2, dy: -2);
        curvedTab.layer.borderWidth = 0.5
        curvedTab.tag = 558
        
        let tabIndent:UIView = UIView(frame: CGRect(x: (Int(UIScreen.main.bounds.width)/2)-15, y: 5, width: 30, height: 4))
        tabIndent.layer.cornerRadius = 2
        tabIndent.backgroundColor = .app_lightGrey
        tabIndent.layer.borderColor = UIColor.app_lightGrey.cgColor
        tabIndent.layer.borderWidth = 1
        tabIndent.tag = 559

        curvedTab.addSubview(tabIndent)
        curvedTab.layer.zPosition = -1
        backgroundMapView.layer.zPosition = -1
        tableView.addSubview(curvedTab)
        
        //  self.backgroundMapView.bounds = CGRect(x: 0, y: 0, width: (Int(tableView.bounds.width)), height: Int(UIScreen.main.bounds.height * 25/32))
        //  self.backgroundMapView.mapView.bounds = CGRect(x: 0, y: 0, width: (Int(tableView.bounds.width)), height: Int(UIScreen.main.bounds.height * 25/32))
        if let coord = self.headingToAnnotation {
            self.backgroundMapView.addHeading(point: coord, deadhead: self.deadhead)
        }
        
        self.backgroundMapView.delegate = self
        self.backgroundMapView.frame = self.view.frame
        self.backgroundMapView.mapView.frame = self.view.frame
        self.tableView.backgroundView = self.backgroundMapView
        
        if let heading = self.headingToAnnotation{
            var location = CLLocationCoordinate2DMake((heading.coordinate.latitude), (heading.coordinate.longitude))
        location.latitude -= self.backgroundMapView.mapView.region.span.latitudeDelta * 0.0002 * Double(self.deadhead)
        let viewRegion = MKCoordinateRegionMakeWithDistance(location, CLLocationDistance(5000 * self.deadhead), CLLocationDistance(5000 * self.deadhead))
        self.backgroundMapView.mapView.setRegion(viewRegion, animated: false)
        }
        
     
        if toggle{
            if let coord = self.headingToAnnotation {
                self.backgroundMapView.addHeading(point: coord, deadhead: self.deadhead)
            }
         
            
            tableView.isScrollEnabled = true
            setPickupButton.frame.origin.y = UIScreen.main.bounds.width - 60
            setDateButton.frame.origin.y = UIScreen.main.bounds.width - 60
            curvedTab.frame.origin.y = UIScreen.main.bounds.width - 10
           // getAPI().getShipments(delegate: self)
           // getAPI().getAvailableShipments(delegate: self)
            
        }
        else{
            if let coord = self.headingToAnnotation {
                self.backgroundMapView.addHeading(point: coord, deadhead: self.deadhead)
            }
           
            tableView.isScrollEnabled = false
            setPickupButton.frame.origin.y = self.tableView.bounds.height * 25/32 - 60
            setDateButton.frame.origin.y = self.tableView.bounds.height * 25/32 - 60
            curvedTab.frame.origin.y = self.tableView.bounds.height * 25/32 - 10
            self.tableView.reloadData()
        }
        
    }

    @objc func willEnterForeground(){
        tableView.reloadData()
        addLocationViewIfNeccessary()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if toggle{
            getAPI().getAvailableShipments(delegate: self)
        }

        
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
      
        // Set the shadow color.
        navigationController?.navigationBar.shadowImage = UIColor.app_lightGrey.as1ptImage()
        
        addLocationViewIfNeccessary()
    }
    
    func addLocationViewIfNeccessary() {
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            let enableLocationView = self.storyboard?.instantiateViewController(withIdentifier: "EnableLocationAlertView") as! EnableLocationAlertView
            enableLocationView.providesPresentationContextTransitionStyle = true
            enableLocationView.definesPresentationContext = true
            enableLocationView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            enableLocationView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            self.present(enableLocationView, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let availableToggle = self.view.viewWithTag(560) as! UISwitch
        let pickupButton = self.view.viewWithTag(556) as! UIButton
        let destinationButton = self.view.viewWithTag(557) as! UIButton
        let curvedTab = self.view.viewWithTag(558)!
        
        if toggle{
            
            availableToggle.isOn = true
            pickupButton.frame.origin.y = UIScreen.main.bounds.width - 60
            destinationButton.frame.origin.y = UIScreen.main.bounds.width - 60
            curvedTab.frame.origin.y = UIScreen.main.bounds.width - 10
            
        }
        else{
            availableToggle.isOn = false
            pickupButton.frame.origin.y = self.tableView.bounds.height * 25/32 - 60
            destinationButton.frame.origin.y = self.tableView.bounds.height * 25/32 - 60
            curvedTab.frame.origin.y = self.tableView.bounds.height * 25/32 - 10
        }
    }
    



    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let aTouches = touches as? Set<UITouch>, let anEvent = event {
            super.touchesBegan(aTouches, with: anEvent)
        }
        for subview: UIView in subviews.reverseObjectEnumerator() {
            if (subview is CustomSubView) {
                if let aTouches = touches as? Set<UITouch> {
                    subview.touchesBegan(aTouches, with: event)
                }
            }
        }
    }
*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func callSupport( button: Any? ){
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CallSupportAlertView") as! CallSupportAlertView
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(customAlert, animated: true, completion: nil)
    }
    @objc func enableLocationServices( button: Any?){
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                // Finished opening URL
            })
        }
    }
    @objc func dateButtonClick( button: Any?){
        let datePicker = self.storyboard?.instantiateViewController(withIdentifier: "DatePicker") as! DatePicker
            datePicker.providesPresentationContextTransitionStyle = true
        datePicker.definesPresentationContext = true
        datePicker.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
       // datePicker.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        datePicker.didSetDate = {
            self.setDateButton.setTitle(datePicker.selectedDate, for: .normal)
            let defaults = UserDefaults.standard
            
            defaults.set(datePicker.selectedDate, forKey: self.dateKey)
            self.shipmentsModel.sortShipments()
        }
        
        self.present(datePicker, animated: true, completion: nil)
    }
    
    @objc func pickupButtonClick( button: Any?){
        let vc = LocationSelectViewController.instance(delegate: self)
        self.navigationItem.backBarButtonItem!.title = "Back"
        self.navigationItem.backBarButtonItem!.image = nil
        vc.hidesBottomBarWhenPushed = true
        vc.sender = "pickup"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func notificationPressed( button: Any? ){    
        let vc = NotificationsViewController.instance(notifications: notifications.notificationArray)
        let vcNavController = UINavigationController(rootViewController: vc)
    
        self.present(vcNavController, animated: true, completion: nil)
    }
    
    
    @objc func deadheadButtonClick( button: Any? ){

        let deadheadAlert = self.storyboard?.instantiateViewController(withIdentifier: "DeadheadAlertView") as! DeadheadAlertView
        deadheadAlert.deadhead = self.deadhead
        deadheadAlert.providesPresentationContextTransitionStyle = true
        deadheadAlert.definesPresentationContext = true
        deadheadAlert.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        deadheadAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        deadheadAlert.delegate = self
        self.present(deadheadAlert, animated: true, completion: nil)

    }
    
    @objc func truckTypeButtonClick( button: Any? ){
        let truckTypeAlert = self.storyboard?.instantiateViewController(withIdentifier: "TruckTypeAlertView") as! TruckTypeAlertView
        truckTypeAlert.truckType = self.truckType
        truckTypeAlert.providesPresentationContextTransitionStyle = true
        truckTypeAlert.definesPresentationContext = true
        truckTypeAlert.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        truckTypeAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        truckTypeAlert.delegate = self
        self.present(truckTypeAlert, animated: true, completion: nil)
    }
    
    @objc func sortButtonClick( button: Any? ){

        let sortingAlert = self.storyboard?.instantiateViewController(withIdentifier: "SortByAlertView") as! SortByAlertView
        sortingAlert.sortBy = shipmentsModel.sortBy
        sortingAlert.providesPresentationContextTransitionStyle = true
        sortingAlert.definesPresentationContext = true
        sortingAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        sortingAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        sortingAlert.delegate = shipmentsModel
        self.present(sortingAlert, animated: true, completion: nil)
        
    }
   
    @objc func refocusMap(){
        if self.headingToAnnotation != nil{
        var location = CLLocationCoordinate2DMake((self.headingToAnnotation?.coordinate.latitude)!, (self.headingToAnnotation?.coordinate.longitude)!)
        var viewRegion = MKCoordinateRegionMakeWithDistance(location, CLLocationDistance(5000 * self.deadhead), CLLocationDistance(5000 * self.deadhead))
        location.latitude -= viewRegion.span.latitudeDelta * 0.002 * Double(self.deadhead / 4 + 150 )
        viewRegion = MKCoordinateRegionMakeWithDistance(location, CLLocationDistance(5000 * self.deadhead), CLLocationDistance(5000 * self.deadhead))
        self.backgroundMapView.mapView.setRegion(viewRegion, animated: true)
        }

    }
    
    @objc func toggleSort( button: Any? ){
        shipmentsModel.sortByToggle = !shipmentsModel.sortByToggle
    }
}

extension AvailableShipmentsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1.0
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shipmentsModel.numberOfCells
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return shipmentsModel.cellHeight(at: indexPath.row, tableViewHeight: tableView.bounds.height, mainScreenWidth: UIScreen.main.bounds.width)
    }
 

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch shipmentsModel.cells[indexPath.row] {
        case .map:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GestureForwardingCell") as? GestureForwardingCell else {
                break
            }

            cell.backgroundColor = UIColor.clear
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.size.width, bottom: 0, right: 0)

            return cell

        case .shipment(let shipment):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadBoardCell") as? LoadBoardCell else {
                break
            }
            
            cell.configureForUseInAvailableShipments()
            
            return cell.configure(shipment: shipment, headingTo: self.headingToAnnotation?.coordinate)

        case .available:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AvailabilityCell") as? AvailabilityCell else {
                break
            }
            cell.layer.zPosition = 0
            cell.availableSwitch.tintColor = .app_lightBlueGrey
            cell.availableSwitch.backgroundColor = .app_lightBlueGrey
            cell.availableSwitch.layer.cornerRadius = 16.0
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.delegate = self
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
        
            return cell
        case .headingTo(let label):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DesiredPickup") as? DesiredPickup else {
                break
            }

            cell.destinationLabel.text = label

            return cell
            
        case .desiredDestination(let label):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DesiredDestination") as? DesiredDestination else {
                break
            }
            
            cell.destinationLabel.text = label
            
            return cell

        case .deadhead(let label):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeadheadCell") as? DeadheadCell else {
                break
            }

            cell.deadheadLabel.text = label

            return cell

        case .noShipments:
            var cell: UITableViewCell
            
            if toggle{
                let aCell = tableView.dequeueReusableCell(withIdentifier: ShipmentsHeaderCell.identifier, for: indexPath) as! ShipmentsHeaderCell
                
                aCell.delegate = self
                aCell.configure(numberOfShipments: shipmentsModel.sortedShipments.count,
                                sortBy: shipmentsModel.sortBy.rawValue,
                                sortByToggle: shipmentsModel.sortByToggle)
                
                cell = aCell
            }
            else{
                cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                
                if LocationManager.shared.locationServicesEnabled {
                    cell.textLabel?.text = kBecomeAvailableTitle
                    cell.textLabel?.textAlignment = .center
                    cell.textLabel?.textColor = .app_darkGrey
                    cell.backgroundColor = .app_lightestGrey
                    
                    cell.separatorInset.right = cell.separatorInset.left
                    
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                }
                else{
                    let locationButton = UIButton(frame: CGRect(x: 40, y: (cell.bounds.height / 2) - 5, width: tableView.frame.width - 80, height: 50))
                    locationButton.backgroundColor = .app_blue
                    locationButton.layer.cornerRadius = 5
                    locationButton.layer.borderWidth = 1
                    locationButton.layer.borderColor = UIColor.app_blue.cgColor
                    locationButton.setTitle("Enable Location Services", for: .normal)
                    locationButton.setTitleColor(.white, for: .normal)
                    locationButton.addTarget(self, action:#selector(self.enableLocationServices), for: .touchUpInside)
                
                    cell.addSubview(locationButton)
                }
            }
            return cell
        case .field(let label):
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            if toggle{
                cell.textLabel?.text = label
            }
            else{
                cell.textLabel?.text = ""
            }
            
           // cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            cell.textLabel?.textColor = .app_darkGrey
            cell.backgroundColor = .app_lightestGrey
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
        
        case .spacing:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.backgroundColor = .app_lightestGrey
            cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
            cell.selectionStyle = .none
            return cell
            
        case .empty:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.backgroundColor = .app_lightestGrey
            return cell
        }

        fatalError("Cannot find cell")
    }
}
extension AvailableShipmentsViewController: MapViewDelegate {
    func annotationSelect(view: MKAnnotationView){
        let title = view.annotation!.title!!
        self.backgroundMapView.mapView.deselectAnnotation(view.annotation,
                                                          animated: false)
        print("annotation",title)
        if title != "pickup"{
            let index = Int(title)
            let vc = AcceptShipmentViewController(shipment: shipmentsModel.sortedShipments[index!])
            self.navigationItem.backBarButtonItem!.title = "Back"
            self.navigationItem.backBarButtonItem!.image = nil
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension AvailableShipmentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch shipmentsModel.cells[indexPath.row] {
        case .shipment(let shipment):
            let vc = AcceptShipmentViewController(shipment: shipment)
            self.navigationItem.backBarButtonItem!.title = "Back"
            self.navigationItem.backBarButtonItem!.image = nil
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)

        case .deadhead:
            let vc = UIAlertController(title: "Deadhead", message: nil, preferredStyle: .actionSheet)
            self.present(vc, animated: true, completion: nil)

        case .headingTo:
            let vc = LocationSelectViewController.instance(delegate: self)
            vc.sender = "pickup"
            self.present(vc, animated: true, completion: nil)
        
        case .desiredDestination:
            let vc = LocationSelectViewController.instance(delegate: self)
            vc.sender = "destination"
            self.present(vc, animated: true, completion: nil)

        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension AvailableShipmentsViewController: GetAvailableShipmentsDelegate {
    func getAvailableShipmentsSuccess(shipments: [Shipment]) {
        shipmentsModel.shipments = shipments
        shipmentsModel.sortShipments()

        self.tableView.reloadData()
    }
}

extension AvailableShipmentsViewController: DeadheadAlertViewDelegate {
    func deadheadTapped(selectedOption: Int) {
        self.deadhead = selectedOption
        let deadheadButton = self.view.viewWithTag(555) as! UIButton
        deadheadButton.setTitle("\(self.deadhead)mi", for: .normal)
        if let coord = self.headingToAnnotation {
            self.backgroundMapView.addHeading(point: coord, deadhead: self.deadhead)
        }
        
        if toggle {
           shipmentsModel.sortShipments()
        }
        
        refocusMap()
    }
}

extension AvailableShipmentsViewController: TruckTypeAlertViewDelegate {
    func truckTypeTapped(selectedOption: String) {
        self.truckType = selectedOption
        var readable = self.truckType
        if selectedOption != "Show All" {
            readable = (TruckType(rawValue: selectedOption)?.readable)!
        }
        UserDefaults.standard.set(selectedOption, forKey: truckTypeKey)
        let truckTypeButton = self.view.viewWithTag(554) as! UIButton
        truckTypeButton.setTitle("\(readable)", for: .normal)

        
        if toggle {
            shipmentsModel.sortShipments()
        }
        
        refocusMap()
    }
}

extension AvailableShipmentsViewController: LocationSelectViewControllerDelegate {
    func locationSet(sender: String, location: String, coord: CLLocationCoordinate2D) {
        
        if sender == "pickup" {
        self.headingToAnnotation = MKPointAnnotation()
        self.headingToAnnotation?.coordinate = coord

        self.headingTo = location

        let defaults = UserDefaults.standard
        defaults.set(coord.latitude, forKey: headingToLatKey)
        defaults.set(coord.longitude, forKey: headingToLngKey)
        defaults.set(headingTo, forKey: headingToKey)
       
        shipmentsModel.updateCells()
        
        let pickupButton = self.view.viewWithTag(556) as! UIButton
        pickupButton.setTitle("\(location)", for: .normal)

        if let coord = self.headingToAnnotation {
            self.backgroundMapView.addHeading(point: coord, deadhead: self.deadhead)
        }
        if toggle{
            //getAPI().getShipments(delegate: self)
            getAPI().getAvailableShipments(delegate: self)
        }
        refocusMap()
        self.tableView.reloadData()
        }
        else{
            let destination = location
            self.destinationAnnotation = MKPointAnnotation()
            self.destinationAnnotation?.coordinate = coord
            
            self.desiredDate = destination
            let defaults = UserDefaults.standard
            defaults.set(coord.latitude, forKey: destinationLatKey)
            defaults.set(coord.longitude, forKey: destinationLngKey)
            defaults.set(destination, forKey: dateKey)
            
            shipmentsModel.updateCells()

            self.tableView.reloadData()
            
            let destinationButton = self.view.viewWithTag(557) as! UIButton
            destinationButton.setTitle("\(destination)", for: .normal)
        }
    }
}

extension AvailableShipmentsViewController: AvailabilityCellControllerDelegate{
    func toggleSwitch(isOn: Bool) {
        toggle = isOn
        if !isOn {
            handleToggleOff()
            return
        }
        
        if !LocationManager.shared.locationServicesEnabled {
            showLocationDisabledAlert()
            return
        }
//        var locationObserverToken: NSObjectProtocol?
//        locationObserverToken = NotificationCenter.default.addObserver(forName: LocationManager.locationAvailableNotif, object: nil, queue: nil) { [weak self] _ in
//            NotificationCenter.default.removeObserver(locationObserverToken!)
//            self?.handleLocationFound(isOn: isOn)
//        }
        self.handleLocationFound(isOn: isOn)

    }
    
    private func handleLocationFound(isOn: Bool) {
        // TODO: need to revisit.. viewWithTag is bad!!
        let pickupButton = self.view.viewWithTag(556) as! UIButton
        let destinationButton = self.view.viewWithTag(557) as! UIButton
        let curvedTab = self.view.viewWithTag(558)!
        
        UserDefaults.standard.set(isOn, forKey: "isAvailable")
        
        tableView.beginUpdates()
        
        tableView.isScrollEnabled = true
        //getAPI().getShipments(delegate: self)
        getAPI().getAvailableShipments(delegate: self)
        UIView.animate(withDuration: 0.3, animations: {
            pickupButton.frame.origin.y = UIScreen.main.bounds.width - 60
            destinationButton.frame.origin.y = UIScreen.main.bounds.width - 60
            curvedTab.frame.origin.y = UIScreen.main.bounds.width - 10
        })
        
        tableView.endUpdates()
    }
    
    private func handleToggleOff() {
        UserDefaults.standard.set(false, forKey: "isAvailable")
        
        tableView.beginUpdates()
        
        // TODO: need to revisit.. viewWithTag is bad!!
        let pickupButton = self.view.viewWithTag(556) as! UIButton
        let destinationButton = self.view.viewWithTag(557) as! UIButton
        let curvedTab = self.view.viewWithTag(558)!
        
        if let coord = self.headingToAnnotation {
            self.backgroundMapView.addHeading(point: coord, deadhead: self.deadhead)
        }
        else {
            let annotations = self.backgroundMapView.mapView.annotations
            self.backgroundMapView.mapView.removeAnnotations(annotations)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            pickupButton.frame.origin.y = self.tableView.bounds.height * 25/32 - 60
            destinationButton.frame.origin.y = self.tableView.bounds.height * 25/32 - 60
            curvedTab.frame.origin.y = self.tableView.bounds.height * 25/32 - 10
        }, completion: {
            (value: Bool) in
            self.tableView.reloadData()
            self.tableView.isScrollEnabled = false
        })
        
        tableView.endUpdates()
    }
    
    private func showLocationDisabledAlert() {
        let alert = UIAlertController(title: "Enable Location Services",
                                      message: "Locations services must be enabled to view available shipments and use this app.",
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
        let availableToggle = self.view.viewWithTag(560) as! UISwitch // TODO: need to revisit.. viewWithTag is an antipattern.
        availableToggle.isOn = false
    }
}



extension AvailableShipmentsViewController: GetShipmentsDelegate {
    func getShipmentsSuccess(shipments: [Shipment]) {
        
        AppDelegate.sharedAppDelegate().appCurrentState.liveShipments = shipments

        LocationManager.shared.clearPreviousGeofencingRegions()
        prepareGeofenceRegions()

        clearNotificationReminders()
        prepareNotificationsReminders()
    }

    fileprivate func clearNotificationReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests();
    }

    fileprivate func prepareNotificationsReminders() {
        let timeIntervals = [-24, -8, -3]
        
        let liveShipments = AppDelegate.sharedAppDelegate().appCurrentState.liveShipments
        
        for shipment in liveShipments {
            
            let shipmentId = shipment.id!
            
            var allRequests = [UNNotificationRequest]()
            
            for timeInterval in timeIntervals {
                let center = UNUserNotificationCenter.current()
                
                if shipment.pickup!.appointmentNeeded! {
                    let displayDate = shipment.pickupAt!.description(with: Locale.current)
                    let body = "Shipment # " + String(shipmentId) + ": Due for Pick-up on " + displayDate
                    
                    let pickUpId = buildNotificationIdentifier(shipmentId: shipmentId, timeInterval: timeInterval, eventType: "PickUp")
                    let pickupRequest = buildNotificationReminder(appointmentDate: shipment.pickupAt!, dateOffSet: timeInterval, title: "Pick-up Reminder", body: body, identifier: pickUpId)
                    allRequests.append(pickupRequest)
                }
                
                if shipment.dropoff!.appointmentNeeded! {
                    let dropOffId = buildNotificationIdentifier(shipmentId: shipmentId, timeInterval: timeInterval, eventType: "DropOff")
                    let displayDate = shipment.dropoffAt!.description(with: Locale.current)
                    let body = "Shipment # " + String(shipmentId) + ": Due for Drop-off on " + displayDate
                    let dropOffRequest = buildNotificationReminder(appointmentDate: shipment.dropoffAt!, dateOffSet: timeInterval, title: "Drop-off Reminder", body: body, identifier: dropOffId)
                    allRequests.append(dropOffRequest)
                }
                
                for request in allRequests {
                    print("request", request.content)
                    center.add(request) { (error : Error?) in
                        if let theError = error {
                            print(theError.localizedDescription)
                        }
                    }
                }
            }
        }
    }

    fileprivate func setupNotifications(){
        let center = UNUserNotificationCenter.current()
        var count = 0
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        
        center.getPendingNotificationRequests(completionHandler: {requests -> () in
            count = requests.count
            for request in requests{
                print(request.content.title)
            }
         
            dispatchGroup.leave()
        })
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            if count > 0{
                let bell = UIImage(named: "bell")
                let notificationButton = UIBarButtonItem(image: bell, style: .plain, target: self, action: #selector
                (self.notificationPressed))
                self.navigationItem.rightBarButtonItem  = notificationButton
            }
            else{
                let bell = UIImage(named: "bell")!.alpha(0.2)
                let notificationButton = UIBarButtonItem(image: bell, style: .plain, target: self, action: #selector
                    (self.notificationPressed))
                self.navigationItem.rightBarButtonItem  = notificationButton
            }
        })
    }
    
    fileprivate func buildNotificationIdentifier(shipmentId:Int, timeInterval: Int, eventType: String) -> String {
        return String(shipmentId) + "::" + String(timeInterval) + " " + eventType
    }

    fileprivate func buildNotificationReminder(appointmentDate: Date, dateOffSet: Int, title: String, body: String, identifier: String) -> UNNotificationRequest{

        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)

        let triggerDate = Calendar.current.date(byAdding: .hour, value: dateOffSet, to: appointmentDate)
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate!)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    }

    fileprivate func prepareGeofenceRegions() {
        let liveShipments = AppDelegate.sharedAppDelegate().appCurrentState.liveShipments
        
        for liveShipment in liveShipments {
            if let pickupInformation = liveShipment.pickup {
                
                let pickupLat = pickupInformation.lat!
                let pickupLng = pickupInformation.lng!
                let radius = pickupInformation.geofenceRadius!
                
                let shipmentId = liveShipment.id!
                let regionIdentifier = String(shipmentId) + "::pickup"
                
                LocationManager.shared.addGeofence(lat: Double(pickupLat)!, lng: Double(pickupLng)!, geofenceRadius: radius, regionIdentifier: regionIdentifier)
            }
            
            if let dropoffInformation = liveShipment.dropoff {
                
                let dropoffLat = dropoffInformation.lat!
                let dropoffLng = dropoffInformation.lng!
                let radius = dropoffInformation.geofenceRadius!
                
                let shipmentId = liveShipment.id!
                let regionIdentifier = String(shipmentId) + "::dropoff"
                
                LocationManager.shared.addGeofence(lat: Double(dropoffLat)!, lng: Double(dropoffLng)!, geofenceRadius: radius, regionIdentifier: regionIdentifier)
            }
        }
    }
}

extension AvailableShipmentsViewController: ShipmentsHeaderDelegate {
    func didToggleSortOrder() {
        self.toggleSort(button: nil)
    }
    
    func didTapSortButton() {
        self.sortButtonClick(button: nil)
    }
}

