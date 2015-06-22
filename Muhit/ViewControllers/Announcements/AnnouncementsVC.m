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
    NSArray *arrAnnouncements;
}

@end

@implementation AnnouncementsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}

-(void)test{
    arrAnnouncements =@[
                        @{
                            @"title":@"Lorem ipsum dolor sit amet, consectetur adipiscing",
                            @"date":@"10.11.2015",
                            @"description":@"Aliquam ut tellus sit amet nulla porta congue vitae vel leo. Pellentesque ac accumsan felis. Curabitur euismod placerat tortor posuere venenatis. Proin id bibendum orci, eu lobortis libero."
                            },
                        @{
                            @"title":@"Lorem ipsum dolor sit amet, consectetur adipiscing",
                            @"date":@"12.11.2015",
                            @"description":@"Aliquam ut tellus sit amet nulla porta congue vitae vel leo. Pellentesque ac accumsan felis. Curabitur euismod placerat tortor posuere venenatis. Proin id bibendum orci, eu lobortis libero."
                            },
                        
                        @{
                            @"title":@"Lorem ipsum dolor sit amet, consectetur adipiscing",
                            @"date":@"08.11.2015",
                            @"description":@"Aliquam ut tellus sit amet nulla porta congue vitae vel leo. Pellentesque ac accumsan felis. Curabitur euismod placerat tortor posuere venenatis. Proin id bibendum orci, eu lobortis libero."
                            }];
    
    [tblAnnouncements reloadData];
}

#pragma mark - UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float textHeight = [UF heightOfTextForString:arrAnnouncements[indexPath.row][@"description"] andFont:[UIFont fontWithName:@"SourceSansPro-It" size:17.0] maxSize:CGSizeMake(self.view.width-100, 200)];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   	NSDictionary *item = [arrAnnouncements objectAtIndex:indexPath.row];
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
