//
//  DeadheadAlertView.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 3/27/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//


import UIKit

protocol DeadheadAlertViewDelegate: class {
    func deadheadTapped(selectedOption: Int)
    
}


class DeadheadAlertView: UIViewController {
    
    var deadhead: Int?
    weak var delegate: DeadheadAlertViewDelegate?
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var deadhead50Outlet: UIButton!
    @IBOutlet weak var deadhead100Outlet: UIButton!
    @IBOutlet weak var deadhead150Outlet: UIButton!
    @IBOutlet weak var deadhead200Outlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.layer.cornerRadius = 15
        
        if deadhead == 50{
            deadhead50Outlet.backgroundColor = UIColor(hex: "0x2490c4")
            deadhead50Outlet.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
        }
        if deadhead == 100{
            deadhead100Outlet.backgroundColor = UIColor(hex: "0x2490c4")
            deadhead100Outlet.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
        }
        if deadhead == 150{
            deadhead150Outlet.backgroundColor = UIColor(hex: "0x2490c4")
            deadhead150Outlet.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
        }
        if deadhead == 200{
            deadhead200Outlet.backgroundColor = UIColor(hex: "0x2490c4")
            deadhead200Outlet.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
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
    @IBAction func deadhead50Tapped(_ sender: Any) {
        self.delegate?.deadheadTapped(selectedOption: 50)
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func deadhead100Tapped(_ sender: Any) {
        self.delegate?.deadheadTapped(selectedOption: 100)
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func deadhead150Tapped(_ sender: Any) {
        self.delegate?.deadheadTapped(selectedOption: 150)
        self.dismiss(animated: true, completion: nil)


    }
    @IBAction func deadhead200Tapped(_ sender: Any) {
        self.delegate?.deadheadTapped(selectedOption: 200)
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
