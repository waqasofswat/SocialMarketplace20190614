
//
//  ChatObj.m
//  SmartAds
//
//  Created by Pham Diep on 5/29/17.
//  Copyright © 2017 Mr Lemon. All rights reserved.
//
//
//  ChatObj.h
//  SmartAds
//
//  Created by Pham Diep on 5/29/17.
//  Copyright © 2017 Mr Lemon. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class RecentChatObj: NSObject {
    var conversationId: String?
    var lastMessage: String?
    var dateLastCreate: Double?
    var senderId: String?
    var receiverId: String?
    var chatStatus: String?
    var imgSender: String?
    var imgReceiver: String?
    var senderName: String?
    var receiverName: String?
    var unreadMessage: Int?

    init(fromFDataSnapshot snapShot: DataSnapshot?) {
        for lastMessSnapshot in (snapShot?.children)! {
            let lastMessSnapshot = lastMessSnapshot as! DataSnapshot
            conversationId = lastMessSnapshot.key
            if let data = lastMessSnapshot.value as? [String: String] {
                lastMessage = data["lastMessage"]
                dateLastCreate = (data["datePost"]?.doubleValue)!
                senderId = data["senderId"]
                receiverId = data["receiverId"]
                chatStatus = data["status"]
                imgSender = data["imageSender"]
                imgReceiver = data["imageReceiver"]
                senderName = data["senderName"]
                receiverName = data["receiverName"]
                unreadMessage = data["unread"]?.integerValue
            }
        }
    
    }
}
