//
//  AppDelegate.m
//  Real Ads
//
//  Created by De Papier on 4/21/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import "SocialMarketplace-Swift.h"
#import "RevealViewController.h"
#import "SWRevealViewController.h"
#import "PayPalMobile.h"
#import "Global.h"



#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@import Firebase;

@interface AppDelegate ()

@end

@import GoogleMobileAds;



@implementation AppDelegate{
    NSTimer *timerAway;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];

    /*for (NSString* family in [UIFont familyNames])
     {
     NSLog(@"%@", family);
     
     for (NSString* name in [UIFont fontNamesForFamilyName: family])
     {
     NSLog(@"  %@", name);
     }
     }*/
    [Util setObject:@"Base" forKey:KEY_SAVE_LANGUAGE];
    [FIRApp configure];
    [GMSServices provideAPIKey:GOOGLE_MAP_KEY];
    [GMSPlacesClient provideAPIKey:GOOGLE_API_KEY];
    [self registerLocalNotification];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    gArrBookMark = [[NSMutableArray alloc]init];
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : kPayPalClientId,
                                                           PayPalEnvironmentSandbox : kPayPalClientId}];
    
    [self performSelectorInBackground:@selector(getDataSetting) withObject:nil];
    NSString* thumbLogin_already = [Util stringForKey:KEY_LOGIN];
    login_already = [Util stringForKey:KEY_LOGIN];
    if ([thumbLogin_already isEqualToString:@"1"] ||[thumbLogin_already isEqualToString:@"2"]) {
        gUser = [Util getObjectWithDecode:KEY_SAVE_gUSER];
        [ModelManager loginbyDefaultWithUserName:gUser.usUserName password:[Util objectForKey:@"password"] withSuccess:^(id userInfo) {
            gUser = userInfo;
            [self performSelectorInBackground:@selector(getArrBookMarks) withObject:nil];
        } failure:^(NSString *err) {
        
        }];
        
    }else if([thumbLogin_already isEqualToString:@"2"]){
        gUser = [Util getObjectWithDecode:KEY_SAVE_gUSER];
        [ModelManager loginFbWithName:gUser.usUserName email:gUser.usEmail fbId:gUser.usFbId andImage:gUser.usImage withsuccess:^(id userInfo) {
            [self performSelectorInBackground:@selector(getArrBookMarks) withObject:nil];
        } failure:^(NSString *err) {
            
            
        }];
    }
    
    HomeVC *frontController = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
    UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:frontController];
    [naviVC setNavigationBarHidden:YES animated:NO];
    RevealViewController *rearViewController = [[RevealViewController alloc] initWithNibName:@"RevealViewController" bundle:nil];
    _mainRevealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:naviVC];
    
    _mainRevealController.rearViewRevealWidth = self.window.frame.size.width*3/4;
    _mainRevealController.rearViewRevealOverdraw = 0;
    _mainRevealController.bounceBackOnOverdraw = NO;
    _mainRevealController.stableDragOnOverdraw = YES;
    [_mainRevealController setFrontViewPosition:FrontViewPositionLeft];

    self.window.rootViewController = _mainRevealController;
    
    [self.window makeKeyAndVisible];
    
    [LocationManager sharedManager];
    return YES;
}

-(void)getDataSetting{
    [ModelManager getSettingAppWithSuccess:^(NSDictionary *dicSuccess) {
        strTerm = dicSuccess[@"termCondition"];
        strPrivacy = dicSuccess[@"privacy"];
        strFAQ = dicSuccess[@"faq"];
    } failure:^(NSString *err) {
        
    }];
}

