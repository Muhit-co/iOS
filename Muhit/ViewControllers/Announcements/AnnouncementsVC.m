//
//  AnnouncementsVC.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "AnnouncementsVC.h"
#import "AnnouncementCell.h"

@interface AnnouncementsVC (){
    IBOutlet UITableView *tblAnnouncements;
    IBOutlet UIButton *btnMenu;
    NSMutableArray *arrAnnouncements;
    BOOL fromMenu;
}
@end

@implementation AnnouncementsVC

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
    [self getAnnouncements];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view layoutIfNeeded];
}

-(IBAction)actMenu:(id)sender{
    [self.view endEditing:YES];
    [[MT drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(NSArray*)arrTestData{
    
    NSArray* arrSupporteds = @[
                               @{
                                   @"title":@"Hola",
                                   @"created_at": @"2015-06-14 10:00:00",
                                   @"content":@"Sevgili Fenerbahçeliler, 16.04.2015 tarihinde Saat 09.00-14.00 saatleri arasında Kılıç Sokak'ta elektrik kesilecektir.",
                                   @"headman":@"Ali Kemal",
                                   @"hood":@"Altunizade Mahallesi"
                                   },
                               @{
                                   @"title":@"Hola",
                                   @"created_at": @"2015-06-14 10:00:00",
                                   @"content":@"Sevgili Fenerbahçeliler, 16.04.2015 tarihinde Saat 09.00-14.00 saatleri arasında Kılıç Sokak'ta elektrik kesilecektir.",
                                   @"headman":@"Ali Kemal",
                                   @"hood":@"Altunizade Mahallesi"
                                   },
                               
                               @{
                                   @"title":@"Hola",
                                   @"created_at": @"2015-06-14 10:00:00",
                                   @"content":@"Sevgili Fenerbahçeliler, 16.04.2015 tarihinde Saat 09.00-14.00 saatleri arasında Kılıç Sokak'ta elektrik kesilecektir.",
                                   @"headman":@"Ali Kemal",
                                   @"hood":@"Altunizade Mahallesi"
                                   }];
    
    return arrSupporteds;
}

- (void)getAnnouncements{
    ADD_HUD
    [SERVICES getAnnouncements:[MT userId] handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
            REMOVE_HUD
        }
        else{
            NSLog(@"getAnnouncementsResponse:%@",response);
            arrAnnouncements = response[@"announcements"];
            [tblAnnouncements reloadData];
            REMOVE_HUD
        }
    }];
}

#pragma mark - UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float titleHeight = [UF heightOfTextForString:arrAnnouncements[indexPath.row][@"title"] andFont:[UIFont fontWithName:FONT_BOLD size:16.0] maxSize:CGSizeMake([UF screenSize].width-78, MAXFLOAT)];
    
    float contentHeight = [UF heightOfTextForString:arrAnnouncements[indexPath.row][@"content"] andFont:[UIFont fontWithName:FONT_REGULAR size:16.0] maxSize:CGSizeMake([UF screenSize].width-78, MAXFLOAT)];
    
    return 20 + titleHeight + 20 + contentHeight + 55;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrAnnouncements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = [arrAnnouncements objectAtIndex:indexPath.row];
    
    AnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementCell"];
    
    if (!cell) {
        cell = [[AnnouncementCell alloc] init];
    }
    
    [cell setWithDictionary:item];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{
    [[self navigationItem] setTitleView:[UF titleViewWithTitle:LocalizedString(@"announcements")]];
}

@end
