//
//  FacebookManager.m
//  BiTaksi Client
//
//  Created by Emre YANIK on 23/01/15.
//  Copyright (c) 2015 BiTaksi. All rights reserved.
//

#import "FacebookManager.h"

#define FACEBOOK_ERROR_DUPLICATE_MESSAGE @"code = 506"

@interface FacebookManager () <FBLoginViewDelegate>

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

NSString *NSStringFromFBSessionState(FBSessionState state)
{
    switch (state) {
        case FBSessionStateClosed:
            return @"FBSessionStateClosed";
        case FBSessionStateClosedLoginFailed:
            return @"FBSessionStateClosedLoginFailed";
        case FBSessionStateCreated:
            return @"FBSessionStateCreated";
        case FBSessionStateCreatedOpening:
            return @"FBSessionStateCreatedOpening";
        case FBSessionStateCreatedTokenLoaded:
            return @"FBSessionStateCreatedTokenLoaded";
        case FBSessionStateOpen:
            return @"FBSessionStateOpen";
        case FBSessionStateOpenTokenExtended:
            return @"FBSessionStateOpenTokenExtended";
            
    }
    return @"Not Found";
}

- (void) informDelegateForSessionOpened:(id <FacebookDelegate>) delegate
{
    if([delegate respondsToSelector:@selector(openedFacebookSessionWithToken:)]) {
        [delegate openedFacebookSessionWithToken:FBSession.activeSession.accessTokenData.accessToken];
    }
}

- (void) closeSessionWithToken:(BOOL)withToken {
    if(withToken) {
        [FBSession.activeSession closeAndClearTokenInformation];
    } else {
        [FBSession.activeSession close];
    }
}

- (void) openSessionWithCompletionBlock:(void (^)(NSError *error))block {
    if (!FBSession.activeSession.isOpen) {
        DLog(@"1");
        if (FBSession.activeSession.state != FBSessionStateCreated) {
            FBSession.activeSession = [[FBSession alloc] initWithPermissions:@[@"public_profile", @"email"]];
        }

        [FBSession.activeSession openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if(status == FBSessionStateOpen) {
                block(nil);
            }
            if (error) {
                block(error);
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

- (void) publishMessage:(NSString *)message withDelegate:(id <FacebookDelegate>)delegate {
    
    if (FBSession.activeSession.isOpen) {
        [FBRequestConnection startForPostStatusUpdate:message
                                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                        if([delegate respondsToSelector:@selector(postedOnFacebook:successfully:)]) {
                                            [delegate postedOnFacebook:message successfully:!error || [error.description rangeOfString:FACEBOOK_ERROR_DUPLICATE_MESSAGE].length > 0];
                                        }
                                    }];
    } else {
        [self openSessionWithCompletionBlock:^(NSError *error){
            [self publishMessage:message withDelegate:delegate];
        }];
    }
}

- (void) requestUserInfoWithDelegate:(id <FacebookDelegate>) delegate {
    if (FBSession.activeSession.isOpen) {
        [self informDelegateForSessionOpened:delegate];
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if([delegate respondsToSelector:@selector(fetchedFacebookUserInfo:error:)]) {
                [delegate fetchedFacebookUserInfo:result error:error];
            }
        }];
    } else {
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
    if (FBSession.activeSession.isOpen) {
        return FBSession.activeSession.accessTokenData.accessToken;
    }
    else{
        return nil;
    }
}

@end