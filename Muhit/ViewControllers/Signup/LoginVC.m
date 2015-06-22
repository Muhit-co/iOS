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
    BSKeyboardControls *keyboardControl;
    
}

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    
    NSArray *txtFields = @[txtEmail ,txtPassword];
    keyboardControl = [[BSKeyboardControls alloc] initWithFields:txtFields];
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
            [UD setObject:[NSDate date] forKey:UD_ACCESS_TOKEN_TAKEN_DATE];
            [UD setObject:response[AUTH][@"access_token"] forKey:UD_ACCESS_TOKEN];
            [UD setObject:response[AUTH][@"refresh_token"] forKey:UD_REFRESH_TOKEN];
            [UD setObject:response[AUTH][@"expires_in"] forKey:UD_ACCESS_TOKEN_LIFETIME];
            [UD setObject:response[@"user"][@"first_name"] forKey:UD_FIRSTNAME];
            [UD setObject:response[@"user"][@"last_name"] forKey:UD_SURNAME];
            [[MT navCon] popToRootViewControllerAnimated:YES];
            [MT setIsLoggedIn:YES];
            [[MT menuVC] viewWillAppear:NO];
        }
        REMOVE_HUD
    }];
}

-(IBAction)actFacebook:(id)sender{
    [FACEBOOK openSessionWithDelegate:self];
}

-(void)openedFacebookSessionWithToken:(NSString *)accessToken{
    if(accessToken){
        ADD_HUD
    	[MuhitServices loginWithFacebook:accessToken handler:^(NSDictionary *response, NSError *error) {
            if (error) {
                SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
            }
            else{
                NSLog(@"loginFacebookResponse:%@",response);
                [UD setObject:[NSDate date] forKey:UD_ACCESS_TOKEN_TAKEN_DATE];
                [UD setObject:response[AUTH][@"access_token"] forKey:UD_ACCESS_TOKEN];
                [UD setObject:response[AUTH][@"refresh_token"] forKey:UD_REFRESH_TOKEN];
                [UD setObject:response[AUTH][@"expires_in"] forKey:UD_ACCESS_TOKEN_LIFETIME];
                [UD setObject:response[@"user"][@"first_name"] forKey:UD_FIRSTNAME];
                [UD setObject:response[@"user"][@"last_name"] forKey:UD_SURNAME];
                [[MT navCon] popToRootViewControllerAnimated:YES];
                [MT setIsLoggedIn:YES];
                [[MT menuVC] viewWillAppear:NO];
            }
            REMOVE_HUD
        }];
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

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction{
    [scrollRoot setContentOffset:CGPointMake(0,field.frame.origin.y - 35 ) animated:YES];
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls{
    [self.view endEditing:YES];
    [self resetScrollOffset];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{
    [self setTitle:LocalizedString(@"Giriş Yap")];
    [btnLogin setTitle:LocalizedString(@"GİRİŞ YAP")];
    [btnSignup setTitle:LocalizedString(@"ÜYE OL")];
    [btnForgotPassword setTitle:LocalizedString(@"ŞİFREMİ UNUTTUM")];
    [lblEmail setText:LocalizedString(@"E-posta adresi")];
    [lblPassword setText:LocalizedString(@"Şifre")];
}
@end
