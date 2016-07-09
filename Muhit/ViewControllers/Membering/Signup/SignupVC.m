//
//  Signup.m
//  Muhit
//
//  Created by Emre YANIK on 03/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "SignupVC.h"

@interface SignupVC (){
    IBOutlet MTTextField *txtFirstname,*txtSurname,*txtEmail,*txtPassword;
    IBOutlet UILabel *lblSignup,*lblFirstname,*lblSurname,*lblEmail,*lblPassword,*lblHood;
    IBOutlet UIButton *btnSignup,*btnHood,*btnLogin,*btnReadAgreement,*btnCheck;
    IBOutlet UIImageView *imgDownIcon;
    IBOutlet NSLayoutConstraint *constContainerHeight;
    KeyboardControls *keyboardControl;
    PlacesView *placeView;
    NSString *fullGeoCode;
}

@end

@implementation SignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    keyboardControl = [[KeyboardControls alloc] initWithFields:@[txtFirstname, txtSurname, txtEmail,txtPassword]];
    [keyboardControl setDelegate:self];
    [NC addObserver:self selector:@selector(geoCodePicked:) name:NC_GEOCODE_PICKED object:nil];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    constContainerHeight.constant = btnSignup.bottomPosition+15;
    [scrollRoot setContentSize:CGSizeMake(self.view.bounds.size.width, btnSignup.bottomPosition+15)];
    [self.view layoutIfNeeded];
}

-(void)dealloc{
    [NC removeObserver:self name:NC_GEOCODE_PICKED object:nil];
}

- (void)geoCodePicked:(NSNotification*)notification{
    NSDictionary *dict = [notification object];
    fullGeoCode = dict[@"full"];
    [btnHood setTitle:dict[@"hood"]];
}

-(void)adjustUI{
    txtFirstname.layer.cornerRadius = cornerRadius;
    txtSurname.layer.cornerRadius = cornerRadius;
    txtEmail.layer.cornerRadius = cornerRadius;
    txtPassword.layer.cornerRadius = cornerRadius;
    btnSignup.layer.cornerRadius = cornerRadius;
    btnHood.layer.cornerRadius = cornerRadius;
    btnLogin.layer.cornerRadius = 4;
    [imgDownIcon setImage:[IonIcons imageWithIcon:ion_chevron_down size:20 color:CLR_LIGHT_BLUE]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLogin];
}

-(IBAction)actSignup:(id)sender{
    [self.view endEditing:YES];
    BOOL isValid = [UF validateSignUpInputWithName:txtFirstname.text
                                           surname:txtSurname.text
                                             email:txtEmail.text
                                          password:txtPassword.text
                                   isFacebookLogin:NO];
    
    if (isValid == NO){
        [self.view endEditing:YES];
        [scrollRoot setContentOffset:CGPointMake(0,0) animated:YES];
        return;
    }
    
    ADD_HUD
    [SERVICES signUp:txtFirstname.text lastName:txtSurname.text email:txtEmail.text password:txtPassword.text activeHood:@"" handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
        }
        else{
            NSLog(@"signUpResponse:%@",response);
            [UF setUserDefaultsWithDetails:response];
            [self.view endEditing:YES];
            [MT setIsLoggedIn:YES];
        }
        REMOVE_HUD
    }];
}

-(IBAction)actSearchHood:(id)sender{
    [ScreenOperations openPickFromMap];
}

-(IBAction)actLogin:(id)sender{
    [ScreenOperations openLogin];
}

-(IBAction)actCheck:(id)sender{
    [btnCheck setSelected:![btnCheck isSelected]];
}

-(IBAction)actAgreement:(id)sender{
    
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
    [scrollRoot setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{
    [self setTitle:nil];
    [btnSignup setTitle:[LocalizedString(@"signup") toUpper]];
    [btnLogin setTitle:[LocalizedString(@"login") toUpper]];
    [btnReadAgreement setTitle:LocalizedString(@"read-agreement")];
    [lblFirstname setText:LocalizedString(@"name")];
    [lblSurname setText:LocalizedString(@"surname")];
    [lblEmail setText:LocalizedString(@"email")];
    [lblPassword setText:LocalizedString(@"password")];
    [lblSignup setText:LocalizedString(@"signup")];
    [lblHood setText:LocalizedString(@"hood")];
}

@end
