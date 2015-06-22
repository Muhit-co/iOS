//
//  RootVC.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "RootVC.h"
#import "MainVC.h"

@interface RootVC (){
    UIImageView *imgLogo;
}
@end

@implementation RootVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewDidLayoutSubviews{
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [[self view] setBackgroundColor:CLR_LIGHT_BLUE];
    [scrollRoot setBackgroundColor:[UIColor clearColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLocalizedStrings) name:kLocalizationChanged object:nil];

    if ([[UF osVersion] floatValue] >= 7.0) {
        UIBarButtonItem *barBack = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
        [[self navigationItem] setBackBarButtonItem:barBack];
    }
    
    for (UIView *view in [[self view] subviews]) {
        if ([view class] == [UITableView class]) {
            UITableView *tableView = (UITableView*)view;
            [tableView setTableFooterView:[[UIView alloc] init]];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self class] != [MenuVC class]) {
        [[MT drawerController] closeDrawerAnimated:YES completion:nil];
    }
    if ([self class] != [MainVC class] && [self class] != [MenuVC class]) {
        [[MT drawerController] setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeCustom];
        [[MT drawerController] setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
            return NO;
        }];
    }
    [self setLocalizedStrings];
    [self trackScreenName];
}

-(void)trackScreenName{
    
    NSString *name,*class;
    class = [[self class] description];
    
    if([class isEqualToString:@"AboutUsVC"])
        name = @"About_Us";
    else
        name = @"Unknown";
    
    [TRACKER setScreenName:name];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)back{
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)resetScrollOffset{
    [scrollRoot setContentOffset:CGPointMake(0,0) animated:YES];
}

- (void)setMuhitLogo {
    imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bitaksi"]];
    [imgLogo setWidth:115];
    [imgLogo setHeight:31];
    [imgLogo setContentMode:UIViewContentModeScaleAspectFit];
    [imgLogo setUserInteractionEnabled:YES];
    [[self navigationItem] setTitleView:imgLogo];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) setLocalizedStrings{
    
}

@end

