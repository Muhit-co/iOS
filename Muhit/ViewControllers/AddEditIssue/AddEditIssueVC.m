//
//  AddEditIssueVC.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "AddEditIssueVC.h"
#import "PickFromMapVC.h"

@interface AddEditIssueVC (){
    NSDictionary *issueDict;
    IBOutlet UILabel *lblTitle,*lblDescription,*lblHood,*lblTags,*lblPhotos,*lblAnonim,*lblAddTag;
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextView *txtDescription;
    IBOutlet UIView *viewHood,*viewDescription,*viewTags,*viewPhotos,*viewAddTag,*viewAnonim;
    IBOutlet UIButton *btnSave,*btnAnonim,*btnAddTag,*btnAddPhoto,*btnHood;
    IBOutlet UIImageView *imgDownIconHood,*imgAnonim,*imgLocation,*imgAnonimTick,*imgLocationTick,*imgAddTag;
    IBOutlet NSLayoutConstraint *constPhotosViewWidth,*constBtnAddImageLeft,*constTagsViewHeight,*constBtnAddTagLeft,*constBtnAddTagTop,*constContainerHeight;
    BOOL isAnonim,displayOnce;
    float totalPhotosWidth,totalTagsWidth,lastTagsY;
    UIActionSheet *actionSheet;
    UIImagePickerController * imgPicker;
    NSMutableArray *arrPhotos,*arrTagIds,*arrTags;
    NSArray *dictTags;
    NSString *issueGeoCode,*issueCoordinate;
    TagSelectorVC *tagSelector;
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
    
    totalPhotosWidth = 0,totalTagsWidth = 0,lastTagsY = 0;
    tagSelector = [[TagSelectorVC alloc] init];
    [tagSelector setDelegate:self];
    [self getTags];
    [self adjustUI];
    
    [NC addObserver:self selector:@selector(geoCodePicked:) name:NC_GEOCODE_PICKED object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (issueDict && !displayOnce) {
        displayOnce = YES;
        [self setForEdit];
    }
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
-(void)updateViewConstraints{
    [super updateViewConstraints];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)geoCodePicked:(NSNotification*)notification{
    NSDictionary *dict = [notification object];
    issueGeoCode = dict[@"full"];
    issueCoordinate = dict[@"coordinates"];
    [btnHood setTitle:dict[@"hood"]];
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
    btnSave.layer.cornerRadius = cornerRadius;
    btnAddPhoto.layer.cornerRadius = cornerRadius;
    viewAddTag.layer.cornerRadius = cornerRadius;
    
    imgAnonimTick.layer.borderWidth = borderWidth;
    imgAnonimTick.layer.borderColor = [CLR_LIGHT_BLUE CGColor];
    imgAnonimTick.layer.cornerRadius = cornerRadius;
    imgAnonimTick.layer.masksToBounds = YES;
    
    imgLocationTick.layer.borderWidth = borderWidth;
    imgLocationTick.layer.borderColor = [CLR_LIGHT_BLUE CGColor];
    imgLocationTick.layer.cornerRadius = cornerRadius;
    imgLocationTick.layer.masksToBounds = YES;
    
    [imgDownIconHood setImage:[IonIcons imageWithIcon:ion_android_locate size:20 color:CLR_LIGHT_BLUE]];
    [imgAnonim setImage:[IonIcons imageWithIcon:ion_eye_disabled size:26 color:CLR_LIGHT_BLUE]];
    [imgLocation setImage:[IonIcons imageWithIcon:ion_location size:26 color:CLR_LIGHT_BLUE]];
    [btnAddPhoto setImage:[IonIcons imageWithIcon:ion_plus size:26 color:[UIColor whiteColor]]];
    [imgAddTag setImage:[IonIcons imageWithIcon:ion_plus size:15 color:[UIColor whiteColor]]];
    
    [imgAnonimTick setImage:[IonIcons imageWithIcon:ion_checkmark size:20 color:[UIColor whiteColor]]];
    [imgLocationTick setImage:[IonIcons imageWithIcon:ion_checkmark size:20 color:[UIColor whiteColor]]];
}

-(void)setForEdit{

    issueCoordinate = nilOrJson(issueDict[@"coordinates"]);
    issueGeoCode = nilOrJson(issueDict[@"location"]);
    [btnHood setTitle:issueDict[@"location"]];
    [txtTitle setText:issueDict[@"title"]];
    [txtDescription setText:issueDict[@"desc"]];
    
    isAnonim = ![issueDict[@"is_anonymous"] boolValue];
    [self actAnonim:nil];
    
    /************ Images Area ************/
    
    arrPhotos = [[NSMutableArray alloc] init];

    NSArray * arrImages = [NSArray arrayWithArray:issueDict[@"images"]];

    for (int i = 0; i < arrImages.count; i++) {

        NSString *imgUrl = [NSString stringWithFormat:@"%@/3000x3000/%@",IMAGE_PROXY,arrImages[i][@"image"]];

    	[[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imgUrl]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                [arrPhotos addObject:image];
                                if (i==arrImages.count-1) {
                                    [self refreshPhotosView];
                                    REMOVE_HUD
                                }
                            }
                        }];
    }
 	/************************************/
    
