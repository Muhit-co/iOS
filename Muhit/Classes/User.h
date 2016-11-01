//
//  User.h
//  Muhit
//
//  Created by Emre YANIK on 31/10/2016.
//  Copyright © 2016 Muhit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (id)instance;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *surname;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *locationText;
@property (nonatomic, retain) NSString *hood;
@property (nonatomic, retain) NSString *profileImageUrl;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) UIImage *profileImage;
@property (nonatomic) BOOL isLoggedIn;

- (void)startInstance;
- (void)setDetailsWithInfo:(NSDictionary *)info;
- (void)setDetailsWithInfo:(NSDictionary *)info refreshNav:(BOOL)refreshNav;
- (void)clearUser;

@end
