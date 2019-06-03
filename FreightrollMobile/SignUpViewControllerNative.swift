//
//  SignUpViewController.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/4/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//
//
//import Foundation
//import UIKit
//
//class SignUpViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate{
//
//    @IBOutlet weak var tableView: UITableView!
//    
//    
//    fileprivate var api: HttpAPI = HttpAPI(authToken: nil)
//    fileprivate var cells: [Cell] = []
//    var tableViewBottomConstraint: NSLayoutConstraint?
//    var tableViewFirstLoad = true
//    
//    enum Cell {
//        case header
//        case firstName(title: String?)
//        case lastName(title: String?)
//        case mcNumber(title: String?)
//        case email(title: String?)
//        case password(title: String?)
//        case truckType(title: String?)
//        case button
//    }
//   
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = "SIGN UP"
//        self.tableView.dataSource = self
//        tableView.separatorStyle = .none
//        tableView.allowsSelection = false
//        tableView.estimatedRowHeight = 85.0
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.register(UINib(nibName: "TextFieldCell", bundle: Bundle.main), forCellReuseIdentifier: "TextFieldCell")
//        cells = setupCells()
//        tableView.reloadData()
//        
//       
//        if #available(iOS 11.0, *) {
//            tableViewBottomConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal,  toItem: self.view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
//          
//        } else {
//            tableViewBottomConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal,  toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
//          
//        }
//        
//        NSLayoutConstraint.activate([tableViewBottomConstraint!])
//        
//        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.keyboardNotification(notification:)),
//                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
//                                               object: nil)
//       
//    }
//    @objc func keyboardNotification(notification: NSNotification) {
//        if let userInfo = notification.userInfo {
//            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//            let endFrameY = endFrame?.origin.y ?? 0
//            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
//            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
//            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
//            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
//           
//            if endFrameY >= UIScreen.main.bounds.size.height {
//                self.tableViewBottomConstraint!.constant = 0.0
//            } else {
//           
//                self.tableViewBottomConstraint!.constant = -1 * (endFrame?.size.height ?? 0.0)
//            }
//            UIView.animate(withDuration: duration,
//                           delay: TimeInterval(0),
//                           options: animationCurve,
//                           animations: { self.view.layoutIfNeeded() },
//                           completion: nil)
//        }
//    }
// 
//    func setupCells() -> [Cell] {
//        var cells: [Cell] = []
//        
//        cells.append(.header)
//        cells.append(.firstName(title: "First Name"))
//        cells.append(.lastName(title: "Last Name"))
//        cells.append(.mcNumber(title: "MC Number"))
//        cells.append(.email(title: "Email"))
//        cells.append(.password(title: "Password"))
//        cells.append(.truckType(title: "Truck Type"))
//        cells.append(.button)
//        
//        return cells
//       
//    }
//    
//    /*
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        if isValidEmail(testStr: emailField.text!){
//            let checkImage = UIImageView(frame :CGRect(x: emailField.frame.size.width - 16, y: 7, width: 16, height: 16))
//            checkImage.image = UIImage(named: "checkActive")
//            
//            emailField.addSubview(checkImage)
//        }
//        else{
//            let animation = CABasicAnimation(keyPath: "position")
//            animation.duration = 0.1
//            animation.repeatCount = 2
//            animation.autoreverses = true
//            animation.fromValue = NSValue(cgPoint: CGPoint(x: emailField.center.x - 7, y: emailField.center.y))
//            animation.toValue = NSValue(cgPoint: CGPoint(x: emailField.center.x + 7, y: emailField.center.y))
//            
//            let checkImage = UIImageView(frame :CGRect(x: emailField.frame.size.width - 16, y: 7, width: 16, height: 16))
//            checkImage.image = UIImage(named: "checkInactive")
//            
//            emailField.addSubview(checkImage)
//            emailField.layer.add(animation, forKey: "position")
//            
//        }
//    }
//    */
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool
//    {
//        // Try to find next responder
//
//        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
//            nextField.becomeFirstResponder()
//            let indexPath = NSIndexPath(row: textField.tag + 3, section: 0)
//            self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
//  
//        } else {
//            // Not found, so remove keyboard.
//            textField.resignFirstResponder()
//        }
//            
//        // Do not add a line break
//        return false
//    }
// 
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    //https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
//    func isValidEmail(testStr:String) -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluate(with: testStr)
//    }
//    @objc func createAccount(button: Any?){
//        let backItem = UIBarButtonItem()
//        backItem.title = "Back"
//        self.navigationItem.backBarButtonItem = backItem
//        
//
//
//        performSegue(withIdentifier: "SignUpSuccessSegue", sender: self)
//    }
//    
//    
//}
//extension SignUpViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//       
//        return cells.count
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch cells[indexPath.row] {
//            
//        case .header:
//            return 216
//            
//        case .firstName, .lastName, . mcNumber, .email, . password, .truckType, .button:
//            return 100
//        }
//    }
//  
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch cells[indexPath.row] {
//            
//        case .header:
//           let cell = tableView.dequeueReusableCell(withIdentifier: "signUpHeading", for: indexPath as IndexPath)
//            return cell
//            
//        case .firstName(let title):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as? TextFieldCell else {
//                break
//            }
//            
//            cell.textFieldOutlet.delegate = self
//            cell.textFieldOutlet.tag = 0
//            cell.textFieldOutlet.returnKeyType = .next
//            if tableViewFirstLoad{
//                cell.textFieldOutlet.becomeFirstResponder()
//                tableViewFirstLoad = false
//            }
//            
//            return cell.configure(title: title!)
//            
//        case .lastName(let title):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as? TextFieldCell else {
//                break
//            }
//            cell.textFieldOutlet.delegate = self
//            cell.textFieldOutlet.tag = 1
//            cell.textFieldOutlet.returnKeyType = .next
//
//            return cell.configure(title: title!)
//            
//        case .mcNumber(let title):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as? TextFieldCell else {
//                break
//            }
//            cell.textFieldOutlet.delegate = self
//            cell.textFieldOutlet.tag = 2
//            cell.textFieldOutlet.returnKeyType = .next
//
//            return cell.configure(title: title!)
//        
//        case .email(let title):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as? TextFieldCell else {
//                break
//            }
//            cell.textFieldOutlet.delegate = self
//            cell.textFieldOutlet.tag = 3
//            cell.textFieldOutlet.returnKeyType = .next
//
//            return cell.configure(title: title!)
//            
//        case .password(let title):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as? TextFieldCell else {
//                break
//            }
//            cell.textFieldOutlet.isSecureTextEntry = true
//            cell.textFieldOutlet.delegate = self
//            cell.textFieldOutlet.tag = 4
//            cell.textFieldOutlet.returnKeyType = .next
//
//            return cell.configure(title: title!)
//        
//        case .truckType(let title):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as? TextFieldCell else {
//                break
//            }
//            cell.textFieldOutlet.delegate = self
//            cell.textFieldOutlet.tag = 5
//            cell.textFieldOutlet.returnKeyType = .done
//
//            return cell.configure(title: title!)
//            
//        case .button:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "signUpButton", for: indexPath as IndexPath)
//            let button = cell.contentView.viewWithTag(88) as! UIButton
//            button.layer.cornerRadius = 5
//            button.addTarget(self, action: #selector(self.createAccount), for: .touchUpInside)
//            
//            return cell
//        }
//        
//        fatalError("Cannot find cell")
//    }
//}

