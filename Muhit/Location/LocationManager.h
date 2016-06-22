//
//  LocationManager.h
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import <MapKit/MapKit.h>

@class LocationManager;

@protocol LocationManagerDelegate <NSObject>

@optional
- (void)locationManager:(LocationManager *)locationManager didUpdateToLocation:(CLLocation *)newLocation;
@end

@interface LocationManager : NSObject

+ (LocationManager *)sharedManager;
- (CLLocation *)currentLocation;
- (void) startUpdatingLocation;
- (void) stopUpdatingLocation;
- (void) setDelegate:(id<LocationManagerDelegate>)delegate;
- (void) onLocationDataError;

@end
