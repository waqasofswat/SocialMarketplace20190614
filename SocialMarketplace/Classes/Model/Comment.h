//
//  Comment.h
//  SmartAds
//
//  Created by Pham Diep on 5/26/17.
//  Copyright © 2017 Mr Lemon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
@property (strong, nonatomic) NSString *linkAvatar;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *accName;
@property (assign, nonatomic) double timeIntervalPost;

- (instancetype)initWithDict:(NSDictionary*)dict;
@end