    /************ Tags Area ************/

    arrTags = [[NSMutableArray alloc] initWithArray:issueDict[@"tags"]];
    arrTagIds = [[NSMutableArray alloc] init];
    
    for (NSDictionary *tag in issueDict[@"tags"]) {
        [arrTagIds addObject: STRING_W_INT([tag[@"id"] intValue])];
    }
    
    [self refreshTagsView];
    /************************************/
}

-(void)getTags{
	ADD_HUD
    [SERVICES getTags:@"" handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
        }
        else{
            if (!issueDict) {
                REMOVE_HUD
            }
            dictTags = (NSArray *)response;
            [tagSelector setItems:(NSArray *)response];
        }
    }];
}

-(IBAction)actSearchHood:(id)sender{
    [ScreenOperations openPickFromMap];
}

-(IBAction)actAddPhoto:(id)sender{
    if (!actionSheet) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizedString(@"İptal") destructiveButtonTitle:nil otherButtonTitles:LocalizedString(@"Fotoğraf Çek"),LocalizedString(@"Kütüphaneden Seç"),nil];
    }

    [actionSheet showInView:self.view];
    [actionSheet reloadInputViews];
}

-(IBAction)actAddTag:(id)sender{
    [tagSelector show];
}

-(IBAction)actAnonim:(id)sender{
    if (isAnonim) {
        [imgAnonimTick setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [imgAnonimTick setBackgroundColor:CLR_LIGHT_BLUE];
    }
    isAnonim = !isAnonim;
}

-(IBAction)actSave:(id)sender{
    
    NSMutableArray *arrBase64Photos = [[NSMutableArray alloc] init];
    
    for (UIImage *image in arrPhotos) {
        [arrBase64Photos addObject:[UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    }
    
    NSString *issueId = nil;
    if (issueDict) {
    	issueId = STRING_W_INT([issueDict[@"id"] intValue]);
    }

    ADD_HUD
    [MuhitServices addOrUpdateIssue:txtTitle.text description:txtDescription.text location:issueGeoCode tags:arrTagIds images:arrBase64Photos isAnonymous:isAnonim coordinate:issueCoordinate issueId:issueId handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
        }
        else{
            if(response[@"id"]){
                [self back];
            }
                
            NSLog(@"addIssueResponse:%@",response);
        }
        REMOVE_HUD
    }];
}

-(void)actRemoveTag:(UIButton*)sender{
    NSString* tag = STRING_W_INT((int)sender.tag);
    
    NSUInteger index = [arrTagIds indexOfObject:tag];
    [arrTagIds removeObjectAtIndex:index];
   	[arrTags removeObjectAtIndex:index];
    [self refreshTagsView];
}

- (void)refreshTagsView{
    
    UIFont *tagFont = [UIFont fontWithName:@"SourceSansPro-Bold" size:16.0];

    for (UIView *view in [viewTags subviews]) {
        if (view != viewAddTag) {
            [view removeFromSuperview];
        }
    }
    
    if ([arrTags count] == 3) {
        [viewAddTag setHidden:YES];
    }
    else{
    	[viewAddTag setHidden:NO];
    }
    constBtnAddTagTop.constant = 0;
    constBtnAddTagLeft.constant = 0;

    constTagsViewHeight.constant = 30;
	[self.view layoutIfNeeded];
    constContainerHeight.constant = [viewAnonim bottomPosition] + 10;
    totalTagsWidth = 0;
    lastTagsY = 0;
    
    for (NSDictionary* tag in arrTags) {
        
        float lblWidth = [[tag[@"name"] toUpper] sizeWithAttributes:@{NSFontAttributeName:tagFont}].width;
        float viewItemWidth = lblWidth + 35;
        
        if ((totalTagsWidth + viewItemWidth)>lblTags.width) {
            totalTagsWidth = 0;
            lastTagsY += 40;
            constTagsViewHeight.constant = 30 + lastTagsY;
            [self.view layoutIfNeeded];
            constContainerHeight.constant = [viewAnonim bottomPosition] + 10;
            [self.view layoutIfNeeded];
        }
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, lblWidth, 30)];
        [lbl setText:[tag[@"name"] toUpper]];
        [lbl setFont:tagFont];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:[UIColor whiteColor]];

        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(viewItemWidth-30, 0, 30, 30)];
        btn.tag = [tag[@"id"] intValue];
        [btn addTarget:self action:@selector(actRemoveTag:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[IonIcons imageWithIcon:ion_close size:15 color:[UIColor whiteColor]]];
        
        UIView *viewItem = [[UIView alloc] initWithFrame:CGRectMake(totalTagsWidth, lastTagsY, viewItemWidth, 30)];
        viewItem.layer.cornerRadius = cornerRadius;
        [viewItem setClipsToBounds:YES];
        [viewItem setBackgroundColor:[HXColor colorWithHexString:tag[@"background"]]];
        [viewItem addSubview:lbl];
        [viewItem addSubview:btn];
        
        totalTagsWidth += viewItemWidth + 10;
        
        if (totalTagsWidth+80>lblTags.width && [arrTags count] != 3) {
            totalTagsWidth = 0;
            lastTagsY += 40;
            constTagsViewHeight.constant = 30 + lastTagsY;
            [self.view layoutIfNeeded];
            constContainerHeight.constant = [viewAnonim bottomPosition] + 10;
            [self.view layoutIfNeeded];
        }
        
        constBtnAddTagTop.constant = lastTagsY;
        constBtnAddTagLeft.constant = totalTagsWidth;
        
        [viewTags addSubview:viewItem];
        [viewTags addSubview:viewAddTag];
        
        [self.view layoutIfNeeded];
    }
}

