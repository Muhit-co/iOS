//
//  UIView+CustomNib.h
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CustomNib)

+ (id)viewWithNibName:(NSString *)nibName;
+ (id)viewWithNibName:(NSString *)nibName owner:(id)owner;
+ (NSString *)nibName;

- (void) initialize;

@end
