//
//  ButtonCell.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/20/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit
import AVFoundation

class ButtonCell: UITableViewCell {

    typealias Callback = (UIButton) -> Void

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonShadow: UIButton!
    @IBOutlet weak var documentButton: UIButton!
    
    fileprivate var callback: Callback?
    var callPickup: Callback?
    var callDoc: Callback?

    override func awakeFromNib() {
        super.awakeFromNib()
        documentButton.layer.cornerRadius = 5
        buttonShadow.layer.cornerRadius = 5
        documentButton.setImage(UIImage(named: "camera_gray"), for: .normal)
        documentButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(title: String, callback: Callback?, uploadCall: Callback?) -> ButtonCell {
        button.setTitle(title, for: .normal)
        
        self.callPickup = callback
        self.callDoc = uploadCall

        return self
    }
    @IBAction func uploadButton(_ sender: UIButton) {
        self.callback = callDoc
        callback?(sender)
    }
    
    @IBAction func tapped(_ sender: UIButton) {
        self.callback = callPickup
        callback?(sender)
    }
    
}
