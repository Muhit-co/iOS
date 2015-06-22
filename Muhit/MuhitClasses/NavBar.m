//
//  BTNavigationBar.m
//  BiTaksi Client
//
//  Created by Emre YANIK on 23/01/15.
//  Copyright (c) 2015 BiTaksi. All rights reserved.
//

#import "NavBar.h"

@implementation NavBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTranslucent:NO];
        [self setBarStyle:UIBarStyleDefault];
        [self setBarTintColor:CLR_LIGHT_BLUE];
        [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                                NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                NSFontAttributeName: [UIFont fontWithName:@"SourceSansPro-Semibold" size:19.0f]
                                                                }];
        [self setTintColor:[UIColor whiteColor]];
        [self setTintAdjustmentMode:UIViewTintAdjustmentModeAutomatic];
        [self setBackIndicatorImage:[UIImage imageNamed:@"back"]];
        [self setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];

    }
    return self;
}

@end
