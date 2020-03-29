//
//  LocationShareModel.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import "LocationManager.h"
#import "ModelManager.h"
#import <UIKit/UIKit.h>

@interface LocationManager ()

@end

@implementation LocationManager{

}

//Class method to make sure the share model is synch across the app
+ (instancetype)sharedManager {
    static id sharedMyModel = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyModel =  [[self alloc] init];
        [sharedMyModel startMonitoringLocation];
       // [sharedMyModel setRef:[[FIRDatabase database] reference]];
    });
    return sharedMyModel;
}

#pragma mark - CLLocationManager

- (void)startMonitoringLocation {
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    if (locationAllowed==NO)
    {
        
        [Util showMessage:@"To re-enable, please go to Settings and turn on Location Service for this app." withTitle:@"Location Service Disabled"];
    }
    
    self.anotherLocationManager = [[CLLocationManager alloc]init];
    _anotherLocationManager.delegate = self;
    _anotherLocationManager.pausesLocationUpdatesAutomatically = YES;
    _anotherLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.anotherLocationManager.distanceFilter = kDistanceFilter;
    self.anotherLocationManager.headingFilter = kHeadingFilter;
    if(IS_OS_8_OR_LATER) {
        [_anotherLocationManager requestAlwaysAuthorization];
    }
    
    [_anotherLocationManager startUpdatingLocation];
}

- (void)restartMonitoringLocation {
    [_anotherLocationManager stopUpdatingLocation];
    [_anotherLocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    _anotherLocationManager.pausesLocationUpdatesAutomatically = YES;
    [_anotherLocationManager startUpdatingLocation];
    [_anotherLocationManager stopMonitoringSignificantLocationChanges];
}

//starts automatically with locationManager
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
        NSLog(@"App Received new location Location");
//    if (gUser.is_driver) {
//        [[[self.ref child:@"user"] child:gUser.client_id] updateChildValues:@{@"status" : [Validator getSafeString:gUser.is_online],
//                                                                              @"lat" : [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude],
//                                                                              @"lng" : [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude]}];
//    }
//

    
    [self.delegate didUpdateLocationFrom:_anotherLocationManager.location.coordinate toLocation:newLocation.coordinate];
    
    if (!_updateOn) {
        [_anotherLocationManager stopUpdatingLocation];
        return;
    }
    
}


@end
