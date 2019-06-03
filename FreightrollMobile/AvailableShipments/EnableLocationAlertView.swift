//
//  EnableLocationAlertView.swift
//  FreightrollMobile
//
//  Created by Alexander Cyr on 8/15/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit

class EnableLocationAlertView: UIViewController{

    @IBOutlet weak var freightrollLogo: UIImageView!{
        didSet{
            freightrollLogo.image = freightrollLogo.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            freightrollLogo.tintColor = UIColor.app_blue
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func enableLocationPressed(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                // Finished opening URL
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
}

