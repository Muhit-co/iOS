//
//  Pokemon.h
//  Muhit
//
//  Created by Emre YANIK on 31/10/2016.
//  Copyright © 2016 Muhit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface Idea : NSObject

@property (nonatomic, retain) NSString *ideaId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *problem;
@property (nonatomic, retain) NSString *solution;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *locationText;
@property (nonatomic, retain) NSString *createdAt;
@property (nonatomic, retain) NSString *supporterCount;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *userFullName;
@property (nonatomic, retain) NSString *userProfileImageUrl;

@property (nonatomic, retain) NSArray *comments;
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) NSArray *tags;

@property (nonatomic, retain) CLLocation *coordinate;

@property (nonatomic) BOOL isSupported;
@property (nonatomic) BOOL isAnonymus;


-(id)initWithInfo:(NSDictionary*)info;
-(void)setInfo:(NSDictionary*)info;

@end
