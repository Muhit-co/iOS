//
//  IdeasVC.m
//  Muhit
//
//  Created by Emre YANIK on 16/06/16.
//  Copyright © 2016 Muhit. All rights reserved.
//

#import "MyIdeasVC.h"
#import "IssueCell.h"

@interface MyIdeasVC (){
    IBOutlet UITableView *tblIdeas;
    IBOutlet UIButton *btnMenu,*btnCreateIssue;
    NSArray *arrIdeas;
    BOOL fromMenu;
}
@end

@implementation MyIdeasVC

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
    
    btnCreateIssue.layer.cornerRadius = 4;
    [btnCreateIssue setSize:CGSizeMake(70, 30)];
    [btnCreateIssue setImage:[IonIcons imageWithIcon:ion_plus size:15 color:CLR_WHITE]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCreateIssue];
    
    [tblIdeas setAllowsSelection:YES];
    [tblIdeas setSectionFooterHeight:0];
    [tblIdeas setSeparatorInset:UIEdgeInsetsZero];
    [self getCreateds];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [tblIdeas setEditing:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([tblIdeas respondsToSelector:@selector(setSeparatorInset:)]) {
        [tblIdeas setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tblIdeas respondsToSelector:@selector(setLayoutMargins:)]) {
        [tblIdeas setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view layoutIfNeeded];
}

-(void)getCreateds{
    ADD_HUD
    [SERVICES getCreateds:[USER userId] handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            REMOVE_HUD
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
        }
        else{
            arrIdeas = response[@"issues"];
            [tblIdeas reloadData];
            REMOVE_HUD
        }
    }];
}

-(void)deleteIssue:(NSDictionary *)issue{
    ADD_HUD
    [SERVICES deleteIssue:issue[@"id"] handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            REMOVE_HUD
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
        }
        else{
            arrIdeas = response[@"issues"];
            [tblIdeas reloadData];
            REMOVE_HUD
        }
    }];
}


-(IBAction)actMenu:(id)sender{
    [self.view endEditing:YES];
    [[MT drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(IBAction)actCreateIssue:(id)sender{
    if ([USER isLoggedIn]) {
        [ScreenOperations openAddIdea];
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
    Idea *idea = [[Idea alloc] initWithInfo:[arrIdeas objectAtIndex:indexPath.row]];
    [ScreenOperations openIdeaWithIdea:idea];
}

//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *item = arrIdeas[indexPath.row];
        [self deleteIssue:item];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LocalizedString(@"delete");
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{
    [[self navigationItem] setTitleView:[UF titleViewWithTitle:LocalizedString(@"my-ideas")]];
}

@end
