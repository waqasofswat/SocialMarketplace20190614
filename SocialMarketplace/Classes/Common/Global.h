//
//  Global.h
//  interface4
//
//  Created by ASang on 12/12/14.
//  Copyright (c) 2014 Sang Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


@interface Global : NSObject
extern NSString *deviceTokenString;
extern NSMutableArray *guserArray;
extern NSString *gText;
extern NSString *page;
extern NSString *login_already;
extern NSString *autoLogin;
extern NSMutableArray *gmessageArr;
extern NSString *facebookPassword;
extern NSString *twitterPassword;
extern NSMutableArray *favoriteArr;
extern User *gUser;
extern NSMutableArray *gArrBookMark;
extern NSDictionary *notificationsDic;
extern NSString *gChatWithId;

extern NSString *strTerm;
extern NSString *strPrivacy;
extern NSString *strFAQ;
@end
