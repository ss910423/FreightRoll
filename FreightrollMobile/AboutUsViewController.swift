//
//  AboutUsViewController.swift
//  FreightrollMobile
//
//  Created by Douglas Drouillard on 3/4/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit
import WebKit

class AboutUsViewController : WebViewController {

    override func viewDidLoad() {
        self.url = "https://www.freightroll.com/pages/about"
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = "ABOUT"

    }
 

}
