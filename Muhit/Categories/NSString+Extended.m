//
//  NSString+Extended.m
//  Muhit
//
//  Created by Emre YANIK on 11/07/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "NSString+Extended.h"

@implementation NSString (Extended)

- (NSString *)toUpper{
	return [self uppercaseStringWithLocale:[LM currentLocale]];
}

@end
