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
    IBOutlet UIButton *btnLogout,*btnProfile,*btnLogin,*btnSignup;
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
    
    [btnLogout setImage:[IonIcons imageWithIcon:ion_log_out size:30 color:[HXColor colorWithHexString:@"FFFFFF" alpha:0.3]]];
    [btnLogin setImage:[IonIcons imageWithIcon:ion_log_in size:30 color:[HXColor colorWithHexString:@"FFFFFF" alpha:0.3]]];
    [btnSignup setImage:[IonIcons imageWithIcon:ion_person_add size:30 color:[HXColor colorWithHexString:@"FFFFFF" alpha:0.3]]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([MT isLoggedIn]) {
        [viewLoggedIn setHidden:NO];
        [viewLoggedOut setHidden:YES];
         NSString *imgUrl = [NSString stringWithFormat:@"%@/80x80/%@",IMAGE_PROXY,[UD objectForKey:UD_USER_PICTURE]];
        [imgProfile sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
        lblName.text = [NSString stringWithFormat:@"%@ %@",[UD objectForKey:UD_FIRSTNAME],[UD objectForKey:UD_SURNAME]];
    }
    else{
        [viewLoggedIn setHidden:YES];
        [viewLoggedOut setHidden:NO];
    }
	[self reloadMenu];
}

- (void)createMenu{
    arrMenu = [[NSMutableArray alloc] init];
    
    [arrMenu addObject:@{@"title":[LocalizedString(@"Tümü") toUpper],@"icon":ion_home,@"selector":SELECTOR_MAIN}];
    
    if ([MT isLoggedIn]) {
        [arrMenu addObject:@{@"title":[LocalizedString(@"Desteklediklerim") toUpper],@"icon":ion_thumbsup,@"selector":SELECTOR_SUPPORTS}];
        [arrMenu addObject:@{@"title":[LocalizedString(@"Fikirlerim") toUpper],@"icon":ion_lightbulb,@"selector":SELECTOR_IDEAS}];

    }
    
    [arrMenu addObject:@{@"title":[LocalizedString(@"Duyurular") toUpper],@"icon":ion_speakerphone,@"selector":SELECTOR_NOTIFICATIONS}];
    
    if ([MT isLoggedIn]) {
		[arrMenu addObject:@{@"title":[LocalizedString(@"Muhtarım") toUpper],@"icon":ion_information_circled,@"selector":SELECTOR_HEADMAN}];
    }
}
-(void)reloadMenu{
    [self createMenu];
    [tblMenu reloadData];
}

- (void)openMain:(id)sender{
    [ScreenOperations openMain];
    [[MT drawerController] closeDrawerAnimated:YES completion:nil];
}

- (void)openSupports:(id)sender{
    [ScreenOperations openSupports];
}

- (void)openIdeas:(id)sender{
    [ScreenOperations openIdeas];
}

- (void)openAnnouncements:(id)sender{
    [ScreenOperations openAnnouncements];
}

- (void)openHeadman:(id)sender{
    [ScreenOperations openHeadman];
}

- (IBAction)actLogin:(id)sender{
    [ScreenOperations openLogin];
}

- (IBAction)actSignup:(id)sender{
    [ScreenOperations openSignUp];
}

- (IBAction)actProfile:(id)sender{
    [ScreenOperations openProfileWithId:@""];
}

- (IBAction)actLogout:(id)sender{

    [FACEBOOK closeSessionWithToken:YES];
    [MT setIsLoggedIn:NO];
    [self viewWillAppear:NO];
    [NC postNotificationName:NC_LOGGED_OUT object:nil];
    [UF setUserDefaultsWithDetails:nil];
	[[MT navCon] popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 45;
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
    cell.contentView.backgroundColor = [HXColor colorWithHexString:@"1E455E"];
    cell.backgroundColor = [HXColor colorWithHexString:@"1E455E"];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = (MenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
}
#pragma mark -

- (void) setLocalizedStrings{
    [self reloadMenu];
    [btnSignup setTitle:[LocalizedString(@"Üye Ol") toUpper]];
    [btnLogin setTitle:[LocalizedString(@"Giriş Yap") toUpper]];
    [btnLogout setTitle:[LocalizedString(@"Çıkış Yap") toUpper]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end