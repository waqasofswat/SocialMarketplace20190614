//
//  User.m
//  Real Ads
//
//  Created by De Papier on 4/22/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

#import "User.h"
@implementation User


- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.usId = [Validator getSafeString:dic[@"id"]];
        self.usName = [Validator getSafeString:dic[@"name"]];
        self.usImage = [Validator getSafeString:dic[@"image"]];
        self.usAddress = [Validator getSafeString:dic[@"address"]];
        self.usPhone = [Validator getSafeString:dic[@"phone"]];
        self.usEmail = [Validator getSafeString:dic[@"email"]];
        self.usSkype = [Validator getSafeString:dic[@"skype"]];
        self.usWebsite = [Validator getSafeString:dic[@"website"]];
        self.usIndividual = [Validator getSafeString:dic[@"individual"]];
        self.usType = [Validator getSafeString:dic[@"type"]];
        self.usIsverified = [Validator getSafeString:dic[@"isVerified"]];
        self.usDateCreated = [Validator getSafeString:dic[@"dateCreated"]];
        self.usAdsNumber = [Validator getSafeString:dic[@"numberAds"]];
        self.usDescription = [Validator getSafeString:dic[@"description"]];
        self.usIsFollow = [Validator getSafeBool:dic[@"isFollowed"]];
    }
    return self;
}
- (id) initWithCoder: (NSCoder *)coder
{
    self = [super init];
    if (self != nil)
    {
        self.usId = [coder decodeObjectForKey:@"estateId"];
        self.usUserName = [coder decodeObjectForKey:@"image"];
        self.usEmail = [coder decodeObjectForKey:@"title"];
        self.usName = [coder decodeObjectForKey:@"type"];
        self.usPhone = [coder decodeObjectForKey:@"city"];
        self.usAddress = [coder decodeObjectForKey:@"estateDescription"];
        self.usSkype = [coder decodeObjectForKey:@"condition"];
        self.usImage = [coder decodeObjectForKey:@"price"];
        self.usType = [coder decodeObjectForKey:@"address"];
        self.usSex = [coder decodeObjectForKey:@"latitude"];
        self.usIsverified = [coder decodeObjectForKey:@"longitude"];
        self.usWebsite = [coder decodeObjectForKey:@"forRent"];
        self.usIndividual = [coder decodeObjectForKey:@"forSale"];
        self.usFbId = [coder decodeObjectForKey:@"status"];
        self.usDateCreated = [coder decodeObjectForKey:@"bedRoom"];
        self.usAdsNumber = [coder decodeObjectForKey:@"bathRoom"];
        self.usDescription = [coder decodeObjectForKey:@"usDescription"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    //[coder encodeObject:estateId forKey:@"locationId"];
    [coder encodeObject:self.usId forKey:@"estateId"];
    [coder encodeObject:self.usUserName forKey:@"image"];
    [coder encodeObject:self.usEmail forKey:@"title"];
    [coder encodeObject:self.usName forKey:@"type"];
    [coder encodeObject:self.usPhone forKey:@"city"];
    [coder encodeObject:self.usAddress forKey:@"estateDescription"];
    [coder encodeObject:self.usSkype forKey:@"condition"];
    [coder encodeObject:self.usImage forKey:@"price"];
    [coder encodeObject:self.usType forKey:@"address"];
    [coder encodeObject:self.usSex forKey:@"latitude"];
    [coder encodeObject:self.usIsverified forKey:@"longitude"];
    [coder encodeObject:self.usWebsite forKey:@"forRent"];
    [coder encodeObject:self.usIndividual forKey:@"forSale"];
    [coder encodeObject:self.usFbId forKey:@"status"];
    [coder encodeObject:self.usDateCreated forKey:@"bedRoom"];
    [coder encodeObject:self.usAdsNumber forKey:@"bathRoom"];
    [coder encodeObject:_usDescription forKey:@"usDescription"];

}



@end
