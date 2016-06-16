//
//  ForgotPasswordVC.m
//  Muhit
//
//  Created by Emre YANIK on 03/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "ForgotPasswordVC.h"

@interface ForgotPasswordVC (){
    IBOutlet MTTextField *txtEmail;
    IBOutlet UILabel *lblForgotPassword,*lblDescription;
    IBOutlet UIButton *btnSubmit,*btnSignup;
}

@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    txtEmail.layer.cornerRadius = cornerRadius;
    btnSubmit.layer.cornerRadius = cornerRadius;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSignup];
}

-(IBAction)actSubmit:(id)sender{
    
}

-(IBAction)actSignup:(id)sender{
    
}

- (void)setLocalizedStrings{
    [self setTitle:nil];
    [btnSubmit setTitle:[LocalizedString(@"submit") toUpper]];
    [btnSignup setTitle:[LocalizedString(@"signup") toUpper]];
    [txtEmail setPlaceholder:LocalizedString(@"email")];
    [lblForgotPassword setText:LocalizedString(@"forgot-pass")];
    [lblDescription setText:LocalizedString(@"forgot-pass-description")];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
