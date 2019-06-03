//
//  MessageCell.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 12/29/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    var userMessage = false
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        textView.tintColor = .clear
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.95, alpha:1)
        view.layer.borderColor = UIColor(red:0.94, green:0.94, blue:0.95, alpha:1).cgColor
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.95, alpha:1)
        imageView.image = UIImage(named: "dispatcher")
        return imageView
    }()
    
    var triangleView = TriangleView()
    let userLabel = UILabel()
    let postedLabel = UILabel()

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.userMessage = false
        profileImageView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.95, alpha:1)
        profileImageView.image = UIImage(named: "dispatcher")
        triangleView.transform = CGAffineTransform(rotationAngle: 0)
        triangleView.setColor(color: UIColor(red:0.94, green:0.94, blue:0.95, alpha:1))
        textBubbleView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.95, alpha:1)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(message: Message, chat: Chat) -> MessageCell? {
        guard
            let user = chat.user(message: message),
            let username = user.displayName,
            //let body = message.body,
            let posted = message.createdAt
        else { return nil }
/*
        nameLabel.text = "\(username) - \(posted)"
        messageLabel.text = body
        */
    
        triangleView.setColor(color: UIColor(red:0.94, green:0.94, blue:0.95, alpha:1))
        if user.id! == UserDefaults.standard.integer(forKey: "userID"){
            userMessage = true
            profileImageView.backgroundColor = UIColor(red:0.85, green:0.93, blue:0.98, alpha:1)
            profileImageView.image = UIImage(named: "dryvanBlue")
        }
      
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d, h:mm")
        
     

        userLabel.text = username
        userLabel.font = UIFont.boldSystemFont(ofSize: 15)
  
        postedLabel.text = dateFormatter.string(from: posted)
        postedLabel.textColor = UIColor(hex: "0x8c8c8c")
        postedLabel.font = UIFont.systemFont(ofSize: 10)
        postedLabel.textAlignment = .right
        
        self.addSubview(triangleView)
        self.addSubview(textBubbleView)
        self.addSubview(messageTextView)
        self.addSubview(userLabel)
        self.addSubview(postedLabel)
        self.sendSubview(toBack: triangleView)

    
        self.addSubview(profileImageView)

        return self
    }
}

