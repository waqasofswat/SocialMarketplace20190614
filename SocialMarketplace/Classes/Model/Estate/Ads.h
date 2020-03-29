//
//  Ads.h
//  Real Ads
//
//  Created by Hicom Solutions on 1/24/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ads : NSObject

@property (strong,nonatomic) NSString *adsId;
@property (strong,nonatomic) NSString *adsImage;
@property (strong,nonatomic) NSString *adsTitle;
@property (strong,nonatomic) NSString *adsDescription;
@property (strong,nonatomic) NSString *adsPrice;
@property (strong,nonatomic) NSString *adsPriceValue;
@property (strong,nonatomic) NSString *adsPriceUnit;
@property (strong,nonatomic) NSString *adsCity;
@property (strong,nonatomic) NSString *adsForRent;
@property (strong,nonatomic) NSString *adsForSale;
@property (strong,nonatomic) NSString *adsStatus;
@property (strong,nonatomic) NSString *adsAccountId;
@property (strong,nonatomic) NSString *adsAccountName;
@property (strong,nonatomic) NSString *adsAccountDateCreated;
@property (strong,nonatomic) NSString *adsAccountType;
@property (strong,nonatomic) NSString *adsAccountContact;
@property (strong,nonatomic) NSString *adsCategory;
@property (strong,nonatomic) NSString *adsSub;
@property (strong,nonatomic) NSString *adsCityId;
@property (strong,nonatomic) NSString *adsCategoryId;
@property (strong,nonatomic) NSString *adsSubCatId;
@property (strong,nonatomic) NSString *adsDateCreated;
@property (strong,nonatomic) NSString *adsIsAvailable;
@property (strong,nonatomic) NSString *adsViews;
@property (strong,nonatomic) NSString *adsLat;
@property (strong,nonatomic) NSString *adsLng;
@property (assign,nonatomic) int likeCount;
@property (assign,nonatomic) int commentCount;
@property (assign, nonatomic) int favouriteCount;
@property (assign,nonatomic) BOOL isLiked;
@property (assign,nonatomic) BOOL isFavorite;
@property (strong,nonatomic) NSString *adsImgAvatar;

@property (strong,nonatomic) NSMutableArray *adsGallery;
@property (strong,nonatomic) NSString *adsIsFeatured;

- (instancetype)initWithDict:(NSDictionary*)dic;

@end
