//
//  ModelManager.m
//  EbookMobile
//
//  Created by Hicom on 1/29/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//
#define STATUS_KEY                  @"status"
#define SUCCSESS                    @"SUCCESS"
#define ERROR                       @"ERROR"
#define DATA_KEY                    @"data"

#import <AssetsLibrary/AssetsLibrary.h>
#import "ModelManager.h"
#import "Ads.h"
#import "ImageObj.h"
#import "User.h"
#import "SocialMarketplace-Swift.h"
#import "CategoryPr.h"


@implementation ModelManager
+(BOOL)networkIsAvailable{
    return [[AFNetworkReachabilityManager manager] isReachable];
}

+(void)sendGetRequestUrl:(NSString *)url parameters:(NSDictionary *)parameter withSuccess:(void (^)(id))success failure:(void (^)(NSString *))failure {
    
    [self parseUrlRequest:parameter path:url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.description);
    }];
}

+ (void)sendPostRequestWithData:(NSData *)data parameters:(NSDictionary *)parameter url:(NSString *)url withSuccess:(void (^)(id))success failure:(void (^)(NSString *))failure{

}

+(void)parseUrlRequest:(NSDictionary *)data path:(NSString *)path {
    NSString*url = [NSString stringWithFormat:@"%@?", path];
    for (NSString* key in data.allKeys) {
        NSString *value = (NSString *)[data objectForKey:key];
        //NSLog(@"urlRequestObj: prams: %@: %@", key, value);
        //NSLog(@"urlRequestObj: key = %@",key);
        
        url = [NSString stringWithFormat:@"%@%@=%@&", url, key, value];
    }
    if (![path  isEqual: @"updateCoordinate"]) {
        NSLog(@"url.....:  %@", url);
    }
}

+(void)getSettingAppWithSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_SETTING_APP];
    NSDictionary *param = @{};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            if (success) {
                success(dicSuccess[@"data"]);
            }
        }else{
            if (failure) {
                failure(@"Have error");
            }
        }
    } failure:^(NSString *error) {
        if (failure) {
            failure(@"Network error");
        }
        
    }];
    
    
}

+(void)registerAccountWithUsername:(NSString *)username password:(NSString *)pass email:(NSString *)email name:(NSString *)name phone:(NSString *)phone address:(NSString *)address sex:(NSString *)sex skype:(NSString *)skype web:(NSString *)website individual:(NSString *)individual description:(NSString *)description dataImgAvatar:(NSData *)imageData withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_REGISTER];
    NSDictionary *data = @{
                           @"user_name":username,
                           @"password":pass,
                           @"email":email,
                           @"name":name,
                           @"phone":phone,
                           @"address":address,
                           @"sex":sex,
                           @"skype":skype,
                           @"website":website,
                           @"individual":individual,
                           @"description":description
                           };
    NSString* jsonObj = [Util convertObjectToJSON:data];
    NSDictionary *param =@{@"data":jsonObj};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //  [formData appendPartWithFileURL:filePath name:@"image" error:nil];
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"myImage.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([responseObject[STATUS_KEY] isEqualToString:SUCCSESS]) {
            if (success) {
                success(responseObject[@"message"]);
            }
        }else{
            if (failure) {
                failure(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure(@"Network error");
        }
    }];
    
}

