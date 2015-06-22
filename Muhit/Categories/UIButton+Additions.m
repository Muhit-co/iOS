//
//  UIButton+Additions.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "UIButton+Additions.h"

@implementation UIButton (Additions)

- (void) setTitle:(NSString *)text
{
    [self setTitle:text forState:UIControlStateNormal];
    [self setTitle:text forState:UIControlStateHighlighted];
    [self setTitle:text forState:UIControlStateSelected];
    [self setTitle:text forState:UIControlStateDisabled];
}

- (void) setTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateHighlighted];
    [self setTitleColor:color forState:UIControlStateSelected];
    [self setTitleColor:color forState:UIControlStateDisabled];
}

- (void) setTitleShadowColor:(UIColor *)color
{
    [self setTitleShadowColor:color forState:UIControlStateNormal];
    [self setTitleShadowColor:color forState:UIControlStateHighlighted];
    [self setTitleShadowColor:color forState:UIControlStateSelected];
    [self setTitleShadowColor:color forState:UIControlStateDisabled];
}

- (void) setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
    [self setImage:image forState:UIControlStateSelected];
    [self setImage:image forState:UIControlStateDisabled];
}

- (void) setBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
    [self setBackgroundImage:image forState:UIControlStateSelected];
    [self setBackgroundImage:image forState:UIControlStateDisabled];
}

@end
