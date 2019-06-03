//
//  NotificationsViewController.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/18/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

//
//  ChangePasswordViewController.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/6/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit

class NotificationsViewController: UITableViewController{

    fileprivate var cells: [Cell] = []
    fileprivate var notificationArr: [NotificationObj]?

  
    static func instance(notifications: [NotificationObj]) -> NotificationsViewController {
        let vc = NotificationsViewController()
        vc.notificationArr = notifications

        return vc
    }
    
    enum Cell {
        case field(title: String?, desc: String?)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissNotifications))
        
        self.title = "NOTIFICATIONS"
        self.tableView.dataSource = self
       
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        cells = setupCells()
        tableView.reloadData()
    }
    
    
    func setupCells() -> [Cell] {
        var cells: [Cell] = []
        notificationArr?.reverse()
        for notification in notificationArr!{
             print(notification.body)
            cells.append(.field(title: "\(notification.title!)", desc: "\(notification.body!)"))
        }
        
        return cells
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cells[indexPath.row] {

        case .field:
            return UITableViewAutomaticDimension
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        
        case .field(let title, let desc):
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = desc
            
            cell.detailTextLabel?.numberOfLines = 0
            
            let tempFont = cell.textLabel?.font
            cell.textLabel?.font = cell.detailTextLabel?.font
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.detailTextLabel?.font = tempFont
            
            cell.textLabel?.textColor = UIColor(hex: "0xB8B8B8")
            cell.separatorInset.right = cell.separatorInset.left
            
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let notification = notificationArr![indexPath.row]
        if notification.isMessage{
            let vc = ChatViewController.instance(shipment: notification.shipment!)
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            self.navigationItem.backBarButtonItem = backItem
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = AcceptShipmentViewController(shipment: notification.shipment!)
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            self.navigationItem.backBarButtonItem = backItem
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func dismissNotifications() {
        self.dismiss(animated: true, completion: nil)
    }
}


