//
//  DeadheadAlertView.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 3/27/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//


import UIKit

protocol TruckTypeAlertViewDelegate: class {
    func truckTypeTapped(selectedOption: String)
}


class TruckTypeAlertView: UIViewController {
    
    var truckType: String?
    weak var delegate: TruckTypeAlertViewDelegate?
    
    @IBOutlet weak var alertView: UIView!

    @IBOutlet weak var showAll: UIButton!
    @IBOutlet weak var flatbed: UIButton!
    @IBOutlet weak var dryVan: UIButton!
    @IBOutlet weak var stepDeck: UIButton!
    @IBOutlet weak var LTL: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.layer.cornerRadius = 15
        
        if truckType == "Show All" {
            showAll.backgroundColor = UIColor(hex: "0x2490c4")
            showAll.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
        }
        if truckType == "flatbed" {
            flatbed.backgroundColor = UIColor(hex: "0x2490c4")
            flatbed.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
        }
        if truckType == "dry_van" {
            dryVan.backgroundColor = UIColor(hex: "0x2490c4")
            dryVan.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
        }
        if truckType == "step_deck" {
            stepDeck.backgroundColor = UIColor(hex: "0x2490c4")
            stepDeck.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
        }
        if truckType == "ltl" {
            LTL.backgroundColor = UIColor(hex: "0x2490c4")
            LTL.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
        }
        
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
   
    @IBAction func showAllTapped(_ sender: Any) {
        self.delegate?.truckTypeTapped(selectedOption: "Show All")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func flatbedTapped(_ sender: Any) {
        self.delegate?.truckTypeTapped(selectedOption: "flatbed")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func dryVanTapped(_ sender: Any) {
        self.delegate?.truckTypeTapped(selectedOption: "dry_van")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func stepDeckTapped(_ sender: Any) {
        self.delegate?.truckTypeTapped(selectedOption: "step_deck")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func LTLTapped(_ sender: Any) {
        self.delegate?.truckTypeTapped(selectedOption: "ltl")
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelTapped(_ sender: Any) {
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
