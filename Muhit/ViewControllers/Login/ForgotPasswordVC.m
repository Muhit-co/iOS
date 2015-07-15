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
    IBOutlet UILabel *lblEmail;
    IBOutlet UIButton *btnSendPassword;
}

@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    txtEmail.layer.cornerRadius = cornerRadius;
    btnSendPassword.layer.cornerRadius = cornerRadius;
}

-(IBAction)actSendPassword:(id)sender{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{
    [self setTitle:LocalizedString(@"Şifremi Unuttum")];
    [btnSendPassword setTitle:[LocalizedString(@"Şifremi Gönder") toUpper]];
    [lblEmail setText:LocalizedString(@"E-posta adresi")];
}

@end
