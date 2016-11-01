//
//  User.m
//  Muhit
//
//  Created by Emre YANIK on 31/10/2016.
//  Copyright © 2016 Muhit. All rights reserved.
//

#import "User.h"
#import "NavBar.h"
#import "MainVC.h"

@implementation User

@synthesize name,surname,username,userId,profileImage,profileImageUrl,locationText,hood,token,isLoggedIn,email;

+ (id)instance{
    static User *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        if ([UD objectForKey:UD_USERNAME]) {
            [self setDetailsFromDefaults];
        }
    }
    return self;
}

- (void)setDetailsWithInfo:(NSDictionary *)info{
    [self setDetailsWithInfo:info refreshNav:YES];
}

- (void)setDetailsWithInfo:(NSDictionary *)info refreshNav:(BOOL)refreshNav{
    token = info[KEY_API_TOKEN];
    name = info[@"first_name"];
    surname = info[@"last_name"];
    userId = info[@"id"];
    email = info[@"email"];
    profileImageUrl = info[@"picture"];
    username = info[@"username"];
    
    isLoggedIn = YES;
    
    if(profileImageUrl.length>0){
        NSString *imgUrl = [NSString stringWithFormat:@"%@/240x240/users/%@",IMAGE_PROXY,profileImageUrl];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imgUrl]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                          if (image) {
                                                              profileImage = image;
                                                          }
                                                      }];
    }
    
    if (isNotNull(info[@"location"])) {
        locationText = info[@"location"];
        NSArray *locationParts = [[locationText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@","];
        if (locationParts && locationParts.count>0) {
            hood = locationParts[0];
        }
    }
    
    [self setDefaults];
    
    if (refreshNav) {
        [self setNavigation];
    }
}

- (void)setDefaults{
    [UD setObject:token forKey:UD_API_TOKEN];
    [UD setObject:name forKey:UD_FIRSTNAME];
    [UD setObject:surname forKey:UD_SURNAME];
    [UD setObject:userId forKey:UD_USER_ID];
    [UD setObject:profileImageUrl forKey:UD_USER_PICTURE];
    [UD setObject:username forKey:UD_USERNAME];
    [UD setObject:email forKey:UD_EMAIL];

    if (locationText) {
        [UD setObject:locationText forKey:UD_LOCATION];
    }
}

- (void)clearUser{
    [UD removeObjectForKey:UD_API_TOKEN];
    [UD removeObjectForKey:UD_FIRSTNAME];
    [UD removeObjectForKey:UD_SURNAME];
    [UD removeObjectForKey:UD_USER_ID];
    [UD removeObjectForKey:UD_USER_PICTURE];
    [UD removeObjectForKey:UD_USERNAME];
    [UD removeObjectForKey:UD_LOCATION];
    [UD removeObjectForKey:UD_EMAIL];
    
    token = nil;
    name = nil;
    surname = nil;
    userId = nil;
    username = nil;
    profileImageUrl = nil;
    profileImage = nil;
    locationText = nil;
    hood = nil;
    email = nil;
    isLoggedIn = NO;
    
    [self setNavigation];
}

- (void)setDetailsFromDefaults{
    token = [UD objectForKey:UD_API_TOKEN];
    name = [UD objectForKey:UD_FIRSTNAME];
    surname = [UD objectForKey:UD_SURNAME];
    userId = [UD objectForKey:UD_USER_ID];
    profileImageUrl = [UD objectForKey:UD_USER_PICTURE];
    username = [UD objectForKey:UD_USERNAME];
    email = [UD objectForKey:UD_EMAIL];
    isLoggedIn = YES;
    
    if ([UD objectForKey:UD_LOCATION]) {
        locationText = [UD objectForKey:UD_LOCATION];
        NSArray *locationParts = [[locationText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@","];
        if (locationParts && locationParts.count>0) {
            hood = locationParts[0];
        }
    }
    
    if(profileImageUrl.length>0){
        NSString *imgUrl = [NSString stringWithFormat:@"%@/240x240/users/%@",IMAGE_PROXY,profileImageUrl];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imgUrl]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                          if (image) {
                                                              profileImage = image;
                                                          }
                                                      }];
    }
    [self setNavigation];
}

-(void) startInstance{
}

-(void)setNavigation{
    UINavigationController *navCon = [[UINavigationController alloc] initWithNavigationBarClass:[NavBar class] toolbarClass:nil];
    [navCon pushViewController:[[MainVC alloc] init] animated:NO];
    [navCon setNavigationBarHidden:NO];
    [MT setNavCon:navCon];
    [[MT drawerController] setCenterViewController:navCon withCloseAnimation:YES completion:^(BOOL finished) {
        if (finished) {
            [[MT drawerController] setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        }
    }];
}

@end
