//
//  CollaborationViewController.swift
//  FreightrollMobile
//
//  Created by Nick Forte on 8/27/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit
import UserNotifications
import NVActivityIndicatorView

class CollaborationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    fileprivate var shipments: [Shipment] = []
    fileprivate var chatMessageCount: [Int] = []
    fileprivate var chats: [Chat] = []
    fileprivate var user: User?
    var chatCount = 0
    var loaded = false
    let notifications = NotificationListBuilder()


    override func viewDidLoad() {
        super.viewDidLoad()

        let activityView = NVActivityIndicatorView(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 15, y: 45, width: 30, height: 30), type: .circleStrokeSpin, color: UIColor(hex: "0xe5e5e5"))
        activityView.tag = 100
        self.view.addSubview(activityView)
        activityView.startAnimating()
        self.tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(hex: "0xf9f9f9")
        
        self.navigationItem.title = "MESSAGES"
        getAPI().getUser(delegate: self)
        setupNotifications()
        notifications.setup()
        
        tableView.register(UINib(nibName: "LoadBoardCell", bundle: Bundle.main), forCellReuseIdentifier: "LoadBoardCell")

         self.tableView.tableFooterView = UIView()
        
        let supportButton = UIBarButtonItem(image: UIImage(named: "phone_small"), style: .plain, target: self, action: #selector(self.callSupport))
        self.navigationItem.leftBarButtonItem  = supportButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCommonAppearance()
        
        getAPI().getShipments(delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

}

extension CollaborationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatViewController.instance(shipment: shipments[indexPath.row])
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CollaborationViewController: UITableViewDataSource {
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loaded{
            tableView.allowsSelection = true
            return (shipments.count == 0) ? 1 : shipments.count
            

        }else{
            return 0
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if shipments.count == 0{
            return 110
        }
        
            return 80
        
      
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (shipments.count == 0){
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "No Message Feeds"
            cell.textLabel?.textAlignment = .center
            cell.separatorInset.right = cell.separatorInset.left
            cell.backgroundColor = UIColor.clear
            tableView.allowsSelection = false

            return cell
        }
        else{
            self.tableView.separatorStyle = .singleLine

            
           
            if self.shipments[indexPath.row] == nil {
                return UITableViewCell()
            }
            guard var cell = tableView.dequeueReusableCell(withIdentifier: "LoadBoardCell") as? LoadBoardCell else {
                return UITableViewCell()
            }
          
            cell = cell.configure(shipment: self.shipments[indexPath.row])
            cell.rateLabel.text = ""
            cell.cellBottomConstraint.constant = -7
            
            let arrow = UIImageView( frame: CGRect(x:UIScreen.main.bounds.width - 24, y: 20, width: 7, height: 12))
            arrow.image = UIImage(named: "greyArrow")
            cell.addSubview(arrow)
            
            cell.setStatus(shipment: self.shipments[indexPath.row])
            //cell.setMessageLabel(messageCount: chatMessageCount[indexPath.row])
            cell.rightConstraint.constant = 40
            cell.centerConstraint.constant = -10
            cell.statusContraint.constant = 5
            cell.deadheadLabel.text = " "
            
            if let _ = self.view.viewWithTag(44) as? UILabel {
                    cell.viewWithTag(44)?.removeFromSuperview()
            }
            
            if !chatMessageCount.isEmpty{
                if chatMessageCount[indexPath.row] > 0{
                    let countLabel = UILabel( frame: CGRect(x:UIScreen.main.bounds.width - 29, y: 39, width: 18, height: 18))
                    countLabel.text = "\(chatMessageCount[indexPath.row])"
                    countLabel.textAlignment = .center
                    countLabel.font = UIFont.systemFont(ofSize: 14)
                    countLabel.textColor = UIColor.white
                    countLabel.backgroundColor = UIColor(hex: "0xff4f01")
                    countLabel.layer.cornerRadius = 9.0
                    countLabel.layer.masksToBounds = true
                    countLabel.tag = 44
                    cell.addSubview(countLabel)
                }
                
            }
            
            
                cell.preservesSuperviewLayoutMargins = false
                cell.separatorInset = UIEdgeInsets.zero
                cell.layoutMargins = UIEdgeInsets.zero
            
            
            return cell
        }
    }
    func setupChatNotifications(){
        if let localChat = ArchiveUtil.loadChat(){
            var chatArray = localChat
            var index = 0
            for shipment in shipments{
            //get count of new messages
            for newChat in chats{
                var found = false
                if newChat.shipmentId == shipment.id{
                for chatFeed in chatArray{
                    if chatFeed.id == newChat.id{
                        found = true
                        print("found chat for ", newChat.id)
                        let newMessageCount = newChat.messages.count - chatFeed.messageCount!
                        chatMessageCount.append(newMessageCount)
                        print(newMessageCount)
                    }
                }
                if !found{
                     print(newChat.messages.count)
                    chatMessageCount.append(newChat.messages.count)
                }
                index += 1
                }
                
            }
                
            
            //remove from local if not found in updated chat messages
            index = 0
            for chatFeed in chatArray{
                var found = false
                for newChat in chats{
                    if chatFeed.id == newChat.id{
                        found = true
                    }
                }
                if !found{
                    chatArray.remove(at: index)
                }
                index += 1
            }
           
            ArchiveUtil.saveChat(chat: chatArray)
            tableView.reloadData()
        }
        }
        else{
            for newChat in chats{
                chatMessageCount.append(newChat.messages.count)
            }
        }
    }
}

extension CollaborationViewController: GetShipmentsDelegate {
    func getShipmentsSuccess(shipments: [Shipment]) {
        self.shipments = shipments
        chatCount = 0

        chats.removeAll()
        chatMessageCount.removeAll()
        for shipment in self.shipments{
             getAPI().getShipmentChat(shipment: shipment, delegate: self)
        }
        
        loaded = true
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
        let activityView = self.view.viewWithTag(100) as! NVActivityIndicatorView
        activityView.stopAnimating()
        
        
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
}
extension CollaborationViewController: GetShipmentChatDelegate {
    func getShipmentChatSuccess(chat: Chat) {
        chats.append(chat)
        chatCount += 1
        if chatCount == shipments.count{
            setupChatNotifications()
            print("loading notifications")
        }

    }
}
extension CollaborationViewController: GetUserDelegate {
    func getUserSuccess(user: User) {
        self.user = user
        UserDefaults.standard.set(user.id!,forKey: "userID")
    }
}

