//
//  AcceptShipmentViewController.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/14/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class AcceptShipmentViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    fileprivate var acceptShipmentModel = AcceptShipmentModel()

    init(shipment: Shipment) {
        self.shipment = shipment
        super.init(style: .plain)
    }
    
    fileprivate var user: User?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate var shipment: Shipment
    var imagePickerModel: ImagePickerModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        getAPI().getUser(delegate: self)
        configureUI()
        print("accept shipment", shipment.status)
    }
    
    func configureUI(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        self.view.backgroundColor = UIColor(hex: "0xf9f9f9")
        
        self.tableView.contentInset = UIEdgeInsetsMake(-90,0,0,0)
 
        tableView.register(UINib(nibName: "MapCell", bundle: Bundle.main), forCellReuseIdentifier: MapCell.cellIdentifier)
        tableView.register(UINib(nibName: "AcceptBidCell", bundle: Bundle.main), forCellReuseIdentifier: "AcceptBidCell")
        tableView.register(UINib(nibName: "SingleButtonCell", bundle: Bundle.main), forCellReuseIdentifier: "SingleButtonCell")
        tableView.allowsSelection = false
    }

    

    override func viewWillAppear(_ animated: Bool) {
        
        acceptShipmentModel.loadData(shipment: self.shipment)
        let cell = Bundle.main.loadNibNamed("LoadBoardCell", owner: self, options: nil)![0] as! LoadBoardCell
        cell.configure(shipment: shipment)
        cell.pickupLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        cell.dropoffLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        cell.cellBottomConstraint.constant = -20
       
        let size = CGSize(width: tableView.frame.width / 2, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let initialFrame = NSString(string: cell.pickupLabel.text!).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 23)], context: nil)
        
        //format pickupLabel location text
        var text = cell.pickupLabel.text!
        cell.pickupLabel.numberOfLines = 2
        cell.pickupLabel.adjustsFontSizeToFitWidth = false
        cell.pickupLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.pickupLabel.sizeToFit()
        var textArr = text.components(separatedBy: " ")
        var newPickupText = ""
        if textArr.count <= 2 {
            cell.pickupLabel.numberOfLines = 1
            cell.pickupLabel.adjustsFontSizeToFitWidth = true
            newPickupText = text
            cell.pickupLabel.baselineAdjustment = .alignCenters
            cell.pickupLabel.lineBreakMode = NSLineBreakMode.byClipping

        }
        else{
            for (index, word) in textArr.enumerated(){
                if index == textArr.count / 2{
                    newPickupText += "\n"
                }
                newPickupText += word
                if index != textArr.count - 1{
                    newPickupText += " "
                }
            }
        }
        cell.pickupLabel.text = newPickupText
        
        //format dropoff location text
        text = cell.dropoffLabel.text!
        cell.dropoffLabel.numberOfLines = 2
        cell.dropoffLabel.adjustsFontSizeToFitWidth = false
        cell.dropoffLabel.sizeToFit()
        
        textArr = text.components(separatedBy: " ")
        newPickupText = ""
        if textArr.count <= 2 {
            cell.dropoffLabel.numberOfLines = 1
            cell.dropoffLabel.adjustsFontSizeToFitWidth = true
            cell.pickupLabel.baselineAdjustment = .alignCenters
            cell.dropoffLabel.lineBreakMode = NSLineBreakMode.byClipping
            newPickupText = text
        }
        else{
            for (index, word) in textArr.enumerated(){
                if index == textArr.count / 2{
                    newPickupText += "\n"
                }
                newPickupText += word
                if index != textArr.count - 1{
                    newPickupText += " "
                }
            }
        }
        cell.dropoffLabel.text = newPickupText
        
        
        
        
        cell.pickupLabel.frame.size.width = initialFrame.width
        cell.dropoffLabel.frame.size.width = initialFrame.width
        var fontSize = cell.pickupLabel.fontSize
        let pickupEstimatedFrame = NSString(string: cell.pickupLabel.text!).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)], context: nil)
        fontSize = cell.dropoffLabel.fontSize
        let dropoffEstimatedFrame = NSString(string: cell.dropoffLabel.text!).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)], context: nil)
        cell.pickupLabel.frame = CGRect(x: 0, y: 0, width: (Int(pickupEstimatedFrame.width)), height: Int(pickupEstimatedFrame.height))        
        cell.dropoffLabel.frame = CGRect(x: (Int(tableView.bounds.width / 2)), y: 0 - Int(dropoffEstimatedFrame.height)  , width: (Int(tableView.bounds.width)), height: Int(dropoffEstimatedFrame.height))
        print("font", cell.pickupLabel.font.pointSize)
        print("font2", cell.pickupLabel.fontSize)
        cell.rateLabel.text = ""
      
        cell.contentView.frame = CGRect(x: 0, y: (Int(tableView.bounds.height / 2)) - 110  , width: (Int(tableView.bounds.width)), height: 110)
        
        let whiteView = CALayer()
        whiteView.frame = CGRect(x: 0, y: 70, width: (Int(tableView.bounds.width)), height: 40)
        whiteView.backgroundColor = UIColor.white.cgColor
        cell.contentView.layer.insertSublayer(whiteView, at: 0)
        let colors = Colors()
        let backgroundLayer = colors.gl
        
        let gradView = UIView( frame: CGRect(x: 0, y: (Int(tableView.bounds.height / 2)) - 120, width: (Int(tableView.bounds.width)), height: 80))
        backgroundLayer?.frame = CGRect(x: 0, y: 0, width: (Int(tableView.bounds.width)), height: 80)
        // gradView.frame = cell.contentView.frame
        gradView.layer.insertSublayer(backgroundLayer!, at: 0)
        tableView.addSubview(gradView)
        
        tableView.addSubview(cell.contentView)

    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acceptShipmentModel.numberOfCells
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(acceptShipmentModel.cells[indexPath.row]){
        case .description:
            return UITableViewAutomaticDimension
        default:
            return CGFloat(acceptShipmentModel.cellHeight(at: indexPath.row))
        }

    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch acceptShipmentModel.cells[indexPath.row] {
        case .map:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell") as! MapCell
           
            if shipment.status == .accepted || shipment.status == .inTransit{
                cell.mapView.showsUserLocation = true
            }
            
            
            return cell.configure(for: shipment)


        case .bid:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AcceptBidCell") as? AcceptBidCell else {
                break
            }
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            return cell.configure(accept: self.accept, bid: self.bid)
        
        case .waiting:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AcceptBidCell") as? AcceptBidCell else {
                break
            }
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.acceptButton.setTitle("Awaiting Confirmation", for: .normal)
            cell.acceptButton.isEnabled = false
            cell.acceptButton.backgroundColor = UIColor(hex: "0xefefef")
            cell.acceptButton.setTitleColor( UIColor(hex: "0x999999"), for: .normal)
            cell.buttonShadow.isHidden = true
            cell.bidButton.isHidden = true
            return cell

        case .field(let label, let value):
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.text = label
            cell.detailTextLabel?.text = value
            
            let tempFont = cell.textLabel?.textColor
            cell.textLabel?.textColor = cell.detailTextLabel?.textColor
            cell.detailTextLabel?.textColor = tempFont
            
            cell.separatorInset.right = cell.separatorInset.left
            
            if label == "Rate"{
                cell.detailTextLabel?.textColor = UIColor(hex: "0x2490c4")
            }
            if (shipment.status != .available && label == "Weight"){
                cell.preservesSuperviewLayoutMargins = false
                cell.separatorInset = UIEdgeInsets.zero
                cell.layoutMargins = UIEdgeInsets.zero
            }
            if value == "✓" {
                cell.accessoryType = .checkmark
                cell.detailTextLabel?.text = ""
            }

            return cell
            
        case .heading(let label):
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = label
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            cell.textLabel?.frame.origin.y += 150
            cell.backgroundColor = UIColor(hex: "0xf9f9f9")
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
            
        case .description(let label, let value):
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = label
            cell.detailTextLabel?.text = value
            cell.detailTextLabel?.numberOfLines = 0

            let tempFont = cell.textLabel?.font
            cell.textLabel?.font = cell.detailTextLabel?.font
            cell.detailTextLabel?.font = tempFont
            
            cell.textLabel?.textColor = UIColor(hex: "0xB8B8B8")
            cell.separatorInset.right = cell.separatorInset.left
            
            if label == "Pickup Instructions" || label == "Dropoff Instructions"{
                cell.preservesSuperviewLayoutMargins = false
                cell.separatorInset = UIEdgeInsets.zero
                cell.layoutMargins = UIEdgeInsets.zero
            }
            
            return cell
            
        case .serviceDescription(let label, let value, let info):
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = label
            cell.detailTextLabel?.text = value
            cell.detailTextLabel?.numberOfLines = 0
            
            let infoLabel = UILabel(frame: CGRect (x: 0, y: 0, width: 30, height: 30))
            infoLabel.textAlignment = .right
            infoLabel.text = info
            cell.accessoryView = infoLabel
            
            cell.textLabel?.textColor = UIColor(hex: "0xB8B8B8")
            cell.separatorInset.right = cell.separatorInset.left
            
            return cell

        case .available(let isAvailable):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AvailabilityCell") as? AvailabilityCell else {
                break
            }

            cell.availableSwitch.isOn = isAvailable

            return cell

        case .pickup:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleButtonCell") as? SingleButtonCell else {
                break
            }
            cell.button.layer.cornerRadius = 5
            cell.button.layer.borderWidth = 1
            cell.button.layer.borderColor = UIColor.app_orange.cgColor
            cell.button.layer.backgroundColor = UIColor.app_orange.cgColor
            cell.separatorInset.right = cell.separatorInset.left

            return cell.configure(title: "Mark as Picked Up", callback: self.pickedUp(_:))

        case .delivered:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleButtonCell") as? SingleButtonCell else {
                break
            }
            cell.button.layer.cornerRadius = 5
            cell.button.layer.borderWidth = 1
            cell.button.layer.borderColor = UIColor.app_green.cgColor
            cell.button.layer.backgroundColor = UIColor.app_green.cgColor
            cell.separatorInset.right = cell.separatorInset.left
           
            return cell.configure(title: "Mark as Delivered", callback: self.delivered(_:))
        
        case .uploadPOD:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleButtonCell") as? SingleButtonCell else {
                break
            }
            cell.button.layer.cornerRadius = 5
            cell.button.layer.borderWidth = 1
            cell.button.layer.borderColor = UIColor.app_purple.cgColor
            cell.button.layer.backgroundColor = UIColor.app_purple.cgColor
            cell.separatorInset.right = cell.separatorInset.left
            
            return cell.configure(title: "Upload Proof of Delivery", callback: self.uploadDocument(_:))
            
        case .spacing:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.backgroundColor = UIColor(hex: "0xf9f9f9")
            cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
            return cell
            
        }

        fatalError("Accept Shipment: Uknown cell type")
    }
    func uploadDocument(_ button: UIButton){
        imagePickerModel = ImagePickerModel( viewController: self, shipment: shipment)
        imagePickerModel?.showImagePicker()
        
    }

    func pickedUp(_ button: UIButton) {
        getAPI().pickup(shipment: self.shipment, delegate: self)
    }

    func delivered(_ button: UIButton) {
        getAPI().delivered(shipment: self.shipment, delegate: self)
    }

    func accept() {
        let vc = UIAlertController(title: "Accept Load?", message: nil, preferredStyle: .alert)

        vc.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            getAPI().accept(shipment: self.shipment, delegate: self)
        }))

        vc.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(vc, animated: true, completion: nil)
    }

    func bid() {
        let vc = UIAlertController(title: "Please Enter Bid", message: nil, preferredStyle: .alert)

        vc.addTextField { (textField) in
            textField.keyboardType = .decimalPad
        }

        vc.addAction(UIAlertAction(title: "Bid", style: .default, handler: { (action) in
            self.showAlert(title: "Not implemented", message: nil, okTapped: {
                vc.dismiss(animated: true, completion: nil)
            })
        }))

        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(vc, animated: true, completion: nil)
    }
    func fetchLatestPhotos(forCount count: Int?) -> PHFetchResult<PHAsset> {
        
        // Create fetch options.
        let options = PHFetchOptions()
        
        // If count limit is specified.
        if let count = count { options.fetchLimit = count }
        
        // Add sortDescriptor so the lastest photos will be returned.
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]
        
        // Fetch the photos.
        return PHAsset.fetchAssets(with: .image, options: options)
        
    }
    
}

