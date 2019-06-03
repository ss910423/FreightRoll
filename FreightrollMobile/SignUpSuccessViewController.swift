//
//  SignUpSuccessViewController.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/5/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit

class SignUpSuccessViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func willMove(toParentViewController parent: UIViewController?)
    {
        if parent == nil
        {
            self.performSegue(withIdentifier: "successToHome", sender: self)
        }
    }
}
