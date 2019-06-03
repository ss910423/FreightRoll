//
//  ChatManager.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 12/27/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import Foundation

protocol ChatListener {
    func newMessage(message: Message)
}

//protocol ChatManager {
//    var tabBarController: UITabBarController? { get set }
//
//    func connect(token: String)
//    func listen(chat: Chat, listener: ChatListener)
//}

//class HttpChatManager: ChatManager {
//    func connect(token: String) {
//        
//    }
//
//    func listen(chat: Chat, listener: ChatListener) {
//
//    }
//}

//class ChatManager {
//    static let shared = ChatManager()
//
//    var tabBarController: UITabBarController?
//
//    fileprivate var client: ActionCableClient
//    fileprivate var channel: Channel?
//
//    fileprivate var listener: ChatListener?
//    fileprivate var chat: Chat?
//
//    init() {
//        self.client = ActionCableClient(url: URL(string: "ws://freightroll-collaboration.herokuapp.com/cable")!)
//    }
//
//    func connect(token: String) {
//        client.headers = [
//            "Authorization": token
//        ]
//
//        client.connect()
//
//        //client.onConnected = self.onConnected
//        //client.onDisconnected = self.onDisconnected
//    }
//
//    func listen(chat: Chat, listener: ChatListener) {
//        self.chat = chat
//        self.listener = listener
//    }
//
//    fileprivate func onConnected() {
//        self.channel = self.client.create("ChatroomsChannel")
//        self.channel?.onReceive = self.onReceive
//    }
//
//    fileprivate func onDisconnected(error: Error?) {
//        print("error = \(error)")
//    }
//
//    fileprivate func onReceive(JSON: Any?, error: Error?) {
//        print("\(JSON) \(error)")
//    }
//}

