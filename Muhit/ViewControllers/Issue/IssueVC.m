//
//  IssueVC.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "IssueVC.h"
#import "AnnouncementCell.h"

@interface IssueVC (){
    IBOutlet UILabel *lblSupportTitle,*lblSupportCount,*lblHood,*lblDate,*lblType,*lblIssueTitle,*lblIssueDescription,*lblCommentTitle,*lblCreatorName;
    IBOutlet UIButton *btnBack,*btnSupport,*btnEdit;
    IBOutlet UIImageView *imgLocationIcon,*imgTypeIcon,*imgCreator;
    IBOutlet UIView *viewSupport,*viewType,*viewTagsContainer,*viewCommentsHolder;
    IBOutlet UIScrollView *scrollImages;
    IBOutlet UITableView *tblComments;
    IBOutlet UIPageControl *pageControl;
    IBOutlet NSLayoutConstraint *contTitleHeight,*constDescriptionHeight,*constViewTypeWidth,*constTagsViewHeight,*constContainerHeight;
    NSDictionary *detail;
    NSArray *arrComments;
    IBOutlet GMSMapView *map;
    NSString *issueCoordinate;
}

@end

@implementation IssueVC

- (id)initWithDetail:(NSDictionary *)_detail{
    self = [super init];
    if (self){
        detail = _detail;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_HUD_TOP
    [btnEdit setHidden:YES];
    [btnSupport setHidden:YES];
    [scrollRoot setHidden:YES];
    [self adjustUI];
    self.automaticallyAdjustsScrollViewInsets=NO;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view layoutIfNeeded];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setDetailsWithDictionary:detail];
}

- (void)viewWillAppear:(BOOL)animated {
    [[MT navCon] setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[MT navCon] setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)setDetailsWithDictionary:(NSDictionary*)dict{
    NSLog(@"issueDetail:%@",dict);

    if ([dict[@"user_id"] integerValue] == [UD integerForKey:UD_USER_ID]) {
        [btnEdit setHidden:NO];
        [btnSupport setHidden:YES];
    }
    else{
        [btnEdit setHidden:YES];
        [btnSupport setHidden:NO];
    }

    arrComments = [NSArray arrayWithArray:dict[@"comments"]];
    [tblComments reloadData];
	[imgCreator sd_setImageWithURL:[NSURL URLWithString:dict[@"user"][@"picture"]] placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
    
    [lblCreatorName setText:[NSString stringWithFormat:@"%@ %@",dict[@"user"][@"first_name"],dict[@"user"][@"last_name"]]];
    [lblSupportCount setText:[dict[@"supporter_counter"] stringValue]];
    
    [lblHood setText:dict[@"location"]];
    [lblDate setText:[UF getDetailedDateString:dict[@"created_at"]]];
    [lblIssueTitle setText:dict[@"title"]];
    [lblIssueDescription setText:dict[@"desc"]];
    
    issueCoordinate = nilOrJson(dict[@"coordinates"]);
    
    if ([dict[@"status"] isEqualToString:@"new"]) {
        [lblType setText:LocalizedString(@"Başvuruldu")];
        [viewType setBackgroundColor:[HXColor colorWithHexString:@"44a2e0"]];
        [imgTypeIcon setImage:[IonIcons imageWithIcon:ion_lightbulb size:20 color:[HXColor colorWithHexString:@"FFFFFF"]]];
    }
    else if ([dict[@"status"] isEqualToString:@"developing"]){
        [lblType setText:LocalizedString(@"Gelişmekte")];
        [viewType setBackgroundColor:[HXColor colorWithHexString:@"c677ea"]];
        [imgTypeIcon setImage:[IonIcons imageWithIcon:ion_wrench size:20 color:[HXColor colorWithHexString:@"FFFFFF"]]];
    }
    else{
        [lblType setText:LocalizedString(@"Çözüldü")];
        [viewType setBackgroundColor:[HXColor colorWithHexString:@"27ae61"]];
        [imgTypeIcon setImage:[IonIcons imageWithIcon:ion_checkmark_circled size:20 color:[HXColor colorWithHexString:@"FFFFFF"]]];
    }
    
    CGSize textSize = [[lblType text] sizeWithAttributes:@{NSFontAttributeName:[lblType font]}];
    constViewTypeWidth.constant = 40 + textSize.width;
    
    /************ Images Area ************/
    NSArray * arrImages = [NSArray arrayWithArray:dict[@"images"]];
    [scrollImages removeSubviews];
    [pageControl setNumberOfPages:arrImages.count];
    
    if (arrImages.count==0) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [img setImage:[UIImage imageNamed:@"issuePlaceholder"]];
        [scrollImages addSubview:img];
        [img centerInSuperView];
    }
    else{
        for (int i = 0; i < arrImages.count; i++) {
            CGRect frame;
            frame.origin.x = scrollImages.width * i;
            frame.origin.y = 0;
            frame.size = scrollImages.frame.size;
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:frame];
            NSString *imgUrl = [NSString stringWithFormat:@"%@/%dx%d/%@",IMAGE_PROXY,2*(int)frame.size.width,2*(int)frame.size.height,arrImages[i][@"image"]];
            [UF logFrame:img identifier:@"imageView"];
            [img sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"issuePlaceholder"]];
            [scrollImages addSubview:img];
        }
        
        if (issueCoordinate) {
            [pageControl setNumberOfPages:arrImages.count + 1];
            [scrollImages setContentSize:CGSizeMake(scrollImages.frame.size.width * (arrImages.count+1), scrollImages.frame.size.height)];
        }
        else{
            [pageControl setNumberOfPages:arrImages.count];
        	[scrollImages setContentSize:CGSizeMake(scrollImages.frame.size.width * arrImages.count, scrollImages.frame.size.height)];
        }
        
    }
    /**************************************/
    
    /************ Map Area ************/
    
    
    if (issueCoordinate) {
        
        CGRect frame = scrollImages.frame;
        frame.origin.x = scrollImages.contentSize.width - scrollImages.width;
        
        NSArray *points = [issueCoordinate componentsSeparatedByString:@", "];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[points[0] floatValue] longitude:[points[1] floatValue] zoom:15];
        
        map = [GMSMapView mapWithFrame:frame camera:camera];;
        map.settings.rotateGestures = NO;
        map.settings.tiltGestures = NO;
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = camera.target;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.groundAnchor = CGPointMake(0.5, 1);
        marker.icon = [IonIcons imageWithIcon:ion_location size:60 color:CLR_LIGHT_BLUE];
        marker.map = map;
        
        [scrollImages addSubview:map];
    }
    
    /**************************************/
    
    /************ Tags Area ************/
    float totalTagsWidth = 0,lastTagsY = 0;
    UIFont *tagFont = [UIFont fontWithName:@"SourceSansPro-Bold" size:16.0];
    [viewTagsContainer removeSubviews];
    
    for (NSDictionary* tag in dict[@"tags"]) {
        
        float lblWidth = [[tag[@"name"] toUpper] sizeWithAttributes:@{NSFontAttributeName:tagFont}].width;
        float viewItemWidth = lblWidth + 10;
        
        if ((totalTagsWidth + viewItemWidth)>viewTagsContainer.width) {
            totalTagsWidth = 0;
            lastTagsY += 40;
            constTagsViewHeight.constant = 30 + lastTagsY;
//            constContainerHeight.constant += 40;
        }
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, lblWidth, 30)];
        [lbl setText:[tag[@"name"] toUpper]];
        [lbl setFont:tagFont];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:[UIColor whiteColor]];
        

        UIView *viewItem = [[UIView alloc] initWithFrame:CGRectMake(totalTagsWidth, lastTagsY, viewItemWidth, 30)];
        viewItem.layer.cornerRadius = cornerRadius;
        [viewItem setClipsToBounds:YES];
        [viewItem setBackgroundColor:[HXColor colorWithHexString:tag[@"background"]]];
        [viewItem addSubview:lbl];
        
        totalTagsWidth += viewItemWidth + 10;
        
        [viewTagsContainer addSubview:viewItem];
    }
     /**************************************/
    [scrollRoot setContentSize:CGSizeMake(scrollRoot.width, viewTagsContainer.bottomPosition + 10)];
    
    constContainerHeight.constant = viewTagsContainer.bottomPosition +10;
    [self.view layoutIfNeeded];
    //todo comments
    
    [scrollRoot setHidden:NO];
    REMOVE_HUD
}

