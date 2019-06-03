//
//  TextFieldCell.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/4/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

//
//  TextFieldCell.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/20/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
    
    @IBOutlet weak var textFieldOutlet: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(title: String) -> TextFieldCell {
        
        textFieldOutlet.placeholder = title
      
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor(hex: "0xe5e5e5").cgColor
        border.frame = CGRect(x: 0, y: textFieldOutlet.frame.size.height - width, width:  textFieldOutlet.frame.size.width, height: textFieldOutlet.frame.size.height)
        border.borderWidth = width
        
        
        textFieldOutlet.layer.addSublayer(border)
        textFieldOutlet.layer.masksToBounds = true
        
        return self
    }
    

}

