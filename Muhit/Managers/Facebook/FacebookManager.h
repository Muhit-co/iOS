//
//  FacebookManager.h
//  BiTaksi Client
//
//  Created by Emre YANIK on 23/01/15.
//  Copyright (c) 2015 BiTaksi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#define FACEBOOK [FacebookManager sharedManager]
#define FB_EMAIL @"email"
#define FB_FULLNAME @"name"
#define FB_ID @"id"
#define FB_GENDER @"gender"

@protocol FacebookDelegate <NSObject>

@optional

- (void) openedFacebookSessionWithToken:(NSString *)accessToken;
- (void) fetchedFacebookUserInfo:(id<FBGraphUser>)userInfo error:(NSError *)error;
- (void) postedOnFacebook:(NSString *)message successfully:(BOOL)success;

@end

@interface FacebookManager : NSObject

+ (FacebookManager *) sharedManager;

- (void) closeSessionWithToken:(BOOL)withToken;

- (void) openSessionWithDelegate:(id <FacebookDelegate>) delegate;
- (void) requestUserInfoWithDelegate:(id <FacebookDelegate>) delegate;
- (void) publishMessage:(NSString *)message withDelegate:(id<FacebookDelegate>)delegate;
- (NSString *) accessToken;

@end