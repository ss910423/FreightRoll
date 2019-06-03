//
//  ShipmentsViewController.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/14/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit
import UserNotifications
import NVActivityIndicatorView

class ShipmentsViewController: UIViewController {

    fileprivate var shipmentsViewModel = ShipmentsViewModel()
    
    let notifications = NotificationListBuilder()

    @IBOutlet weak var activityView: NVActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

        setupNotifications()
        notifications.setup()
        
        shipmentsViewModel.didFetchShipmentsHandler = { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.separatorStyle = .singleLine
            self?.tableView.tableFooterView = UIView()
            self?.activityView.stopAnimating()
        }
    }
    
    func configureUI(){
        activityView.startAnimating()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.app_lightestGrey
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        
        self.navigationItem.title = "LIVE SHIPMENTS"
        let supportButton = UIBarButtonItem(image: UIImage(named: "phone_small"), style: .plain, target: self, action: #selector(self.callSupport))
        self.navigationItem.leftBarButtonItem  = supportButton
        
        tableView.register(UINib(nibName: "LoadBoardCell", bundle: Bundle.main), forCellReuseIdentifier: "LoadBoardCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCommonAppearance()
        
        shipmentsViewModel.loadData()
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
    
    @objc func callSupport( button: Any? ){
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CallSupportAlertView") as! CallSupportAlertView
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(customAlert, animated: true, completion: nil)
    }
    @objc func notificationPressed( button: Any? ){
        let vc = NotificationsViewController.instance(notifications: notifications.notificationArray)
        let vcNavController = UINavigationController(rootViewController: vc)
        
        self.present(vcNavController, animated: true, completion: nil)
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    
}


extension ShipmentsViewController: UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shipmentsViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(shipmentsViewModel.cellHeight(at: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch shipmentsViewModel.cells[indexPath.row] {

        case .shipment(let shipment):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadBoardCell") as? LoadBoardCell else {
                break
            }
            self.tableView.separatorStyle = .singleLine
            cell.rateLabel.layer.cornerRadius = 10
            cell.rateLabel.layer.borderWidth = 1
            cell.rateLabel.textColor = UIColor(red:0.1, green:0.56, blue:0.78, alpha:1)
            cell.rateLabel.layer.borderColor = UIColor.app_blue.cgColor
            cell.setStatus(shipment: shipment)
            cell.separatorInset.right = cell.separatorInset.left
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
           
            return cell.configure(shipment: shipment)
            
        case .noShipments:
            self.tableView.separatorStyle = .none
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "No Live Shipments"
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = UIColor.clear
            
            return cell
        }
        
        fatalError("Cannot find cell")
    }
}

extension ShipmentsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch shipmentsViewModel.cells[indexPath.row] {
        case .shipment(let shipment):
            let vc = AcceptShipmentViewController(shipment: shipment)
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            self.navigationItem.backBarButtonItem = backItem
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        default:
            break
        }
    }
}


