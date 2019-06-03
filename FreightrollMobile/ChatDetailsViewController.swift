//
//  ChatDetailsViewController.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/6/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit

class ChatDetailsViewController: UITableViewController {
        
    var chat: Chat?
    fileprivate var shipment: Shipment?
    fileprivate var user: User?
    fileprivate var cells: [Cell] = []
    fileprivate var users: [User] = []
    var userID : Int?
    
    enum Cell {
        case available(isAvailable: Bool)
        case map
        case members(chat: Chat?)
        
    }

    
    static func instance(chat: Chat, shipment: Shipment) -> ChatDetailsViewController {
        let vc = ChatDetailsViewController()
        vc.chat = chat
        vc.shipment = shipment
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //self.tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(hex: "0xf9f9f9")
        self.navigationController?.navigationBar.tintColor = UIColor.black

        self.title = "DETAILS"
        
        tableView.register(UINib(nibName: "ChatMemberCell", bundle: Bundle.main), forCellReuseIdentifier: "ChatMemberCell")
        tableView.register(UINib(nibName: "MuteNotificationsCell", bundle: Bundle.main), forCellReuseIdentifier: "MuteNotificationsCell")
        self.tableView.tableFooterView = UIView()
        
        userID = UserDefaults.standard.integer(forKey: "userID")
        
        for member in (chat?.users)!{
            if !(member.id == userID){
                users.append(member)
            }
        }
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupCommonAppearance()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let vc = AcceptShipmentViewController(shipment: shipment!)
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor =  UIColor(hex: "0xf9f9f9")
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return users.count
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.section){
        case 0:
            return 92
        case 1:
            return 50
        case 2:
            return 50
        default:
            return 0
        }
      
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        switch(indexPath.section){
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMemberCell") as? ChatMemberCell else {
                break
            }
            cell.separatorInset.right = cell.separatorInset.left
            cell.selectionStyle = .none

            return cell.configure(user: users[indexPath.row])
        case 1:
            if(indexPath.row == 0){
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MuteNotificationsCell") as? MuteNotificationsCell else {
                    break
                }
                cell.selectionStyle = .none
                cell.separatorInset.right = cell.separatorInset.left
                return cell
            }
            else{
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "Leave Conversation"
                cell.textLabel?.textColor = UIColor.red
                
                cell.separatorInset.right = cell.separatorInset.left
                return cell
            }
        case 2:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "View Shipment in Live Shipments"
            cell.textLabel?.textColor = UIColor(red:0.1, green:0.56, blue:0.78, alpha:1)
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)

            return cell
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        return cell
        
    }
    let headerTitles = ["Members", " ", " "]
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section
        {
        case 0:
            return headerTitles[0]
        case 1:
            return headerTitles[1]
        case 2:
            return headerTitles[2]
        default:
            return "No More Data"
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 60
            
        }
        else{
            return 35
        }
    }

    
    
}



