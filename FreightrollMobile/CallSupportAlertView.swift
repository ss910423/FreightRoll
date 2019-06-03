//
//  CallSupportAlertView.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 3/27/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation

import UIKit
import MessageUI // Remove when done with debugging

class CallSupportAlertView: UIViewController, MFMailComposeViewControllerDelegate {
    

    @IBOutlet weak var alertView: UIView!
    @IBAction func dispatchAction(_ sender: Any) {
        let url: NSURL = URL(string: "TEL://7345476034")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func freightrollAction(_ sender: Any) {
        let url: NSURL = URL(string: "TEL://7345476034")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.layer.cornerRadius = 15
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.backTapped))
        let newView = UIView()
        newView.frame = self.view.frame
        newView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        newView.addGestureRecognizer(gesture)
        newView.layer.zPosition = -1
        self.view.addSubview(newView)
        self.view.sendSubview(toBack: newView)
        
       
        animateView()
    }
    @objc func backTapped(sender:UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
}
