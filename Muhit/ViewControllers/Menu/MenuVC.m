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

#define DK_IMAGE @"image"
#define DK_TITLE @"title"
#define DK_SELECTOR @"selector"
#define DK_PARENT @"parent"

@interface MenuVC (){
    
    IBOutlet UIImageView *imgBG;
    IBOutlet UIButton *btnLogout,*btnProfile,*btnLogin,*btnSignup;
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
    [btnProfile setImage:[IonIcons imageWithIcon:ion_person size:30 color:[HXColor colorWithHexString:@"FFFFFF" alpha:0.3]]];
    [btnLogout setImage:[IonIcons imageWithIcon:ion_log_out size:30 color:[HXColor colorWithHexString:@"FFFFFF" alpha:0.3]]];
    [btnLogin setImage:[IonIcons imageWithIcon:ion_log_in size:30 color:[HXColor colorWithHexString:@"FFFFFF" alpha:0.3]]];
    [btnSignup setImage:[IonIcons imageWithIcon:ion_person_add size:30 color:[HXColor colorWithHexString:@"FFFFFF" alpha:0.3]]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([MT isLoggedIn]) {
        [viewLoggedIn setHidden:NO];
        [viewLoggedOut setHidden:YES];
    }
    else{
        [viewLoggedIn setHidden:YES];
        [viewLoggedOut setHidden:NO];
    }
	[self reloadMenu];
}

- (void)createMenu{
    arrMenu = [[NSMutableArray alloc] init];
    [arrMenu addObject:@{@"title":LocalizedString(@"TÜMÜ"),@"icon":ion_home,@"selector":SELECTOR_MAIN}];
    [arrMenu addObject:@{@"title":LocalizedString(@"DESTEKLEDİKLERİM"),@"icon":ion_thumbsup,@"selector":SELECTOR_SUPPORTS}];
    [arrMenu addObject:@{@"title":LocalizedString(@"FİKİRLERİM"),@"icon":ion_lightbulb,@"selector":SELECTOR_IDEAS}];
    [arrMenu addObject:@{@"title":LocalizedString(@"DUYURULAR"),@"icon":ion_speakerphone,@"selector":SELECTOR_NOTIFICATIONS}];
	[arrMenu addObject:@{@"title":LocalizedString(@"MUHTARIM"),@"icon":ion_information_circled,@"selector":SELECTOR_HEADMAN}];
}
-(void)reloadMenu{
    [self createMenu];
    [tblMenu reloadData];
}

- (void)openMain:(id)sender{
    [ScreenOperations openMain];
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
    [ScreenOperations openProfile];
}

- (IBAction)actLogout:(id)sender{
    
//    [FACEBOOK closeSessionWithToken:YES];
    [MT setIsLoggedIn:NO];
    [self viewWillAppear:NO];
    [NC postNotificationName:NC_LOGGED_OUT object:nil];
    [UD setObject:nil forKey:UD_ACCESS_TOKEN];
    [UD setObject:nil forKey:UD_REFRESH_TOKEN];
    [UD setObject:nil forKey:UD_ACCESS_TOKEN_LIFETIME];
    [UD setObject:nil forKey:UD_ACCESS_TOKEN_TAKEN_DATE];
    [UD setObject:nil forKey:UD_FIRSTNAME];
    [UD setObject:nil forKey:UD_SURNAME];
//    [self reloadMenu];
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
        [NC postNotificationName:MENU_ITEM_SELECTED object:item[@"selector"]];
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
    cell.contentView.backgroundColor = CLR_LIGHT_BLUE;
    cell.backgroundColor = CLR_LIGHT_BLUE;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = (MenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
}
#pragma mark -

- (void) setLocalizedStrings{
    [self reloadMenu];
    [btnSignup setTitle:LocalizedString(@"ÜYE OL")];
    [btnLogin setTitle:LocalizedString(@"GİRİŞ YAP")];
    [btnProfile setTitle:LocalizedString(@"PROFİLİM")];
    [btnLogout setTitle:LocalizedString(@"ÇIKIŞ YAP")];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end