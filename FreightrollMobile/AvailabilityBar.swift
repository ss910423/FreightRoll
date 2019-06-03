//
//  AvailabilityBar.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 9/27/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit

class AvailabilityBar: UIView {

    static let AvailabilityChangeNotification = Notification.Name(rawValue: "AvailabilityChangeNotification")

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var availableSwitch: UISwitch!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate func commonInit() {
        contentView = self.instanceFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)

        NotificationCenter.default.addObserver(self, selector: #selector(availabilityChanged(_:)), name: AvailabilityBar.AvailabilityChangeNotification, object: nil)
    }

    @IBAction func toggleAvailability(_ sender: UISwitch) {
        NotificationCenter.default.post(name: AvailabilityBar.AvailabilityChangeNotification, object: sender.isOn)
    }

    @objc func availabilityChanged(_ notification: Notification) {
        guard let isOn = notification.object as? Bool else { return }

        self.availableSwitch.setOn(isOn, animated: false)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
