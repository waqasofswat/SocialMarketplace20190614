//
//  Comment.m
//  SmartAds
//
//  Created by Pham Diep on 5/26/17.
//  Copyright © 2017 Mr Lemon. All rights reserved.
//

#import "Comment.h"

@implementation Comment
- (instancetype)initWithDict:(NSDictionary *)dict {
   self = [super init];
    if (self) {
        _linkAvatar = [Validator getSafeString:dict[@"accountImage"]];
        _content = [Validator getSafeString:dict[@"content"]];
        _accName = [Validator getSafeString:dict[@"accountName"]];
        _timeIntervalPost = [Validator getSafeFloat:dict[@"dateCreated"]];

    }
    return self;
}

@end

