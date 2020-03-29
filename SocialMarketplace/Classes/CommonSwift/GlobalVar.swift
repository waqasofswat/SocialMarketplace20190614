
//
//  Global.swift
//  interface4
//
//  Created by ASang on 12/12/14.
//  Copyright (c) 2014 Sang Le. All rights reserved.
//
//utf-8;13421798484
//  interface4
//
//  Created by ASang on 12/12/14.
//  Copyright (c) 2014 Sang Le. All rights reserved.
//

import Foundation

class GlobalVar: NSObject {
    @objc static let shareInstance: GlobalVar = GlobalVar()
    
    @objc var autoLogin = ""
   @objc var gSeller: User?
    @objc var deviceTokenString = ""
    @objc var guserArray = [Any]()
    @objc  var gText = ""
    @objc var page = ""
    @objc  var gmessageArr = [Any]()
    @objc  var facebookPassword = ""
    @objc  var twitterPassword = ""
    @objc  var favoriteArr = [Any]()
    @objc  var login_already = ""
//    @objc  var gUser: User?
    @objc  var gArrBookMark = [Any]()
    @objc  var notificationsDic = [String: Any]()
    @objc  var gChatWithId = ""
    @objc var strTerm = ""
    @objc   var strPrivacy = ""
    @objc   var strFAQ = ""
}
