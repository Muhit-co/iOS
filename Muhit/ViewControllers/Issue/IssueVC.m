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
    IBOutlet UIButton *btnBack,*btnSupport;
    IBOutlet UIImageView *imgLocationIcon,*imgTypeIcon,*imgCreator;
    IBOutlet UIView *viewSupport,*viewType;
    IBOutlet UIScrollView *scrollTags,*scrollImages;
    IBOutlet UITableView *tblComments;
    IBOutlet UIPageControl *pageControl;
    IBOutlet NSLayoutConstraint *contTitleHeight,*constDescriptionHeight,*constViewTypeWidth;
    NSString *issueId;
    NSArray *arrComments;
}

@end

@implementation IssueVC

- (id)initWithId:(NSString *)_id{
    self = [super init];
    if (self){
        issueId = _id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    self.automaticallyAdjustsScrollViewInsets=NO;
//    [self test];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self test];
}

- (void)viewWillAppear:(BOOL)animated {
    [[MT navCon] setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[MT navCon] setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)test{
    
    NSDictionary *dict = @{
                           @"tags":@[
                                   @{
                                       @"name":@"AĞAÇLANDIRMA",
                                       @"background":@"5e9455"
                                       },
                                   @{
                                       @"name":@"TRAFİK IŞIĞI",
                                       @"background":@"e96c4a"
                                       },
                                   @{
                                       @"name":@"YAYA",
                                       @"background":@"f0b328"
                                       }],
                           @"images":@[   
                                       @"http://imgsv.imaging.nikon.com/lineup/lens/zoom/normalzoom/af-s_nikkor28-300mmf_35-56gd_ed_vr/img/sample/sample2_l.jpg",
                                       @"http://imgsv.imaging.nikon.com/lineup/lens/zoom/normalzoom/af-s_nikkor28-300mmf_35-56gd_ed_vr/img/sample/sample4_l.jpg",
                                       @"http://nikonrumors.com/wp-content/uploads/2014/03/Nikon-1-V3-sample-photo.jpg"
                                       ],
                           @"comments":@[
                                   @{
                                       @"title":@"Lorem ipsum dolor sit amet, consectetur adipiscing",
                                       @"date":@"10.11.2015",
                                       @"description":@"Aliquam ut tellus sit amet nulla porta congue vitae vel leo. Pellentesque ac accumsan felis. Curabitur euismod placerat tortor posuere venenatis. Proin id bibendum orci, eu lobortis libero."
                                       },
                                   @{
                                       @"title":@"Lorem ipsum dolor sit amet, consectetur adipiscing",
                                       @"date":@"10.11.2015",
                                       @"description":@"Aliquam ut tellus sit amet nulla porta congue vitae vel leo. Pellentesque ac accumsan felis. Curabitur euismod placerat tortor posuere venenatis. Proin id bibendum orci, eu lobortis libero."
                                       },
                                   
                                   @{
                                       @"title":@"Lorem ipsum dolor sit amet, consectetur adipiscing",
                                       @"date":@"10.11.2015",
                                       @"description":@"Aliquam ut tellus sit amet nulla porta congue vitae vel leo. Pellentesque ac accumsan felis. Curabitur euismod placerat tortor posuere venenatis. Proin id bibendum orci, eu lobortis libero."
                                       }],
                           @"name":@"Kamil Can",
                           @"imageUrl":@"http://themes.justgoodthemes.com/demo/getready/full-blue/images/John_Doe.jpg",
                           @"supportsCount":@"18",
                           @"hood":@"Gümüşsuyu",
                           @"date":@"13 Ağustos 2015",
                           @"type" : @"3",
                           @"title":@"Aliquam ut tellus sit amet nulla",
                           @"description":@"Pellentesque ac accumsan felis. Curabitur euismod placerat tortor posuere venenatis. Proin id bibendum orci, eu lobortis libero."
                           
                           };
    [self setDetailsWithDictionary:dict];
}

-(void)setDetailsWithDictionary:(NSDictionary*)dict{
    
    arrComments = [NSArray arrayWithArray:dict[@"comments"]];
    [tblComments reloadData];
	[imgCreator sd_setImageWithURL:[NSURL URLWithString:dict[@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
    
    [lblCreatorName setText:dict[@"name"]];
    [lblSupportCount setText:dict[@"supportsCount"]];
    [lblHood setText:dict[@"hood"]];
    [lblDate setText:dict[@"date"]];
    
    int type = [dict[@"type"] intValue];
    if (type == 0) {
        [lblType setText:LocalizedString(@"Başvuruldu")];
        [viewType setBackgroundColor:[HXColor colorWithHexString:@"44a2e0"]];
        [imgTypeIcon setImage:[IonIcons imageWithIcon:ion_lightbulb size:20 color:[HXColor colorWithHexString:@"FFFFFF"]]];
    }
    else if (type == 1){
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
    
    /* Images Area */
    
    NSArray * arrImages = [NSArray arrayWithArray:dict[@"images"]];
    
    for (int i = 0; i < arrImages.count; i++) {
        CGRect frame;
        frame.origin.x = scrollImages.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = scrollImages.frame.size;
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:frame];
        [img sd_setImageWithURL:[NSURL URLWithString:arrImages[i]] placeholderImage:[UIImage imageNamed:@"issuePlaceholder"]];
        [scrollImages addSubview:img];
    }
    
    scrollImages.contentSize = CGSizeMake(scrollImages.frame.size.width * arrImages.count, scrollImages.frame.size.height);
    
    /* Tags Area */
    
    float totalTagsWidth = 0;
    UIFont *tagFont = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:14.0];
    for (NSDictionary *tag in dict[@"tags"]) {
        
        float lblWidth = [tag[@"name"] sizeWithAttributes:@{NSFontAttributeName:tagFont}].width + 10;
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(totalTagsWidth, 15, lblWidth, 20)];
        lbl.layer.cornerRadius = cornerRadius;
        lbl.layer.masksToBounds = YES;
        [lbl setText:tag[@"name"]];
        [lbl setFont:tagFont];
        [lbl setBackgroundColor:[HXColor colorWithHexString:tag[@"background"]]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:[UIColor whiteColor]];
        totalTagsWidth += lblWidth + 10;
        [scrollTags addSubview:lbl];
    }
    
    scrollTags.contentSize = CGSizeMake(totalTagsWidth, scrollTags.frame.size.height);
}

-(void)adjustUI{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    viewSupport.layer.cornerRadius = 30;
    [imgLocationIcon setImage:[IonIcons imageWithIcon:ion_location size:20 color:[UIColor whiteColor]]];
    viewType.layer.cornerRadius = cornerRadius;
    imgCreator.layer.cornerRadius = 15;
    imgCreator.layer.masksToBounds = YES;
    btnSupport.layer.cornerRadius = cornerRadius;
}

-(IBAction)actBack:(id)sender{
    [self back];
}

-(IBAction)actSupport:(id)sender{
    
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
    [lblCommentTitle setText:LocalizedString(@"Muhtardan gelen yorumlar")];
    [lblSupportTitle setText:LocalizedString(@"DESTEKÇİ")];
}

@end
