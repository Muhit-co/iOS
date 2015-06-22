//
//  Signup.m
//  Muhit
//
//  Created by Emre YANIK on 03/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "SignupVC.h"

@interface SignupVC (){
    IBOutlet MTTextField *txtFirstname,*txtSurname,*txtEmail,*txtPassword,*txtRePassword;
    IBOutlet UILabel *lblFirstname,*lblSurname,*lblEmail,*lblPassword,*lblRePassword,*lblHood;
    IBOutlet UIButton *btnSignup,*btnHood;
    IBOutlet UIImageView *imgDownIcon;
    BSKeyboardControls *keyboardControl;
    PlacesView *placeView;
}

@end

@implementation SignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adjustUI];
    
    NSArray *txtFields = @[txtFirstname, txtSurname, txtEmail,txtPassword,txtRePassword];
    keyboardControl = [[BSKeyboardControls alloc] initWithFields:txtFields];
    [keyboardControl setDelegate:self];
}

-(void)adjustUI{
    txtFirstname.layer.cornerRadius = cornerRadius;
    txtSurname.layer.cornerRadius = cornerRadius;
    txtEmail.layer.cornerRadius = cornerRadius;
    txtPassword.layer.cornerRadius = cornerRadius;
    txtRePassword.layer.cornerRadius = cornerRadius;
    btnSignup.layer.cornerRadius = cornerRadius;
    btnHood.layer.cornerRadius = cornerRadius;
    
    [imgDownIcon setImage:[IonIcons imageWithIcon:ion_chevron_down size:20 color:CLR_LIGHT_BLUE]];
}

-(IBAction)actSignup:(id)sender{
    [self.view endEditing:YES];
    BOOL isValid = [UF validateSignUpInputWithName:txtFirstname.text
                                           surname:txtSurname.text
                                             email:txtEmail.text
                                          password:txtPassword.text
                    					rePassword:txtRePassword.text
                                   isFacebookLogin:NO];
    
    if (isValid == NO){
        [self.view endEditing:YES];
        [scrollRoot setContentOffset:CGPointMake(0,0) animated:YES];
        return;
    }
    
    ADD_HUD
    [MuhitServices signUp:txtFirstname.text lastName:txtSurname.text email:txtEmail.text password:txtPassword.text activeHood:@"" handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
        }
        else{
            NSLog(@"signUpResponse:%@",response);
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

-(IBAction)actSearchHood:(id)sender{
    if (!placeView) {
        placeView = [[PlacesView alloc] init];
        [placeView setDelegate:self];
    }
    [placeView show];
}

-(void)placesView:(PlacesView *)placesView selectedAddress:(GMSAutocompletePrediction *)selectedAddress{
    NSDictionary *parsedAddress = [UF parsePlaces:selectedAddress];
    [btnHood setTitle:parsedAddress[@"hood"]];
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
    [scrollRoot setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{
    [self setTitle:LocalizedString(@"Üye Ol")];
    [btnSignup setTitle:LocalizedString(@"ÜYE OL")];
    [lblFirstname setText:LocalizedString(@"Ad")];
    [lblSurname setText:LocalizedString(@"Soyad")];
    [lblEmail setText:LocalizedString(@"E-posta adresi")];
    [lblPassword setText:LocalizedString(@"Şifre")];
    [lblRePassword setText:LocalizedString(@"Şifre (tekrar)")];
    [lblHood setText:LocalizedString(@"Mahalle")];
}

@end
