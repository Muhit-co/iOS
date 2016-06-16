//
//  IdeasVC.m
//  Muhit
//
//  Created by Emre YANIK on 16/06/16.
//  Copyright © 2016 Muhit. All rights reserved.
//

#import "IdeasVC.h"
#import "IssueCell.h"

@interface IdeasVC (){
    IBOutlet UITableView *tblIdeas;
    IBOutlet UIButton *btnMenu;;
    NSArray *arrIdeas;
    BOOL fromMenu;
}
@end

@implementation IdeasVC

- (id)initFromMenu{
    self = [super init];
    if (self){
        fromMenu = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (fromMenu) {
        [btnMenu setSize:CGSizeMake(40, 36)];
        [btnMenu setImage:[IonIcons imageWithIcon:ion_navicon size:36 color:CLR_WHITE]];
        UIBarButtonItem *barBtnMenu = [[UIBarButtonItem alloc] initWithCustomView:btnMenu];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -12;
        [[self navigationItem] setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, barBtnMenu, nil] animated:NO];
    }
    [self test];
}

-(void)test{
    arrIdeas = @[
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
    
    [tblIdeas reloadData];
}


-(IBAction)actMenu:(id)sender{
    [self.view endEditing:YES];
    [[MT drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(IBAction)actCreateIssue:(id)sender{
    if ([MT isLoggedIn]) {
        [ScreenOperations openCreateIssue];
    }
    else{
        [ScreenOperations openLogin];
    }
}

#pragma mark - UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrIdeas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = [arrIdeas objectAtIndex:indexPath.row];
    
    IssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueCell"];
    
    if (!cell) {
        cell = [[IssueCell alloc] init];
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
    [[self navigationItem] setTitleView:[UF titleViewWithTitle:LocalizedString(@"my-ideas")]];
}

@end
