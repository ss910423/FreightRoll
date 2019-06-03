//
//  SortByAlertView.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 3/30/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//


import UIKit

protocol SortByAlertViewDelegate: class {
    func sortTapped(selectedOption: String)
    
}


class SortByAlertView: UIViewController {
    
    var sortBy: AvailableShipmentsModel.Sort?
    weak var delegate: SortByAlertViewDelegate?
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var byRelevanceOutlet: UIButton!
    @IBOutlet weak var byRateOutlet: UIButton!
    @IBOutlet weak var byDistanceOutlet: UIButton!
    @IBOutlet weak var byPickupOutlet: UIButton!
    @IBOutlet weak var byDropoffOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.layer.cornerRadius = 15
        
        if sortBy == .byRelevance{
            byRelevanceOutlet.backgroundColor = UIColor(hex: "0x2490c4")
            byRelevanceOutlet.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
        }
        if sortBy == .byRate{
            byRateOutlet.backgroundColor = UIColor(hex: "0x2490c4")
            byRateOutlet.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
        }
        if sortBy == .byDistance{
            byDistanceOutlet.backgroundColor = UIColor(hex: "0x2490c4")
            byDistanceOutlet.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
        }
        if sortBy == .byPickupDate{
            byPickupOutlet.backgroundColor = UIColor(hex: "0x2490c4")
            byPickupOutlet.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
        }
        if sortBy == .byDeliveryDate{
            byDropoffOutlet.backgroundColor = UIColor(hex: "0x2490c4")
            byDropoffOutlet.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
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
    @IBAction func byRelevanceTapped(_ sender: Any) {
        sortBy = .byRelevance
        self.delegate?.sortTapped(selectedOption: "\(sortBy!.rawValue)")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func byRateTapped(_ sender: Any) {
        sortBy = .byRate
        self.delegate?.sortTapped(selectedOption: "\(sortBy!.rawValue)")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func byDistanceTapped(_ sender: Any) {
        sortBy = .byDistance
        self.delegate?.sortTapped(selectedOption: "\(sortBy!.rawValue)")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func byPickupTapped(_ sender: Any) {
        sortBy = .byPickupDate
        self.delegate?.sortTapped(selectedOption: "\(sortBy!.rawValue)")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func byDropoffTapped(_ sender: Any) {
        sortBy = .byDeliveryDate
        self.delegate?.sortTapped(selectedOption: "\(sortBy!.rawValue)")
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