-(void)actRemovePhoto:(UIButton*)sender{
   	[arrPhotos removeObjectAtIndex:sender.tag];
    [self refreshPhotosView];
}

-(void)refreshPhotosView{
    [viewPhotos removeSubviews];
    
    if ([arrPhotos count] == 3) {
        [btnAddPhoto setHidden:YES];
    }
    else{
    	[btnAddPhoto setHidden:NO];
    }
    
    if ([arrPhotos count] == 0) {
        constPhotosViewWidth.constant = 0;
        constBtnAddImageLeft.constant = 0;
    }
    else{
        totalPhotosWidth = 0;
        
        for (int i=0; i<arrPhotos.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:arrPhotos[i]];
            [imgView setFrame:CGRectMake(totalPhotosWidth, 0, 45, 45)];
            imgView.layer.cornerRadius = cornerRadius;
            imgView.layer.masksToBounds = YES;
            
            UIButton *btn = [[UIButton alloc] initWithFrame:imgView.frame];
            [btn setTag:i];
            [btn addTarget:self action:@selector(actRemovePhoto:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[IonIcons imageWithIcon:ion_close size:25 color:[UIColor whiteColor]]];
            [btn setAlpha:07];
            
            [viewPhotos addSubview:imgView];
            [viewPhotos addSubview:btn];
            totalPhotosWidth+= 55;
            constPhotosViewWidth.constant = totalPhotosWidth-10;
            constBtnAddImageLeft.constant = 10;
            [self.view layoutIfNeeded];
        }
    }
}

#pragma mark - TagSelector

- (void)selectedTagIndex:(int)index{

    if (!arrTags) {
        arrTags = [[NSMutableArray alloc] init];
    }
    if (!arrTagIds) {
        arrTagIds = [[NSMutableArray alloc] init];
    }
    for (NSString *tag in arrTagIds) {
        if ([tag isEqualToString:STRING_W_INT([dictTags[index][@"id"] intValue])]) {
            return;
        }
    }
    
    [arrTags addObject:dictTags[index]];
    [arrTagIds addObject: STRING_W_INT([dictTags[index][@"id"] intValue])];
    
    [self refreshTagsView];
}

#pragma mark - UIImagePickerViewController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (!arrPhotos) {
        arrPhotos = [[NSMutableArray alloc] init];
    }
    
    [arrPhotos addObject:image];

    [self refreshPhotosView];
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
            imgPicker.navigationBar.titleTextAttributes = @{
                                                            NSForegroundColorAttributeName:[UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"SourceSansPro-Semibold" size:19.0f]
                                                            };
            [self presentViewController:imgPicker animated:YES completion:nil];
        }
        break;
        case 1:{
            imgPicker = [[UIImagePickerController alloc] init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imgPicker setDelegate:self];
            imgPicker.navigationBar.titleTextAttributes = @{
                                                         NSForegroundColorAttributeName:CLR_LIGHT_BLUE,
                                                         NSFontAttributeName: [UIFont fontWithName:@"SourceSansPro-Semibold" size:19.0f]
                                                         };
            [self presentViewController:imgPicker animated:YES completion:nil];
        }
        break;
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{

    [lblTitle setText:LocalizedString(@"Başlık")];
    [lblDescription setText:LocalizedString(@"Açıklama")];
    [lblHood setText:LocalizedString(@"Mahalle")];
    [lblTags setText:LocalizedString(@"Etiketler (max 3)")];
    [lblPhotos setText:LocalizedString(@"Resimler (max 3)")];
    [lblAnonim setText:LocalizedString(@"Anonim olarak başvuru yap")];
    [lblAddTag setText:[LocalizedString(@"Ekle") toUpper]];
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
