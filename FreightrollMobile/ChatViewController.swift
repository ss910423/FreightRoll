//
//  ChatViewController.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 12/26/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//
//  Keyboard Notification from: https://stackoverflow.com/questions/25693130/move-textfield-when-keyboard-appears-swift
//

import UIKit
import UserNotifications

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var messageView: UIView!
    @IBOutlet weak var backButtonOutlet: UIBarButtonItem!
    
    fileprivate var shipment: Shipment!
    fileprivate var chat: Chat?
    var timer: Timer?
   
    var bottomConstraint: NSLayoutConstraint?
    var tableViewBottomConstraint: NSLayoutConstraint?
    var secCount = 1
    
    static func instance(shipment: Shipment) -> ChatViewController {
        let vc = ChatViewController(nibName: "ChatViewController", bundle: Bundle.main)
        vc.shipment = shipment
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let margins = view.layoutMarginsGuide
        self.view.addSubview(messageView)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false

        
        let dummyViewHeight = CGFloat(40)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width:
            self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tableTapped))
        tableView.addGestureRecognizer(tap)

        
  

        messageView.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraint  = NSLayoutConstraint(item: messageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let widthConstraint  = NSLayoutConstraint(item: messageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
       


        
        if #available(iOS 11.0, *) {
            tableViewBottomConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal,  toItem: self.view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            self.tableViewBottomConstraint!.constant = self.tableViewBottomConstraint!.constant + messageView.frame.height
            bottomConstraint = NSLayoutConstraint(item: messageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        } else {
            tableViewBottomConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal,  toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            self.tableViewBottomConstraint!.constant = self.tableViewBottomConstraint!.constant + messageView.frame.height

            bottomConstraint = NSLayoutConstraint(item: messageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        }
      
        NSLayoutConstraint.activate([bottomConstraint!, tableViewBottomConstraint!, widthConstraint, leadingConstraint])
        
       
        tableView.register(UINib(nibName: "MessageCell", bundle: Bundle.main), forCellReuseIdentifier: "MessageCell")
       

        
        getAPI().getShipmentChat(shipment: self.shipment, delegate: self)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            if let _ = self.chat{
                if ((self.chat?.messages.count)! > 0 ){
                    let indexPath = NSIndexPath(row: 0, section: (self.chat?.messages.count)! - 1)
                    print("index path:", indexPath )
                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
                }
            }
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        if self.timer != nil
        {
            self.timer!.invalidate()
            self.timer = nil
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        setupCommonAppearance()
        setupNavbar()
    }
    @objc func updateCounter(){
        print(secCount)
        if secCount % 3 == 0{
            getAPI().getShipmentChat(shipment: self.shipment, delegate: self)
            secCount = 1
        }
        else{
            secCount += 1
        }
    }
    func setupNavbar(){
        let attachment = NSTextAttachment()
        attachment.bounds = CGRect(x: 0, y: 0,width: 14,height: 10);
        attachment.image = UIImage(named: "arrow short")
        let attachmentString = NSAttributedString(attachment: attachment)
        var attributes = [NSAttributedStringKey: AnyObject]()
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        attributes = [.paragraphStyle: paragraph]
        let titleString = NSMutableAttributedString(string: "\(shipment.pickup?.city ?? "UNKNOWN") ".uppercased(), attributes: attributes)
        let dropoffString = NSMutableAttributedString(string: " \(shipment.dropoff?.city ?? "UNKNOWN")".uppercased(), attributes: attributes)
        
        
        titleString.append(attachmentString)
        titleString.append(dropoffString)
        
        let label = UILabel()
        label.frame = CGRect(x: -100, y: -8, width: 200, height: 44)
        label.attributedText = titleString
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        let textView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        
        label.contentMode = .scaleAspectFit
        
        textView.addSubview(label)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d")
        
        let subLabel = UILabel()
        subLabel.text =  "\(dateFormatter.string(for: shipment.pickupAt) ?? "not provided") to \(dateFormatter.string(for: shipment.dropoffAt) ?? "not provided")"
        subLabel.font = UIFont.systemFont(ofSize: 14)
        subLabel.textColor = UIColor(hex: "0xB8B8B8")
        subLabel.frame = CGRect(x: -100, y: 8, width: 200, height: 44)
        subLabel.textAlignment = .center
        textView.addSubview(subLabel)
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.titleView = textView
        
        let infoButton = UIBarButtonItem(image: UIImage(named: "Info_Icon"), style: .plain, target: self, action: #selector(self.showInfo))
        self.navigationItem.rightBarButtonItem  = infoButton
    }

    func setLocalChat(){
        if let localChat = ArchiveUtil.loadChat(){
            var chatArray = localChat
            var index = 0
            var found = false
            for chatInfo in localChat{
                if chatInfo.id == chat?.id{
                    found = true
                    let info = ChatInfo(n: (chat!.id)!, a: (chat?.messages.count)!)
                    chatArray[index] = info
                }
                index += 1
            }
            if !found{
                let info = ChatInfo(n: (chat?.id)!, a: (chat?.messages.count)!)
                chatArray.append(info)
            }
            ArchiveUtil.saveChat(chat: chatArray)
        }
        else{
            var chatArray: [ChatInfo] = []
            let info = ChatInfo(n: (chat?.id)!, a: (chat?.messages.count)!)
            chatArray.append(info)
            ArchiveUtil.saveChat(chat: chatArray)
        }
    }
    
   
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
             DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                if let _ = self.chat{
                    if (self.chat?.messages.count)! > 0{
                        let indexPath = NSIndexPath(row: 0, section: (self.chat?.messages.count)! - 1)
                        print("index path:", indexPath )
                        self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
                    }
                }
            }
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.bottomConstraint!.constant = 0.0
                self.tableViewBottomConstraint!.constant = 0.0
            } else {
                if #available(iOS 11.0, *) {
                    self.bottomConstraint!.constant = -1 * (endFrame?.size.height ?? 0.0) + self.view.safeAreaInsets.bottom
                } else {
                    self.bottomConstraint!.constant = -1 * (endFrame?.size.height ?? 0.0)
                }
                self.tableViewBottomConstraint!.constant = -1 * (endFrame?.size.height ?? 0.0) - messageView.frame.height
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    @objc func tableTapped(){
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showInfo(button: Any?){
      
        let vc = ChatDetailsViewController.instance(chat: chat!, shipment: shipment!)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(vc, animated: true)
    }
   
    
}

extension ChatViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let chat = chat else { return 0 }
        if chat.messages.count == 0{
            return 1
        }

        return chat.messages.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
 
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.backgroundColor = UIColor.white
        header.textLabel?.textColor = UIColor.white
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (chat?.messages.count == 0){
            return 100
        }
        if let messageText = chat?.messages[indexPath.section].body {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], context: nil)
            
            if indexPath.section == ((chat?.messages.count)! - 1){
                return CGSize(width: view.frame.width, height: estimatedFrame.height + 20 + 20 + 20).height

            }
            else{
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20 + 20 + 4).height
            }
        }
        
        return CGSize(width: view.frame.width,height: 100).height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if (chat?.messages.count == 0){
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "No one is chatting yet.\nBe the first to say something!"
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            cell.separatorInset.right = cell.separatorInset.left
            cell.backgroundColor = UIColor.clear
            tableView.allowsSelection = false
            
            return cell
        }
        if  let chat = self.chat,
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? MessageCell,
            let configuredCell = cell.configure(message: chat.messages[indexPath.section], chat: chat){
            let isUser = configuredCell.userMessage
        
        configuredCell.messageTextView.text = chat.messages[indexPath.section].body
        
        if let messageText = chat.messages[indexPath.section].body {
            
            //cell.profileImageView.image = UIImage(named: profileImageName)
            
            let size = CGSize(width:250,height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            var estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], context: nil)
            let estimatedNameSize = NSString(string: configuredCell.userLabel.text!).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], context: nil)
            let estimatedDateSize = NSString(string: configuredCell.postedLabel.text!).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10)], context: nil)
            
            if estimatedFrame.width < (estimatedNameSize.width + 10 + estimatedDateSize.width){
                estimatedFrame.size.width = (estimatedNameSize.width + 10 + estimatedDateSize.width)
            }
            
            
            
            if configuredCell.userMessage {
                configuredCell.messageTextView.frame = CGRect(x:  UIScreen.main.bounds.width - estimatedFrame.width - 16 - 16 - 46,y: estimatedNameSize.height + 4,width: estimatedFrame.width + 16, height: estimatedFrame.height + 24 + estimatedNameSize.height)
                configuredCell.textBubbleView.frame = CGRect(x: UIScreen.main.bounds.width - estimatedFrame.width - 16 - 8 - 16 - 46,y: 0,width: estimatedFrame.width + 16 + 16, height: estimatedFrame.height + 24 + estimatedNameSize.height)
                configuredCell.profileImageView.frame = CGRect(x:UIScreen.main.bounds.width - 42, y: 0, width: 30, height: 30)
                configuredCell.triangleView.transform.rotated(by: CGFloat(Double.pi / 2))
                configuredCell.triangleView.frame = CGRect(x: UIScreen.main.bounds.width - 46 - 8, y: 9, width: 6, height: 12)
                configuredCell.triangleView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                configuredCell.userLabel.frame = CGRect(x: UIScreen.main.bounds.width - estimatedFrame.width - 16 - 16 - 48 + 6, y: 9, width: estimatedNameSize.width + 20, height: estimatedNameSize.height)
                configuredCell.postedLabel.frame = CGRect(x: UIScreen.main.bounds.width - estimatedDateSize.width - 46 - 16, y: 3, width: estimatedDateSize.width, height: 20)
                configuredCell.triangleView.setColor(color: UIColor(red:0.85, green:0.93, blue:0.98, alpha:1))
                configuredCell.textBubbleView.backgroundColor = UIColor(red:0.85, green:0.93, blue:0.98, alpha:1)
                configuredCell.textBubbleView.layer.borderColor = UIColor(red:0.85, green:0.93, blue:0.98, alpha:1).cgColor
                
            }
            else{
                configuredCell.profileImageView.frame = CGRect(x: 12, y: 0, width: 30, height: 30)
                configuredCell.messageTextView.frame = CGRect(x:  16 + 46,y: estimatedNameSize.height + 4,width: estimatedFrame.width + 16, height: estimatedFrame.height + 24 + estimatedNameSize.height)
                configuredCell.textBubbleView.frame = CGRect(x: 8 + 46,y: 0,width: estimatedFrame.width + 16 + 16, height: estimatedFrame.height + 24 + estimatedNameSize.height)
                configuredCell.triangleView.frame = CGRect(x:  48, y: 9, width: 6, height: 12)
                configuredCell.userLabel.frame = CGRect(x: 16 + 48 + 3, y: 9, width: estimatedNameSize.width + 20, height: estimatedNameSize.height)
                configuredCell.postedLabel.frame = CGRect(x: estimatedFrame.width - estimatedDateSize.width + 16 + 46 + 8, y: 3, width: estimatedDateSize.width + 10, height: 20)
                
                
            }
        }
         
            return configuredCell
        }
            
            else {
                return UITableViewCell()
        }
        
        
    }
}

extension ChatViewController: UITableViewDelegate {
    /*
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     return headerView
     }
     */
    
}

extension ChatViewController: GetShipmentChatDelegate {
    func getShipmentChatSuccess(chat: Chat) {
        self.chat = chat
        setLocalChat()
        tableView.reloadData()
    }
}

extension ChatViewController: PostShipmentChatDelegate {
    func postShipmentChatSuccess(chat: Chat, message: String) {
        getAPI().getShipmentChat(shipment: self.shipment, delegate: self)
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let chat = chat else { return false }
        
        if string == "\n" {
            if let message = textField.text {
                getAPI().postShipmentChat(chat: chat, message: message, delegate: self)
            }
            
            textField.text = ""
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
}