+(void)editAccountInfoWithName:(NSString *)name phone:(NSString *)phone address:(NSString *)address sex:(NSString *)sex skype:(NSString *)skype web:(NSString *)website individual:(NSString *)individual description:(NSString *)description dataImgAvatar:(NSData *)imageData withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_EDIT_INFO];
    NSDictionary *data = @{@"userId":gUser.usId,
                           @"name":name,
                           @"phone":phone,
                           @"address":address,
                           @"sex":sex,
                           @"skype":skype,
                           @"website":website,
                           @"individual":individual,
                           @"description":description
                           };
    NSString* jsonObj = [Util convertObjectToJSON:data];
    NSDictionary *param =@{@"data":jsonObj};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //  [formData appendPartWithFileURL:filePath name:@"image" error:nil];
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"myImage.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([responseObject[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSDictionary *dic = responseObject[@"data"];
            User *user = [[User alloc] init];
            user.usId = dic[@"id"];
            user.usUserName =[Validator getSafeString: dic[@"user_name"]];
            user.usEmail = dic[@"email"];
            user.usName = dic[@"name"];
            user.usPhone = dic[@"phone"];
            user.usAddress = dic[@"address"];
            user.usSkype = dic[@"skype"];
            user.usImage = dic[@"image"];
            user.usType = @"0";
            user.usSex = dic[@"sex"];
            user.usIsverified = dic[@"isVerified"];
            user.usWebsite = dic[@"website"];
            user.usIndividual = dic[@"individual"];
            user.usFbId = dic[@"facebookId"];
           user.usDescription = dic[@"description"];
            gUser = user;
            [Util saveObjectWithEncode:gUser forkey:KEY_SAVE_gUSER];
            
            if (success) {
                success(responseObject[@"message"]);
            }
        }else{
            if (failure) {
                failure(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure(@"Network error");
        }
    }];
    
}
+(void)sendNotificationWithFirebase:(NSString*)firebase withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_EDIT_INFO];
    NSDictionary *data = @{@"userId":gUser.usId
                           };
    NSString* jsonObj = [Util convertObjectToJSON:data];
    NSDictionary *param =@{@"data":jsonObj};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"key=AIzaSyDnSO-tBvBg3TXpru0fIERFSLF6sLHCy3M" forHTTPHeaderField:@"Authorization"];
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([responseObject[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSDictionary *dic = responseObject[@"data"];
            User *user = [[User alloc] init];
            user.usId = dic[@"id"];
            user.usUserName =[Validator getSafeString: dic[@"user_name"]];
            user.usEmail = dic[@"email"];
            user.usName = dic[@"name"];
            user.usPhone = dic[@"phone"];
            user.usAddress = dic[@"address"];
            user.usSkype = dic[@"skype"];
            user.usImage = dic[@"image"];
            user.usType = @"0";
            user.usSex = dic[@"sex"];
            user.usIsverified = dic[@"isVerified"];
            user.usWebsite = dic[@"website"];
            user.usIndividual = dic[@"individual"];
            user.usFbId = dic[@"facebookId"];
            gUser = user;
            [Util saveObjectWithEncode:gUser forkey:KEY_SAVE_gUSER];
            
            if (success) {
                success(responseObject[@"message"]);
            }
        }else{
            if (failure) {
                failure(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure(@"Network error");
        }
    }];
    
}

+(void)loginbyDefaultWithUserName:(NSString *)userName password:(NSString *)password withSuccess:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_LOGIN_DEFAULT];
    NSDictionary *param = @{
                            @"user":userName,
                            @"pass":password,
                            @"type":@"0",
                            @"gcm_id":[Validator getSafeString:[Util objectForKey:KEY_SAVE_TOKEN]],
                            @"ime":[Validator getSafeString:[Util objectForKey:KEY_SAVE_TOKEN]],
                            @"typeDevice":PLATFORM_DEVICE
                                    };
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            
            NSDictionary *dic = dicSuccess[@"data"];
            User *user = [[User alloc] init];
            user.usId = dic[@"id"];
            user.usUserName = [Validator getSafeString:dic[@"user_name"]];
            user.usEmail = dic[@"email"];
            user.usName = dic[@"name"];
            user.usPhone = dic[@"phone"];
            user.usAddress = dic[@"address"];
            user.usSkype = dic[@"skype"];
            user.usImage = dic[@"image"];
            user.usType = @"0";
            user.usSex = dic[@"sex"];
            user.usIsverified = dic[@"isVerified"];
            user.usWebsite = dic[@"website"];
            user.usIndividual = dic[@"individual"];
            user.usDescription = [Validator getSafeString:dic[@"description"]];
            gUser = user;
            login_already = @"1";
            [Util setObject:@"1" forKey:KEY_LOGIN];
            [Util saveObjectWithEncode:gUser forkey:KEY_SAVE_gUSER];
            [[[FIRDatabase database].reference  child:[NSString stringWithFormat:@"user/%@", user.usId]] updateChildValues:@{@"status" : @"1"}];
            if (success) {
                success(user);
            }
            
        }else{
            login_already = @"0";
            [Util setObject:@"0" forKey:KEY_LOGIN];
            if (failure) {
                failure(dicSuccess[@"message"]);
            }
        }
    } failure:^(NSString *error) {
        if (failure) {
            failure(@"No internet connection");
        }
    }];
}
+(void)logoutWithSuccess:(void (^)(NSString *))returnSuccess failure:(void (^)(NSString *))returnFailure{
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_LOGOUT];
    NSDictionary *param = @{@"user_id":[Validator getSafeString:gUser.usId]
                            };
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        returnSuccess(dicSuccess[@"message"]);
    } failure:^(NSString *err) {
        if (returnFailure) {
            returnFailure(err);
        }
    }];
}
+(void)followWithAgentId:(NSString *)agentId type:(NSString *)type Success:(void (^)(NSString *))returnSuccess failure:(void (^)(NSString *))returnFailure{
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_FOLLOW];
    NSDictionary *param = @{@"userId":[Validator getSafeString:gUser.usId],
                            @"agentId":agentId,
                            @"type":type
                            };
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        returnSuccess(dicSuccess[@"message"]);
    } failure:^(NSString *err) {
        if (returnFailure) {
            returnFailure(err);
        }
    }];
}

