//
//  Pokemon.m
//  Muhit
//
//  Created by Emre YANIK on 31/10/2016.
//  Copyright © 2016 Muhit. All rights reserved.
//

#import "Idea.h"

@implementation Idea

@synthesize ideaId,title,problem,solution,status,locationText,createdAt,supporterCount,coordinate;
@synthesize userId,userFullName,userProfileImageUrl,comments,images,tags,isSupported,isAnonymus;

-(id)initWithInfo:(NSDictionary*)info{
    if (self = [super init]) {
        [self setInfo:info];
    }
    return self;
}

-(void)setInfo:(NSDictionary*)info{
    
    @try {
        ideaId = info[@"id"];
        title = info[@"title"];
        problem = info[@"problem"];
        solution = info[@"solution"];
        status = info[@"status"];
        locationText = info[@"location"];
        createdAt = info[@"created_at"];
        supporterCount = info[@"supporter_count"];
        userId = info[@"user"][@"id"];
        userFullName = info[@"user"][@"full_name"];
        userProfileImageUrl = info[@"user"][@"picture"];
        
        if (info[@"tags"]) {
            tags = info[@"tags"];
        }
        if (info[@"images"]) {
            images = info[@"images"];
        }
        if (info[@"comments"]) {
            comments = info[@"comments"];
        }
        if (isNotNull(info[@"coordinates"]) && [info[@"coordinates"] length]>0) {
            NSString *coord = info[@"coordinates"];
            NSArray *arrPoints = [coord componentsSeparatedByString:@", "];
            coordinate = [[CLLocation alloc] initWithLatitude:[arrPoints[0] doubleValue] longitude:[arrPoints[1] doubleValue]];
        }
    }
    @catch (NSException *exception) {}
    @finally {}
}

@end

