//
//  SearchVC.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "SearchVC.h"
#import "SupportedCell.h"

@interface SearchVC (){
    IBOutlet UITableView *tblSearchResults;
    IBOutlet UITextField *txtQuery;
    IBOutlet UILabel *lblResult;
    IBOutlet UIPickerView *pickerHood;
    IBOutlet UIImageView *imgDownIcon,*imgClearIcon;
    IBOutlet UIView *viewHood,*viewQuery;
    IBOutlet UIButton *btnHood;
    PlacesView *placeView;
    NSArray *arrSearchResults;
}

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    [self test];
}

-(void)adjustUI{
    viewHood.layer.cornerRadius = cornerRadius;
    viewQuery.layer.cornerRadius = cornerRadius;
    [imgDownIcon setImage:[IonIcons imageWithIcon:ion_chevron_down size:20 color:CLR_LIGHT_BLUE]];
    [imgClearIcon setImage:[IonIcons imageWithIcon:ion_close size:20 color:CLR_LIGHT_BLUE]];
}

-(void)test{
    arrSearchResults = @[
                      @{
                          @"title":@"Lorem ipsum dolor sit amet, consectetur adipiscing",
                          @"date":@"10.11.2015",
                          @"imageUrl":@"http://cdn.gottabemobile.com/wp-content/uploads/2012/02/nikon-d800-sample-library-photo-620x413.jpg"
                          },
                      @{
                          @"title":@"Lorem ipsum dolor sit amet, consectetur adipiscing",
                          @"date":@"12.11.2015",
                          @"imageUrl":@"http://farm5.staticflickr.com/4044/5163861339_10d4ba7d4d_z.jpg"
                          },
                      
                      @{
                          @"title":@"Lorem ipsum dolor sit amet, consectetur adipiscing",
                          @"date":@"08.11.2015",
                          @"imageUrl":@"http://www.canon.com.tr/Images/PowerShot%20G1%20X%20Mark%20II%20sample%20Z2%20med_tcm123-1139968.jpg"
                          }];
    
    [tblSearchResults reloadData];
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
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrSearchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = [arrSearchResults objectAtIndex:indexPath.row];
    
    SupportedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupportedCell"];
    
    if (!cell) {
        cell = [[SupportedCell alloc] init];
    }
    
    [cell setWithDictionary:item];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   	NSDictionary *item = [arrSearchResults objectAtIndex:indexPath.row];
    [ScreenOperations openIssueWithId:item[@"id"]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
#pragma mark -

- (void)setLocalizedStrings{
    [self setTitle:LocalizedString(@"Arama Sonuçları")];
}

@end
