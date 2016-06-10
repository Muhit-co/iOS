//
//  FacebookManager.m
//  BiTaksi Client
//
//  Created by Emre YANIK on 23/01/15.
//  Copyright (c) 2015 BiTaksi. All rights reserved.
//

#import "FacebookManager.h"

@interface FacebookManager (){
    FBSDKLoginManager *manager;
}

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
    if (self = [super init]) {}
    return self;
}

- (void) logout{
    //    if (!manager) {
    manager = [[FBSDKLoginManager alloc] init];
    //    }
    [manager logOut];
}

- (void) loginWithDelegate:(id <FacebookDelegate>) delegate fromViewController:(UIViewController *)fromViewController{
    
    
    if ([self accessToken]) {
        [self getUserInfo:delegate];
    }
    else{
        if (!manager) {
            manager = [[FBSDKLoginManager alloc] init];
        }
        
        [manager setLoginBehavior:FBSDKLoginBehaviorSystemAccount];
        
        [manager logInWithReadPermissions:@[@"email",@"user_birthday"] fromViewController:fromViewController handler: ^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            ADD_HUD_TOP
            if (error) {
                DLog(@"FB Error Code: %ld Desc: %@",(long)error.code,error.description);
                if([delegate respondsToSelector:@selector(fetchedFacebookUserInfo:error:)]) {
                    [delegate fetchedFacebookUserInfo:nil error:error];
                }
            }
            else if (result.isCancelled) {
                NSError *cancelError = [NSError errorWithDomain:@"bitaksi" code:ERROR_FB_LOGIN_CANCELLED userInfo:nil];
                
                if([delegate respondsToSelector:@selector(fetchedFacebookUserInfo:error:)]) {
                    [delegate fetchedFacebookUserInfo:nil error:cancelError];
                }
            }
            else {
                [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
                [self getUserInfo:delegate];
            }
        }];
    }
}

-(void) getUserInfo:(id <FacebookDelegate>) delegate{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me?fields=email,birthday,gender,name,id" parameters:nil]
     startWithCompletionHandler: ^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             DLog(@"FB Graph Result:%@",result);
             if([delegate respondsToSelector:@selector(fetchedFacebookUserInfo:error:)]) {
                 [delegate fetchedFacebookUserInfo:result error:error];
             }
         }
         else{
             DLog(@"FB Error Code: %ld Desc: %@",(long)error.code,error.description);
             if([delegate respondsToSelector:@selector(fetchedFacebookUserInfo:error:)]) {
                 [delegate fetchedFacebookUserInfo:nil error:error];
             }
         }
     }];
}

- (NSString *) accessToken{
    return [[FBSDKAccessToken currentAccessToken] tokenString];
}

@end