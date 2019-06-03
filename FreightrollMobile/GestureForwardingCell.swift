//
//  GestureForwardingCell.swift
//  FreightrollMobile
//
//  Created by Douglas Drouillard on 3/26/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//
// A Transparent Cell that forwards its touch events to another 
import Foundation

import UIKit

class GestureForwardingCell: UITableViewCell {
    
    var receivingView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("sending to receiving view")
        return receivingView?.hitTest(point, with: event)
    }
}