+(void)loginFbWithName:(NSString *)name email:(NSString *)email fbId:(NSString *)fbId andImage:(NSString *)image withsuccess:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_LOGIN_FB];
    NSDictionary *param = @{
                            @"name":name,
                            @"email":email,
                            @"facebookId":fbId,
                            @"image":image,
                            @"type":@"1",
                            @"typeDevice":PLATFORM_DEVICE};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSDictionary *dic = dicSuccess[@"data"];
            User *user = [[User alloc] init];
            user.usId = dic[@"id"];
            user.usUserName =[Validator getSafeString:dic[@"email"]];
            user.usEmail = dic[@"email"];
            user.usName = dic[@"name"];
            user.usPhone = dic[@"phone"];
            user.usAddress = dic[@"address"];
            user.usSkype = dic[@"skype"];
            user.usImage = dic[@"image"];
            user.usType = @"1";
            user.usSex = dic[@"sex"];
            user.usIsverified = dic[@"isVerified"];
            user.usWebsite = dic[@"website"];
            user.usIndividual = dic[@"individual"];
            user.usFbId = dic[@"facebookId"];
            gUser = user;
            login_already = @"2";
            [Util saveObjectWithEncode:gUser forkey:KEY_SAVE_gUSER];
            if (success) {
                success(user);
            }
            
        }else{
            login_already = @"0";
            [Util setObject:@"0" forKey:KEY_LOGIN];
            if (failure) {
                failure(dicSuccess[@"message"]);
            }
        }
    } failure:^(NSString *error) {
        if (failure) {
            failure(@"No internet connection");
        }
        
    }];
}

+(void)getAdsByUserId:(NSString *)userId typeUser:(NSString *)typeUser andPage:(NSString *)page sortType:(NSString*)sortType sortBy:(NSString*)sortBy withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_GET_ADS_BY_ID];
    NSDictionary *param = @{@"sortType":sortType,
                            @"sortBy":sortBy,
                            @"id":userId,
                            @"page":page,
                            @"type":typeUser
                            };
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSArray *arrAdsObj = dicSuccess[DATA_KEY];
            NSMutableArray *arrAdsReturn = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arrAdsObj) {
                Ads *adsObject = [[Ads alloc] initWithDict:dic];
                [arrAdsReturn addObject:adsObject];
            }
            NSDictionary *dicReturn = @{@"arrAds":arrAdsReturn.copy,
                                        @"allpage":dicSuccess[@"allpage"]};
            if (success) {
                success(dicReturn);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        NSLog(@"Error when get url: %@ with param %@",url,param);
        if (failure) {
            failure(error);
        }
    }];
    
}

+(void)getBookmarksAdsByUserId:(NSString *)userId andPage:(NSString *)page sortType:(NSString *)sortType sortBy:(NSString *)sortBy withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_GET_BOOKMARKS_ADS];
    NSDictionary *param = @{@"userId":userId,
                            @"sortType":sortType,
                            @"sortBy":sortBy,
                            @"page":page};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSArray *arrAdsObj = dicSuccess[DATA_KEY];
            NSMutableArray *arrAdsReturn = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arrAdsObj) {
                Ads *adsObject = [[Ads alloc] initWithDict:dic];
                if ([gArrBookMark containsObject:adsObject.adsId]) {
                    
                }else{
                    [gArrBookMark addObject:adsObject.adsId];
                }
                [arrAdsReturn addObject:adsObject];
            }
            NSDictionary *dicReturn = @{@"arrAds":arrAdsReturn.copy,
                                        @"allpage":dicSuccess[@"allpage"]};
            if (success) {
                success(dicReturn);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        
        if (failure) {
            failure(@"network error");
        }
        
    }];
    
    
}
+(void)getAdsInPageWithNearBy:(NSString*)page lat:(NSString*)lat lon:(NSString*)lon withSuccess:(void (^)(NSArray* arrReturn, int allPage))success failure:(void (^)(NSString *error)) failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_GET_LIST_NEAR_BY];
    NSString *userId = @"";
    if (gUser != nil) {
        userId = gUser.usId;
    }
    NSDictionary *param = @{@"longitude":lon,
                            @"latitude":lat,
                            @"page":page,
                            @"userId" : userId};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSArray *arrAdsObj = dicSuccess[DATA_KEY];
            NSMutableArray *arrAdsReturn = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arrAdsObj) {
                Ads *adsObject = [[Ads alloc] initWithDict:dic];
                [arrAdsReturn addObject:adsObject];
            }
            if (success) {
                success(arrAdsReturn.copy,[Validator getSafeInt:dicSuccess[@"allpage"]]);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        
        if (failure) {
            failure(@"network error");
        }
        
    }];
}
+(void)getAdsInPage:(NSString *)page sortType:(NSString *)sortType  sortBy:(NSString*)sortBy screenType:(NSString *)screenType withSuccess:(void (^)(NSArray* arrReturn, int allPage))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_GET_LIST_ADS];
    NSString *userId = @"";
    if (gUser != nil) {
        userId = gUser.usId;
    }
    NSDictionary *param = @{@"sortType":sortType,
                            @"sortBy":sortBy,
                            @"page":page,
                            @"userId" : userId,
                            @"screenType":screenType};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSArray *arrAdsObj = dicSuccess[DATA_KEY];
            NSMutableArray *arrAdsReturn = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arrAdsObj) {
                Ads *adsObject = [[Ads alloc] initWithDict:dic];
                [arrAdsReturn addObject:adsObject];
            }
            int allPage = [Validator getSafeInt:dicSuccess[@"allpage"]];
            if (success) {
                success(arrAdsReturn.copy,allPage);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        
        if (failure) {
            failure(@"network error");
        }
        
    }];
}


