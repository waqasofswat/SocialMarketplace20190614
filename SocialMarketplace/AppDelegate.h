//
//  AppDelegate.h
//  Real Ads
//
//  Created by De Papier on 4/21/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *mainRevealController;


@end

