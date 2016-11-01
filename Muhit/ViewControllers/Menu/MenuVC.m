//
//  MenuVC.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "MenuVC.h"
#import "ScreenOperations.h"
#import "FacebookManager.h"
#import "MMDrawerController+Subclass.h"

@interface MenuVC (){
    
    IBOutlet UIImageView *imgBG,*imgProfile;
    IBOutlet UIButton *btnLogout,*btnProfile,*btnLogin,*btnSignup,*btnFacebook;
    IBOutlet UILabel *lblName;
    IBOutlet UITableView *tblMenu;
    IBOutlet UIView *viewLoggedIn,*viewLoggedOut;
    NSMutableArray *arrMenu;
}


@end

@implementation MenuVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [[self view] setBackgroundColor:CLR_DARK_BLUE];
    
    imgProfile.layer.cornerRadius = 20;
    imgProfile.layer.masksToBounds = YES;
    [btnLogout setImage:[IonIcons imageWithIcon:ion_log_out size:30 color:[HXColor hx_colorWithHexRGBAString:@"FFFFFF" alpha:0.3]]];
    
    btnLogin.layer.cornerRadius = cornerRadius;
    btnFacebook.layer.cornerRadius = cornerRadius;
    btnSignup.layer.cornerRadius = cornerRadius;
    
    [btnLogin setImage:[IonIcons imageWithIcon:ion_log_in size:24 color:[HXColor hx_colorWithHexRGBAString:@"EEEEEE"]]];
    [btnFacebook setImage:[IonIcons imageWithIcon:ion_social_facebook size:24 color:[HXColor hx_colorWithHexRGBAString:@"EEEEEE"]]];
    [btnSignup setImage:[IonIcons imageWithIcon:ion_person_add size:24 color:[HXColor hx_colorWithHexRGBAString:@"EEEEEE"]]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([USER isLoggedIn]) {
        [viewLoggedIn setHidden:NO];
        [viewLoggedOut setHidden:YES];
        
        if ([USER profileImage]) {
            [imgProfile setImage:[USER profileImage]];
        }
        else{
        	[imgProfile setImage:PLACEHOLDER_IMAGE];
        }
        
        lblName.text = [NSString stringWithFormat:@"%@ %@",[USER name],[USER surname]];
    }
    else{
        [viewLoggedIn setHidden:YES];
        [viewLoggedOut setHidden:NO];
    }
    [self reloadMenu];
}

- (void)createMenu{
    arrMenu = [[NSMutableArray alloc] init];
    
    [arrMenu addObject:@{@"title":[LocalizedString(@"all") toUpper],@"icon":ion_home,@"selector":SELECTOR_MAIN}];
    
    if ([USER isLoggedIn]) {
        [arrMenu addObject:@{@"title":[LocalizedString(@"my-supporteds") toUpper],@"icon":ion_thumbsup,@"selector":SELECTOR_SUPPORTS}];
        [arrMenu addObject:@{@"title":[LocalizedString(@"my-ideas") toUpper],@"icon":ion_lightbulb,@"selector":SELECTOR_IDEAS}];
        
    }
    
    [arrMenu addObject:@{@"title":[LocalizedString(@"announcements") toUpper],@"icon":ion_speakerphone,@"selector":SELECTOR_NOTIFICATIONS}];
    
    if ([USER isLoggedIn]) {
        [arrMenu addObject:@{@"title":[LocalizedString(@"my-headman") toUpper],@"icon":ion_information_circled,@"selector":SELECTOR_HEADMAN}];
    }
}
-(void)reloadMenu{
    [self createMenu];
    [tblMenu reloadData];
}

- (void)openMain:(id)sender{
    [ScreenOperations openMain];
}

- (void)openSupporteds:(id)sender{
    [ScreenOperations openSupporteds:YES];
}

- (void)openIdeas:(id)sender{
    [ScreenOperations openMyIdeas:YES];
}

- (void)openAnnouncements:(id)sender{
    [ScreenOperations openAnnouncements:YES];
}

- (void)openHeadman:(id)sender{
    [ScreenOperations openHeadman:YES];
}

- (IBAction)actLogin:(id)sender{
    [ScreenOperations openLogin];
}

- (IBAction)actSignup:(id)sender{
    [ScreenOperations openSignUp];
}

- (IBAction)actProfile:(id)sender{
    [ScreenOperations openProfileWithId:[USER userId]];
}

- (IBAction)actLogout:(id)sender{
    
    [FACEBOOK logout];
    [self viewWillAppear:NO];
    [USER clearUser];
    [self.view endEditing:YES];
}

- (IBAction)actFacebook:(id)sender{
    [FACEBOOK loginWithDelegate:self fromViewController:self];
}

- (void) fetchedFacebookUserInfo:(NSDictionary*)userInfo error:(NSError *)error{
    DLog(@"user: %@",userInfo);
    if (userInfo) {
        [SERVICES loginWithFacebook:[FACEBOOK accessToken] fbId:userInfo[FB_ID] handler:^(NSDictionary *response, NSError *error) {
            if (error) {
                SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
            }
            else{
                NSLog(@"loginFacebookResponse:%@",response);
                [USER setDetailsWithInfo:response[@"user"]];
                [self.view endEditing:YES];
            }
            REMOVE_HUD
        }];
    }
    else if(error){
        REMOVE_HUD
        if ([error.domain isEqualToString:@"bitaksi"] && error.code==ERROR_FB_LOGIN_CANCELLED){
            DLog(@"User cancelled permission");
        }
        else if ([error.domain isEqualToString:FBSDKLoginErrorDomain] &&  error.code==FBSDKLoginSystemAccountAppDisabledErrorCode) {
            SHOW_ALERT(LocalizedString(@"facebook-permission"))
        }
        else{
            [self actFacebook:nil];
        }
    }
    else{
        [self actFacebook:nil];
    }
}

#pragma mark - UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrMenu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = [arrMenu objectAtIndex:indexPath.row];
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    if (!cell) {
        cell = [[MenuCell alloc] init];
    }
    
    [cell setTitle:item[@"title"] icon:item[@"icon"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   	NSDictionary *item = [arrMenu objectAtIndex:indexPath.row];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self respondsToSelector:NSSelectorFromString(item[@"selector"])]) {
        [self performSelector:NSSelectorFromString(item[@"selector"]) withObject:nil];
        //        [NC postNotificationName:MENU_ITEM_SELECTED object:item[@"selector"]];
    }
#pragma clang diagnostic pop
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = (MenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [HXColor hx_colorWithHexRGBAString:@"1E455E"];
    cell.backgroundColor = [HXColor hx_colorWithHexRGBAString:@"1E455E"];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = (MenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
}
#pragma mark -

- (void) setLocalizedStrings{
    [self reloadMenu];
    [btnSignup setTitle:[LocalizedString(@"signup") toUpper]];
    [btnLogin setTitle:[LocalizedString(@"login") toUpper]];
    [btnFacebook setTitle:[LocalizedString(@"connect") toUpper]];
    [btnLogout setTitle:[LocalizedString(@"logout") toUpper]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
