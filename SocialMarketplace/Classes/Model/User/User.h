//
//  User.h
//  Real Ads
//
//  Created by De Papier on 4/22/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (strong,nonatomic) NSString *usId;
@property (strong,nonatomic) NSString *usUserName;
@property (strong,nonatomic) NSString *usEmail;
@property (strong,nonatomic) NSString *usName;
@property (strong,nonatomic) NSString *usPhone;
@property (strong,nonatomic) NSString *usAddress;
@property (strong,nonatomic) NSString *usSkype;
@property (strong,nonatomic) NSString *usImage;
@property (strong,nonatomic) NSString *usType;
@property (strong,nonatomic) NSString *usSex;
@property (strong,nonatomic) NSString *usIsverified;
@property (strong,nonatomic) NSString *usWebsite;
@property (strong,nonatomic) NSString *usIndividual;
@property (strong,nonatomic) NSString *usFbId;
@property (strong,nonatomic) NSString *usDateCreated;
@property (strong,nonatomic) NSString *usAdsNumber;
@property (strong,nonatomic) NSString *usDescription;
@property (assign,nonatomic) BOOL usIsFollow;


- (instancetype)initWithDic:(NSDictionary*)dic;

@end
