//
//  InitSelectorVC.h
//  Taksicim
//
//  Created by Emre YANIK on 01/12/14.
//  Copyright (c) 2014 Halid Ozsoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagSelectorVC;

@protocol TagSelectorDelegate <NSObject>

- (void) selectedTagIndex:(int)index;

@end

@interface TagSelectorVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id<TagSelectorDelegate> delegate;
- (void) setItems:(NSArray*)_items;
- (void) show;
- (void) dismiss;
@end
