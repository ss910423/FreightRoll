//
//  UINavigationBar.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 3/29/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    func backButton(action: Selector) -> UIButton {
        let attachment = NSTextAttachment()
        attachment.bounds = CGRect(x: 0, y: -8,width: 11,height: 18);
        attachment.image = UIImage(named: "Back_icon")
        let attachmentString = NSAttributedString(attachment: attachment)
        var attributes = [NSAttributedStringKey: AnyObject]()
        attributes[NSAttributedStringKey.foregroundColor] = UIColor.white
        let myString = NSMutableAttributedString(string: "", attributes: attributes)
        let backString = NSMutableAttributedString(string: " Back", attributes: attributes)
        myString.append(attachmentString)
        myString.append(backString)
        
        let label = UIButton()
        
    
        label.addTarget(self, action:action, for: .touchUpInside)
        label.titleLabel?.attributedText = myString
        label.sizeToFit()
        
        
        return label
    }
    
}
