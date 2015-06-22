//
//  ScreenOperations.h
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

@interface ScreenOperations : NSObject

+ (void)openLogin;
+ (void)openSignUp;
+ (void)openForgotPassword;
+ (void)openProfile;
+ (void)openEditProfile;
+ (void)openSearch;
+ (void)openIssueWithId:(NSString *)issueId;
+ (void)openCreateIssue;
+ (void)openEditIssueWithInfo:(NSDictionary *)info;
+ (void)openMain;
+ (void)openSupports;
+ (void)openIdeas;
+ (void)openAnnouncements;
+ (void)openHeadman;

@end
