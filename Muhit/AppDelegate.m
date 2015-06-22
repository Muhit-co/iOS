//
//  AppDelegate.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "AppDelegate.h"
#import "Crittercism.h"
#import "MainVC.h"
#import "NavBar.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [[self window] setBackgroundColor:[UIColor whiteColor]];
    [[self window] makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UITextField appearance] setTintColor:CLR_DARK_BLUE];
    
//    [MT setServiceURL:@"http://api1.muhit.co"];//Production
    [MT setServiceURL:@"http://api51.muhit.co"];//Sandbox
    
    if ([UD objectForKey:UD_ACCESS_TOKEN]) {
        [UF isAccessTokenValid];
        [MT setIsLoggedIn:YES];
    }
    
    [self initNavigationBar];
    
    [Crittercism enableWithAppID:@"556cb8a5d4c2452f5c33bd15"];
    [GMSServices provideAPIKey:@"AIzaSyDhFJMt6qYhCayG6MdiVZ5OqxG1CUjjNfY"];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

-(void)initNavigationBar{
    MainVC *main = [[MainVC alloc] init];
    
    [MT setNavCon:[[UINavigationController alloc] initWithNavigationBarClass:[NavBar class]
                                                                toolbarClass:nil]];
    
    [[MT navCon] pushViewController:main animated:NO];
    [[MT navCon] setNavigationBarHidden:NO];
    
    [MT setDrawerController:[[MMDrawerController alloc] initWithCenterViewController: [MT navCon]
                                                            leftDrawerViewController: [[MenuVC alloc] init]]];
    
    [[MT drawerController] setMaximumLeftDrawerWidth:240.0];
    [[MT drawerController] setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    [[MT drawerController] setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [[MT drawerController] setShowsShadow:YES];
    [[MT drawerController] setShouldStretchDrawer:NO];

    [[self window] setRootViewController:[MT drawerController]];
}

@end
