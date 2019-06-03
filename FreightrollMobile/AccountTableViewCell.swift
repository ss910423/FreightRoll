//
//  AccountTableViewCell.swift
//  FreightrollMobile
//
//  Created by Nick Forte on 8/27/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
