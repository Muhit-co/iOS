//
//  Muhit.h
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import <MMDrawerController/MMDrawerController.h>
#import "MBProgressHUD.h"
#import "MenuVC.h"

@interface Muhit : NSObject

+ (id)instance;

@property (nonatomic, retain) NSString *serviceURL;
@property (nonatomic, retain) UINavigationController *navCon;
@property (nonatomic, retain) MMDrawerController *drawerController;
@property (nonatomic, retain) NSString *tokenCode;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) NSArray *arrIssueTags;
@property (nonatomic, retain) NSString *userId;

@property (nonatomic) BOOL isLoggedIn;
@property (nonatomic) BOOL isPresentingVC;
@property (nonatomic, retain) MenuVC *menuVC;
@end