//
//  EditProfileVC.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "EditProfileVC.h"

@interface EditProfileVC (){
    IBOutlet MTTextField *txtFullName,*txtEmail,*txtUsername,*txtPassword,*txtHood;
    IBOutlet UILabel *lblFullName,*lblEmail,*lblUsername,*lblPassword,*lblHood;
    IBOutlet UIButton *btnSave;
    IBOutlet UIPickerView *pickerHood;
    IBOutlet UIImageView *imgDownIcon;
    IBOutlet UIView *viewHood;
    NSArray *arrHoods;
    BSKeyboardControls *keyboardControl;
}

@end

@implementation EditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adjustUI];
    
    NSArray *txtFields = @[txtFullName ,txtEmail,txtUsername,txtPassword,txtHood];
    keyboardControl = [[BSKeyboardControls alloc] initWithFields:txtFields];
    [keyboardControl setDelegate:self];
    
    if (!pickerHood) {
        pickerHood = [[UIPickerView alloc] init];
    }
    
    [pickerHood setDelegate:self];
    [pickerHood setDataSource:self];
    [pickerHood setShowsSelectionIndicator:YES];
    [txtHood setInputView:pickerHood];
    [txtHood setText:@""];
    
    arrHoods = @[@"Siyavuş",@"Çamlık",@"Yayla",@"UEFA",@"Çaldıran"];
    [pickerHood reloadAllComponents];
}

-(void)adjustUI{
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat borderWidth = 1;
    
    txtFullName.layer.cornerRadius = cornerRadius;
    txtFullName.layer.borderWidth = borderWidth;
    txtFullName.layer.borderColor = [CLR_LIGHT_BLUE CGColor];
    txtEmail.layer.cornerRadius = cornerRadius;
    txtEmail.layer.borderWidth = borderWidth;
    txtEmail.layer.borderColor = [[HXColor colorWithHexString:@"eeeeee"] CGColor];
    txtUsername.layer.cornerRadius = cornerRadius;
    txtUsername.layer.borderWidth = borderWidth;
    txtUsername.layer.borderColor = [[HXColor colorWithHexString:@"eeeeee"] CGColor];
    txtPassword.layer.cornerRadius = cornerRadius;
    txtPassword.layer.borderWidth = borderWidth;
    txtPassword.layer.borderColor = [CLR_LIGHT_BLUE CGColor];
    viewHood.layer.cornerRadius = cornerRadius;
    viewHood.layer.borderWidth = borderWidth;
    viewHood.layer.borderColor = [CLR_LIGHT_BLUE CGColor];
    btnSave.layer.cornerRadius = cornerRadius;
    
    [imgDownIcon setImage:[IonIcons imageWithIcon:ion_chevron_down size:26 color:CLR_LIGHT_BLUE]];
}

-(IBAction)actSave:(id)sender{
    [MuhitServices updateProfile:@"" lastName:@"" email:@"" password:@"" activeHood:@"" handler:^(NSDictionary *response, NSError *error) {
        
    }];
}

#pragma mark -
#pragma mark Picker Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [arrHoods count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return arrHoods[row];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = arrHoods[row];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
    [str addAttribute:NSForegroundColorAttributeName value:CLR_DARK_BLUE range:NSMakeRange(0,[title length])];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Bold" size:20.0] range:NSMakeRange(0, [title length])];
    
    return str;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [txtHood setText:arrHoods[row]];
}

#pragma mark -

#pragma mark -
#pragma mark Keyboard Controls Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == txtHood) {
        [scrollRoot setContentOffset:CGPointMake(0,[textField superview].frame.origin.y - 35 ) animated:YES];
    }
    else{
        [scrollRoot setContentOffset:CGPointMake(0,textField.frame.origin.y - 35 ) animated:YES];
    }
    
    [keyboardControl setActiveField:textField];
}

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction{
    if (field == txtHood) {
        [scrollRoot setContentOffset:CGPointMake(0,[field superview].frame.origin.y - 35 ) animated:YES];
    }
    else{
        [scrollRoot setContentOffset:CGPointMake(0,field.frame.origin.y - 35 ) animated:YES];
    }
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
    [self setTitle:LocalizedString(@"Profili Düzenle")];
    [btnSave setTitle:LocalizedString(@"GÜNCELLE")];
    [lblFullName setText:LocalizedString(@"Ad Soyad")];
    [lblEmail setText:LocalizedString(@"E-posta adresi")];
    [lblUsername setText:LocalizedString(@"Kullanıcı adı")];
    [lblPassword setText:LocalizedString(@"Şifre")];
    [lblHood setText:LocalizedString(@"Mahalle")];
}

@end