+(void)getAdsDetailbyId:(NSString *)adsId withSuccess:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_GET_ADS_DETAIL];
    NSString *userId = @"";
    if (gUser != nil) {
        userId = gUser.usId;
    }
    NSDictionary *param = @{@"userId" : userId,
                            @"id":adsId};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSArray *dic = dicSuccess[DATA_KEY];
            Ads *adsObject = [[Ads alloc] initWithDict:dic.firstObject];
            if (success) {
                success(adsObject);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        NSLog(@"Error when get url: %@ with param %@",url,param);
        if (failure) {
            failure(error);
        }
        
    }];
}

+(void)getlistCityWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_GET_LIST_CITY];
    NSDictionary *param = [[NSDictionary alloc] init];
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        NSArray *arrCities = dicSuccess[DATA_KEY];
        NSMutableArray *arrCityReturn = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in arrCities) {
            CityObj *cityObj = [[CityObj alloc]init];
            cityObj.cityId = dic[@"id"];
            cityObj.cityName = dic[@"name"];
            cityObj.cityStatus = dic[@"status"];
            cityObj.cityDateCreated = dic[@"dateCreated"];
            [arrCityReturn addObject:cityObj];
        }
        if (success) {
            success(arrCityReturn.copy);
        }
    } failure:^(NSString *error) {
        if (failure) {
            failure(error);
        }
        
    }];
}

+(void)getListNewsInpage:(NSString *)page sortType:(NSString*)sortType sortBy:(NSString*)sortBy searchKey:(NSString*)key withSuccess:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_GET_NEWS];
    NSDictionary *param = @{@"keyword":key,
                            @"sortBy":sortBy,
                            @"sortType":sortType,
                            @"page":page};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSArray *dicArrNewsObj = dicSuccess[DATA_KEY];
            NSMutableArray *arrNewsReturn = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in dicArrNewsObj) {
                News *newsObj = [[News alloc]init];
                newsObj.newsId = dic[@"id"];
                newsObj.newsTitle = dic[@"title"];
                newsObj.newsImage = dic[@"image"];
                newsObj.newsDescription = dic[@"description"];
                newsObj.newsUrl = dic[@"url"];
                newsObj.newsDateCreated = dic[@"dateCreated"];
                
                [arrNewsReturn addObject:newsObj];
            }
            NSDictionary *dicReturn = @{@"arrNews":arrNewsReturn.copy,
                                        @"allpage":dicSuccess[@"allpage"]};
            if (success) {
                success(dicReturn);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
+(void)getListSellerFollowedWithPage:(NSString *)page sortType:(NSString *)sortType sortBy:(NSString *)sortBy searchKey:(NSString *)searchKey withSuccess:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_GET_LIST_FOLLOWED];
    NSDictionary *param = @{@"userId":[Validator getSafeString:gUser.usId],
                            @"sortType":sortType,
                            @"sortBy":sortBy,
                            @"keyword":searchKey,
                            @"page":page};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSArray *arrAccObj = dicSuccess[DATA_KEY];
            NSMutableArray *arrNewsReturn = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arrAccObj) {
                User *accObj = [[User alloc]initWithDic:dic];
                if (![accObj.usId isEqualToString:[Validator getSafeString:gUser.usId]]) {
                    [arrNewsReturn addObject:accObj];
                }
            }
            NSDictionary *dicReturn = @{@"arrAcc":arrNewsReturn.copy,
                                        @"allpage":dicSuccess[@"allpage"]};
            if (success) {
                success(dicReturn);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+(void)getListSellerWithPage:(NSString *)page sortType:(NSString *)sortType sortBy:(NSString*)sortBy searchKey:(NSString*)searchKey withSuccess:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_GET_LIST_ACCOUNT];
    NSDictionary *param = @{@"userId":[Validator getSafeString:gUser.usId],
                            @"sortType":sortType,
                            @"sortBy":sortBy,
                            @"keyword":searchKey,
                            @"page":page};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSArray *arrAccObj = dicSuccess[DATA_KEY];
            NSMutableArray *arrNewsReturn = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arrAccObj) {
                User *accObj = [[User alloc]initWithDic:dic];
                if (![accObj.usId isEqualToString:[Validator getSafeString:gUser.usId]]) {
                   [arrNewsReturn addObject:accObj];
                }
            }
            NSDictionary *dicReturn = @{@"arrAcc":arrNewsReturn.copy,
                                        @"allpage":dicSuccess[@"allpage"]};
            if (success) {
                success(dicReturn);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)changePasswordWithUserId:(NSString *)userId currentPass:(NSString *)currentPass newPass:(NSString *)newPass withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CHANGE_PASS];
    NSDictionary *param = @{
                            @"userId":userId,
                            @"current_pass":currentPass,
                            @"new_pass":newPass};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            if (success) {
                success(dicSuccess[@"message"]);
            }
        }else{
            if (failure) {
                failure(dicSuccess[@"message"]);
            }
        }
    } failure:^(NSString *error) {
        if (failure) {
            failure(@"Network error");
        }
    }];
}

