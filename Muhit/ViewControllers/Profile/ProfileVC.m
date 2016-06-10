//
//  ProfileVC.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "ProfileVC.h"
#import "SupportedCell.h"

@interface ProfileVC (){
    IBOutlet UILabel *lblUsername,*lblName,*lblIdeasCount,*lblSupportsCount,*lblAddress,*lblMail,*lblIdeasTitle;
    IBOutlet UIImageView *imgUser,*imgIdeas,*imgSupports,*imgAddress,*imgMail;
    IBOutlet UIView *viewIdeas,*viewSupports;
    IBOutlet UITableView *tblIdeas;
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
	[MuhitServices getProfile:profileId handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
            REMOVE_HUD
        }
        else{
            NSLog(@"getProfileResponse:%@",response);
            [self setDetailsWithDictionary:response[USER]];
        }
    }];
}

-(void)setDetailsWithDictionary:(NSDictionary*)dict{
    
    dictProfile = dict;
    arrIdeas = [NSArray arrayWithArray:dict[@"ideas"]];
    
    [lblUsername setText:dict[@"username"]];
    [lblName setText:[NSString stringWithFormat:@"%@ %@",dict[@"first_name"],dict[@"last_name"]]];
    [lblAddress setText:dict[@"address"]];
    [lblMail setText:dict[@"email"]];
    [lblSupportsCount setText:[dict[@"supported_issue_counter"] stringValue]];
    [lblIdeasCount setText:STRING_W_INT((int)[arrIdeas count])];
    
    NSString *imgUrl = [NSString stringWithFormat:@"%@/140x140/%@",IMAGE_PROXY,dict[@"picture"]];
    [imgUser sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
    
    [tblIdeas reloadData];
    REMOVE_HUD
}

-(void)adjustUI{
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];

    [imgAddress setImage:[IonIcons imageWithIcon:ion_location size:22 color:[HXColor colorWithHexString:@"dddddd"]]];
    [imgMail setImage:[IonIcons imageWithIcon:ion_email size:22 color:[HXColor colorWithHexString:@"dddddd"]]];
    [imgIdeas setImage:[IonIcons imageWithIcon:ion_lightbulb size:24 color:CLR_LIGHT_BLUE]];
    [imgSupports setImage:[IonIcons imageWithIcon:ion_thumbsup size:24 color:CLR_LIGHT_BLUE]];
    
    viewIdeas.layer.cornerRadius = cornerRadius;
    viewIdeas.layer.borderColor = [[HXColor colorWithHexString:@"dbdbdb"] CGColor];
    viewIdeas.layer.borderWidth = 1;
    
    viewSupports.layer.cornerRadius = cornerRadius;
    viewSupports.layer.borderColor = [[HXColor colorWithHexString:@"dbdbdb"] CGColor];
    viewSupports.layer.borderWidth = 1;
    
    imgUser.layer.cornerRadius = 35;
    imgUser.layer.masksToBounds = YES;
    
    if (profileId.length==0) {
        UIButton *btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [btnEdit setImage:[IonIcons imageWithIcon:ion_edit size:20 color:[UIColor whiteColor]]];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
        [btnEdit addTarget:self action:@selector(editProfile) forControlEvents:UIControlEventTouchUpInside];
    }
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
    
    SupportedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupportedCell"];
    
    if (!cell) {
        cell = [[SupportedCell alloc] init];
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
        [self setTitle:LocalizedString(@"Profilim")];
    }
    else{
        [self setTitle:LocalizedString(@"Profil")];
    }
    
    [lblIdeasTitle setText:LocalizedString(@"Yarattığı Fikirler")];
}

@end
