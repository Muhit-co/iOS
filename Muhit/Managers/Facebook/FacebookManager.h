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

#define ERROR_FB_LOGIN_CANCELLED 101
#define FACEBOOK [FacebookManager sharedManager]
#define FB_EMAIL @"email"
#define FB_FULLNAME @"name"
#define FB_ID @"id"
#define FB_GENDER @"gender"
#define FB_BIRTHDAY @"birthday"

@protocol FacebookDelegate <NSObject>

@optional

- (void) fetchedFacebookUserInfo:(NSDictionary *)userInfo error:(NSError *)error;

@end

@interface FacebookManager : NSObject

+ (FacebookManager *) sharedManager;

- (void) logout;
- (void) loginWithDelegate:(id <FacebookDelegate>)delegate fromViewController:(UIViewController *)fromViewController;
- (NSString *) accessToken;

@end