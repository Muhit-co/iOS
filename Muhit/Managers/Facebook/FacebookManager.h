//
//  FacebookManager.h
//  BiTaksi Client
//
//  Created by Emre YANIK on 23/01/15.
//  Copyright (c) 2015 BiTaksi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#define FACEBOOK [FacebookManager sharedManager]
#define FB_EMAIL @"email"
#define FB_FULLNAME @"name"
#define FB_ID @"id"
#define FB_GENDER @"gender"

@protocol FacebookDelegate <NSObject>

@optional

- (void) openedFacebookSessionWithToken:(NSString *)accessToken;
- (void) fetchedFacebookUserInfo:(NSDictionary*)userInfo error:(NSError *)error;

@end

@interface FacebookManager : NSObject

+ (FacebookManager *) sharedManager;

- (void) closeSession;

- (void) openSessionWithDelegate:(id <FacebookDelegate>) delegate;
- (void) requestUserInfoWithDelegate:(id <FacebookDelegate>) delegate;
- (NSString *) accessToken;

@end