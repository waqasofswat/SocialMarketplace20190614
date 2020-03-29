//
//  ModelManager.h
//  EbookMobile
//
//  Created by Hicom on 1/29/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"



@interface ModelManager : NSObject

+(void)parseUrlRequest:(NSDictionary *)data path:(NSString *)path;

+(void)sendGetRequestUrl:(NSString*)url parameters:( NSDictionary* )parameter withSuccess:(void (^)(id dicSuccess))success failure:(void (^)(NSString* error)) failure;

+(void)sendPostRequestWithData:(NSData*)data parameters:(NSDictionary*)parameter url:(NSString*)url withSuccess:(void (^)(id dicSuccess))success failure:(void (^)(NSString* error)) failure;

                    //----------------API-----------------//
+(void)getSettingAppWithSuccess:(void (^)(NSDictionary *dicSuccess))success failure:(void (^)(NSString *err))failure;

+(void)registerAccountWithUsername:(NSString*)username
                          password:(NSString*)pass
                             email:(NSString*)email
                              name:(NSString*)name
                             phone:(NSString*)phone
                           address:(NSString*)address
                               sex:(NSString*)sex
                             skype:(NSString*)skype
                               web:(NSString*)website
                        individual:(NSString*)individual
                       description:(NSString*)description
                     dataImgAvatar:(NSData*)imageData
                       withSuccess:(void (^)(NSString* successStr))success failure:(void (^)(NSString * err))failure;

+(void)editAccountInfoWithName:(NSString*)name
                             phone:(NSString*)phone
                           address:(NSString*)address
                               sex:(NSString*)sex
                             skype:(NSString*)skype
                               web:(NSString*)website
                        individual:(NSString*)individual
                       description:(NSString*)description
                     dataImgAvatar:(NSData*)imageData
                       withSuccess:(void (^)(NSString* successStr))success failure:(void (^)(NSString * err))failure;


+(void)getAdsInPage:(NSString*)page sortType:(NSString*)sortType sortBy:(NSString*)sortBy screenType:(NSString*)screenType withSuccess:(void (^)(NSArray* arrReturn, int allPage))success failure:(void (^)(NSString *error)) failure;

+(void)getAdsInPageWithNearBy:(NSString*)page lat:(NSString*)lat lon:(NSString*)lon withSuccess:(void (^)(NSArray* arrReturn, int allPage))success failure:(void (^)(NSString *error)) failure;

+(void)getAdsByUserId:(NSString *)userId typeUser:(NSString *)typeUser andPage:(NSString *)page sortType:(NSString*)sortType sortBy:(NSString*)sortBy withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure;

+(void)getBookmarksAdsByUserId:(NSString*)userId andPage:(NSString*)page sortType:(NSString*)sortType sortBy:(NSString*)sortBy withSuccess:(void (^)(NSDictionary* dicReturn))success failure:(void (^)(NSString *error)) failure;

+(void)getListNewsInpage:(NSString*)page sortType:(NSString*)sortType sortBy:(NSString*)sortBy searchKey:(NSString*)key withSuccess:(void (^)(id dicReturn))success failure:(void (^)(NSString *error))failure;

+(void)getListSellerWithPage:(NSString*)page sortType:(NSString*)sortType sortBy:(NSString*)sortBy searchKey:(NSString*)searchKey withSuccess:(void (^)(id dicReturn))success failure:(void (^)(NSString *error))failure;
+(void)getListSellerFollowedWithPage:(NSString*)page sortType:(NSString*)sortType sortBy:(NSString*)sortBy searchKey:(NSString*)searchKey withSuccess:(void (^)(id dicReturn))success failure:(void (^)(NSString *error))failure;

+(void)getlistCityWithSuccess:(void (^)(NSArray *arrCity))success failure:(void (^)(NSString *error))failure;

+(void)getAdsDetailbyId:(NSString*)adsId withSuccess:(void (^)(id adsDetail))success failure:(void (^)(NSString* err))failure;

+(void)loginbyDefaultWithUserName:(NSString*)userName password:(NSString*)password withSuccess:(void (^)(id userInfo))success failure:(void (^)(NSString* err))failure;

+(void)loginFbWithName:(NSString*)name email:(NSString*)email fbId:(NSString*)fbId andImage:(NSString*)image withsuccess:(void (^)(id userInfo))success failure:(void (^)(NSString* err))failure;

+(void)forgotPasswordWithEmail:(NSString*)email withSuccess:(void (^)(NSString* successStr))success failure:(void (^)(NSString *err))failure;

+(void)changePasswordWithUserId:(NSString*)userId currentPass:(NSString*)currentPass newPass:(NSString*)newPass withSuccess:(void (^)(NSString *success))success failure:(void (^)(NSString* error))failure;

+(void)increaseViewAdsCount:(NSString*)adsId withSuccess:(void (^)(NSString* succ))success failure:(void (^)(NSString *err))failure;

+(void)getSellerDetailWithId:(NSString*)sellerId withSuccess:(void (^)(id successObj))success failure:(void (^)(NSString *err))failure;

