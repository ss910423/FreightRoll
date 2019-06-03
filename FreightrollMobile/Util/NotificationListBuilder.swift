//
//  NotificationListBuilder.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/19/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation



class NotificationListBuilder: NSObject{
    var notificationArray: [NotificationObj] = []
    var shipments: [Shipment] = []
    var chats: [Chat] = []
    var chatCount = 0
    
    func setup() {
        getAPI().getShipments(delegate: self)
    }

    func buildNotificationList(){
        
    }
    func setupChatNotifications(chats: [Chat]){
        
        if let localChat = ArchiveUtil.loadChat(){
            var chatArray = localChat
            var index = 0
            for shipment in shipments{
                //get count of new messages
                for newChat in chats{
                    var found = false
                    if newChat.shipmentId == shipment.id{
                        for chatFeed in chatArray{
                            if chatFeed.id == newChat.id{
                                found = true
                                let newMessageCount = newChat.messages.count - chatFeed.messageCount!
                                if newMessageCount > 0 {
                                    let notification = NotificationObj(t: "New Messages - \(formattedDate(date: newChat.messages[newChat.messages.count - 1].createdAt!))", b:"There \(newMessageCount != 1 ? "are \(newMessageCount) new messages" : "is \(newMessageCount) new message") for Shipment #\(shipment.id ?? 0) from \(shipment.pickup?.city ?? "") to \(shipment.dropoff?.city ?? "").", ship: shipment, time: 0)
                                 
                                    notification.shipment = shipment
                                    notification.isMessage = true
                                    notificationArray.append(notification)
                                   
                                }
                            }
                        }
                        if !found{
                            if newChat.messages.count > 0{
                                let notification = NotificationObj(t: "New Messages - \(formattedDate(date: newChat.messages[newChat.messages.count - 1].createdAt!))", b:"There \(newChat.messages.count != 1 ? "are \(newChat.messages.count) new messages" : "is \(newChat.messages.count) new message") for Shipment #\(shipment.id ?? 0) from \(shipment.pickup?.city ?? "") to \(shipment.dropoff?.city ?? "").", ship: shipment, time: 0)
                                notification.isMessage = true
                                notification.shipment = shipment
                                notificationArray.append(notification)
                                
                            }
                        }
                        index += 1
                    }
                }

                //remove from local if not found in updated chat messages
                index = 0
                print("chatArray", chatArray)
                for chatFeed in chatArray{
                    var found = false
                    for newChat in chats{
                        if chatFeed.id == newChat.id{
                            found = true
                        }
                    }
                    if !found{
                        print(index)
                        chatArray.remove(at: index)
                        index -= 1
                    }
                    index += 1
                }
                ArchiveUtil.saveChat(chat: chatArray)
            }
        }
        
    }
    
    func setTimingNotifications(shipment: Shipment){
        
        if shipment.status == .available {
            let notification = NotificationObj(t: "Pickup Reminder - \(formattedDate(date: shipment.pickupAt!))", b:"Shipment #\(shipment.id ?? 0) \(shipment.pickup?.city ?? "") to \(shipment.pickup?.city ?? ""): Due for pickup at \(formattedDate(date: shipment.pickupAt!))", ship: shipment, time: 0)
            notification.shipment = shipment
            notificationArray.append(notification)
            
            
        }
        
        if shipment.status == .accepted {
            let notification = NotificationObj(t: "Pickup Reminder - \(formattedDate(date: shipment.pickupAt!))", b:"Shipment #\(shipment.id ?? 0) \(shipment.pickup?.city ?? "") to \(shipment.dropoff?.city ?? ""): Due for pickup at \(formattedDate(date: shipment.pickupAt!))", ship: shipment, time: 0)
            notification.shipment = shipment
            notificationArray.append(notification)

            
        }
        
        if shipment.status == .inTransit {
            
            let notification = NotificationObj(t: "Dropoff Reminder - \(formattedDate(date: shipment.dropoffAt!))", b:"Shipment #\(shipment.id ?? 0) \(shipment.pickup?.city ?? "") to \(shipment.dropoff?.city ?? ""): Due for pickup at \(formattedDate(date: shipment.dropoffAt!))", ship: shipment, time: 0)
            notification.shipment = shipment
            notificationArray.append(notification)
            
        }
        if shipment.status == .delivered {
            let notification = NotificationObj(t: "Upload POD Reminder - \(formattedDate(date: shipment.dropoffAt!))", b:"Remember to upload your Proof of Delivery for Shipment #\(shipment.id ?? 0) from \(shipment.dropoff?.city ?? "") to \(shipment.dropoff?.city ?? "").", ship: shipment, time: 0)
            notification.shipment = shipment
            notificationArray.append(notification)
 
        }
    }
    func currentDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM dd, h:mm a")
        return dateFormatter.string(from: Date())
    }
    func formattedDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM dd, h:mm a")
        return dateFormatter.string(from: date)
    }
}
extension NotificationListBuilder: GetShipmentsDelegate {
    func apiError(code: Int?, message: String) {
    }
    
    
    func getShipmentsSuccess(shipments: [Shipment]) {
        self.shipments = shipments
        chats.removeAll()
        chatCount = 0
  
        for shipment in self.shipments{
            setTimingNotifications(shipment: shipment)
            getAPI().getShipmentChat(shipment: shipment, delegate: self)
        }
        
       

    }
}
extension NotificationListBuilder: GetShipmentChatDelegate {
    func getShipmentChatSuccess(chat: Chat) {
       
        chats.append(chat)
        chatCount += 1
        if chatCount == shipments.count{
            setupChatNotifications(chats: chats)
        }
        
    }
}