+(void)forgotPasswordWithEmail:(NSString *)email withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_FORGET_PASS];
    NSDictionary *param = @{@"email":email};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            if (success) {
                success(dicSuccess[@"message"]);
            }
        }else{
            if (failure) {
                failure(dicSuccess[@"message"]);
            }
        }
    } failure:^(NSString *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)getSellerDetailWithId:(NSString *)sellerId withSuccess:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_GET_SELLER_INFO];
    NSDictionary *param = @{@"id":sellerId};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSDictionary *dicObj = dicSuccess[@"data"];
            User *userDetail = [[User alloc]init];
            
            userDetail.usId = dicObj[@"id"];
            userDetail.usName = dicObj[@"name"];
            userDetail.usImage = dicObj[@"image"];
            userDetail.usAddress = dicObj[@"address"];
            userDetail.usPhone = dicObj[@"phone"];
            userDetail.usEmail = dicObj[@"email"];
            userDetail.usSkype = dicObj[@"skype"];
            userDetail.usWebsite = dicObj[@"website"];
            userDetail.usIndividual = dicObj[@"individual"];
            userDetail.usType = dicObj[@"type"];
            userDetail.usIsverified = dicObj[@"isVerified"];
            userDetail.usDateCreated = dicObj[@"dateCreated"];
            userDetail.usAdsNumber = dicObj[@"numberAds"];
            if (success) {
                success(userDetail);
            }
        }else{
            if (failure) {
                failure(dicSuccess[@"message"]);
            }
        }
    } failure:^(NSString *error) {
        if (failure) {
            failure(@"No network");
        }
    }];
}

+(void)getListCategoryWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_GET_LIST_CATEGORY];
    NSDictionary *param = @{};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSArray *arrCategories = [[NSArray alloc]init];
            arrCategories = dicSuccess[@"data"];
            NSMutableArray *arrReturn = [[NSMutableArray alloc]init];
            for (NSDictionary *dicObj in arrCategories) {
                CategoryPr *catObj = [[CategoryPr alloc]init];
                catObj.categoryId = dicObj[@"id"];
                catObj.categoryImg = dicObj[@"image"];
                catObj.categoryName = dicObj[@"name"];
                catObj.categoryParentId = dicObj[@"parent"];
                [arrReturn addObject:catObj];
            }
            if (success) {
                success(arrReturn.copy);
            }
        }else{
            if (failure) {
                failure(dicSuccess[@"message"]);
            }
        }
    } failure:^(NSString *error) {
        if (failure) {
            failure(@"network error");
        }
    }];
    
    
}


+(void)searchAdsWithParam:(NSDictionary *)param withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_SEARCH_ADS];
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSArray *arrAdsObj = dicSuccess[DATA_KEY];
            NSMutableArray *arrAdsReturn = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arrAdsObj) {
                Ads *adsObject = [[Ads alloc] initWithDict:dic];
                [arrAdsReturn addObject:adsObject];
            }
            NSDictionary *dicReturn = @{@"arrAds":arrAdsReturn.copy,
                                        @"allpage":dicSuccess[@"allpage"]};
            if (success) {
                success(dicReturn);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        
        if (failure) {
            failure(@"network error");
        }
        
    }];
    
    
    
}

+(void)sendMessageWithAdsId:(NSString *)adsId accountId:(NSString *)accountId name:(NSString *)name phone:(NSString *)phone email:(NSString *)email title:(NSString *)title content:(NSString *)content withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_SEND_MESSAGE];
    NSDictionary *param = @{@"adsId":adsId,
                            @"accountId":accountId,
                            @"name":name,
                            @"phone":phone,
                            @"email":email,
                            @"title":title,
                            @"content":content
                            };
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            
            if (success) {
                success(dicSuccess[@"message"]);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        
        if (failure) {
            failure(@"network error");
        }
        
    }];
    
    
}

