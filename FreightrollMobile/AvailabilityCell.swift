//
//  AvailabilityCell.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/15/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit

protocol AvailabilityCellControllerDelegate: class {
    func toggleSwitch(isOn: Bool)
}


class AvailabilityCell: UITableViewCell {

    @IBOutlet var availableSwitch: UISwitch!
    weak var delegate: AvailabilityCellControllerDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func toggleAvailability(_ sender: UISwitch) {
        NotificationCenter.default.post(name: AvailabilityBar.AvailabilityChangeNotification, object: sender.isOn)
        self.delegate?.toggleSwitch(isOn: sender.isOn)
    }

    @objc func availabilityChanged(_ notification: Notification) {
        guard let isOn = notification.object as? Bool else { return }
        
        self.availableSwitch.setOn(isOn, animated: false)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
