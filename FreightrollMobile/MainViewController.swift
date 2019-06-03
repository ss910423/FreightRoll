//
//  MainViewController.swift
//  FreightrollMobile
//
//  Created by Nick Forte on 8/24/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    static func storyboardInstance() -> MainViewController? {
        //String(describing: LoginViewController.self)
        let storyboard = UIStoryboard(name: "Main2", bundle: nil)
        return storyboard.instantiateInitialViewController() as? MainViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
