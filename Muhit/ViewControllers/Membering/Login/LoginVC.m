//
//  LoginVC.m
//  Muhit
//
//  Created by Emre YANIK on 02/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC (){
    IBOutlet MTTextField *txtEmail,*txtPassword;
    IBOutlet UIButton *btnLogin,*btnSignup,*btnForgotPassword,*btnFacebook;
    IBOutlet UILabel *lblOr;
    KeyboardControls *keyboardControl;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSignup];
    
    keyboardControl = [[KeyboardControls alloc] initWithFields:@[txtEmail ,txtPassword]];
    [keyboardControl setDelegate:self];
    
    [self adjustUI];
}

-(void)adjustUI{
    
    txtEmail.layer.cornerRadius = cornerRadius;
    txtPassword.layer.cornerRadius = cornerRadius;
    btnLogin.layer.cornerRadius = cornerRadius;
    btnSignup.layer.cornerRadius = 4;
    btnForgotPassword.layer.cornerRadius = cornerRadius;
    btnFacebook.layer.cornerRadius = cornerRadius;
    [btnFacebook setImage:[IonIcons imageWithIcon:ion_social_facebook size:30 color:CLR_WHITE]];
}

-(IBAction)actLogin:(id)sender{
    
    [self resetScrollOffset];
    [self.view endEditing:YES];
    
    BOOL isValid = [UF validateLoginWithEmail:txtEmail.text password:txtPassword.text];
    
    if (isValid == NO){
        [self.view endEditing:YES];
        [scrollRoot setContentOffset:CGPointMake(0,0) animated:YES];
        return;
    }
    
    ADD_HUD
    [SERVICES login:txtEmail.text password:txtPassword.text handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
        }
        else{
            NSLog(@"loginResponse:%@",response);
            [USER setDetailsWithInfo:response[@"user"]];
            [self.view endEditing:YES];
        }
        REMOVE_HUD
    }];
}

-(IBAction)actFacebook:(id)sender{
    [FACEBOOK loginWithDelegate:self fromViewController:self];
}

- (void) fetchedFacebookUserInfo:(NSDictionary*)userInfo error:(NSError *)error{
    DLog(@"user: %@",userInfo);
    if (userInfo) {
        [SERVICES loginWithFacebook:[FACEBOOK accessToken] fbId:userInfo[FB_ID] handler:^(NSDictionary *response, NSError *error) {
            if (error) {
                SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
            }
            else{
                NSLog(@"loginFacebookResponse:%@",response);
                [USER setDetailsWithInfo:response[@"user"]];
                [self.view endEditing:YES];
            }
            REMOVE_HUD
        }];
    }
    else if(error){
        REMOVE_HUD
        if ([error.domain isEqualToString:@"bitaksi"] && error.code==ERROR_FB_LOGIN_CANCELLED){
            DLog(@"User cancelled permission");
        }
        else if ([error.domain isEqualToString:FBSDKLoginErrorDomain] &&  error.code==FBSDKLoginSystemAccountAppDisabledErrorCode) {
            SHOW_ALERT(LocalizedString(@"facebook-permission"))
        }
        else{
            [self actFacebook:nil];
        }
    }
    else{
        [self actFacebook:nil];
    }
    
}

-(IBAction)actSignup:(id)sender{
    [ScreenOperations openSignUp];
}

-(IBAction)actForgotPassword:(id)sender{
    [ScreenOperations openForgotPassword];
}

#pragma mark - Keyboard Controls Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [scrollRoot setContentOffset:CGPointMake(0,textField.frame.origin.y - 35 ) animated:YES];
    [keyboardControl setActiveField:textField];
}

- (void)keyboardControls:(KeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(KeyboardControlsDirection)direction{
    [scrollRoot setContentOffset:CGPointMake(0,field.frame.origin.y - 35 ) animated:YES];
}

- (void)keyboardControlsDonePressed:(KeyboardControls *)keyboardControls{
    [self.view endEditing:YES];
    [self resetScrollOffset];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{
    [self setTitle:nil];
    [lblOr setText:LocalizedString(@"or")];
    [btnLogin setTitle:[LocalizedString(@"login") toUpper]];
    [btnSignup setTitle:[LocalizedString(@"signup") toUpper]];
    [btnForgotPassword setTitle:[LocalizedString(@"forgot-pass") toUpper]];
    [btnFacebook setTitle:[LocalizedString(@"login-with-facebook") toUpper]];
    [txtEmail setPlaceholder:LocalizedString(@"email")];
    [txtPassword setPlaceholder:LocalizedString(@"password")];
}
@end
