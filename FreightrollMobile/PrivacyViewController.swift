//
//  PrivacyViewController.swift
//  FreightrollMobile
//
//  Created by Douglas Drouillard on 3/4/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit
import WebKit

class PrivacyViewController : WebViewController {
    
    override func viewDidLoad() {
        self.url = "https://www.freightroll.com/pages/privacy"
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = "PRIVACY POLICY"

    }
}

