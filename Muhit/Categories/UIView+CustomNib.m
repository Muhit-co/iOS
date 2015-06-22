//
//  UIView+CustomNib.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "UIView+CustomNib.h"

@implementation UIView (CustomNib)

+ (id)viewWithNibName:(NSString *)nibName
{
    return [self viewWithNibName:nibName owner:nil];
}

+ (id)viewWithNibName:(NSString *)nibName owner:(id)owner
{
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
	return [nibObjects objectAtIndex:0];
}

+ (NSString *)nibName
{
    return NSStringFromClass([self class]);
}

- (void) initialize {
    UIView *view = [[self class] viewWithNibName:[[self class] nibName] owner:self];
    [view setFrame:self.bounds];
    [self addSubview:view];
}

@end
