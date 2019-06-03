//
//  LoginViewController.swift
//  FreightrollMobile
//
//  Created by Nick Forte on 8/19/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var signInButton: UIButton!
    

    fileprivate var api: HttpAPI = HttpAPI(authToken: nil)

    static func storyboardInstance() -> LoginViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateInitialViewController() as? LoginViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 5
        
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor(hex: "0xe5e5e5").cgColor
        border.frame = CGRect(x: 0, y: emailField.frame.size.height - width, width:  emailField.frame.size.width, height: emailField.frame.size.height)
        border.borderWidth = width
        let border2 = CALayer()
        
        
        border2.borderColor = UIColor(hex: "0xe5e5e5").cgColor
        border2.frame = CGRect(x: 0, y: passwordField.frame.size.height - width, width:  passwordField.frame.size.width, height: passwordField.frame.size.height)
        border2.borderWidth = width
        
        emailField.layer.addSublayer(border)
        emailField.layer.masksToBounds = true
        
        passwordField.layer.addSublayer(border2)
        passwordField.layer.masksToBounds = true
        
        passwordField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)

        emailField.delegate = self
        emailField.tag = 0
        passwordField.delegate = self
        passwordField.tag = 1
        
        emailField.becomeFirstResponder()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if isValidEmail(testStr: emailField.text!){
            let checkImage = UIImageView(frame :CGRect(x: emailField.frame.size.width - 16, y: 7, width: 16, height: 16))
            checkImage.image = UIImage(named: "checkActive")
            
            emailField.addSubview(checkImage)
        }
        else{
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.1
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: emailField.center.x - 7, y: emailField.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: emailField.center.x + 7, y: emailField.center.y))
            
            let checkImage = UIImageView(frame :CGRect(x: emailField.frame.size.width - 16, y: 7, width: 16, height: 16))
            checkImage.image = UIImage(named: "checkInactive")
            
            emailField.addSubview(checkImage)
            emailField.layer.add(animation, forKey: "position")
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            if isValidEmail(testStr: emailField.text!){
                nextField.becomeFirstResponder()
                let checkImage = UIImageView(frame :CGRect(x: emailField.frame.size.width - 16, y: 7, width: 16, height: 16))
                checkImage.image = UIImage(named: "checkActive")
                
                emailField.addSubview(checkImage)
            }
            else{
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.1
                animation.repeatCount = 2
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x: emailField.center.x - 7, y: emailField.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: emailField.center.x + 7, y: emailField.center.y))
                
                let checkImage = UIImageView(frame :CGRect(x: emailField.frame.size.width - 16, y: 7, width: 16, height: 16))
                checkImage.image = UIImage(named: "checkInactive")
                
                emailField.addSubview(checkImage)
                emailField.layer.add(animation, forKey: "position")
                
            }
            
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            let user = User()
            user.email = emailField.text
            user.password = passwordField.text
            
            api.signIn(user: user, delegate: self)
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

    @IBAction func signin(_: UIButton) {
        if isValidEmail(testStr: emailField.text!){
            let user = User()
            user.email = emailField.text
            user.password = passwordField.text
            
            api.signIn(user: user, delegate: self)
        }
        else{
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.1
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: emailField.center.x - 7, y: emailField.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: emailField.center.x + 7, y: emailField.center.y))
            
            let checkImage = UIImageView(frame :CGRect(x: emailField.frame.size.width - 16, y: 7, width: 16, height: 16))
            checkImage.image = UIImage(named: "checkInactive")
            
            emailField.addSubview(checkImage)
            emailField.layer.add(animation, forKey: "position")
            
        }
        
     
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    //https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
   
}

extension LoginViewController: SigninDelegate {
    func signInSuccess(user: User) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "completeLogin"), object: user, userInfo: nil)
    }
}
