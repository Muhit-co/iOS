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
#import "IssueVC.h"
#import "AddEditIssueVC.h"


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

+ (void)openProfile{
    ProfileVC *vc = [[ProfileVC alloc] init];
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

+ (void)openIssueWithId:(NSString *)issueId{
    IssueVC *vc = [[IssueVC alloc] initWithId:issueId];
    [[MT navCon] pushViewController:vc animated:YES];
}

+ (void)openCreateIssue{
    AddEditIssueVC *vc = [[AddEditIssueVC alloc] initWithInfo:nil];
    [[MT navCon] pushViewController:vc animated:YES];
}

+ (void)openEditIssueWithInfo:(NSDictionary *)info{
    AddEditIssueVC *vc = [[AddEditIssueVC alloc] initWithInfo:info];
    [[MT navCon] pushViewController:vc animated:YES];
}

+ (void)openMain{
    [[MT navCon] popToRootViewControllerAnimated:YES];
}

+ (void)openSupports{
    SupportedsVC *vc = [[SupportedsVC alloc] init];
    [[MT navCon] pushViewController:vc animated:YES];
}

+ (void)openIdeas{
}

+ (void)openAnnouncements{
    AnnouncementsVC *vc = [[AnnouncementsVC alloc] init];
    [[MT navCon] pushViewController:vc animated:YES];
}

+ (void)openHeadman{
    HeadmanVC *vc = [[HeadmanVC alloc] init];
    [[MT navCon] pushViewController:vc animated:YES];
}
@end