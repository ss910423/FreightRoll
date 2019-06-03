//
//  MuteNotificationsCell.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/6/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit



class MuteNotificationsCell: UITableViewCell {
    
    @IBOutlet var availableSwitch: UISwitch!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

    @objc func availabilityChanged(_ notification: Notification) {
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

