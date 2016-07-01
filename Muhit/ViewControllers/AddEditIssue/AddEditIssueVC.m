//
//  AddEditIssueVC.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "AddEditIssueVC.h"
#import "PickFromMapVC.h"

@interface AddEditIssueVC ()<UIAlertViewDelegate>{
    NSDictionary *issueDict;
    IBOutlet UILabel *lblTitle,*lblProblem,*lblSolution,*lblHood,*lblTags,*lblPhotos,*lblAnonim,*lblAddTag;
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextView *txtProblem,*txtSolution;
    IBOutlet UIView *viewHood,*viewProblem,*viewSolution,*viewTags,*viewPhotos,*viewAddTag,*viewAnonim;
    IBOutlet UIButton *btnSave,*btnAnonim,*btnAddTag,*btnAddPhoto,*btnHood;
    IBOutlet UIImageView *imgDownIconHood,*imgAddTag;
    IBOutlet NSLayoutConstraint *constBtnAddImageTop,*constTagsViewHeight,*constBtnAddTagLeft,*constBtnAddTagTop,*constContainerHeight;
    BOOL displayOnce;
    float totalPhotosWidth,totalTagsWidth,lastTagsY;
    UIActionSheet *actionSheet;
    UIImagePickerController * imgPicker;
    NSMutableArray *arrPhotos,*arrTagIds,*arrTags;
    NSString *issueGeoCode,*issueCoordinate;
    TagSelectorVC *tagSelector;
    KeyboardControls *keyboardControl;
    UIBarButtonItem *barBtnSave;
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
    tagSelector = [[TagSelectorVC alloc] initWithDelegate:self];
    
    keyboardControl = [[KeyboardControls alloc] initWithFields:@[txtTitle ,txtProblem,txtSolution]];
    [keyboardControl setDelegate:self];
    
    barBtnSave = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    [self.navigationItem setRightBarButtonItem:barBtnSave];
    [NC addObserver:self selector:@selector(geoCodePicked:) name:NC_GEOCODE_PICKED object:nil];
    
    [self getTags];
    [self adjustUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    
    float totalHeight = 453 + constTagsViewHeight.constant + constBtnAddImageTop.constant+80;
    [scrollRoot setContentSize:CGSizeMake([UF screenSize].width, totalHeight)];
    constContainerHeight.constant = totalHeight;
    [self.view layoutIfNeeded];
}

-(void)dealloc{
    [NC removeObserver:self name:NC_GEOCODE_PICKED object:nil];
}


-(void)adjustUI{
    [[self view] setBackgroundColor:[HXColor hx_colorWithHexRGBAString:@"EEEEEE"]];
    
    [btnSave setSize:CGSizeMake(70, 35)];
    txtTitle.layer.cornerRadius = cornerRadius;
    viewProblem.layer.cornerRadius = cornerRadius;
    viewSolution.layer.cornerRadius = cornerRadius;
    viewHood.layer.cornerRadius = cornerRadius;
    btnSave.layer.cornerRadius = 4;
    btnAddPhoto.layer.cornerRadius = cornerRadius;
    viewAddTag.layer.cornerRadius = cornerRadius;
    
    [imgDownIconHood setImage:[IonIcons imageWithIcon:ion_chevron_down size:18 color:[HXColor hx_colorWithHexRGBAString:@"9999AA"]]];
    [btnAddPhoto setImage:[IonIcons imageWithIcon:ion_camera size:16 color:CLR_WHITE]];
    [imgAddTag setImage:[IonIcons imageWithIcon:ion_chevron_down size:18 color:[HXColor hx_colorWithHexRGBAString:@"9999AA"]]];
}


- (void)geoCodePicked:(NSNotification*)notification{
    NSDictionary *dict = [notification object];
    issueGeoCode = dict[@"full"];
    issueCoordinate = dict[@"coordinates"];
    [btnHood setTitle:dict[@"hood"]];
}

-(void)setForEdit{
    
    issueCoordinate = nilOrJson(issueDict[@"coordinates"]);
    issueGeoCode = nilOrJson(issueDict[@"location"]);
    [btnHood setTitle:issueDict[@"location"]];
    [txtTitle setText:issueDict[@"title"]];
    [txtProblem setText:issueDict[@"problem"]];
    [txtSolution setText:issueDict[@"solution"]];
    
    [btnAnonim setSelected:[issueDict[@"is_anonymous"] boolValue]];
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
    if ([MT arrIssueTags]) {
        [tagSelector setItems:[MT arrIssueTags]];
    }
    else{
        ADD_HUD
        [SERVICES getTagsWithhandler:^(NSDictionary *response, NSError *error) {
            if (error) {
                SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
                REMOVE_HUD
            }
            else{
                if (!issueDict) {
                    REMOVE_HUD
                }
                [MT setArrIssueTags:response[@"tags"]];
                [tagSelector setItems:[MT arrIssueTags]];
            }
        }];
    }
}

#pragma mark - IBActions

-(IBAction)actSave:(id)sender{
    
    if (![UF validateIssue:txtTitle.text problem:txtProblem.text solution:txtSolution.text]){
        [self.view endEditing:YES];
        [scrollRoot setContentOffset:CGPointMake(0,0) animated:YES];
        return;
    }
    
    NSMutableArray *arrBase64Photos = [[NSMutableArray alloc] init];
    
    for (UIImage *image in arrPhotos) {
        [arrBase64Photos addObject:[UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    }
    
    NSString *issueId = nil;
    if (issueDict) {
        issueId = STRING_W_INT([issueDict[@"id"] intValue]);
    }
    
    ADD_HUD
    [SERVICES addOrUpdateIssue:txtTitle.text problem:txtProblem.text solution:txtSolution.text location:issueGeoCode tags:arrTagIds images:arrBase64Photos isAnonymous:btnAnonim.isSelected coordinate:issueCoordinate issueId:issueId handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            REMOVE_HUD
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
        }
        else{
            REMOVE_HUD
            if(response[@"issue"]){
                SHOW_ALERT_WITH_TAG_AND_DELEGATE(LocalizedString(@"issue-added"), 1, self);
            }
            
            NSLog(@"addIssueResponse:%@",response);
        }
        
    }];
}

-(IBAction)actSearchHood:(id)sender{
    [ScreenOperations openPickFromMap];
}

-(IBAction)actAddPhoto:(id)sender{
    if (!actionSheet) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizedString(@"cancel") destructiveButtonTitle:nil otherButtonTitles:LocalizedString(@"take-photo"),LocalizedString(@"pick-from-library"),nil];
    }
    
    [actionSheet showInView:self.view];
    [actionSheet reloadInputViews];
}

