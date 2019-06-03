//
//  ChatMemberCell.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/6/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit

class ChatMemberCell: UITableViewCell {
    
    @IBOutlet weak var memberAvatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var userRole: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    func configure(user: User?) -> ChatMemberCell {
        username.text = user?.displayName
        companyName.text = user?.billingInfo?.companyName ?? "Company Name LLC"
        userRole.text = user?.role?.titlecased()
        
        
        var userImage = UIImage()
        if let imageUrl = user?.image{
            if let imageData :NSData = NSData(contentsOf: imageUrl){
                userImage = UIImage(data:imageData as Data)!
            }
        }
        else{
            userImage = UIImage(named: "defaultAvatar")!
        }
        memberAvatar.image = userImage
        memberAvatar.layer.cornerRadius = 30
        memberAvatar.clipsToBounds = true

        return self
    }
    
    
}


