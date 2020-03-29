//
//  Util.m
//  MyBeautyPlan
//
//  Created by hieunguyen on 8/9/14.
//  Copyright (c) 2014 HiComSOLUTION. All rights reserved.
//

#import "Util.h"
#import "Macros.h"
#import "Common.h"



#define kCalendarType NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit

@implementation Util

+ (Util *)sharedUtil {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}
    
+ (NSString *)localized:(NSString *)key {
//    return NSLocalizedString(key, nil);
    // langCode should be set as a global variable somewhere
    NSString *path = [[NSBundle mainBundle] pathForResource:[Util objectForKey:KEY_SAVE_LANGUAGE] ofType:@"lproj"];
    
    NSBundle* languageBundle = [NSBundle bundleWithPath:path];
    return [languageBundle localizedStringForKey:key value:@"" table:nil];
}

//+ (AppDelegate *)appDelegate {
//    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    return appDelegate;
//}

+(id)stringForKey:(NSString *)key{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }else{
        return @"0";
    }
}
+(void)pushNotificationLocal:(NSString*)alertBody badgeNumber:(NSString*)badgeNumber{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    notification.alertBody = alertBody;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = badgeNumber.intValue;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
////
+ (void)saveObjectWithEncode:(id)object forkey:(NSString *)key{
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSData *data =[NSKeyedArchiver archivedDataWithRootObject:object];
    [userDefault removeObjectForKey:key];
    [userDefault synchronize];
    [userDefault setObject:data forKey:key];
    [userDefault synchronize];
}
+(id)getObjectWithDecode:(NSString *)key{
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSData *data =[userDefault objectForKey:key];
    return (id)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

////
+(void)borderAndcornerImagewith:(float )conner andBorder:(float )border andColor:(UIColor *)color withImage:(UIImageView *)button
{
    button.layer.borderWidth = border;
    button.layer.borderColor = color.CGColor;
    button.layer.cornerRadius = conner;
    button.clipsToBounds = YES;
}
+(void)borderAndcornerButtonwith:(float )conner andBorder:(float )border andColor:(UIColor *)color withButton:(UIButton *)button
{
    button.layer.borderWidth = border;
    button.layer.borderColor = color.CGColor;
    button.layer.cornerRadius = conner;
    button.clipsToBounds = YES;
}
+(void)shadowImage:(UIImageView *)imgView
{
    UIColor *shadow2 = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    imgView.layer.shadowColor = shadow2.CGColor;
    imgView.layer.shadowOffset = CGSizeMake(0, 8);
    imgView.layer.shadowOpacity = 1.0;
    imgView.layer.shadowRadius = 4.0;
    imgView.clipsToBounds = YES;
}
+(void)borderAndcornerLabelwith:(float )conner andBorder:(float )border andColor:(UIColor *)color withImage:(UILabel *)button
{
    button.layer.borderWidth = border;
    button.layer.borderColor = color.CGColor;
    button.layer.cornerRadius = conner;
    button.clipsToBounds = YES;
}
+(NSString *)getTeamInfoWithName:(NSString *)teamName{
    
    NSError *error;
    NSString* path = [[NSBundle mainBundle] pathForResource:teamName
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
    if (error) {
        //        NSLog(@"file content: %@",error);
    }
    return content;
}

+(BOOL)isConnectNetwork{
    
    NSString *urlString = @"http://www.google.com/";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    return ([response statusCode] == 200) ? YES : NO;
    
}
+(BOOL)checkString:(NSString *)sub isSubStringOf:(NSString *)large{
    
    if ([large rangeOfString:sub].location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}
+(float)getTextHight:(UILabel *)label font: (UIFont *)font{
    CGSize maximumLabelSize = CGSizeMake(label.frame.size.width,990);
    CGSize expectedLabelSize = [label.text sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];
    return  expectedLabelSize.height;
}
+(float)getLabelHight:(UILabel *)label{
    CGRect rect = [label.attributedText boundingRectWithSize:CGSizeMake(label.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    if (IS_IPAD()) {
        return rect.size.height*2;
    }
    return rect.size.height;
}
+(UIActivityIndicatorView*)addLoadingViewandTheViewToShowIn: (UIView *)viewToShowIn
{
    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView     alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setCenter:viewToShowIn.center];
    [activityIndicator startAnimating];
    [viewToShowIn addSubview:activityIndicator];
    [viewToShowIn bringSubviewToFront:activityIndicator];
    return activityIndicator;
}


+(void)removeLoadingView: (UIActivityIndicatorView *)activityIndicator
      andTheViewToShowIn: (UIView *)viewToShowIn
{
    [activityIndicator removeFromSuperview];
}



+ (void)removeObjectForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getBoolForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+(void)setBool:(BOOL)obj forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setBool:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setObject:(id)obj forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)stringFromDate:(NSDate *)date format:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *stringFromDate = [formatter stringFromDate:date];
    if (stringFromDate.length == 0) {
        return @" ";
    }
    return stringFromDate;
}
+(int)getTimezoneOffset{
    NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    return [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600.0;
}
+(BOOL)isPM{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    if (pmRange.location != NSNotFound || amRange.location != NSNotFound) {
        return YES;
    }
    return NO;
}
+ (NSString *)convertObjectToJSON:(id)obj {
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        return @"";
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
+ (NSString *)convertPriceString:(NSString*)PriceString{
    int dem = (int)(PriceString.length - 3);
    NSString *Sotienchuanhoa_Ok = @"";
    NSString *Sotienchuanhoa_Ok1 = @"";
    int i;
    for (i = (int)(PriceString.length - 1); i >= 0; i--)
    {
        Sotienchuanhoa_Ok = [NSString stringWithFormat:@"%@%c", Sotienchuanhoa_Ok,[PriceString characterAtIndex:i]];
        if (i == dem && i != 0) {
            Sotienchuanhoa_Ok = [NSString stringWithFormat:@"%@%@", Sotienchuanhoa_Ok , @","];
            dem = dem - 3;
        }
    }
    for (i = (int)(Sotienchuanhoa_Ok.length - 1); i >= 0; i--) {
        Sotienchuanhoa_Ok1 = [NSString stringWithFormat:@"%@%c", Sotienchuanhoa_Ok1,[Sotienchuanhoa_Ok characterAtIndex:i]];
    }
    return Sotienchuanhoa_Ok1;

}
+(NSDate *)dateFromString:(NSString *)date format:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"] ;
    [formatter setLocale:formatterLocale];
    if ([self isPM]) {
        
        for(int i=13;i<25;i++){
            NSRange amRange = [date rangeOfString:[NSString stringWithFormat:@"T%d",i]];
            if (amRange.location != NSNotFound) {
                date = [date stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"T%d",i] withString:[NSString stringWithFormat:@"T%d",i-12]];
                date = [NSString stringWithFormat:@"%@ %@", date,[formatter PMSymbol]];
                format = [NSString stringWithFormat:@"%@ a",format];
                i = 25;
            }
            
        }
        
    }
    
    
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*[self getTimezoneOffset]]];
    NSDate *dateFromString = [formatter dateFromString:date];
    if (!dateFromString) {
        NSString *tmp = [date stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%.2d:00",[Util getTimezoneOffset]] withString:@"00:00"];
        if (![tmp isEqualToString:date]) {
            return [self dateFromString:tmp format:format];
        }
        return [NSDate date];
    }
    return dateFromString;
}



#pragma mark Alert functions
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
    
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title andDelegate:(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title delegate:(id)delegate andTag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = tag;
    [alert show];
    
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle delegate:(id)delegate andTag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    alert.tag = tag;
    alert.delegate = delegate;
    [alert show];
    
}



+(CGRect )viewUp:(UIView *)view Up:(int)height{
    //    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-height, view.frame.size.width, view.frame.size.height);
    return  CGRectMake(view.frame.origin.x, view.frame.origin.y-height, view.frame.size.width, view.frame.size.height);
}

+(CGRect )viewDown:(UIView *)view Down:(int)height{
    //    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+height, view.frame.size.width, view.frame.size.height);
    return CGRectMake(view.frame.origin.x, view.frame.origin.y+height, view.frame.size.width, view.frame.size.height);
}



+ (UIButton *) drawButton: (UIButton *)button {
    CGRect textRect = button.titleLabel.frame;
    
    // need to put the line at top of descenders (negative value)
    CGFloat descender = button.titleLabel.font.descender;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // set to same colour as text
    CGContextSetStrokeColorWithColor(contextRef, button.titleLabel.textColor.CGColor);
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender);
    
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender);
    
    CGContextClosePath(contextRef);
    
    CGContextDrawPath(contextRef, kCGPathStroke);
    
    return button;
}

