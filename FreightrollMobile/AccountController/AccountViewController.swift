//
//  AccountViewController.swift
//  FreightrollMobile
//
//  Created by Nick Forte on 8/27/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit
import UserNotifications
import ObjectMapper
import MapKit

let accountViewMapHeight = Double(UIScreen.main.bounds.height * 31 / 64)
let screenWidth = Double(UIScreen.main.bounds.width)

class AccountViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let notifications = NotificationListBuilder()

    
    fileprivate var toggle = true {
        didSet {
            UserDefaults.standard.set(toggle, forKey: "isAvailable")
        }
    }
    
    fileprivate var accountViewModel = AccountViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        setupNotifications()
        notifications.setup()
        
        // remove lines on extra empty table cells
        tableView.tableFooterView = UIView()
        
        accountViewModel.didFetchUserHandler = { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.separatorStyle = .singleLine
        }
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
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        accountViewModel.loadData()
        
        setupCommonAppearance()
        
        toggle = UserDefaults.standard.bool(forKey: "isAvailable")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    private func configureUI() {
        view.backgroundColor = .app_lightestGrey

        tableView.isEditing = false
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .app_lightestGrey
        
        tableView.register(UINib(nibName: "AvailabilityCell", bundle: Bundle.main), forCellReuseIdentifier: "AvailabilityCell")
        
        let supportButton = UIBarButtonItem(image: UIImage(named: "phone_small"), style: .plain, target: self, action: #selector(self.callSupport))
        navigationItem.leftBarButtonItem  = supportButton
        navigationItem.title = "ACCOUNT"
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
    
    fileprivate func showLogoutAlert() {
        let alert = UIAlertController(title: kLogOutTitle,
                                      message: kLogoutMessage,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: kCancel, style: .cancel, handler: nil)
        alert.addAction(okAction)
        let settingsAction = UIAlertAction(title: kLogOutTitle, style: .default, handler: { _ in
            // Take the user to Settings app to possibly change permission.
            UserDefaults.standard.removeObject(forKey: Const.tokenKey)
            
            let controller: RootViewController = UIStoryboard(storyboard: .login).instantiateViewController()
            controller.hidesBottomBarWhenPushed = true
            AppDelegate.sharedAppDelegate().window?.makeKeyAndVisible()
            self.navigationController?.pushViewController(controller, animated: true)
        })
        alert.addAction(settingsAction)
        present(alert, animated: true, completion: nil)
    }
    
    
}
extension AccountViewController: UITableViewDataSource{
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountViewModel.numberOfCells
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(accountViewModel.cellHeight(at: indexPath.row))
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch accountViewModel.cells[indexPath.row] {
            
        case .field(let label, let value):
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.text = label
            cell.detailTextLabel?.text = value
            return cell
            
        case .map:
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountMapCell.cellIdentifier, for: indexPath) as! AccountMapCell

            cell.configure(withName: accountViewModel.userFullName,
                           companyName: accountViewModel.userCompanyName,
                           avatarUrl: accountViewModel.userImageUrl,
                           isAvailable: toggle)
            
            return cell
            
        case .available:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AvailabilityCell") as? AvailabilityCell else {
                break
            }
           
            cell.availableSwitch.tintColor = UIColor(hex: "0xcdced2")
            cell.availableSwitch.backgroundColor = UIColor(hex: "0xcdced2")
            cell.availableSwitch.layer.cornerRadius = 16.0
            
            if toggle {
                cell.availableSwitch.isOn = true
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.delegate = self
            
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
            
        case .logout(let label):
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = label
            cell.textLabel?.textColor = UIColor.red
            cell.accessoryType = .disclosureIndicator
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
            
        case .editAccount(let label), .about(let label), .privacy(let label):
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = label
            cell.accessoryType = .disclosureIndicator
            return cell
            
        case  .contact(let label):
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = label
            cell.accessoryType = .disclosureIndicator
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
            
        case  .changePassword(let label):
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = label
            cell.accessoryType = .disclosureIndicator
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
            
        case .heading(let label):
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = label
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            cell.textLabel?.frame.origin.y += 150
            cell.backgroundColor = .app_lightestGrey
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.selectionStyle = .none
            
            return cell
            
        }
        
        fatalError("Account Information View: Unknown cell type")
        
    }
    
}

extension AccountViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        func openWebController(vc: WebViewController) {
            vc.hidesBottomBarWhenPushed = true
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        switch accountViewModel.cells[indexPath.row] {
            
        case .logout:
            showLogoutAlert()
            
        case .privacy:
            openWebController(vc: PrivacyViewController())
            
        case .contact:
            openWebController(vc: ContactViewController())
            
        case .about:
            openWebController(vc: AboutUsViewController())
            
        case .editAccount:
            print("clicked")
            
        case .changePassword:
            performSegue(withIdentifier: "AccountToPassword", sender: self)
            
        default:
            print("clicked")
        }
        
    }
}

extension AccountViewController: AvailabilityCellControllerDelegate{
    func toggleSwitch(isOn: Bool) {
        toggle = isOn
    }
    
}



