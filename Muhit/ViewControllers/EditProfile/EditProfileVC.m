//
//  EditProfileVC.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "EditProfileVC.h"

@interface EditProfileVC (){
    IBOutlet MTTextField *txtName,*txtSurname,*txtEmail,*txtPassword;
    IBOutlet UILabel *lblName,*lblSurname,*lblEmail,*lblPassword,*lblHood,*lblPhoto;
    IBOutlet UIButton *btnSave,*btnEditPhoto,*btnRemovePhoto,*btnHood;
    IBOutlet UIPickerView *pickerHood;
    IBOutlet UIImageView *imgDownIcon,*imgProfile;
    IBOutlet UIView *viewHood;
    IBOutlet NSLayoutConstraint *constContainerHeight;
    NSArray *arrHoods;
    NSString *fullGeoCode;
    KeyboardControls *keyboardControl;
    UIActionSheet *actionSheet;
    UIImagePickerController * imgPicker;
    UIImage *imageForProfile;
}

@end

@implementation EditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adjustUI];
    
    keyboardControl = [[KeyboardControls alloc] initWithFields:@[txtName, txtSurname, txtEmail,txtPassword]];
    [keyboardControl setDelegate:self];
    
    [self setDetails];
    [NC addObserver:self selector:@selector(geoCodePicked:) name:NC_GEOCODE_PICKED object:nil];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    constContainerHeight.constant =  self.view.bounds.size.height;
    [self.view layoutIfNeeded];
}

-(void)dealloc{
    [NC removeObserver:self name:NC_GEOCODE_PICKED object:nil];
}

-(void)setDetails{
    
    [txtName setText:[USER name]];
    [txtSurname setText:[USER surname]];
    [txtEmail setText:[USER email]];
    
    if ([USER locationText]) {
        [btnHood setTitle:[USER hood]];
        fullGeoCode = [USER locationText];
    }
    if ([USER profileImage]) {
        [imgProfile setImage:[USER profileImage]];
    }
    else{
    	[imgProfile setImage:PLACEHOLDER_IMAGE];
    }
}

- (void)geoCodePicked:(NSNotification*)notification{
    NSDictionary *dict = [notification object];
    fullGeoCode = dict[@"full"];
    [btnHood setTitle:dict[@"hood"]];
}

-(void)adjustUI{
    txtName.layer.cornerRadius = cornerRadius;
    txtSurname.layer.cornerRadius = cornerRadius;
    txtEmail.layer.cornerRadius = cornerRadius;
    txtPassword.layer.cornerRadius = cornerRadius;
    viewHood.layer.cornerRadius = cornerRadius;
    
    btnSave.layer.cornerRadius = cornerRadius;
    btnRemovePhoto.layer.cornerRadius = cornerRadius;
    btnEditPhoto.layer.cornerRadius = cornerRadius;
    
    imgProfile.layer.cornerRadius = 30;
    imgProfile.layer.masksToBounds = YES;
}

-(IBAction)actSave:(id)sender{
    ADD_HUD
    NSString * base64Photo = [UIImageJPEGRepresentation(imageForProfile, 0.7) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [SERVICES updateProfile:txtName.text lastName:txtSurname.text password:txtPassword.text location:fullGeoCode photo:base64Photo email:[USER email] username:[USER username] handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
            REMOVE_HUD
        }
        else{
            SHOW_ALERT(response[KEY_MESSAGE]);
            REMOVE_HUD
        }
    }];
}

-(IBAction)actSearchHood:(id)sender{
    [ScreenOperations openPickFromMap];
}

-(IBAction)actEditPhoto:(id)sender{
    if (!actionSheet) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizedString(@"cancel") destructiveButtonTitle:nil otherButtonTitles:LocalizedString(@"take-photo"),LocalizedString(@"pick-from-library"),nil];
    }
    
    [actionSheet showInView:self.view];
    [actionSheet reloadInputViews];
}

-(IBAction)actRemovePhoto:(id)sender{
    [imgProfile setImage:PLACEHOLDER_IMAGE];
    imageForProfile = nil;
}

#pragma mark - UIImagePickerViewController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [imgProfile setImage:image];
    imageForProfile = image;
    
    [imgPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [imgPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex){
            
        case 0:{
            imgPicker = [[UIImagePickerController alloc] init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            imgPicker.navigationBar.titleTextAttributes = @{
                                                            NSForegroundColorAttributeName:CLR_WHITE,
                                                            NSFontAttributeName: [UIFont fontWithName:FONT_SEMI_BOLD size:19.0f]
                                                            };
            [self presentViewController:imgPicker animated:YES completion:nil];
        }
            break;
        case 1:{
            imgPicker = [[UIImagePickerController alloc] init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imgPicker setDelegate:self];
            imgPicker.navigationBar.titleTextAttributes = @{
                                                            NSForegroundColorAttributeName:CLR_WHITE,
                                                            NSFontAttributeName: [UIFont fontWithName:FONT_SEMI_BOLD size:19.0f]
                                                            };
            imgPicker.navigationBar.translucent = NO;
            imgPicker.navigationBar.tintColor = CLR_WHITE;
            imgPicker.navigationBar.barTintColor = CLR_LIGHT_BLUE;
            [imgPicker setAllowsEditing:YES];
            [self presentViewController:imgPicker animated:YES completion:nil];
        }
            break;
    }
    
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
    [scrollRoot setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{
    [self setTitle:LocalizedString(@"edit-profile")];
    [btnSave setTitle:[LocalizedString(@"save") toUpper]];
    [lblName setText:LocalizedString(@"name")];
    [lblSurname setText:LocalizedString(@"surname")];
    [lblEmail setText:LocalizedString(@"email")];
    [lblPassword setText:LocalizedString(@"password")];
    [lblHood setText:LocalizedString(@"hood")];
    [lblPhoto setText:LocalizedString(@"profile-photo")];
}

@end
