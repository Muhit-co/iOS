//
//  Muhit.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "Muhit.h"
#import "UtilityFunctions.h"
#import "NavBar.h"
#import "MainVC.h"

@implementation Muhit

@synthesize tokenCode,isLoggedIn;

+ (id)instance{
    static Muhit *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

-(void)setIsLoggedIn:(BOOL)_isLoggedIn{
    isLoggedIn = _isLoggedIn;
    
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
