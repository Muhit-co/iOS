//
//  FacebookManager.m
//  BiTaksi Client
//
//  Created by Emre YANIK on 23/01/15.
//  Copyright (c) 2015 BiTaksi. All rights reserved.
//

#import "FacebookManager.h"

@interface FacebookManager ()

@end

@implementation FacebookManager

#pragma mark Singleton Methods

+ (FacebookManager *) sharedManager {
    static FacebookManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark -

- (void) informDelegateForSessionOpened:(id <FacebookDelegate>) delegate{
    if([delegate respondsToSelector:@selector(openedFacebookSessionWithToken:)]) {
        [delegate openedFacebookSessionWithToken:[[FBSDKAccessToken currentAccessToken] tokenString]];
    }
}

- (void) closeSession{
    [FBSDKAccessToken setCurrentAccessToken:nil];
}

- (void) openSessionWithCompletionBlock:(void (^)(NSError *error))block {
    if (![FBSDKAccessToken currentAccessToken]) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                block(error);
            } else if (result.isCancelled) {
                block(error);
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if ([result.grantedPermissions containsObject:@"email"]) {
                    block(nil);
                }
            }
        }];
    }
    else {
        block(nil);
    }
}

- (void) openSessionWithDelegate:(id<FacebookDelegate>)delegate
{
    [self openSessionWithCompletionBlock:^(NSError *error){
        [self informDelegateForSessionOpened:delegate];
    }];
}

- (void) requestUserInfoWithDelegate:(id<FacebookDelegate>) delegate {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [self informDelegateForSessionOpened:delegate];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if([delegate respondsToSelector:@selector(fetchedFacebookUserInfo:error:)]) {
                 [delegate fetchedFacebookUserInfo:result error:error];
             }
         }];
    }
    else {
        [self openSessionWithCompletionBlock:^(NSError *error){
            if (error) {
                if([delegate respondsToSelector:@selector(fetchedFacebookUserInfo:error:)]) {
                    [delegate fetchedFacebookUserInfo:nil error:error];
                }
            }
            else{
                [self requestUserInfoWithDelegate:delegate];
            }
        }];
    }
}

- (NSString *) accessToken{
    if ([FBSDKAccessToken currentAccessToken]) {
        return [[FBSDKAccessToken currentAccessToken] tokenString];
    }
    else{
        return nil;
    }
}

@end