-(IBAction)actAddTag:(id)sender{
    [tagSelector show];
    [[self navigationItem] setRightBarButtonItem:barBtnSave];
}

-(IBAction)actAnonim:(id)sender{
    [btnAnonim setSelected:![btnAnonim isSelected]];
}


-(void)actRemoveTag:(UIButton*)sender{
    NSString* tag = STRING_W_INT((int)sender.tag);
    
    NSUInteger index = [arrTagIds indexOfObject:tag];
    [arrTagIds removeObjectAtIndex:index];
   	[arrTags removeObjectAtIndex:index];
    [self refreshTagsView];
}

- (void)refreshTagsView{
    
    UIFont *tagFont = [UIFont fontWithName:FONT_BOLD size:16.0];
    
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
        [viewItem setBackgroundColor:[HXColor hx_colorWithHexRGBAString:tag[@"background"]]];
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
    
    if ([arrPhotos count] == 0) {
        constBtnAddImageTop.constant = 5;
        [self.view setNeedsLayout];
    }
    else{
        totalPhotosWidth = 0;
        
        for (int i=0; i<arrPhotos.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:arrPhotos[i]];
            [imgView setFrame:CGRectMake(totalPhotosWidth, 0, 60, 60)];
            imgView.layer.cornerRadius = cornerRadius;
            imgView.layer.masksToBounds = YES;
            
            UIButton *btn = [[UIButton alloc] initWithFrame:imgView.frame];
            [btn setTag:i];
            [btn addTarget:self action:@selector(actRemovePhoto:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[IonIcons imageWithIcon:ion_close size:14 color:CLR_WHITE]];
            [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [btn setContentEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 5)];
            [btn setAlpha:07];
            
            [viewPhotos addSubview:imgView];
            [viewPhotos addSubview:btn];
            totalPhotosWidth+= 70;
        }
        
        if ([arrPhotos count] == 3) {
            [btnAddPhoto setHidden:YES];
            constBtnAddImageTop.constant = 35;
        }
        else{
            [btnAddPhoto setHidden:NO];
            constBtnAddImageTop.constant = 75;
        }
    }
    [self.view layoutIfNeeded];
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
        if ([tag isEqualToString:STRING_W_INT([[MT arrIssueTags][index][@"id"] intValue])]) {
            return;
        }
    }
    
    [arrTags addObject:[MT arrIssueTags][index]];
    [arrTagIds addObject: STRING_W_INT([[MT arrIssueTags][index][@"id"] intValue])];
    
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [imgPicker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
                                                            NSForegroundColorAttributeName:CLR_LIGHT_BLUE,
                                                            NSFontAttributeName: [UIFont fontWithName:FONT_SEMI_BOLD size:19.0f]
                                                            };
            [self presentViewController:imgPicker animated:YES completion:nil];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        [self back];
    }
}

#pragma mark - Keyboard Controls Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [scrollRoot setContentOffset:CGPointMake(0,textView.superview.frame.origin.y - 25 ) animated:YES];
    [keyboardControl setActiveField:textView];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [self resetScrollOffset];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UF logFrame:textField identifier:@"field2"];
    [scrollRoot setContentOffset:CGPointMake(0,textField.frame.origin.y - 25 ) animated:YES];
    [keyboardControl setActiveField:textField];
}

- (void)keyboardControls:(KeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(KeyboardControlsDirection)direction{
    if ([field isKindOfClass:[UITextField class]]) {
        [UF logFrame:field identifier:@"field1"];
        [scrollRoot setContentOffset:CGPointMake(0,field.frame.origin.y - 25 ) animated:YES];
    }
    else{
        [scrollRoot setContentOffset:CGPointMake(0,field.superview.frame.origin.y - 25 ) animated:YES];
    }
}

- (void)keyboardControlsDonePressed:(KeyboardControls *)keyboardControls{
    [self.view endEditing:YES];
    [self resetScrollOffset];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{
    [lblTitle setText:LocalizedString(@"title")];
    [lblProblem setText:LocalizedString(@"problem")];
    [lblSolution setText:LocalizedString(@"solution")];
    [lblHood setText:LocalizedString(@"hood")];
    [lblTags setText:LocalizedString(@"tags-max-3")];
    [lblPhotos setText:LocalizedString(@"photos-max-3")];
    [lblAnonim setText:LocalizedString(@"anonymus-issue")];
    [lblAddTag setText:LocalizedString(@"choose-tag")];
    [btnAddPhoto setTitle:[LocalizedString(@"add-photo") toUpper]];
    
    if (issueDict) {
        [self setTitle:LocalizedString(@"edit")];
        [btnSave setTitle:[LocalizedString(@"save") toUpper]];
    }
    else{
        [self setTitle:LocalizedString(@"add")];
        [btnSave setTitle:[LocalizedString(@"save") toUpper]];
    }
}

@end
