//
//  SwitchCell.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/6/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate: class {
    func switchChatMessages(selectedIndex: Int)
}

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var controlOutlet: UISegmentedControl!
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func controlValueChanged(_ sender: Any) {
        self.delegate?.switchChatMessages(selectedIndex: controlOutlet.selectedSegmentIndex)
    }
    
    
}