+(void)saveImage:(UIImage *)img withName:(NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
    
    NSData *imageData = UIImagePNGRepresentation(img);
    [imageData writeToFile:savedImagePath atomically:NO];
    
    
    
}

+ (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}
+(UIImage *)getImageWithName:(NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",name] ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}
+(int)dayLeftFromDate:(NSDate *)endDate{
    
    NSDate *startDate = [NSDate date];
    
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    int diff = (int)[components day];
    
    return diff;
}

+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}


+ (void)scheduleNotificationAfter10MinutesForDate:(NSDate *)date withMessage:(NSString *) msg
{
    // Here we cancel all previously scheduled notifications
    
    float day = [self dayLeftFromDate:date];
    
    if (day<0) {
        return;
    }
    [Util deleteNotificationOnDate:date];
    
    
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = date;
    //    NSLog(@"Notification will be shown on: %@",localNotification.fireDate);
    //
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = msg;
    localNotification.alertAction = NSLocalizedString(@"View details", nil);
    
    /* Here we set notification sound and badge on the app's icon "-1"
     means that number indicator on the badge will be decreased by one
     - so there will be no badge on the icon */
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 0;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
+ (void)scheduleNotificationForDate:(NSDate *)date withMessage:(NSString *) msg
{
    // Here we cancel all previously scheduled notifications
    float day = [self dayLeftFromDate:date];
    [Util deleteNotificationOnDate:date];
    if (day<0) {
        return;
    }
    
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        
        if ([localNotification.alertBody isEqualToString:msg]) {
            //            NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
            
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
            
        }
        
    }
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = date;
    //    NSLog(@"Notification will be shown on: %@",localNotification.fireDate);
    
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = msg;
    localNotification.alertAction = NSLocalizedString(@"View details", nil);
    
    /* Here we set notification sound and badge on the app's icon "-1"
     means that number indicator on the badge will be decreased by one
     - so there will be no badge on the icon */
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 0;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [self scheduleNotificationAfter10MinutesForDate:[NSDate dateWithTimeInterval:(10*60) sinceDate:date] withMessage:msg];
}


