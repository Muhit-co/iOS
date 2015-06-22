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
    PlacesView *placeView;
    NSArray *arrIssues;
}

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adjustUI];
    [self actPopular:nil];
}

-(void)test{
    arrIssues = @[
                      @{
                        @"id":@"1",
                      	@"title":@"Lorem ipsum dolor sit amet, consectetur adipiscing",
                      	@"date":@"10.11.2015",
                      	@"count" :@"120",
                      	@"type" : @"0",
                      	@"imageUrl":@"http://cdn.gottabemobile.com/wp-content/uploads/2012/02/nikon-d800-sample-library-photo-620x413.jpg",
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
                                    }]
                      	},
                      @{
                        @"id":@"1",
                        @"title":@"Lorem ipsum dolor sit amet, consectetur adipiscing",
                        @"date":@"12.11.2015",
                        @"count" :@"70",
                        @"type" : @"1",
                        @"imageUrl":@"http://farm5.staticflickr.com/4044/5163861339_10d4ba7d4d_z.jpg",
                        @"tags":@[
                                @{
                                    @"name":@"AĞAÇLANDIRMA",
                                    @"background":@"5e9455"
                                    },
                                @{
                                    @"name":@"YAYA",
                                    @"background":@"f0b328"
                                    }]
                        },

                      @{
                        @"id":@"1",
                        @"title":@"Lorem ipsum dolor sit amet, consectetur adipiscing",
                        @"date":@"08.11.2015",
                        @"count" :@"15",
                        @"type" : @"2",
                        @"imageUrl":@"http://www.canon.com.tr/Images/PowerShot%20G1%20X%20Mark%20II%20sample%20Z2%20med_tcm123-1139968.jpg",
                        @"tags":@[
                                @{
                                    @"name":@"KAMİL",
                                    @"background":@"f0b328"
                                    }]
                        }];
    
    [tblIssues reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [[MT navCon] setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[MT navCon] setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self test];
    [self.view layoutIfNeeded];
}

-(void)adjustUI{
    btnCreateIssue.layer.cornerRadius = cornerRadius;
    btnCreateIssue.layer.borderColor = [[HXColor colorWithHexString:@"FFFFFF"] CGColor];
    btnCreateIssue.layer.borderWidth = 1;
    
    [btnCreateIssue setImage:[IonIcons imageWithIcon:ion_plus size:15 color:[HXColor colorWithHexString:@"FFFFFF"]]];
    
    [imgLocation setImage:[IonIcons imageWithIcon:ion_location size:115 color:[HXColor colorWithHexString:@"676778"]]];

    [imgDownIcon setImage:[IonIcons imageWithIcon:ion_chevron_down size:20 color:CLR_LIGHT_BLUE]];
    [imgSearch setImage:[IonIcons imageWithIcon:ion_search size:20 color:CLR_LIGHT_BLUE]];
    
    viewHood.layer.cornerRadius = cornerRadius;
    viewSearch.layer.cornerRadius = cornerRadius;
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
    [ScreenOperations openCreateIssue];
}

-(IBAction)actMenu:(id)sender{
    [self.view endEditing:YES];
	[[MT drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(IBAction)actSearchHood:(id)sender{
    if (!placeView) {
        placeView = [[PlacesView alloc] init];
        [placeView setDelegate:self];
    }
    [placeView show];
}

-(void)placesView:(PlacesView *)placesView selectedAddress:(GMSAutocompletePrediction *)selectedAddress{
    NSDictionary *parsedAddress = [UF parsePlaces:selectedAddress];
    [btnHood setTitle:parsedAddress[@"hood"]];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

#pragma mark - UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
    [ScreenOperations openIssueWithId:item[@"id"]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{
    [btnPopular setTitle:LocalizedString(@"POPÜLER")];
    [btnNewest setTitle:LocalizedString(@"EN SON")];
}
@end
