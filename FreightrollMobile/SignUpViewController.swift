//
//  SignUpViewController.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/4/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

//
//  SignUpViewController.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/4/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class SignUpViewController : WebViewController {
    
    
    
    
    override func viewDidLoad() {
        self.url = "https://www.freightroll.com/users/sign_up"
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = "SIGN UP"
        
    }

    
    
}