+(void)getListCategoryWithSuccess:(void (^)(NSArray *arrCategory))success failure:(void (^)(NSString *err))failure;

+(void)searchAdsWithParam:(NSDictionary*)param
                    withSuccess:(void (^)(NSDictionary* successDic))success
                    failure:(void (^)(NSString* err))failure;

+(void)sendMessageWithAdsId:(NSString*)adsId
                  accountId:(NSString*)accountId
                       name:(NSString*)name
                      phone:(NSString*)phone
                      email:(NSString*)email
                      title:(NSString*)title
                    content:(NSString*)content withSuccess:(void (^)(NSString *successStr))success failure:(void (^)(NSString *err))failure;


+(void)addAdsWithTitle:(NSString*)title
                          description:(NSString*)description
                             price:(NSString*)price
                              price_value:(NSString*)price_value
                             price_unit:(NSString*)price_unit
                           forRent:(NSString*)forRent
                               forSale:(NSString*)forSale
                             accountId:(NSString*)accountId
                        categoryId:(NSString*)categoryId
                            subCate:(NSString*)subCate
                  city:(NSString*)city
         dataImgAvatar:(NSData*)imageData
           dataGallery:(NSArray*)dataGallery
            isAvailable:(NSString*)isAvailable
                   lat:(NSString*)lat
                   lng:(NSString*)lng
                       withSuccess:(void (^)(NSString* successStr))success failure:(void (^)(NSString * err))failure;


+(void)editAdsWithTitle:(NSString*)title
             oldGallery:(NSString*)oldGallery
           description:(NSString*)description
                 price:(NSString*)price
           price_value:(NSString*)price_value
            price_unit:(NSString*)price_unit
               forRent:(NSString*)forRent
               forSale:(NSString*)forSale
             accountId:(NSString*)accountId
            categoryId:(NSString*)categoryId
               subCate:(NSString*)subCate
                  city:(NSString*)city
         dataImgAvatar:(NSData*)imageData
           dataGallery:(NSArray*)dataGallery
             isAvailable:(NSString*)isAvailable
                  adsId:(NSString*)adsId
                    lat:(NSString*)lat
                    lng:(NSString*)lng
           withSuccess:(void (^)(NSString* successStr))success failure:(void (^)(NSString * err))failure;


+(void)getListMessageWithPage:(NSString*)page withSuccess:(void (^)(NSDictionary *dicReturn))success failure:(void(^)(NSString *err))failure;

+(void)contactUsActionWithName:(NSString*)name  email:(NSString*)email type:(NSString*)type subject:(NSString*)subject content:(NSString*)content withSuccess:(void (^)(NSString *strSuccess))success failure:(void (^)(NSString *err))failure;


+(void)addSubCriptionWithStartDate:(NSString *)startDate endate:(NSString *)endate duration:(NSString *)duration value:(NSString *)value adsId:(NSString *)adsId payment:(NSString *)payment subId:(NSString *)subId withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

+(void)addSubCriptionWithParam:(NSDictionary*)param withSuccess:(void (^)(NSString *strSuccess))success failure:(void (^)(NSString *err))failure;

+(void)mySubcriptionWithPage:(NSString*)page withSuccess:(void (^)(NSDictionary *dicReturn))success failure:(void (^)(NSString *err))failure;

+(void)bookmarkClickWithUserId:(NSString*)userId adsId:(NSString*)adsId type:(NSString*)type withSuccess:(void (^)(NSString *strSuccess))success failure:(void (^)(NSString *err))failure;

+(void)deleteAdsWitjAdsId:(NSString*)adsId withSuccess:(void (^)(NSString *strSuccess))success failure:(void (^)(NSString *err))failure;
+(void)getlistSubscriptionWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure;

+ (void)changeLikeAdsId:(NSString *)adsId status:(NSString*)status withSuccess:(void (^)(NSString *strSuccess))success failure: (void (^)(NSString *err))failure;

+ (void)getListCommentOfAds:(NSString *)adsId page:(int )page withSuccess:(void (^)(NSDictionary *dicReturn))success failure:(void (^)(NSString *err))failure;

+ (void)pushCommentWithAdsId:(NSString *)adsId content:(NSString*)content withSuccess:(void (^)(NSString *strSuccess))success failure:(void (^)(NSString *err))failure;
+ (void)pushMessageWithReceiveId:(NSString *)receiveId content:(NSString *)content withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;
+(void)uploadWithFile:(NSData *)imageData uid:(NSString *)uid withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;
+ (void)logoutWithSuccess:(void (^)(NSString *strStatus)) returnSuccess failure:(void (^)(NSString*err))returnFailure;
+ (void)followWithAgentId:(NSString*)agentId type:(NSString*)type Success:(void (^)(NSString *strStatus)) returnSuccess failure:(void (^)(NSString*err))returnFailure;
+(void)sendMessage: (NSString*) accountID 
                    title:(NSString*)title
                    name:(NSString*)name
                    phone:(NSString*)phone
                    email:(NSString*)email
                    content:(NSString*)content withSuccess:(void (^)(NSString *successStr))success failure:(void (^)(NSString *err))failure;
@end