+(void)deleteNotificationOnDate:(NSDate *)date{
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
    
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        
        if ([localNotification.fireDate compare:date] == NSOrderedSame) {
            //            NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
            
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification]; // delete the notification from the system
            
        }
        
    }
}

+(void)callPhoneNumber:(NSString *)phone{
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSString *cleanedString = [[phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *phoneURLString = [NSString stringWithFormat:@"telprompt:%@", escapedPhoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
    else{
        
        [Util showMessage:@"Call facility is not available!!!" withTitle:nil];
    }
}
+(BOOL)isFilenameExits:(NSString *)name{
    NSString *imageName = [NSString stringWithFormat:@"%@.png",name];
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:imageName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    if (fileExists) {
        UIImage *img = [Util getImageWithName:name];
        NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((img), 0.5)];
        
        int imageSize = imageData.length;
        
        if (imageSize > 100) {
            return YES;
        }
    }
    return NO;
}
+ (CGSize)imageScale:(UIImageView *)image{
    CGFloat sx = image.frame.size.width / image.image.size.width;
    CGFloat sy = image.frame.size.height / image.image.size.height;
    CGFloat s = 1.0;
    switch (image.contentMode) {
        case UIViewContentModeScaleAspectFit:
            s = fminf(sx, sy);
            return CGSizeMake(s, s);
            break;
            
        case UIViewContentModeScaleAspectFill:
            s = fmaxf(sx, sy);
            return CGSizeMake(s, s);
            break;
            
        case UIViewContentModeScaleToFill:
            return CGSizeMake(sx, sy);
            
        default:
            return CGSizeMake(s, s);
    }
}


+ (UIImage*)imageWithImage:(UIImage *)image convertToWidth:(float)width covertToHeight:(float)height {
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}

+ (UIImage*)imageWithImage:(UIImage *)image convertToHeight:(float)height {
    float ratio = image.size.height / height;
    float width = image.size.width / ratio;
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}

+ (UIImage*)imageWithImage:(UIImage *)image convertToWidth:(float)width {
    float ratio = image.size.width / width;
    float height = image.size.height / ratio;
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}

+ (UIImage*)imageWithImage:(UIImage *)image fitInsideWidth:(float)width fitInsideHeight:(float)height {
    if (image.size.height >= image.size.width) {
        return [Util imageWithImage:image convertToWidth:width];
    } else {
        return [Util imageWithImage:image convertToHeight:height];
    }
}

+ (UIImage*)imageWithImage:(UIImage *)image fitOutsideWidth:(float)width fitOutsideHeight:(float)height {
    if (image.size.height >= image.size.width) {
        return [Util imageWithImage:image convertToHeight:height];
    } else {
        return [Util imageWithImage:image convertToWidth:width];
    }
}

+ (UIImage*)imageWithImage:(UIImage *)image cropToWidth:(float)width cropToHeight:(float)height {
    CGSize size = [image size];
    CGRect rect = CGRectMake(((size.width-width) / 2.0f), ((size.height-height) / 2.0f), width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage * img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return img;
}



@end
