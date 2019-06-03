//
//  ChangePasswordViewController.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/6/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UITableViewController, UITextFieldDelegate{
    

    fileprivate var api: HttpAPI = HttpAPI(authToken: nil)
    fileprivate var cells: [Cell] = []
    var tableViewBottomConstraint: NSLayoutConstraint?
    var tableViewFirstLoad = true
    
    enum Cell {
        case header
        case field(title: String?)
        case button
       
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SIGN UP"
        self.tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.tintColor = UIColor.black

        tableView.register(UINib(nibName: "TextFieldCell", bundle: Bundle.main), forCellReuseIdentifier: "TextFieldCell")
        cells = setupCells()
        tableView.reloadData()
        
        if #available(iOS 11.0, *) {
            tableViewBottomConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal,  toItem: self.view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            
        } else {
            tableViewBottomConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal,  toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            
        }
        
        NSLayoutConstraint.activate([tableViewBottomConstraint!])
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        
    }
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.tableViewBottomConstraint!.constant = 0.0
            } else {
                
                self.tableViewBottomConstraint!.constant = -1 * (endFrame?.size.height ?? 0.0)
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func setupCells() -> [Cell] {
        var cells: [Cell] = []
        
        cells.append(.header)
        cells.append(.field(title: "Current Password"))
        cells.append(.field(title: "New Password"))
        cells.append(.field(title: "Confirm New Password"))
        cells.append(.button)
     
        
        return cells
        
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
            let indexPath = NSIndexPath(row: textField.tag + 3, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
            
        } else {
            // Not found, so remove keyboard.
            //textField.resignFirstResponder()
        }
        
        // Do not add a line break
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    @objc func changePassword(button: Any?){

        self.navigationController?.popViewController(animated: true)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cells.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cells[indexPath.row] {
            
        case .header:
            return 130
            
        case .field:
            return 50
        case .button:
            return 80
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
            
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChangePassHeading", for: indexPath as IndexPath)
            return cell
            
        case .field(let title):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as? TextFieldCell else {
                break
            }
            cell.textFieldOutlet.isSecureTextEntry = true
            cell.textFieldOutlet.delegate = self
            cell.textFieldOutlet.tag = indexPath.row - 1
            cell.textFieldOutlet.returnKeyType = .next
            if tableViewFirstLoad{
                cell.textFieldOutlet.becomeFirstResponder()
                tableViewFirstLoad = false
            }
            
            return cell.configure(title: title!)
            
        case .button:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitButton", for: indexPath as IndexPath)
            let button = cell.contentView.viewWithTag(88) as! UIButton
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(self.changePassword), for: .touchUpInside)
            
            return cell
        }
        
        fatalError("Cannot find cell")
    }
    
}

