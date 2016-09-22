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
    IBOutlet NSLayoutConstraint *constContainerHeight;
    IBOutlet UIView *viewContainer;
    IBOutlet UITableView *tblTags;
    IBOutlet UIButton *btnCancel,*btnOk;
    id<TagSelectorDelegate> delegate;
    NSArray *arrItems;
}
@end

@implementation TagSelectorVC

- (id)initWithDelegate:(id<TagSelectorDelegate>)_delegate{
    
    if(self = [super init]){
        self = [[[NSBundle mainBundle] loadNibNamed:@"TagSelectorVC" owner:self options:nil] lastObject];
        delegate = _delegate;
        viewContainer.layer.cornerRadius = cornerRadius;
        btnCancel.layer.cornerRadius = cornerRadius;
        btnOk.layer.cornerRadius = cornerRadius;
        self.translatesAutoresizingMaskIntoConstraints = YES;
        [btnCancel setTitle:[LocalizedString(@"dismiss") toUpper]];
        [btnOk setTitle:[LocalizedString(@"ok") toUpper]];
    }
    return self;
}

- (void) setItems:(NSArray*)_items{
    arrItems = _items;
    [tblTags reloadData];
}

-(IBAction)actClose:(id)sender{
    [self dismiss];
}

-(IBAction)actOk:(id)sender{
    
    NSArray *selectedIndexPaths =  [tblTags indexPathsForSelectedRows];
    
    if (selectedIndexPaths && selectedIndexPaths.count > 0) {
        
        NSMutableArray *selectedRows = [[NSMutableArray alloc] initWithCapacity:selectedIndexPaths.count];
        
        for (NSIndexPath *indexPath in selectedIndexPaths) {
            [selectedRows addObject:[NSNumber numberWithInteger:indexPath.row]];
        }
        
        if([delegate respondsToSelector:@selector(selectedTags:)]) {
            [delegate selectedTags:selectedRows];
        }
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.1f];
    }
    else{
    	[self performSelector:@selector(dismiss) withObject:nil afterDelay:0.1f];
    }
}

#pragma mark Interface
- (void) show{
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self setFrame:[APPDELEGATE window].bounds];
    [[APPDELEGATE window].rootViewController.view addSubview:self];
}

- (void) dismiss{
    [self removeFromSuperview];
}

#pragma mark TableView

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrItems count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
    
    NSArray *selectedIndexPaths =  [tblTags indexPathsForSelectedRows];
    if (selectedIndexPaths.count > 5) {
        [tblTags deselectRowAtIndexPath:indexPath animated:NO];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark -

@end

