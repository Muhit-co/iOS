//
//  ScreenOperations.h
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "Idea.h"

@interface ScreenOperations : NSObject

+ (void)openLogin;
+ (void)openSignUp;
+ (void)openForgotPassword;
+ (void)openProfileWithId:(NSString *)profileId;
+ (void)openEditProfile;
+ (void)openSearch;
+ (void)openIdeaWithIdea:(Idea *)idea;
+ (void)openAddIdea;
+ (void)openMain;
+ (void)openSupporteds:(BOOL)fromMenu;
+ (void)openHeadman:(BOOL)fromMenu;
+ (void)openMyIdeas:(BOOL)fromMenu;
+ (void)openAnnouncements:(BOOL)fromMenu;
+ (void)openPickFromMap;

@end
