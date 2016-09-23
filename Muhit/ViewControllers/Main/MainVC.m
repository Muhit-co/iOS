//
//  MainVC.m
//  Muhit
//
//  Created by Emre YANIK on 02/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "MainVC.h"
#import "IssueCell.h"
#import "LocationManager.h"

@interface MainVC ()<LocationManagerDelegate,GMSMapViewDelegate>{
    IBOutlet UIButton *btnCreateIssue,*btnPopular,*btnLatest,*btnMap,*btnMenu,*btnPickHood,*btnLocation;
    IBOutlet UITextField *txtSearch;
    IBOutlet UIImageView *imgLocation;
    IBOutlet NSLayoutConstraint *constActiveLine;
    IBOutlet UIView *viewActiveLine,*viewHood;
    IBOutlet UITableView *tblIssues;
    IBOutlet GMSMapView *map;
    CLLocationCoordinate2D pointedCoordinate;
    NSMutableArray *arrIssues;
    NSString *coordinates;
    int lastIndex;
    BOOL isEndOfList;
}
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [map setDelegate:self];
    [self adjustUI];
    [self actLatest:nil];
    [NC addObserver:self selector:@selector(geoCodePicked:) name:NC_GEOCODE_PICKED object:nil];
    arrIssues = [[NSMutableArray alloc] init];
    [self getIssues];
    [self setMarkers];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        [self actLocation:nil];
    }
    else{
        [map setCamera:[GMSCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(41.0671234,28.989452) zoom:10]];
    }
}

- (void)geoCodePicked:(NSNotification*)notification{
    NSDictionary *dict = [notification object];
    coordinates = dict[@"coordinates"];
    [btnPickHood setTitle:dict[@"hood"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [[MT navCon] setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (![MT isPresentingVC]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view layoutIfNeeded];
}

-(void)dealloc{
    [NC removeObserver:self name:NC_GEOCODE_PICKED object:nil];
}

-(void)adjustUI{
    btnCreateIssue.layer.cornerRadius = cornerRadius;
    viewHood.layer.cornerRadius = cornerRadius;
    viewHood.layer.borderColor = [CLR_WHITE CGColor];
    viewHood.layer.borderWidth = 1;
    
    [btnMenu setImage:[IonIcons imageWithIcon:ion_navicon size:36 color:CLR_WHITE]];
    [btnCreateIssue setImage:[IonIcons imageWithIcon:ion_plus size:15 color:CLR_WHITE]];
    [btnLocation setImage:[IonIcons imageWithIcon:ion_android_locate size:24 color:CLR_WHITE]];
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
            if ([response[@"issues"] count]>0) {
                DLog(@"getIssuesResponse:%@",response);
                [arrIssues addObjectsFromArray:response[@"issues"]];
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

-(IBAction)actLatest:(id)sender{
    if (![btnLatest isSelected]) {
        [btnLatest setSelected:YES];
        [btnPopular setSelected:NO];
        [btnMap setSelected:NO];
        [tblIssues setHidden:NO];
        
        [UIView animateWithDuration:0.2 animations:^{
            constActiveLine.constant = 0;
            [self.view layoutIfNeeded];
            map.alpha = 0;
            tblIssues.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished) {
                [map setHidden:YES];
            }
        }];
    }
}

-(IBAction)actPopular:(id)sender{
    if (![btnPopular isSelected]) {
        [btnPopular setSelected:YES];
        [btnLatest setSelected:NO];
        [btnMap setSelected:NO];
        [tblIssues setHidden:NO];
        
        [UIView animateWithDuration:0.2 animations:^{
            constActiveLine.constant = [btnLatest rightPosition];
            [self.view layoutIfNeeded];
            map.alpha = 0;
            tblIssues.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished) {
                [map setHidden:YES];
            }
        }];
        
    }
}

-(IBAction)actMap:(id)sender{
    if (![btnMap isSelected]) {
        [btnMap setSelected:YES];
        [btnLatest setSelected:NO];
        [btnPopular setSelected:NO];
        [map setHidden:NO];
        
        [UIView animateWithDuration:0.2 animations:^{
            constActiveLine.constant = [btnPopular rightPosition];
            [self.view layoutIfNeeded];
            map.alpha = 1;
            tblIssues.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [tblIssues setHidden:YES];
            }
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

-(IBAction)actPickHood:(id)sender{
    [ScreenOperations openPickFromMap];
}

-(IBAction)actLocation:(id)sender{
    [LOCATION setDelegate:self];
    [LOCATION startUpdatingLocation];
    ADD_HUD
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

#pragma mark - UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
    
    IssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueCell"];
    
    if (!cell) {
        cell = [[IssueCell alloc] init];
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

#pragma mark - Location Manager

-(void)locationManager:(LocationManager *)locationManager didUpdateToLocation:(CLLocation *)newLocation{
    if (newLocation) {
        REMOVE_HUD
        [locationManager stopUpdatingLocation];
        [map setCamera:[GMSCameraPosition cameraWithTarget:CURRENT_LOCATION zoom:12]];
        
        [SERVICES getAddressesWithLocation:CURRENT_LOCATION handler:^(NSDictionary *response, NSError *error) {
            if (!error) {
                @try {
                    coordinates = [NSString stringWithFormat:@"%f, %f",CURRENT_LOCATION.latitude,CURRENT_LOCATION.longitude];
                    [btnPickHood setTitle:[UF getHoodFromGMSAddress:response]];
                }
                @catch (NSException *exception) {} @finally {}
            }
            REMOVE_HUD
        }];
    }
    else{
        REMOVE_HUD
    }
}

#pragma mark - Map Delegates

-(void)setMarkers{
    
    NSArray *arrMarkers = @[
                            @{
                                @"lat":@"41.028148",
                                @"lon":@"29.040775",
                                @"name":@"Kamil Can",
                                @"issueId":@"12342"
                                },
                            @{
                                @"lat":@"441.023906",
                                @"lon":@"29.032921",
                                @"name":@"Emre Can",
                                @"issueId":@"12343"
                                },
                            @{
                                @"lat":@"41.023518",
                                @"lon":@"29.036526",
                                @"name":@"Hasan Can",
                                @"issueId":@"12344"
                                },
                            @{
                                @"lat":@"41.016395",
                                @"lon":@"29.043435",
                                @"name":@"Can Can",
                                @"issueId":@"12345"
                                },
                            
                            ];
    
    for (NSDictionary *dict in arrMarkers) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        [marker setPosition:CLLocationCoordinate2DMake([dict[@"lat"] doubleValue], [dict[@"lon"] doubleValue])];
        [marker setAppearAnimation:kGMSMarkerAnimationPop];
        [marker setIcon:[UIImage imageNamed:@"map-issue-pin"]];
        [marker setTitle:dict[@"name"]];
        [marker setMap:map];
        [marker setUserData:dict[@"issueId"]];
    }
    
    map.myLocationEnabled = YES;
}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    
    NSLog(@"marker tapped:%@",[marker userData]);
    return NO;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    NSLog(@"overlay tapped:%@",[marker userData]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{
    [btnPopular setTitle:[LocalizedString(@"popular") toUpper]];
    [btnLatest setTitle:[LocalizedString(@"latest") toUpper]];
    [btnMap setTitle:[LocalizedString(@"map") toUpper]];
    if(!coordinates)
       	[btnPickHood setTitle:LocalizedString(@"choose-hood")];
    [btnCreateIssue setTitle:[LocalizedString(@"idea") toUpper]];
}
@end
