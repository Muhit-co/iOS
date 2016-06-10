//
//  TrackManager.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "TrackManager.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

#define GOOGLE_ANALYTICS_APP_ID @"UA-41562493-4"


@interface TrackManager ()

@property (nonatomic, retain) id<GAITracker> GoogleTracker;

@end

@implementation TrackManager

@synthesize GoogleTracker;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static TrackManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        [self initGoogleAnalytics];
    }
    return self;
}

- (void)initGoogleAnalytics{
    [[GAI sharedInstance] setTrackUncaughtExceptions:NO];
    [[GAI sharedInstance] setDispatchInterval:30];
    [[GAI sharedInstance] trackerWithTrackingId:GOOGLE_ANALYTICS_APP_ID];
    GoogleTracker = [[GAI sharedInstance] defaultTracker];
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
}

- (void)setScreenName:(NSString*)screenName{
    [GoogleTracker set:kGAIScreenName value:screenName];
    [GoogleTracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)trackEventWithCategory:(NSString*)category desc:(NSString*)description label:(NSString*)label value:(NSNumber*)value{
    NSMutableDictionary *event = [[GAIDictionaryBuilder createEventWithCategory:category action:description label:label value:value] build];
    [GoogleTracker send:event];
}

- (void)trackEventWithCategory:(NSString*)category desc:(NSString*)description label:(NSString*)label{
    NSMutableDictionary *event = [[GAIDictionaryBuilder createEventWithCategory:category action:description label:label value:nil] build];
    [GoogleTracker send:event];
}

- (void)trackEventWithCategory:(NSString*)category desc:(NSString*)description{
    NSMutableDictionary *event = [[GAIDictionaryBuilder createEventWithCategory:category action:description label:nil value:nil] build];
    [GoogleTracker send:event];
}

@end