+(void)sendMessage:(NSString *)accountID title:(NSString *)title name:(NSString *)name phone:(NSString *)phone email:(NSString *)email content:(NSString *)content withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_SEND_MESSAGE];
        NSDictionary *param = @{@"accountId":accountID,
                                @"name":name,
                                @"phone":phone,
                                @"email":email,
                                @"title":title,
                                @"content":content
                                };
        [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
            if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
                
                if (success) {
                    success(dicSuccess[@"message"]);
                }
            }else{
                NSString *errStr = dicSuccess[@"message"];
                if (failure) {
                    failure(errStr);
                }
            }
        } failure:^(NSString *error) {
            
            if (failure) {
                failure(@"network error");
            }
            
        }];
}

+(void)addAdsWithTitle:(NSString *)title description:(NSString *)description price:(NSString *)price price_value:(NSString *)price_value price_unit:(NSString *)price_unit forRent:(NSString *)forRent forSale:(NSString *)forSale accountId:(NSString *)accountId categoryId:(NSString *)categoryId subCate:(NSString *)subCate city:(NSString *)city dataImgAvatar:(NSData *)imageData dataGallery:(NSArray *)dataGallery isAvailable:(NSString*)isAvailable lat:(NSString *)lat lng:(NSString *)lng  withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSDictionary *data = @{@"accountId":accountId,
                           @"categoryId":categoryId,
                           @"subCate":subCate,
                           @"title":title,
                           @"description":description,
                           @"price":price,
                           @"price_value":price_value,
                           @"price_unit":price_unit,
                           @"forRent":forRent,
                           @"forSale":forSale,
                           @"city":city,
                           @"isAvailable":isAvailable,
                           @"latitude":lat,
                           @"longitude":lng
                           };
    NSString* jsonObj = [Util convertObjectToJSON:data];
   NSDictionary *param = @{@"data":jsonObj};
//   NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
//   [param setObject:jsonObj forKey:@"data"];
   NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_ADD_ADS];
    NSMutableArray *arrDataGallery = [[NSMutableArray alloc]init];
    dispatch_group_t dgroup = dispatch_group_create(); //0
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    for (NSURL *imageURL in dataGallery) {
        
        dispatch_group_enter(dgroup); // 1
        [library assetForURL:imageURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                NSLog(@"HAS ASSET: %@", asset);
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                [arrDataGallery addObject:image];
                
                dispatch_group_leave(dgroup); //2
                
            } else {
                NSLog(@"Something went wrong");
                dispatch_group_leave(dgroup);
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"Something went wrong, %@", error);
            dispatch_group_leave(dgroup);
        }];
        
    }
    
    dispatch_group_notify(dgroup, dispatch_get_main_queue(), ^{ //3
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"image" fileName:@"myImage.jpg" mimeType:@"image/jpeg"];
            int i=0;
            for (UIImage *img in arrDataGallery) {
                if ([img isKindOfClass:[UIImage class]]) {
                    NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
                    NSString *fileName2 = [NSString stringWithFormat:@"image%d.jpg",i];
                    [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"gallery[%d]",i] fileName:fileName2 mimeType:@"image/jpeg"];
                    i++;
                }
            }
        } progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
            if ([responseObject[STATUS_KEY] isEqualToString:SUCCSESS]) {
                if (success) {
                    success(responseObject[@"message"]);
                }
            }else{
                if (failure) {
                    failure(responseObject[@"message"]);
                }
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            if (failure) {
                failure(@"Network error");
            }
        }];
        
    });

}

+(void)editAdsWithTitle:(NSString *)title
             oldGallery:(NSString *)oldGallery
            description:(NSString *)description
                  price:(NSString *)price
            price_value:(NSString *)price_value
             price_unit:(NSString *)price_unit
                forRent:(NSString *)forRent
                forSale:(NSString *)forSale
              accountId:(NSString *)accountId
             categoryId:(NSString *)categoryId
                subCate:(NSString *)subCate
                   city:(NSString *)city
          dataImgAvatar:(NSData *)imageData
            dataGallery:(NSArray *)dataGallery
            isAvailable:(NSString*)isAvailable
                  adsId:(NSString*)adsId
                    lat:(NSString*)lat
                    lng:(NSString*)lng
            withSuccess:(void (^)(NSString *))success
                failure:(void (^)(NSString *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_UPDATE_ADS];
    NSDictionary *data = @{@"accountId":accountId,
                           @"categoryId":categoryId,
                           @"subCate":subCate,
                           @"title":title,
                           @"description":description,
                           @"price":price,
                           @"price_value":price_value,
                           @"price_unit":price_unit,
                           @"forRent":forRent,
                           @"forSale":forSale,
                           @"city":city,
                           @"isAvailable":isAvailable,
                           @"id":adsId,
                           @"latitude":lat,
                           @"longitude":lng
                           };
    NSString* jsonObj = [Util convertObjectToJSON:data];
    NSDictionary *param =@{@"data":jsonObj,
                           @"oldGallery":oldGallery};
    NSMutableArray *arrDataGallery = [[NSMutableArray alloc]init];
    dispatch_group_t dgroup = dispatch_group_create(); //0
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    for (NSString *imageURL in dataGallery) {
        dispatch_group_enter(dgroup); // 1
        [library assetForURL:[NSURL URLWithString:imageURL] resultBlock:^(ALAsset *asset) {
            if (asset) {
                NSLog(@"HAS ASSET: %@", asset);
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                [arrDataGallery addObject:image];
                dispatch_group_leave(dgroup); //2
            } else {
                NSLog(@"Something went wrong");
                dispatch_group_leave(dgroup);
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"Something went wrong, %@", error);
            dispatch_group_leave(dgroup);
        }];
        
    }
    
    dispatch_group_notify(dgroup, dispatch_get_main_queue(), ^{ //3
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"image" fileName:@"myImage.jpg" mimeType:@"image/jpeg"];
            int i=0;
            for (UIImage *img in arrDataGallery) {
                if ([img isKindOfClass:[UIImage class]]) {
                    NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
                    NSString *fileName2 = [NSString stringWithFormat:@"image%d.jpg",i];
                    [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"gallery[%d]",i] fileName:fileName2 mimeType:@"image/jpeg"];
                    i++;
                }
            }
        } progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
            if ([responseObject[STATUS_KEY] isEqualToString:SUCCSESS]) {
                if (success) {
                    success(responseObject[@"message"]);
                }
            }else{
                if (failure) {
                    failure(responseObject[@"message"]);
                }
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            if (failure) {
                failure(@"Network error");
            }
        }];
        
    });


}