-(void)getArrBookMarks{
    if ([login_already isEqualToString:@"1"] || [ login_already isEqualToString:@"2"]) {
        [ModelManager getBookmarksAdsByUserId:gUser.usId andPage:[NSString stringWithFormat:@""] sortType:@"" sortBy:@"" withSuccess:^(NSDictionary *dicReturn) {
            
        } failure:^(NSString *error) {
            
        }];
    }
}
-(void)registerLocalNotification{
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *strDevicetoken = [[NSString alloc]initWithFormat:@"%@",[[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSLog(@"Device Token = %@",strDevicetoken);
    deviceTokenString = strDevicetoken;
    [Util setObject:deviceTokenString forKey:KEY_SAVE_TOKEN];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self executeNotification:userInfo];
    NSLog(@"%@",userInfo);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@ = %@", NSStringFromSelector(_cmd), error);
    NSLog(@"Error = %@",error);
}
#pragma mark - UNUserNotificationCenter Delegate // >= iOS 10
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info = %@",notification.request.content.userInfo);
    UIApplication *application = [UIApplication sharedApplication];
    if (application.applicationState == UIApplicationStateActive)
    {
        completionHandler(UNNotificationPresentationOptionAlert);
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    [self executeNotification:response.notification.request.content.userInfo];
    NSLog(@"User Info = %@",response.notification.request.content.userInfo);
    completionHandler();
}
- (void)executeNotification:(NSDictionary*)userInfo{
    NSString *pushKey = [Validator getSafeString:userInfo[@"aps"][@"actionPush"]];
    if ([pushKey isEqualToString:@"NEW_ADS"]) {
        [self haveNewAdsNotify:userInfo];
    }else if ([pushKey isEqualToString:@"CHAT"]){
        [self haveNewChatNotify:userInfo];
    }else{
        [self processPushNotification:userInfo];
    }
}
- (void)haveNewAdsNotify:(NSDictionary*)diction{
    UIViewController *currentFrontNavi = _mainRevealController.frontViewController;
    if ([currentFrontNavi isKindOfClass:[UINavigationController class]]) {
        UINavigationController *naviRoot = (UINavigationController*)currentFrontNavi;
        UIViewController *current = [naviRoot.viewControllers lastObject];
        if ([current isKindOfClass:[DetailAdsViewController class]]) {
            return;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                DetailAdsViewController *conversationVC = [[DetailAdsViewController alloc] initWithNibName:@"DetailAdsViewController" bundle:nil];
                conversationVC.adsId = diction[@"aps"][@"objectId"];
                [naviRoot pushViewController:conversationVC animated:YES];
            });
        }
    }
}
- (void)haveNewChatNotify:(NSDictionary*)diction{
    UIViewController *currentFrontNavi = _mainRevealController.frontViewController;
    if ([currentFrontNavi isKindOfClass:[UINavigationController class]]) {
        UINavigationController *naviRoot = (UINavigationController*)currentFrontNavi;
        UIViewController *current = [naviRoot.viewControllers lastObject];
        if ([current isKindOfClass:[ChatVC class]]) {
            return;
        }else{
        dispatch_async(dispatch_get_main_queue(), ^{
        User *senderObj = [[User alloc] init];
        senderObj.usId = diction[@"aps"][@"sender_id"];
        senderObj.usName = diction[@"aps"][@"sender_name"];
        senderObj.usImage = diction[@"aps"][@"sender_image"];
        ChatVC *conversationVC = [[ChatVC alloc] initWithNibName:@"ChatVC" bundle:nil];
        conversationVC.seller = senderObj;
        [naviRoot pushViewController:conversationVC animated:YES];
            });
        }
    }
}
- (void)processPushNotification:(NSDictionary*)userInfo{
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    [Util showMessage:alert withTitle:APP_NAME];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if ([login_already isEqualToString:@"1"] ||[login_already isEqualToString:@"2"]) {
//        timerAway = [NSTimer scheduledTimerWithTimeInterval:10 repeats:NO block:^(NSTimer * _Nonnull timer) {
            [[[FIRDatabase database].reference  child:[NSString stringWithFormat:@"user/%@", gUser.usId]] updateChildValues:@{@"status" : @"2"}];
            [[NSNotificationCenter defaultCenter] postNotificationName:OUT_STATUS_LASTMSG object:nil];
//        }];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application {
    if ([login_already isEqualToString:@"1"] ||[login_already isEqualToString:@"2"]) {
//        [timerAway invalidate];
//        timerAway = nil;
        [[[FIRDatabase database].reference  child:[NSString stringWithFormat:@"user/%@", gUser.usId]] updateChildValues:@{@"status" : @"0"}];
         [[NSNotificationCenter defaultCenter] postNotificationName:OUT_STATUS_LASTMSG object:nil];
        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    application.applicationIconBadgeNumber = 0;
    if ([login_already isEqualToString:@"1"] ||[login_already isEqualToString:@"2"]) {
        [timerAway invalidate];
        timerAway = nil;
        [[[FIRDatabase database].reference  child:[NSString stringWithFormat:@"user/%@", gUser.usId]] updateChildValues:@{@"status" : @"1"}];
        [[NSNotificationCenter defaultCenter] postNotificationName:IN_STATUS_LASTMSG object:nil];
    }
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

@end
