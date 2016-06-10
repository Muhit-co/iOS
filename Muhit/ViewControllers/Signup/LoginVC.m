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
    IBOutlet UILabel *lblEmail,*lblPassword;
    IBOutlet UIButton *btnLogin,*btnSignup,*btnForgotPassword,*btnFacebook;
    KeyboardControls *keyboardControl;
    
}

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    
    NSArray *txtFields = @[txtEmail ,txtPassword];
    keyboardControl = [[KeyboardControls alloc] initWithFields:txtFields];
    [keyboardControl setDelegate:self];
}

-(void)adjustUI{
    txtEmail.layer.cornerRadius = cornerRadius;
    txtPassword.layer.cornerRadius = cornerRadius;
    btnLogin.layer.cornerRadius = cornerRadius;
    btnSignup.layer.cornerRadius = cornerRadius;
    btnForgotPassword.layer.cornerRadius = cornerRadius;
    btnFacebook.layer.cornerRadius = cornerRadius;
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
    [MuhitServices login:txtEmail.text password:txtPassword.text handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
        }
        else{
            NSLog(@"loginResponse:%@",response);
            [UF setUserDefaultsWithDetails:response];
            [[MT navCon] popToRootViewControllerAnimated:YES];
            [MT setIsLoggedIn:YES];
            [[MT menuVC] viewWillAppear:NO];
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
        [MuhitServices loginWithFacebook:[FACEBOOK accessToken] handler:^(NSDictionary *response, NSError *error) {
            if (error) {
                SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
            }
            else{
                NSLog(@"loginFacebookResponse:%@",response);
                [UF setUserDefaultsWithDetails:response];
                [[MT navCon] popToRootViewControllerAnimated:YES];
                [MT setIsLoggedIn:YES];
                [[MT menuVC] viewWillAppear:NO];
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
            SHOW_ALERT(LocalizedString(@"fbPermissionMessage"))
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

#pragma mark -
#pragma mark Keyboard Controls Delegate

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
    [self setTitle:LocalizedString(@"Giriş Yap")];
    [btnLogin setTitle:[LocalizedString(@"Giriş Yap") toUpper]];
    [btnSignup setTitle:[LocalizedString(@"Üye Ol") toUpper]];
    [btnForgotPassword setTitle:[LocalizedString(@"Şifremi Unuttum") toUpper]];
    [lblEmail setText:LocalizedString(@"E-posta adresi")];
    [lblPassword setText:LocalizedString(@"Şifre")];
}
@end
