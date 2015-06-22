//
//  Muhit.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "Muhit.h"
#import "UtilityFunctions.h"


@implementation Muhit

@synthesize tokenCode;

+ (id)instance{
    static Muhit *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {

    if (self = [super init]) {
    }
    return self;
}
@end
