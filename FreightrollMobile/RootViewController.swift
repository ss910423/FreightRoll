//
//  RootViewController.swift
//  FreightrollMobile
//
//  Created by Nick Forte on 7/26/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var createAccountOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        createAccountOutlet.layer.cornerRadius = 5

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    

}

