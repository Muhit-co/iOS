//
//  AppDelegate.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "AppDelegate.h"
#import "MainVC.h"
#import "NavBar.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "FacebookManager.h"

#define ALERT_PUSH_NOTIFICATION 10

@interface AppDelegate (){
    NSDictionary *pushNotification;
    BOOL isRegisteredPush;
}
@end

@implementation AppDelegate

#pragma mark - Application Delegates

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [[self window] setBackgroundColor:[UIColor whiteColor]];
    [[self window] makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UITextField appearance] setTintColor:CLR_DARK_BLUE];
    [[UITextView appearance] setTintColor:CLR_DARK_BLUE];
    
    //    [MT setServiceURL:@"http://muhit.co"];//Production
    [MT setServiceURL:@"http://stage.muhit.co"];//Sandbox
    
    if ([UD objectForKey:UD_ACCESS_TOKEN]) {
        [UF isAccessTokenValid];
        [MT setIsLoggedIn:YES];
    }
    
    [self initNavigationBar];
    [self initThirdPartyServices];
    [self registerPushNotifications];
    
    if(launchOptions && [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]){
        pushNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self showPushNotificationPopup];
    }
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //Facebook
    if([url.absoluteString rangeOfString:@"fb"].location != NSNotFound) {
        return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark -

#pragma mark - Notification Delegates

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *pushToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    pushToken = [pushToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    DLog(@"token:%@",pushToken);
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler{
    
    DLog(@"userInfo %@",userInfo);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    DLog(@"failed: %@",[NSString stringWithFormat: @"Error: %@", err]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    pushNotification = userInfo;
    [self showPushNotificationPopup];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
}
#pragma mark -

#pragma mark - Initialize Methods

-(void)initNavigationBar{
    MainVC *main = [[MainVC alloc] init];
    
    [MT setNavCon:[[UINavigationController alloc] initWithNavigationBarClass:[NavBar class]
                                                                toolbarClass:nil]];
    
    [[MT navCon] pushViewController:main animated:NO];
    [[MT navCon] setNavigationBarHidden:NO];
    
    [MT setDrawerController:[[MMDrawerController alloc] initWithCenterViewController: [MT navCon]
                                                            leftDrawerViewController: [[MenuVC alloc] init]]];
    
    [[MT drawerController] setMaximumLeftDrawerWidth:240.0];
    [[MT drawerController] setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [[MT drawerController] setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [[MT drawerController] setShowsShadow:YES];
    [[MT drawerController] setShouldStretchDrawer:NO];
    
    [[self window] setRootViewController:[MT drawerController]];
}

-(void)initThirdPartyServices{
    [Fabric with:@[[Crashlytics class]]];
    [GMSServices provideAPIKey:@"AIzaSyDhFJMt6qYhCayG6MdiVZ5OqxG1CUjjNfY"];
}

-(void)registerPushNotifications{
    if (!isRegisteredPush) {
        isRegisteredPush = YES;
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:
                                                                             (UIUserNotificationTypeAlert |
                                                                              UIUserNotificationTypeSound |
                                                                              UIUserNotificationTypeBadge) categories:nil]];
    }
}

- (void)showPushNotificationPopup{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushNotification[@"t"]
                                                    message:pushNotification[@"M"]
                                                   delegate:self
                                          cancelButtonTitle:@"İptal"
                                          otherButtonTitles:@"Detay",nil];
    [alert setTag:ALERT_PUSH_NOTIFICATION];
    [alert show];
}


@end
