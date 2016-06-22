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
                                                                NSFontAttributeName: [UIFont fontWithName:FONT_SEMI_BOLD size:20.0f]
                                                                }];
        [self setTintColor:[UIColor whiteColor]];
        [self setTintAdjustmentMode:UIViewTintAdjustmentModeAutomatic];
        [self setBackIndicatorImage:[UIImage imageNamed:@"navigation-back"]];
        [self setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"navigation-back"]];
        [[UINavigationBar appearance] setShadowImage:[UIImage new]];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage new]
                                          forBarPosition:UIBarPositionAny
                                              barMetrics:UIBarMetricsDefault];
        
    }
    return self;
}


//- (void)layoutSubviews {
//    [super layoutSubviews];
//    UINavigationItem *navigationItem = [self topItem];
//    
//    for (UIView *subview in [self subviews]) {
//        if (subview == [[navigationItem rightBarButtonItem] customView]) {
//            [subview setFrame:CGRectMake([UF screenSize].width-80, 4, 70, 36)];
//        }
//    }
//}

@end
