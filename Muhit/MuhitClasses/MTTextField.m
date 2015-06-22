//
//  MTTextField.m
//  Muhit
//
//  Created by Emre YANIK on 03/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "MTTextField.h"

@implementation MTTextField

- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset( bounds , 8 , 8 );
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 8, 8);
}

@end