-(void)adjustUI{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    viewSupport.layer.cornerRadius = 30;
    [imgLocationIcon setImage:[IonIcons imageWithIcon:ion_location size:20 color:[UIColor whiteColor]]];
    viewType.layer.cornerRadius = cornerRadius;
    imgCreator.layer.cornerRadius = 15;
    imgCreator.layer.masksToBounds = YES;
    btnSupport.layer.cornerRadius = cornerRadius;
    btnEdit.layer.cornerRadius = cornerRadius;
}

-(IBAction)actBack:(id)sender{
    [self back];
}

-(IBAction)actSupport:(id)sender{
    if ([MT isLoggedIn]) {
        ADD_HUD
        [MuhitServices support:STRING_W_INT([detail[@"id"] intValue]) handler:^(NSDictionary *response, NSError *error) {
            if (error) {
                SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
            }
            else{
                if(response.count>0){
                    NSLog(@"support:%@",response);
                    [lblSupportCount setText:STRING_W_INT([response[@"current_supporter_counter"] intValue]) ];
                }
            }
            REMOVE_HUD
        }];
    }
    else{
        [ScreenOperations openLogin];
    }
}

-(IBAction)actProfile:(id)sender{
    [ScreenOperations openProfileWithId:STRING_W_INT([detail[USER][@"id"] intValue])];
}

-(IBAction)actEdit:(id)sender{
    [ScreenOperations openEditIssueWithInfo:detail];
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = scrollImages.frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = scrollImages.frame.size;
    [scrollImages scrollRectToVisible:frame animated:YES];
}


#pragma mark - UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float textHeight = [UF heightOfTextForString:arrComments[indexPath.row][@"description"] andFont:[UIFont fontWithName:@"SourceSansPro-It" size:17.0] maxSize:CGSizeMake(self.view.width-100, 200)];
    
    return textHeight + 81;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrComments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = [arrComments objectAtIndex:indexPath.row];
    
    AnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementCell"];
    
    if (!cell) {
        cell = [[AnnouncementCell alloc] init];
    }
    
    [cell setWithDictionary:item];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
#pragma mark -

#pragma mark - UIScrollView Delegates

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollImages.frame.size.width;
    int page = floor((scrollImages.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}
#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{
    [lblCommentTitle setText:LocalizedString(@"Yorumlar")];
    [lblSupportTitle setText:[LocalizedString(@"Destekçi") toUpper]];
    [btnEdit setTitle:[LocalizedString(@"Düzenle") toUpper]];
    [btnSupport setTitle:[LocalizedString(@"Destekle") toUpper]];
}

@end
