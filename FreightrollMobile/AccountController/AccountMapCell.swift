//
//  AccountMapCell.swift
//  FreightrollMobile
//
//  Created by Yevgeniy Motov on 4/19/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit
import MapKit

class AccountMapCell: UITableViewCell {
    
    static let cellIdentifier = "accountMapCell"
    let gradient = CAGradientLayer()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var gradientView: UIView! {
        didSet {
            gradient.frame = CGRect(x: 0, y: 0, width: CGFloat(screenWidth), height: CGFloat(accountViewMapHeight))
            gradient.colors = [UIColor.white.withAlphaComponent(0.0).cgColor,
                               UIColor.white.withAlphaComponent(1.0).cgColor]
            gradient.locations = [0.0, 0.5]
            gradientView.layer.insertSublayer(gradient, at: 0)

            gradientView.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var isAvailableImageView: UIImageView!
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = 45
            avatarImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.textAlignment = .center
            nameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        }
    }
    
    @IBOutlet weak var companyNameLabel: UILabel! {
        didSet {
            companyNameLabel.textAlignment = .center
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withName userName: String, companyName: String, avatarUrl: URL?, isAvailable: Bool) {
        nameLabel.text = userName
        companyNameLabel.text = companyName

        
        isAvailableImageView.image = UIImage(named: (isAvailable ? "checkActive" : "checkInactive"))
        
        if let url = avatarUrl,
            let imageData = try? Data(contentsOf: url),
            let avatarImg = UIImage(data: imageData)
        {
            avatarImageView.image = avatarImg
        }
    }

}