extension AcceptShipmentViewController: AcceptShipmentDelegate {
    func acceptShipmentSuccess(shipment: Shipment) {
        if ((self.user) != nil){
            if (user?.canBook)! {
                showAlert(title: "Shipment Accepted!", message: nil) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                showAlert(title: "Dispatch Notified!", message: "Dispatch has been notified of your interest in this load") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }

    }
}

extension AcceptShipmentViewController: PickupShipmentDelegate {
    func pickupShipmentSuccess(shipment: Shipment) {
        self.shipment = shipment
        acceptShipmentModel.loadData(shipment: shipment)
        self.tableView.reloadData()

        showAlert(title: "Dispatch Notified!", message: "Dispatch has been notified you picked up the shipment", okTapped: nil)
    }
}

extension AcceptShipmentViewController: DeliveredShipmentDelegate {
    func deliveredShipmentSuccess(shipment: Shipment) {
        self.shipment = shipment
        acceptShipmentModel.loadData(shipment: shipment)
        self.tableView.reloadData()

        showAlert(title: "Dispatch Notified!", message: "Dispatch has been notified you delivered the shipment") {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AcceptShipmentViewController: GetUserDelegate {
    func getUserSuccess(user: User) {
        self.user = user
        UserDefaults.standard.set(user.id!,forKey: "userID")
    }
}



