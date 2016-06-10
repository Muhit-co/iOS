//
//  MTTagLabel.m
//  Muhit
//
//  Created by Emre YANIK on 12/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "MTTagLabel.h"

@implementation MTTagLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 5, 0, 5};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGSize)intrinsicContentSize{

    CGSize size = [super intrinsicContentSize];
    size.width += 10;
    size.height += 0;
    return size;
}

@end
