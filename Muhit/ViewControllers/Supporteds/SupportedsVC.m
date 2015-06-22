//
//  SupportedsVC.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "SupportedsVC.h"
#import "SupportedCell.h"

@interface SupportedsVC (){
    IBOutlet UITableView *tblSupporteds;
    NSArray *arrSupporteds;
}

@end

@implementation SupportedsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}

-(void)test{
    arrSupporteds = @[
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
    
    [tblSupporteds reloadData];
}

#pragma mark - UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrSupporteds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = [arrSupporteds objectAtIndex:indexPath.row];
    
    SupportedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupportedCell"];
    
    if (!cell) {
        cell = [[SupportedCell alloc] init];
    }
    
    [cell setWithDictionary:item];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = [arrSupporteds objectAtIndex:indexPath.row];
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
    [self setTitle:LocalizedString(@"Desteklediklerim")];
}

@end
