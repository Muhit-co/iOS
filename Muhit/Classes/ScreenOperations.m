//
//  ScreenOperations.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "ScreenOperations.h"
#import "ForgotPasswordVC.h"
#import "LoginVC.h"
#import "SignupVC.h"
#import "SupportedsVC.h"
#import "AnnouncementsVC.h"
#import "ProfileVC.h"
#import "EditProfileVC.h"
#import "SearchVC.h"
#import "HeadmanVC.h"
#import "IdeaVC.h"
#import "AddIdeaVC.h"
#import "PickFromMapVC.h"
#import "MainVC.h"
#import "MyIdeasVC.h"
#import "NavBar.h"

@implementation ScreenOperations

+ (void)openLogin{
    LoginVC *vc = [[LoginVC alloc] init];
    [[MT navCon] pushViewController:vc animated:YES];
}

+ (void)openSignUp{
    SignupVC *vc = [[SignupVC alloc] init];
    [[MT navCon] pushViewController:vc animated:YES];
}

+ (void)openForgotPassword{
    ForgotPasswordVC *vc = [[ForgotPasswordVC alloc] init];
    [[MT navCon] pushViewController:vc animated:YES];
}

+ (void)openProfileWithId:(NSString *)profileId{
    ProfileVC *vc = [[ProfileVC alloc] initWithId:profileId];
    [[MT navCon] pushViewController:vc animated:YES];
}

+ (void)openEditProfile{
    EditProfileVC *vc = [[EditProfileVC alloc] init];
    [[MT navCon] pushViewController:vc animated:YES];
}

+ (void)openSearch{
    SearchVC *vc = [[SearchVC alloc] init];
    [[MT navCon] pushViewController:vc animated:YES];
}

+ (void)openIdeaWithIdea:(Idea *)idea{
    IdeaVC *vc = [[IdeaVC alloc] initWithIdea:idea];
    [[MT navCon] pushViewController:vc animated:YES];
}

+ (void)openAddIdea{
    AddIdeaVC *vc = [[AddIdeaVC alloc] initWithInfo:nil];
    [[MT navCon] pushViewController:vc animated:YES];
}

+ (void)openMain{
    MainVC *vc = [[MainVC alloc] init];
    [self setCenterVC:vc];
}

+ (void)openSupporteds:(BOOL)fromMenu{
    if(fromMenu){
        SupportedsVC *vc = [[SupportedsVC alloc] initFromMenu];
        [self setCenterVC:vc];
    }
    else{
        SupportedsVC *vc = [[SupportedsVC alloc] init];
        [[MT navCon] pushViewController:vc animated:YES];
    }
}

+ (void)openMyIdeas:(BOOL)fromMenu{
    if(fromMenu){
        MyIdeasVC *vc = [[MyIdeasVC alloc] initFromMenu];
        [self setCenterVC:vc];
    }
    else{
        MyIdeasVC *vc = [[MyIdeasVC alloc] init];
        [[MT navCon] pushViewController:vc animated:YES];
    }
}

+ (void)openAnnouncements:(BOOL)fromMenu{
    if(fromMenu){
        AnnouncementsVC *vc = [[AnnouncementsVC alloc] initFromMenu];
        [self setCenterVC:vc];
    }
    else{
        AnnouncementsVC *vc = [[AnnouncementsVC alloc] init];
        [[MT navCon] pushViewController:vc animated:YES];
    }
}

+ (void)openHeadman:(BOOL)fromMenu{
    if(fromMenu){
        HeadmanVC *vc = [[HeadmanVC alloc] initFromMenu];
        [self setCenterVC:vc];
    }
    else{
        HeadmanVC *vc = [[HeadmanVC alloc] init];
        [[MT navCon] pushViewController:vc animated:YES];
    }
}

+ (void)openPickFromMap{
    PickFromMapVC * vc = [[PickFromMapVC alloc] init];
    [MT setIsPresentingVC:YES];
    [[MT navCon] presentViewController:vc animated:YES completion:^{
        [MT setIsPresentingVC:NO];
    }];
}

+ (void)setCenterVC:(UIViewController*)vc{
    UINavigationController *navCon = [[UINavigationController alloc] initWithNavigationBarClass:[NavBar class] toolbarClass:nil];
    [navCon pushViewController:vc animated:NO];
    [navCon setNavigationBarHidden:NO];
    [MT setNavCon:navCon];
    [[MT drawerController] setCenterViewController:navCon withCloseAnimation:YES completion:^(BOOL finished) {
        if (finished) {
            [[MT drawerController] setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        }
    }];
}

@end
