//
//  ButtonCell.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/20/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit
import AVFoundation

class SingleButtonCell: UITableViewCell {

    typealias Callback = (UIButton) -> Void

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonShadow: UIButton!
    
    fileprivate var callback: Callback?
    var callPickup: Callback?

    override func awakeFromNib() {
        super.awakeFromNib()
        buttonShadow.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if selected {
            button.layer.opacity = 0.7
        }
        else {
            button.layer.opacity = 1
        }
    }

    func configure(title: String, callback: Callback?) -> SingleButtonCell {
        button.setTitle(title, for: .normal)
        
        self.callPickup = callback

        return self
    }

    @IBAction func tapped(_ sender: UIButton) {
        self.callback = callPickup
        callback?(sender)
    }
    
}