+(void)getListMessageWithPage:(NSString *)page withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_GET_MESSAGE];
    NSDictionary *param = @{@"accountId":gUser.usId,
                            @"page":page};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSArray *arrAdsObj = dicSuccess[DATA_KEY];
            NSMutableArray *arrMessReturn = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arrAdsObj) {
                Messages *est = [[Messages alloc]init];
                est.content = [Validator getSafeString:dic[@"content"]];
                est.dateCreated = [Validator getSafeString:dic[@"dateCreated"]];
                est.email = [Validator getSafeString:dic[@"email"]];
                est.adsId = [Validator getSafeString:dic[@"adsId"]];
                est.MessageId = [Validator getSafeString:dic[@"id"]];
                est.name = [Validator getSafeString:dic[@"name"]];
                est.phone = [Validator getSafeString:dic[@"phone"]];
                est.status = [Validator getSafeString:dic[@"status"]];
                est.title = [Validator getSafeString:dic[@"title"]];
                est.hostagentId = [Validator getSafeString:dic[@"accountId"]];
                est.image = [Validator getSafeString:dic[@"image"]];
                [arrMessReturn addObject:est];
            }
            NSDictionary *dicReturn = @{@"arrMess":arrMessReturn.copy,
                                        @"allpage":dicSuccess[@"allpage"]};
            if (success) {
                success(dicReturn);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        
        if (failure) {
            failure(@"network error");
        }
        
    }];

}

+(void)contactUsActionWithName:(NSString *)name email:(NSString *)email type:(NSString *)type subject:(NSString *)subject content:(NSString *)content withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CONTACT_US];
    NSDictionary *param = @{@"name":name,
                            @"email":email,
                            @"type":type,
                            @"subject":subject,
                            @"content":content
                            };
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {

            if (success) {
                success(dicSuccess[@"message"]);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        
        if (failure) {
            failure(@"network error");
        }
        
    }];


}

+(void)addSubCriptionWithStartDate:(NSString *)startDate endate:(NSString *)endate duration:(NSString *)duration value:(NSString *)value adsId:(NSString *)adsId payment:(NSString *)payment subId:(NSString *)subId withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_ADD_SUBCRIPTION];
    NSDictionary *param = @{@"paidDate":startDate,
                            @"endDate":endate,
                            @"duration":duration,
                            @"value":value,
                            @"adsId":adsId,
                            @"payment":payment,
                            @"subId":subId
                            };
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            if (success) {
                success(dicSuccess[@"message"]);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        
        if (failure) {
            failure(@"network error");
        }
        
    }];
    
}

+(void)addSubCriptionWithParam:(NSDictionary *)param withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
 NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_ADD_SUBCRIPTION];
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            if (success) {
                success(dicSuccess[@"message"]);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        
        if (failure) {
            failure(@"network error");
        }
        
    }];

}

+(void)mySubcriptionWithPage:(NSString *)page withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_SHOW_SUBCRIPTON];
    NSDictionary *param = @{@"accountId":gUser.usId,
                            @"page":page
                            };
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            
            if (success) {
                success(dicSuccess);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        
        if (failure) {
            failure(@"network error");
        }
        
    }];
}

+(void)bookmarkClickWithUserId:(NSString *)userId adsId:(NSString *)adsId type:(NSString *)type withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CLICK_BOOKMARK];
    NSDictionary *param = @{@"userId":gUser.usId,
                            @"adsId":adsId,
                            @"type":type
                            };
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            
            if (success) {
                success(dicSuccess[@"message"]);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        
        if (failure) {
            failure(@"network error");
        }
        
    }];


}

