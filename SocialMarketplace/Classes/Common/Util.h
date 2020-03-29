//
//  Util.h
//  MyBeautyPlan
//
//  Created by hieunguyen on 8/9/14.
//  Copyright (c) 2014 HiComSOLUTION. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface Util : NSObject

+ (Util *)sharedUtil;

+(BOOL)isConnectNetwork;
    
+(NSString*) localized : (NSString*) key;

+(void)shareWithImage:(UIImage *)image
               onView:(UIViewController *)view
             delegate:(id)delegate
          WithSuccess:(void (^)(void))success
              failure:(void (^)(NSString *))failure;
+(void)pushNotificationLocal:(NSString*)alertBody badgeNumber:(NSString*)badgeNumber;
+ (void)removeObjectForKey:(NSString *)key;
+(BOOL)getBoolForKey:(NSString *)key;
////
+ (void)saveObjectWithEncode:(id)object forkey:(NSString*)key;
+ (id)getObjectWithDecode:(NSString*)key;
////
+(id)stringForKey:(NSString*)key;
+(void)setBool:(BOOL)obj forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;
+ (void)setObject:(id)obj forKey:(NSString *)key;
+(BOOL)checkString:(NSString *)sub isSubStringOf:(NSString *)large;

+(NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+(NSDate *)dateFromString:(NSString *)date format:(NSString *)format;

+(float)getTextHight:(UILabel *)label font: (UIFont *)font;
+(float)getLabelHight:(UILabel *)label;
//Alert functions
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title andDelegate:(id)delegate;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title delegate:(id)delegate andTag:(NSInteger)tag;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle delegate:(id)delegate andTag:(NSInteger)tag;


+(void)borderAndcornerImagewith:(float )conner andBorder:(float )border andColor:(UIColor *)color withImage:(UIImageView *)button;
+(void)borderAndcornerLabelwith:(float )conner andBorder:(float )border andColor:(UIColor *)color withImage:(UILabel *)button;
+(void)borderAndcornerButtonwith:(float )conner andBorder:(float )border andColor:(UIColor *)color withButton:(UIButton *)button;
+(void)shadowImage:(UIImageView *)imgView;

+(CGRect )viewUp:(UIView *)view Up:(int)height;

+(CGRect )viewDown:(UIView *)view Down:(int)height;

+(NSString *)replaceString:(NSString *)st1 withString:(NSString *)st2 fromString:(NSString *)str;

+ (UIButton *) drawButton: (UIButton *)button;

+ (NSString*)base64forData:(NSData*)theData ;
+ (NSString *)encodeToBase64String:(UIImage *)image ;
+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;

+(int)dayLeftFromDate:(NSDate *)endDate;





+(int)getTimezoneOffset;

+(void)callPhoneNumber:(NSString *)phone;


+(void)saveImage:(UIImage *)img withName:(NSString *)name;

+(UIImage *)getImageWithName:(NSString *)name;

+ (NSString *)documentsPathForFileName:(NSString *)name;
+(BOOL)isFilenameExits:(NSString *)name;

+(CGSize)imageScale:(UIImageView *)image;
+ (NSString *)convertObjectToJSON:(id)obj;
+ (NSString *)convertPriceString:(NSString*)obj;

+ (UIImage*)imageWithImage:(UIImage *)image convertToWidth:(float)width covertToHeight:(float)height;
+ (UIImage*)imageWithImage:(UIImage *)image convertToHeight:(float)height;
+ (UIImage*)imageWithImage:(UIImage *)image convertToWidth:(float)width;
+ (UIImage*)imageWithImage:(UIImage *)image fitInsideWidth:(float)width fitInsideHeight:(float)height;
+ (UIImage*)imageWithImage:(UIImage *)image fitOutsideWidth:(float)width fitOutsideHeight:(float)height;
+ (UIImage*)imageWithImage:(UIImage *)image cropToWidth:(float)width cropToHeight:(float)height;



@end
