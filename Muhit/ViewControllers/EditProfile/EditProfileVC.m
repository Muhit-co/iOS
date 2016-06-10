//
//  EditProfileVC.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "EditProfileVC.h"

@interface EditProfileVC (){
    IBOutlet MTTextField *txtName,*txtSurname,*txtEmail,*txtUsername,*txtPassword;
    IBOutlet UILabel *lblName,*lblSurname,*lblEmail,*lblUsername,*lblPassword,*lblHood,*lblPicture;
    IBOutlet UIButton *btnSave,*btnChangePicture,*btnHood;
    IBOutlet UIPickerView *pickerHood;
    IBOutlet UIImageView *imgDownIcon,*imgProfile;
    IBOutlet UIView *viewHood;
    NSArray *arrHoods;
    NSString *fullGeoCode;
    KeyboardControls *keyboardControl;
    UIActionSheet *actionSheet;
    UIImagePickerController * imgPicker;
    NSDictionary *profileDict;
}

@end

@implementation EditProfileVC

- (id)initWithInfo:(NSDictionary *)_info{
    self = [super init];
    if (self){
        profileDict = _info;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    
    NSArray *txtFields = @[txtName, txtSurname, txtEmail,txtUsername,txtPassword];
    keyboardControl = [[KeyboardControls alloc] initWithFields:txtFields];
    [keyboardControl setDelegate:self];
    
    [self setDetailsWithDictionary:profileDict];
    
    [NC addObserver:self selector:@selector(geoCodePicked:) name:NC_GEOCODE_PICKED object:nil];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [btnSave setSize:CGSizeMake(70, 36)];
    UIBarButtonItem *barBtnSave = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    [[self navigationItem] setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, barBtnSave, nil] animated:NO];
    [self.view layoutIfNeeded];
}

-(void)setDetailsWithDictionary:(NSDictionary*)dict{
    
    [txtUsername setText:dict[@"username"]];
    [txtName setText:dict[@"first_name"]];
    [txtSurname setText:dict[@"last_name"]];
    [txtEmail setText:dict[@"email"]];
    [btnHood setTitle:dict[@"address"]];
    fullGeoCode = dict[@"address"];
    
    NSString *imgUrl = [NSString stringWithFormat:@"%@/180x180/%@",IMAGE_PROXY,dict[@"picture"]];
    [imgProfile sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
}

- (void)geoCodePicked:(NSNotification*)notification{
    NSDictionary *dict = [notification object];
    fullGeoCode = dict[@"full"];
    [btnHood setTitle:dict[@"hood"]];
}

-(void)adjustUI{
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat borderWidth = 1;
    
    txtName.layer.cornerRadius = cornerRadius;
    txtName.layer.borderWidth = borderWidth;
    txtName.layer.borderColor = [CLR_LIGHT_BLUE CGColor];
    txtSurname.layer.cornerRadius = cornerRadius;
    txtSurname.layer.borderWidth = borderWidth;
    txtSurname.layer.borderColor = [CLR_LIGHT_BLUE CGColor];
    txtEmail.layer.cornerRadius = cornerRadius;
    txtEmail.layer.borderWidth = borderWidth;
    txtEmail.layer.borderColor = [[HXColor hx_colorWithHexRGBAString:@"eeeeee"] CGColor];
    txtUsername.layer.cornerRadius = cornerRadius;
    txtUsername.layer.borderWidth = borderWidth;
    txtUsername.layer.borderColor = [[HXColor hx_colorWithHexRGBAString:@"eeeeee"] CGColor];
    txtPassword.layer.cornerRadius = cornerRadius;
    txtPassword.layer.borderWidth = borderWidth;
    txtPassword.layer.borderColor = [CLR_LIGHT_BLUE CGColor];
    viewHood.layer.cornerRadius = cornerRadius;
    viewHood.layer.borderWidth = borderWidth;
    viewHood.layer.borderColor = [CLR_LIGHT_BLUE CGColor];
    btnSave.layer.cornerRadius = cornerRadius;
    imgProfile.layer.cornerRadius = 45;
    imgProfile.layer.masksToBounds = YES;
    
    [imgDownIcon setImage:[IonIcons imageWithIcon:ion_chevron_down size:26 color:CLR_LIGHT_BLUE]];
}

-(IBAction)actSave:(id)sender{
    ADD_HUD
    NSString * picture = [UIImagePNGRepresentation(imgProfile.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [MuhitServices updateProfile:txtName.text lastName:txtSurname.text password:txtPassword.text activeHood:fullGeoCode picture:picture handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
            REMOVE_HUD
        }
        else{
            NSLog(@"updateProfileResponse:%@",response);
        }
    }];
}

-(IBAction)actSearchHood:(id)sender{
    [ScreenOperations openPickFromMap];
}

-(IBAction)actChangePicture:(id)sender{
    if (!actionSheet) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizedString(@"İptal") destructiveButtonTitle:nil otherButtonTitles:LocalizedString(@"Fotoğraf Çek"),LocalizedString(@"Kütüphaneden Seç"),nil];
    }
    
    [actionSheet showInView:self.view];
    [actionSheet reloadInputViews];
}

#pragma mark - UIImagePickerViewController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imgProfile setImage:image];
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
            [self presentViewController:imgPicker animated:YES completion:nil];
        }
            break;
        case 1:{
            imgPicker = [[UIImagePickerController alloc] init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            [self presentViewController:imgPicker animated:YES completion:nil];
        }
            break;
    }
    
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
    [self setTitle:LocalizedString(@"Profili Düzenle")];
    [btnSave setTitle:LocalizedString(@"Kaydet")];
    [lblName setText:LocalizedString(@"Ad")];
    [lblSurname setText:LocalizedString(@"Soyad")];
    [lblEmail setText:LocalizedString(@"E-posta adresi")];
    [lblUsername setText:LocalizedString(@"Kullanıcı adı")];
    [lblPassword setText:LocalizedString(@"Şifre")];
    [lblHood setText:LocalizedString(@"Mahalle")];
    [lblPicture setText:LocalizedString(@"Değiştir")];
}

@end
