//
//  LoadBoardCell.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/15/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit
import MapKit

class LoadBoardCell: UITableViewCell {

    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickupBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusContraint: NSLayoutConstraint!
    @IBOutlet var priorityLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var deadheadLabel: UILabel!
    @IBOutlet var pickupLabel: UILabel!
    @IBOutlet var dropoffLabel: UILabel!
    @IBOutlet var rateLabel: UILabel!
    @IBOutlet weak var dropoffDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    var shipment: Shipment?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    override func prepareForReuse() {
        statusLabel.text = ""
        statusLabel.textColor = UIColor.clear
        statusLabel.layer.borderColor = UIColor.clear.cgColor
        statusLabel.backgroundColor = UIColor.clear
        dateLabel.text = ""
        deadheadLabel.text = ""
        pickupLabel.text = ""
        dropoffLabel.text = ""
        rateLabel.text = ""
        dropoffDateLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if shipment?.status == .awaitingConfirm || shipment?.status == .dispatcherConfirm {
            self.statusLabel.backgroundColor = UIColor(hex: "0xefefef")
        }
        if shipment?.status == .accepted {
            self.statusLabel.backgroundColor = UIColor.app_blue
        }
        if shipment?.status == .inTransit {
            self.statusLabel.backgroundColor = UIColor(red:1, green:0.58, blue:0, alpha:1)
        }
        if shipment?.status == .delivered {
            self.statusLabel.backgroundColor = UIColor(red:0, green:0.8, blue:0, alpha:1)
        }
    }

    func configure(shipment: Shipment, headingTo: CLLocationCoordinate2D? = nil) -> LoadBoardCell {
        if let pickup = shipment.pickup?.destination {
            self.pickupLabel.text = pickup
        }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM dd")
        
        if let pickupAt = shipment.pickupAt {
            self.dateLabel.text = "\(dateFormatter.string(for: pickupAt) ?? "") \(shipment.pickupAppointment! || dateFormatter.string(for: pickupAt) == dateFormatter.string(for: shipment.pickupAtLatest) ? "" : "- \(dateFormatter.string(for: shipment.pickupAtLatest) ?? "")")"
        }

        if let dropoff = shipment.dropoff?.destination {
            self.dropoffLabel.text = dropoff
        }
        if let dropoffAt = shipment.dropoffAt {
            self.dropoffDateLabel.text = "\(dateFormatter.string(for: dropoffAt) ?? "") \(shipment.dropoffAppointment! || dateFormatter.string(for: dropoffAt) == dateFormatter.string(for: shipment.dropoffAtLatest) ? "" : "- \(dateFormatter.string(for: shipment.dropoffAtLatest) ?? "")")"
        }

        if let rate = shipment.rate {
            var newRate = rate
            
            if let rateDouble = Double(rate){
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                numberFormatter.minimumFractionDigits = 2
                newRate = numberFormatter.string(from: NSNumber(value: rateDouble))!
            }
            
            self.rateLabel.text = "$\(newRate)"
        }

        if let distance = shipment.distance{
            deadheadLabel.text = "\(distance) mi."
        }else{
            deadheadLabel.text = "--"
        }
       

        return self
    }
    
    func setStatus(shipment: Shipment){
        self.shipment = shipment
        self.statusLabel.layer.cornerRadius = 10
        self.statusLabel.layer.borderWidth = 1
        self.statusLabel.layer.borderColor = UIColor.clear.cgColor
        self.statusLabel.layer.masksToBounds = true
        
        if shipment.status == .awaitingConfirm || shipment.status == .dispatcherConfirm {
            statusLabel.text = "Pending"
            self.statusLabel.backgroundColor = UIColor(hex: "0xefefef")
            self.statusLabel.layer.borderColor = UIColor(hex: "0xaaaaaa").cgColor
            self.statusLabel.textColor = UIColor(hex: "0xaaaaaa")
            
        }
        if shipment.status == .accepted {
            statusLabel.text = "Accepted"
            self.statusLabel.backgroundColor = UIColor.app_blue
            self.statusLabel.layer.borderColor = UIColor.app_blue.cgColor
            self.statusLabel.textColor = UIColor.white
            
        }
        if shipment.status == .inTransit {
            statusLabel.text = "In Transit"
            self.statusLabel.backgroundColor = UIColor.app_orange
            self.statusLabel.layer.borderColor = UIColor.app_orange.cgColor
            self.statusLabel.textColor = UIColor.white

        }
        if shipment.status == .delivered {
            statusLabel.text = "Delivered"
            self.statusLabel.backgroundColor = UIColor.app_green
            self.statusLabel.layer.borderColor = UIColor.app_green.cgColor
            self.statusLabel.textColor = UIColor.white

        }
        

    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if shipment?.status == .awaitingConfirm || shipment?.status == .dispatcherConfirm {
            self.statusLabel.backgroundColor = UIColor(hex: "0xefefef")
        }
        if shipment?.status == .accepted {
            self.statusLabel.backgroundColor = UIColor.app_blue
        }
        if shipment?.status == .inTransit {
            self.statusLabel.backgroundColor = UIColor(red:1, green:0.58, blue:0, alpha:1)
        }
        if shipment?.status == .delivered {
            self.statusLabel.backgroundColor = UIColor(red:0, green:0.8, blue:0, alpha:1)
        }
    }
    
    func configureForUseInAvailableShipments() {
        backgroundColor = .app_lightestGrey
        preservesSuperviewLayoutMargins = false
        separatorInset.right = separatorInset.left
        layoutMargins = UIEdgeInsets.zero
        
        rateLabel.layer.cornerRadius = 10
        rateLabel.layer.borderWidth = 1
        rateLabel.textColor = .app_lightBlue
        rateLabel.layer.borderColor = UIColor.app_blue.cgColor
    }
}
