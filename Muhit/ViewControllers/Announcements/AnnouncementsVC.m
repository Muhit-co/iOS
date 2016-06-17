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
    int lastIndex;
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
    
    arrAnnouncements = [[NSMutableArray alloc] init];
    //    [self getAnnouncements];
    [arrAnnouncements addObjectsFromArray:[self arrTestData]];
    [tblAnnouncements reloadData];
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
    lastIndex = (int)arrAnnouncements.count;
    [SERVICES getAnnouncements:lastIndex handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
        }
        else{
            NSLog(@"getAnnouncementsResponse:%@",response);
            //            [arrAnnouncements addObjectsFromArray:response[@"data"]];
            [arrAnnouncements addObjectsFromArray:[self arrTestData]];
            [tblAnnouncements reloadData];
            REMOVE_HUD
            
            [tblAnnouncements scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }
        REMOVE_HUD
    }];
}

#pragma mark - UITableView Delegates

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:[self tableView:tblAnnouncements numberOfRowsInSection:0]-1 inSection:0]]){
        [self getAnnouncements];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float textHeight = [UF heightOfTextForString:arrAnnouncements[indexPath.row][@"content"] andFont:[UIFont fontWithName:@"SourceSansPro-It" size:17.0] maxSize:CGSizeMake(self.view.width-100, 200)];
    
    return textHeight + 81;
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