+(void)deleteAdsWitjAdsId:(NSString *)adsId withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_DELETE_ADS];
    NSDictionary *param = @{
                            @"id":adsId
                            };
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            if (success) {
                success(dicSuccess[@"message"]);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
     } failure:^(NSString *error) {
         
         if (failure) {
             failure(@"network error");
         }
         
     }];
}


+(void)getlistSubscriptionWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_SUBCRIPTION_TYPE];
    NSDictionary *param = [[NSDictionary alloc] init];
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        NSArray *arrSub = dicSuccess[DATA_KEY];
        NSMutableArray *arrCityReturn = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in arrSub) {
            NSLog(@"%@", dic);
            SubCriberItem *i = [[SubCriberItem alloc]init];
            
            i.itemCurrencySymbol = dic[@"currencySymbol"];
            i.itemDuration = dic[@"duration"];
            i.itemID = [dic[@"id"] intValue];
            i.itemPrice = [dic[@"price"] intValue];
            i.itemStatus = [dic[@"status"] intValue];
            i.itemIsFeatured = [dic[@"isFeatured"] intValue];
            [arrCityReturn addObject:i];
        }
        
        if (success) {
            success(arrCityReturn.copy);
        }
    } failure:^(NSString *error) {
        if (failure) {
            failure(error);
        }
        
    }];
}

+(void)increaseViewAdsCount:(NSString *)adsId withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, API_INCREASE_ADS_VIEW];
    NSDictionary *param = @{@"id" : adsId};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        
    } failure:^(NSString *error) {
        
    }];
}


+ (void)changeLikeAdsId:(NSString *)adsId status:(NSString *)status withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_LIKE];
    NSDictionary *param = @{@"userId":gUser.usId,
                            @"adsId":adsId,
                            @"type":status
                            };
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            
            if (success) {
                success([Validator getSafeString:dicSuccess[@"message"]]);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        
        if (failure) {
            failure(@"Have some error while connecting to server, try again later!");
        }
        
    }];


}

+ (void)getListCommentOfAds:(NSString *)adsId page:(int)page withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure {
    
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_GET_LIST_COMMENT];
    NSDictionary *param = @{@"adsId":adsId,
                            @"page": [NSString stringWithFormat:@"%d",page]};
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            NSArray *arrAdsObj = dicSuccess[DATA_KEY];
            NSMutableArray *arrMessReturn = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arrAdsObj) {
                Comment *commentObj = [[Comment alloc] initWithDict:dic];
                
                [arrMessReturn addObject:commentObj];
            }
            NSDictionary *dicReturn = @{@"arrObj":arrMessReturn.copy,
                                        @"allpage":dicSuccess[@"allpage"]};
            if (success) {
                success(dicReturn);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        
        if (failure) {
            failure(@"network error");
        }
    }];
}

+ (void)pushCommentWithAdsId:(NSString *)adsId content:(NSString *)content withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_ADD_COMMENT];
    NSDictionary *param = @{@"userId":gUser.usId,
                            @"adsId":adsId,
                            @"content":content
                            };
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            
            if (success) {
                success([Validator getSafeString:dicSuccess[@"message"]]);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        
        if (failure) {
            failure(@"Have some error while connecting to server, try again later!");
        }
        
    }];

}
+ (void)pushMessageWithReceiveId:(NSString *)receiveId content:(NSString *)content withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString* url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_SEND_PUSH_MSG];
    NSDictionary *param = @{@"sender_id":[Validator getSafeString:gUser.usId],
                            @"receive_id":receiveId,
                            @"message":content
                            };
    [self sendGetRequestUrl:url parameters:param withSuccess:^(id dicSuccess) {
        
        if ([dicSuccess[STATUS_KEY] isEqualToString:SUCCSESS]) {
            
            if (success) {
                success([Validator getSafeString:dicSuccess[@"message"]]);
            }
        }else{
            NSString *errStr = dicSuccess[@"message"];
            if (failure) {
                failure(errStr);
            }
        }
    } failure:^(NSString *error) {
        
        if (failure) {
            failure(@"Have some error while connecting to server, try again later!");
        }
        
    }];
    
}
+(void)uploadWithFile:(NSData *)imageData uid:(NSString *)uid withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,API_UPLOAD_FILE];
    NSDictionary *param = @{@"userId":gUser.usId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //  [formData appendPartWithFileURL:filePath name:@"image" error:nil];
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"myImage.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([responseObject[STATUS_KEY] isEqualToString:SUCCSESS]) {
            if (success) {
                success(responseObject[@"data"]);
            }
        }else{
            if (failure) {
                failure(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure(@"Network error");
        }
    }];
    
}
/////-------------------END----------------------//


@end
