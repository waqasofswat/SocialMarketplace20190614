//
//  Ads.m
//  Real Ads
//
//  Created by Hicom Solutions on 1/24/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

#import "Ads.h"
#import "ImageObj.h"

@implementation Ads
- (instancetype)initWithDict:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _adsId = [Validator getSafeString:dic[@"id"]];
        self.adsImage =dic[@"image"];
        self.adsTitle = dic[@"title"];
        self.adsDescription = dic[@"description"];
        self.adsPrice = [Validator getSafeString:dic[@"price"]];
        self.adsPriceValue = [Validator getSafeString:dic[@"priceValue"]];
        self.adsPriceUnit = [Validator getSafeString:dic[@"priceUnit"]];
        self.adsCity =[Validator getSafeString:dic[@"city"]];
        self.adsForRent = dic[@"forRent"];
        self.adsForSale = dic[@"forSale"];
        self.adsStatus = dic[@"status"];
        self.adsAccountId = dic[@"accountId"];
        self.adsAccountName = dic[@"accountName"];
        self.adsAccountDateCreated = dic[@"accountDateCreated"];
        self.adsAccountType = dic[@"accountType"];
        //            self.adsAccountContact = dic[@"accountContact"];
        self.adsCategory =[Validator getSafeString:dic[@"category"]];
        self.adsSub =[Validator getSafeString:dic[@"subCate"]];
        self.adsDateCreated = dic[@"dateCreated"];
        self.adsIsAvailable = dic[@"isAvailable"];
        self.adsViews = dic[@"views"];
        self.adsGallery = [[NSMutableArray alloc]init];
        self.adsCategoryId =[Validator getSafeString:dic[@"categoryId"]];
        self.adsSubCatId =[Validator getSafeString:dic[@"subCateId"]];
        self.adsCityId =[Validator getSafeString:dic[@"cityId"]];
        self.adsIsFeatured =[Validator getSafeString:dic[@"isFeatured"]];
        self.likeCount = [Validator getSafeInt:dic[@"countLike"]];
        self.commentCount  = [Validator getSafeInt:dic[@"countComment"]];
        self.isLiked = [Validator getSafeBool:dic[@"like"]];
        self.isFavorite = [Validator getSafeBool:dic[@"bookmark"]];
        self.adsImgAvatar = [Validator getSafeString:dic[@"accountImage"]];
        self.favouriteCount = [Validator getSafeInt:dic[@"countBookmark"]];
        self.adsLat = [Validator getSafeString:dic[@"latitude"]];
        self.adsLng = [Validator getSafeString:dic[@"longitude"]];
        
        NSArray *arrGalleryObj = dic[@"gallery"];
        
        for (NSDictionary *dicGallery in arrGalleryObj) {
            ImageObj *imgObj = [[ImageObj alloc]init];
            imgObj.imgId = dicGallery[@"id"];
            imgObj.imgName = dicGallery[@"image"];
            [self.adsGallery addObject:imgObj];
        }

    }
    return self;

}
@end
