
//
//  MessageObj.swift
//  SmartAds
//
//  Created by Pham Diep on 5/29/17.
//  Copyright © 2017 Mr Lemon. All rights reserved.
//

import Foundation
import SwiftyJSON
import Firebase

class MessageObj: NSObject {
    var messageId: String?
    var senderId: String?
    var receiverId: String?
    var content: String?
    var dateCreate: Double = 0.0
    var imgInfoObj: ImageInfoObj?

    init(fromFdataSnapShot snapShot: DataSnapshot?) {
//        super.init()
        
        messageId = snapShot?.key ?? ""
        if let data = snapShot?.value as? [String: String]{
            dateCreate = (data["datePost"]?.doubleValue)!
            senderId = (data["senderId"])!
            receiverId = data["receiverId"]
            content = data["message"]
            imgInfoObj = ImageInfoObj()
            imgInfoObj?.imgIfUrl = data["urlFile"]
            imgInfoObj?.imgHeight = data["imageH"]
            imgInfoObj?.imgWidth = data["imageW"]
        }
        

        
    
    }
}
