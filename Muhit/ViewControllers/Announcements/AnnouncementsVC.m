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
    NSMutableArray *arrAnnouncements;
    int lastIndex;
}

@end

@implementation AnnouncementsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrAnnouncements = [[NSMutableArray alloc] init];
    [self getAnnouncements];
}

-(NSArray*)arrTestData{
	
    NSArray* arrSupporteds = @[
                          @{
                              @"title":@"Hola",
                              @"created_at": @"2015-06-14 10:00:00",
                              @"content":@"Sevgili Fenerbahçeliler, 16.04.2015 tarihinde Saat 09.00-14.00 saatleri arasında Kılıç Sokak'ta elektrik kesilecektir."
                              },
                          @{
                              @"title":@"Hola",
                              @"created_at": @"2015-06-14 10:00:00",
                              @"content":@"Sevgili Fenerbahçeliler, 16.04.2015 tarihinde Saat 09.00-14.00 saatleri arasında Kılıç Sokak'ta elektrik kesilecektir."
                              },
                          
                          @{
                              @"title":@"Hola",
                              @"created_at": @"2015-06-14 10:00:00",
                              @"content":@"Sevgili Fenerbahçeliler, 16.04.2015 tarihinde Saat 09.00-14.00 saatleri arasında Kılıç Sokak'ta elektrik kesilecektir."
                              },
                          @{
                              @"title":@"Hola",
                              @"created_at": @"2015-06-14 10:00:00",
                              @"content":@"Sevgili Fenerbahçeliler, 16.04.2015 tarihinde Saat 09.00-14.00 saatleri arasında Kılıç Sokak'ta elektrik kesilecektir."
                              },
                          @{
                              @"title":@"Hola",
                              @"created_at": @"2015-06-14 10:00:00",
                              @"content":@"Sevgili Fenerbahçeliler, 16.04.2015 tarihinde Saat 09.00-14.00 saatleri arasında Kılıç Sokak'ta elektrik kesilecektir."
                              },
                          @{
                              @"title":@"Hola",
                              @"created_at": @"2015-06-14 10:00:00",
                              @"content":@"Sevgili Fenerbahçeliler, 16.04.2015 tarihinde Saat 09.00-14.00 saatleri arasında Kılıç Sokak'ta elektrik kesilecektir."
                              },
                          @{
                              @"title":@"Hola",
                              @"created_at": @"2015-06-14 10:00:00",
                              @"content":@"Sevgili Fenerbahçeliler, 16.04.2015 tarihinde Saat 09.00-14.00 saatleri arasında Kılıç Sokak'ta elektrik kesilecektir."
                              },
                          
                          @{
                              @"title":@"Hola",
                              @"created_at": @"2015-06-14 10:00:00",
                              @"content":@"Sevgili Fenerbahçeliler, 16.04.2015 tarihinde Saat 09.00-14.00 saatleri arasında Kılıç Sokak'ta elektrik kesilecektir."
                              },
                          @{
                              @"title":@"Hola",
                              @"created_at": @"2015-06-14 10:00:00",
                              @"content":@"Sevgili Fenerbahçeliler, 16.04.2015 tarihinde Saat 09.00-14.00 saatleri arasında Kılıç Sokak'ta elektrik kesilecektir."
                              },
                          @{
                              @"title":@"Hola",
                              @"created_at": @"2015-06-14 10:00:00",
                              @"content":@"Sevgili Fenerbahçeliler, 16.04.2015 tarihinde Saat 09.00-14.00 saatleri arasında Kılıç Sokak'ta elektrik kesilecektir."
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
    [self setTitle:LocalizedString(@"Duyurular")];
}

@end
