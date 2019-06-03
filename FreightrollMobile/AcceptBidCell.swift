//
//  AcceptBidCell.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/14/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit

class AcceptBidCell: UITableViewCell {

    typealias AcceptCallback = () -> Void
    typealias BidCallback = () -> Void

    @IBOutlet var acceptButton: UIButton!
    @IBOutlet var bidButton: UIButton!
    @IBOutlet weak var buttonShadow: UIButton!
    
    fileprivate var accept: AcceptCallback?
    fileprivate var bid: BidCallback?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        acceptButton.layer.cornerRadius = 5
        buttonShadow.layer.cornerRadius = 5

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(accept: @escaping AcceptCallback, bid: @escaping BidCallback) -> AcceptBidCell {
        self.accept = accept
        self.bid = bid

        return self
    }

    @IBAction func accept(_ button: UIButton) {
        accept?()
    }

    @IBAction func bid(_ button: UIButton) {
        bid?()
    }
}
