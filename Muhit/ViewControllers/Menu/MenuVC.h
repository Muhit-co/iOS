//
//  MenuVC.h
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "MenuCell.h"

#define MENU_ITEM_SELECTED @"MenuItemSelected"

#define SELECTOR_MAIN @"openMain:"
#define SELECTOR_SUPPORTS @"openSupporteds:"
#define SELECTOR_IDEAS @"openIdeas:"
#define SELECTOR_NOTIFICATIONS @"openAnnouncements:"
#define SELECTOR_HEADMAN @"openHeadman:"

@interface MenuVC : RootVC<UITableViewDelegate,UITableViewDataSource>

@end
