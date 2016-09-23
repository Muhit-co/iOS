//
//  LocationManager.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "LocationManager.h"

#define ALERT_GPS_PERMISSION 4

static LocationManager *sharedManager;
//static const float kLocationValidityTime = -10;
//static const float kHorizontalAccuracyValidityDistance = 1500;

@interface LocationManager () <CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSError *locationError;
    BOOL monitoringLocation,locationCalibrated,locationCalibrationStarted,isDeleted;
    id<LocationManagerDelegate> delegate;
}

@end

@implementation LocationManager

+ (LocationManager *)sharedManager {
    @synchronized(self) {
        if(sharedManager == nil) {
            sharedManager = [[LocationManager alloc] init];
        }
    }
    return sharedManager;
}

- (id) init {
    self = [super init];
    if(self) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            [locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}

- (void) startUpdatingLocation {
    if(!monitoringLocation) {
        monitoringLocation = YES;
        locationCalibrated = NO;
        locationCalibrationStarted = NO;
        currentLocation = nil;
        [locationManager startUpdatingLocation];
    } else {
        [self onLocationObtained];
    }
}

- (void) stopUpdatingLocation {
    monitoringLocation = NO;
    [locationManager stopUpdatingLocation];
}

- (void) setDelegate:(id<LocationManagerDelegate>)_delegate {
    delegate = _delegate;
}

- (CLLocation *)currentLocation {
    if(locationCalibrated) {
        return currentLocation;
    } else {
        return nil;
    }
}

- (void) onLocationDataError {
    if (currentLocation == nil && [locationError code] == kCLErrorDenied) {
        SHOW_ALERT_WITH_TAG_DELEGATE_FIRST_SECOND(LocalizedString(@"location-services-must-enabled"), ALERT_GPS_PERMISSION, self, LocalizedString(@"ok"), LocalizedString(@"settings"))
    } else if(currentLocation == nil && locationError == nil) {
        SHOW_ALERT(LocalizedString(@"wait-location-calibration"));
    } else if(currentLocation == nil && locationError != nil) {
        SHOW_ALERT(LocalizedString(@"location-error"));
    }
    if([delegate respondsToSelector:@selector(locationManager:didUpdateToLocation:)]) {
        [delegate locationManager:self didUpdateToLocation:nil];
    }
}

#pragma mark Auxilary

- (void) processLocationUpdate {
    locationCalibrated = YES;
    if([delegate respondsToSelector:@selector(locationManager:didUpdateToLocation:)]) {
        [delegate locationManager:self didUpdateToLocation:currentLocation];
    }
}

#pragma mark - Location Manager Delegates

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [self updateUserLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self updateUserLocation:[locations lastObject]];
}

- (void)updateUserLocation:(CLLocation *)location{
    
    currentLocation = location;
    [self onLocationObtained];
}

- (void) onLocationObtained {
    if(locationCalibrated) {
        [self processLocationUpdate];
    } else if(!locationCalibrationStarted) {
        [self performSelector:@selector(processLocationUpdate) withObject:nil afterDelay:1.0f];
        locationCalibrationStarted = YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DLog(@"error on location update %@",[error description]);
    locationError = error;
    [self onLocationDataError];
}

#pragma mark UIAlertViewDelegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([alertView tag] == ALERT_GPS_PERMISSION){
        if (buttonIndex != 0){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}
@end
