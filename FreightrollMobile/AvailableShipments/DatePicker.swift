//
//  DatePicker.swift
//  FreightrollMobile
//
//  Created by Alexander Cyr on 8/14/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit

class DatePicker: UIViewController{
    
    var didSetDate: () -> () = {}
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerTitle: UILabel!
    @IBOutlet weak var pickerView: UIView!
    
    var selectedDate: String?
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        selectedDate = dateFormatter.string(from: Date())

        blurEffectView.frame = pickerView.bounds
        pickerView.addSubview(blurEffectView)
        pickerView.sendSubview(toBack: blurEffectView)
        //pickerView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.dismissDatePicker))
        let newView = UIView()
        newView.frame = self.view.frame
        newView.addGestureRecognizer(gesture)
        newView.layer.zPosition = -1
        self.view.addSubview(newView)
        self.view.sendSubview(toBack: newView)
        
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.minimumDate = Date()
        
        animateView()
        
    }
    
    override func viewDidLayoutSubviews() {
        blurEffectView.frame = pickerView.bounds
    }
    

    @IBAction func confirmPressed(_ sender: UIButton) {
        didSetDate()
        dismissDatePicker()
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismissDatePicker()
    }
    
    @objc func dismissDatePicker() {
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.pickerView.alpha = 0;
            self.pickerView.frame.origin.y = self.view.bounds.height
        }, completion: { (finished: Bool) in
            self.dismiss(animated: true, completion: nil)  
        })
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        selectedDate = dateFormatter.string(from: sender.date)
    }
    
    func animateView() {
        pickerView.alpha = 0;
        self.pickerView.frame.origin.y = self.view.bounds.height
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.pickerView.alpha = 1.0;
            self.pickerView.frame.origin.y = self.view.bounds.height - self.pickerView.bounds.height
        })
    }
}
