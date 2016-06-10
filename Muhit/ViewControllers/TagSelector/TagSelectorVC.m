//
//  InitSelectorVC.m
//  Taksicim
//
//  Created by Emre YANIK on 01/12/14.
//  Copyright (c) 2014 Halid Ozsoy. All rights reserved.
//

#import "TagSelectorVC.h"
#import "TagCell.h"

@interface TagSelectorVC (){
    IBOutlet NSLayoutConstraint *containerViewHeightConst;
    IBOutlet UIView *viewContainer;
    IBOutlet UITableView *tblTags;
    NSArray *arrItems;
}

@end

@implementation TagSelectorVC

- (id)init
{
    self = [super initWithNibName:@"TagSelectorVC" bundle:nil];
    if (self) {
    }
    return self;
}

#pragma mark Life Cycle
- (void) viewDidLoad{
    [super viewDidLoad];
    viewContainer.layer.cornerRadius = cornerRadius;
    [tblTags reloadData];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view layoutIfNeeded];
}

- (void) setItems:(NSArray*)_items{
    arrItems = _items;
    [tblTags reloadData];
}

-(IBAction)actClose:(id)sender{
    [self dismiss];
}

#pragma mark Interface
- (void) show{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.view];
    [self.view setFrame:[[[UIApplication sharedApplication] delegate] window].bounds];
}

- (void) dismiss{
    [self.view removeFromSuperview];
}

#pragma mark TableView

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrItems count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"TagCell";
    TagCell *cell = [tblTags dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[TagCell alloc] init];
    }
    
    NSDictionary *item = arrItems[indexPath.row];
    
    [cell setWithTitle:item[@"name"] bgColor:item[@"background"]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.delegate respondsToSelector:@selector(selectedTagIndex:)]) {
        [self.delegate selectedTagIndex:(int)indexPath.row];
    }
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.1f];
}

#pragma mark -

@end

