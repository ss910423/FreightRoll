//
//  ShipmentsHeaderCell.swift
//  FreightrollMobile
//
//  Created by Yevgeniy Motov on 4/20/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit

protocol ShipmentsHeaderDelegate: class {
    func didToggleSortOrder()
    func didTapSortButton()
}

class ShipmentsHeaderCell: UITableViewCell {
    
    static let identifier = "shipmentsHeaderCell"
    
    @IBOutlet weak var shipmentsLabel: UILabel! {
        didSet {
            shipmentsLabel.text = kShipmentsTitle
            shipmentsLabel.textAlignment = .left
            shipmentsLabel.textColor = .black
            shipmentsLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        }
    }
    
    @IBOutlet weak var numberOfShipmentsLabel: UILabel! {
        didSet {
            numberOfShipmentsLabel.textAlignment = .center
            numberOfShipmentsLabel.textColor = .app_darkGrey
            numberOfShipmentsLabel.layer.cornerRadius = 12
            numberOfShipmentsLabel.layer.borderWidth = 1
            numberOfShipmentsLabel.layer.borderColor = UIColor.app_grey.cgColor
        }
    }
    
    @IBOutlet weak var sortByButton: UIButton! {
        didSet {
            sortByButton.contentHorizontalAlignment = .right
            sortByButton.setTitleColor(.app_darkGrey, for: .normal)
            sortByButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var sortOrderButon: UIButton! {
        didSet {
            sortOrderButon.tintColor = .app_darkGrey
            sortOrderButon.addTarget(self, action: #selector(sortOrderToggled), for: .touchUpInside)
        }
    }
    
    weak var delegate: ShipmentsHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = .app_lightestGrey
        separatorInset.right = separatorInset.left
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(numberOfShipments: Int, sortBy: String, sortByToggle: Bool) {
        numberOfShipmentsLabel.text = String(describing: numberOfShipments)
        
        sortOrderButon.transform = .identity
        if !UserDefaults.standard.bool(forKey: "sortByToggle") {
            sortOrderButon.transform = sortOrderButon.transform.rotated(by: CGFloat(Double.pi))
        }
        
        sortByButton.setTitle(sortBy, for: .normal)
    }
    
    @objc private func sortOrderToggled() {
        delegate?.didToggleSortOrder()
    }
    
    @objc private func sortButtonTapped() {
        delegate?.didTapSortButton()
    }
}
