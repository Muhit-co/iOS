//
//  PlacesView.m
//  Muhit
//
//  Created by Emre YANIK on 17/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "PlacesView.h"
#import "PlacesCell.h"

@interface PlacesView (){
    NSMutableArray *arrPlaces;
    IBOutlet UITableView *tblPlaces;
    IBOutlet UITextField *txtSearch;
    IBOutlet UIButton *btnCancel;
    IBOutlet UIImageView *imgSearchIcon;
}

@end

@implementation PlacesView

- (id)init{
    
    if(self = [super init]){
        self = [[[NSBundle mainBundle] loadNibNamed:@"PlacesView" owner:self options:nil] lastObject];
    }
    return self;
}

-(void)show{

    [imgSearchIcon setImage:[IonIcons imageWithIcon:ion_search size:20 color:CLR_DARK_PUPRPLE]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [self setFrame:[[[UIApplication sharedApplication] delegate] window].bounds];
    [self layoutSubviews];
    [txtSearch becomeFirstResponder];
}

-(IBAction)actCancel:(id)sender{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self removeFromSuperview];
}

-(IBAction)autoCompletePlaces:(id)sender{
    NSString *query = txtSearch.text;
    
    if ([query isEqualToString:@""]) {
        arrPlaces = nil;
        [tblPlaces reloadData];
        return;
    }

    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterRegion;
    
    [[GMSPlacesClient sharedClient] autocompleteQuery:query bounds:nil filter:nil callback:^(NSArray *results, NSError *error) {
         if (error != nil) {
             NSLog(@"Autocomplete error %@", [error localizedDescription]);
             return;
         }
        arrPlaces = [[NSMutableArray alloc] init];
        for (GMSAutocompletePrediction *obj in results) {
            if ([[obj types] containsObject:@"administrative_area_level_4"]) {
                [arrPlaces addObject:obj];
            }
        }
         [tblPlaces reloadData];
     }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

#pragma mark - UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GMSAutocompletePrediction *item = [arrPlaces objectAtIndex:indexPath.row];
    
    PlacesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlacesCell"];
    
    if (!cell) {
        cell = [[PlacesCell alloc] init];
    }
    
    NSString *order;
    
    if (indexPath.row == 0) {
        order = @"first";
    }
    else if(indexPath.row == [arrPlaces count]-1){
    	order = @"last";
    }
    else{
    	order = @"middle";
    }
    
    [cell setWithDictionary:item cellOrder:order];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   	GMSAutocompletePrediction *address = [arrPlaces objectAtIndex:indexPath.row];
    if([self.delegate respondsToSelector:@selector(placesView:selectedAddress:)]) {
        [self.delegate placesView:self selectedAddress:address];
        [self actCancel:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
#pragma mark -

@end
