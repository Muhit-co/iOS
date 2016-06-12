//
//  MainVC.m
//  Muhit
//
//  Created by Emre YANIK on 02/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "MainVC.h"
#import "MainCell.h"

@interface MainVC (){
    IBOutlet UIButton *btnCreateIssue,*btnPopular,*btnNewest,*btnHood;
    IBOutlet UITextField *txtSearch;
    IBOutlet UIImageView *imgLocation;
    IBOutlet NSLayoutConstraint *constActiveLine;
    IBOutlet UIView *viewActiveLine,*viewSearch,*viewHood;
    IBOutlet UIImageView *imgSearch,*imgDownIcon;
    IBOutlet UITableView *tblIssues;
    NSMutableArray *arrIssues;
    NSString *fullGeoCode;
    int lastIndex;
    BOOL isEndOfList;
}

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    [self actPopular:nil];
    [NC addObserver:self selector:@selector(geoCodePicked:) name:NC_GEOCODE_PICKED object:nil];
    [self getIssues];
}

- (void)geoCodePicked:(NSNotification*)notification{
    NSDictionary *dict = [notification object];
    fullGeoCode = dict[@"full"];
    [btnHood setTitle:dict[@"hood"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [[MT navCon] setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    arrIssues = [[NSMutableArray alloc] init];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[MT navCon] setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view layoutIfNeeded];
}

-(void)adjustUI{
    btnCreateIssue.layer.cornerRadius = cornerRadius;
    btnCreateIssue.layer.borderColor = [CLR_WHITE CGColor];
    btnCreateIssue.layer.borderWidth = 1;
    
    [btnCreateIssue setImage:[IonIcons imageWithIcon:ion_plus size:15 color:[HXColor hx_colorWithHexRGBAString:@"FFFFFF"]]];
    
    [imgLocation setImage:[IonIcons imageWithIcon:ion_location size:115 color:[HXColor hx_colorWithHexRGBAString:@"676778"]]];
    
    [imgDownIcon setImage:[IonIcons imageWithIcon:ion_android_locate size:20 color:CLR_LIGHT_BLUE]];
    [imgSearch setImage:[IonIcons imageWithIcon:ion_search size:20 color:CLR_LIGHT_BLUE]];
    
    viewHood.layer.cornerRadius = cornerRadius;
    viewSearch.layer.cornerRadius = cornerRadius;
}

- (void)getIssues{
    ADD_HUD
    lastIndex = (int)arrIssues.count;
    [SERVICES getIssues:lastIndex handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            REMOVE_HUD
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
        }
        else{
            if (response.count>0) {
                DLog(@"getIssuesResponse:%@",response);
                [arrIssues addObjectsFromArray:(NSArray*)response];
                [tblIssues reloadData];
                
                [tblIssues scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                REMOVE_HUD
            }
            else{
                REMOVE_HUD
                isEndOfList = YES;
            }
        }
    }];
}


-(IBAction)actPopular:(id)sender{
    if (![btnPopular isSelected]) {
        [btnPopular setSelected:YES];
        [btnNewest setSelected:NO];
        
        [UIView animateWithDuration:0.2 animations:^{
            constActiveLine.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
}

-(IBAction)actNewest:(id)sender{
    if (![btnNewest isSelected]) {
        [btnNewest setSelected:YES];
        [btnPopular setSelected:NO];
        
        [UIView animateWithDuration:0.2 animations:^{
            constActiveLine.constant = [btnPopular rightPosition];
            [self.view layoutIfNeeded];
        }];
    }
}

-(IBAction)actCreateIssue:(id)sender{
    if ([MT isLoggedIn]) {
        [ScreenOperations openCreateIssue];
    }
    else{
        [ScreenOperations openLogin];
    }
}

-(IBAction)actMenu:(id)sender{
    [self.view endEditing:YES];
    [[MT drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(IBAction)actSearchHood:(id)sender{
    [ScreenOperations openPickFromMap];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

#pragma mark - UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:[self tableView:tblIssues numberOfRowsInSection:0]-1 inSection:0]] && !isEndOfList){
        [self getIssues];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrIssues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = [arrIssues objectAtIndex:indexPath.row];
    
    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    if (!cell) {
        cell = [[MainCell alloc] init];
    }
    
    [cell setWithDictionary:item];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   	NSDictionary *item = [arrIssues objectAtIndex:indexPath.row];
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
    [btnPopular setTitle:[LocalizedString(@"Popüler") toUpper]];
    [btnNewest setTitle:[LocalizedString(@"En Son") toUpper]];
    [btnCreateIssue setTitle:[LocalizedString(@"Fikir") toUpper]];
}
@end
