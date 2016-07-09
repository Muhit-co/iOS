//
//  ProfileVC.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "ProfileVC.h"
#import "IssueCell.h"

@interface ProfileVC (){
    IBOutlet UILabel *lblName,*lblIdeasCount,*lblSupportsCount,*lblIdeasTitle,*lblSupportsTitle,*lblAddress,*lblMail,*lblUsername,*lblIssuesTitle;
    IBOutlet UIImageView *imgUser,*imgIdeas,*imgSupports,*imgAddress,*imgMail,*imgUserName;
    IBOutlet UIView *viewIdeas,*viewSupports;
    IBOutlet UITableView *tblIdeas;
    IBOutlet NSLayoutConstraint *constCreatedIssuesWidth,*constSupportedIssuesWidth;
    NSArray *arrIdeas;
    NSString *profileId;
    NSDictionary *dictProfile;
}

@end

@implementation ProfileVC

- (id)initWithId:(NSString *)_id{
    self = [super init];
    if (self){
        profileId = _id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    [self getProfileInfo];
}

-(void)getProfileInfo{
    ADD_HUD
    [SERVICES getProfile:profileId handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
            REMOVE_HUD
        }
        else{
            [self setDetailsWithDictionary:response[USER]];
        }
    }];
}

-(void)adjustUI{
    [imgAddress setImage:[IonIcons imageWithIcon:ion_location size:24 color:CLR_LIGHT_BLUE]];
    [imgMail setImage:[IonIcons imageWithIcon:ion_email size:24 color:CLR_LIGHT_BLUE]];
    [imgUserName setImage:[IonIcons imageWithIcon:ion_person size:24 color:CLR_LIGHT_BLUE]];
    [imgIdeas setImage:[IonIcons imageWithIcon:ion_lightbulb size:18 color:CLR_LIGHT_BLUE]];
    [imgSupports setImage:[IonIcons imageWithIcon:ion_thumbsup size:18 color:CLR_LIGHT_BLUE]];
    
    viewIdeas.layer.cornerRadius = cornerRadius;
    viewIdeas.layer.borderColor = [[HXColor hx_colorWithHexRGBAString:@"CCCCDD"] CGColor];
    viewIdeas.layer.borderWidth = 1;
    
    viewSupports.layer.cornerRadius = cornerRadius;
    viewSupports.layer.borderColor = [[HXColor hx_colorWithHexRGBAString:@"CCCCDD"] CGColor];
    viewSupports.layer.borderWidth = 1;
    
    imgUser.layer.cornerRadius = 60;
    imgUser.layer.masksToBounds = YES;
    
    if ([profileId isEqualToString:[MT userId]]) {
        UIButton *btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [btnEdit setImage:[IonIcons imageWithIcon:ion_edit size:20 color:CLR_WHITE]];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
        [btnEdit addTarget:self action:@selector(editProfile) forControlEvents:UIControlEventTouchUpInside];
    }
}


-(void)setDetailsWithDictionary:(NSDictionary*)dict{
    
    dictProfile = dict;
    arrIdeas = [NSArray arrayWithArray:dict[@"issues"]];
    
    [lblUsername setText:dict[@"username"]];
    [lblName setText:dict[@"full_name"]];
    [lblAddress setText:dict[@"address"]];
    [lblMail setText:dict[@"email"]];
    [lblSupportsCount setText:[dict[@"supported_issue_counter"] stringValue]];
    [lblIdeasCount setText:[dict[@"opened_issue_counter"] stringValue]];
    
    NSString *imgUrl = [NSString stringWithFormat:@"%@/240x240/%@",IMAGE_PROXY,dict[@"picture"]];
    [imgUser sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:PLACEHOLDER_IMAGE];
    
    CGSize textSize = [[lblIdeasCount text] sizeWithAttributes:@{NSFontAttributeName:[lblIdeasCount font]}];
    constCreatedIssuesWidth.constant = 36 + textSize.width;
    
    textSize = [[lblSupportsCount text] sizeWithAttributes:@{NSFontAttributeName:[lblSupportsCount font]}];
    constSupportedIssuesWidth.constant = 36 + textSize.width;
    [self.view layoutIfNeeded];
    
    [tblIdeas reloadData];
    REMOVE_HUD
}

-(void)editProfile{
    [ScreenOperations openEditProfileWithInfo:dictProfile];
}

#pragma mark - UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrIdeas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = [arrIdeas objectAtIndex:indexPath.row];
    
    IssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueCell"];
    
    if (!cell) {
        cell = [[IssueCell alloc] init];
    }
    
    [cell setWithDictionary:item];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   	NSDictionary *item = [arrIdeas objectAtIndex:indexPath.row];
    [ScreenOperations openIssueWitDetail:item];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{
    if (profileId.length==0) {
        [self setTitle:LocalizedString(@"my-profile")];
    }
    else{
        [self setTitle:LocalizedString(@"profile")];
    }
    
    [lblIssuesTitle setText:LocalizedString(@"created-issues")];
    [lblIdeasTitle setText:LocalizedString(@"created-issues")];
    [lblSupportsTitle setText:LocalizedString(@"supported-issues")];
}

@end
