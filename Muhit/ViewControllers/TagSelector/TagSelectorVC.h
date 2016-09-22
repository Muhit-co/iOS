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

- (void) selectedTags:(NSArray*)tags;

@end

@interface TagSelectorVC : UIView<UITableViewDelegate, UITableViewDataSource>

- (id)initWithDelegate:(id<TagSelectorDelegate>)_delegate;
- (void) setItems:(NSArray*)_items;
- (void) show;
- (void) dismiss;
@end
