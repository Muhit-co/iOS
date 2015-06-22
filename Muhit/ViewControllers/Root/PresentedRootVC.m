//
//  PresentedRootVC.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "PresentedRootVC.h"

@interface PresentedRootVC ()
@end

@implementation PresentedRootVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    navBar = [[NavBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UINavigationItem *navItems = [[UINavigationItem alloc] init];
    [navBar pushNavigationItem:navItems animated:NO];
    [[self view] addSubview:navBar];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [navBar setWidth:self.view.bounds.size.width];
}

- (void)setTitle:(NSString *)title {
    [[navBar topItem] setTitle:title];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
