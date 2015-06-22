//
//  AddEditIssueVC.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "AddEditIssueVC.h"

@interface AddEditIssueVC (){
    NSDictionary *issueDict;
    IBOutlet UILabel *lblTitle,*lblDescription,*lblHood,*lblTags,*lblPhotos,*lblAnonim,*lblLocation;
    IBOutlet UITextField *txtTitle,*txtHood,*txtTags;
    IBOutlet UITextView *txtDescription;
    IBOutlet UIView *viewHood,*viewDescription,*viewTags,*viewPhotos;
    IBOutlet UIButton *btnSave,*btnAnonim,*btnLocation,*btnAddTag,*btnAddPhoto;
    IBOutlet UIImageView *imgDownIconHood,*imgDownIconTag,*imgAnonim,*imgLocation,*imgAnonimTick,*imgLocationTick;
    IBOutlet NSLayoutConstraint *constPhotosViewWidth;
    BOOL isAnonim,isShowLocation;
    float totalWidth;
    UIActionSheet *actionSheet;
    UIImagePickerController * imgPicker;
    NSMutableArray *arrPhotos;
}

@end

@implementation AddEditIssueVC

- (id)initWithInfo:(NSDictionary *)_info{
    self = [super init];
    if (self){
        issueDict = _info;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    totalWidth = 0;
    [self adjustUI];
    if (issueDict) {
        [self setForEdit];
    }
    else{
        [self setForAdd];
    }
}

-(void)adjustUI{
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat borderWidth = 1;
    
    txtTitle.layer.cornerRadius = cornerRadius;
    txtTitle.layer.borderWidth = borderWidth;
    txtTitle.layer.borderColor = [CLR_LIGHT_BLUE CGColor];
    viewDescription.layer.cornerRadius = cornerRadius;
    viewDescription.layer.borderWidth = borderWidth;
    viewDescription.layer.borderColor = [CLR_LIGHT_BLUE CGColor];
    viewHood.layer.cornerRadius = cornerRadius;
    viewHood.layer.borderWidth = borderWidth;
    viewHood.layer.borderColor = [CLR_LIGHT_BLUE CGColor];
    viewTags.layer.cornerRadius = cornerRadius;
    viewTags.layer.borderWidth = borderWidth;
    viewTags.layer.borderColor = [CLR_LIGHT_BLUE CGColor];
    btnSave.layer.cornerRadius = cornerRadius;
    btnAddPhoto.layer.cornerRadius = cornerRadius;
    
    imgAnonimTick.layer.borderWidth = borderWidth;
    imgAnonimTick.layer.borderColor = [CLR_LIGHT_BLUE CGColor];
    imgAnonimTick.layer.cornerRadius = cornerRadius;
    imgAnonimTick.layer.masksToBounds = YES;
    
    imgLocationTick.layer.borderWidth = borderWidth;
    imgLocationTick.layer.borderColor = [CLR_LIGHT_BLUE CGColor];
    imgLocationTick.layer.cornerRadius = cornerRadius;
    imgLocationTick.layer.masksToBounds = YES;
    
    [imgDownIconHood setImage:[IonIcons imageWithIcon:ion_chevron_down size:20 color:CLR_LIGHT_BLUE]];
    [imgDownIconTag setImage:[IonIcons imageWithIcon:ion_chevron_down size:20 color:CLR_LIGHT_BLUE]];
    [imgAnonim setImage:[IonIcons imageWithIcon:ion_eye_disabled size:26 color:CLR_LIGHT_BLUE]];
    [imgLocation setImage:[IonIcons imageWithIcon:ion_location size:26 color:CLR_LIGHT_BLUE]];
    [btnAddTag setImage:[IonIcons imageWithIcon:ion_plus size:26 color:CLR_LIGHT_BLUE]];
    [btnAddPhoto setImage:[IonIcons imageWithIcon:ion_plus size:26 color:[UIColor whiteColor]]];
    
    [imgAnonimTick setImage:[IonIcons imageWithIcon:ion_checkmark size:20 color:[UIColor whiteColor]]];
    [imgLocationTick setImage:[IonIcons imageWithIcon:ion_checkmark size:20 color:[UIColor whiteColor]]];
}

-(void)setForEdit{
}

-(void)setForAdd{
}


-(IBAction)actAddPhoto:(id)sender{
    if (!actionSheet) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizedString(@"İptal") destructiveButtonTitle:nil otherButtonTitles:LocalizedString(@"Fotoğraf Çek"),LocalizedString(@"Kütüphaneden Seç"),nil];
    }

    [actionSheet showInView:self.view];
    [actionSheet reloadInputViews];
}

-(IBAction)actAddTag:(id)sender{
    
}

-(IBAction)actAnonim:(id)sender{
    NSLog(@"anonim:%d",isAnonim);
    if (isAnonim) {
        [imgAnonimTick setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [imgAnonimTick setBackgroundColor:CLR_LIGHT_BLUE];
    }
    isAnonim = !isAnonim;
}

-(IBAction)actLocation:(id)sender{
    NSLog(@"location:%d",isShowLocation);
    if (isShowLocation) {
        [imgLocationTick setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [imgLocationTick setBackgroundColor:CLR_LIGHT_BLUE];
    }
    isShowLocation = !isShowLocation;
}

-(IBAction)actSave:(id)sender{
    
}

#pragma mark - UIImagePickerViewController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSLog(@"picked:%@",info);
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (!arrPhotos) {
        arrPhotos = [[NSMutableArray alloc] init];
    }
    
    [arrPhotos addObject:image];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    [imgView setFrame:CGRectMake(totalWidth, 0, 45, 45)];
    imgView.layer.cornerRadius = cornerRadius;
    imgView.layer.masksToBounds = YES;
    [viewPhotos addSubview:imgView];
    totalWidth+= 55;
    constPhotosViewWidth.constant = totalWidth-10;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{

    [lblTitle setText:LocalizedString(@"Başlık")];
    [lblDescription setText:LocalizedString(@"Açıklama")];
    [lblHood setText:LocalizedString(@"Mahalle")];
    [lblTags setText:LocalizedString(@"Etiketler")];
    [lblPhotos setText:LocalizedString(@"Resimler")];
    [lblAnonim setText:LocalizedString(@"Anonim olarak başvuru yap")];
    [lblLocation setText:LocalizedString(@"Yerimi belirle")];
    
    if (issueDict) {
        [self setTitle:LocalizedString(@"Düzenle")];
        [btnSave setTitle:LocalizedString(@"Kaydet")];
    }
    else{
        [self setTitle:LocalizedString(@"Ekle")];
        [btnSave setTitle:LocalizedString(@"Ekle")];
    }
    
}

@end
