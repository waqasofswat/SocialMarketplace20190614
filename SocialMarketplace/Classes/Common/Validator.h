//
//  Validator.h
//  HiComBase
//
//  Created by Hicom on 3/11/13.
//  Copyright (c) 2013 HiCom Solution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validator : NSObject

+ (Validator *)sharedInstance;

+ (BOOL)validateEmail:(NSString*)email;
+ (BOOL)validateUrl:(NSString *)candidate;
+(NSString *)convertObjectToJSON:(id)obj;
+ (NSString *)getString:(NSInteger)i;
+ (int)getSafeInt:(id)obj;
+ (float)getSafeFloat:(id)obj;
+ (BOOL)getSafeBool:(id)obj;
+ (NSString *)getSafeString:(id)obj;
+ (BOOL)isNullOrNilObject:(id)object;
+ (BOOL)isValidObject:(id)object;


@end
