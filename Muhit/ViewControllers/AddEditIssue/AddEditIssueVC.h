//
//  AddEditIssueVC.h
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//
#import "TagSelectorVC.h"

@interface AddEditIssueVC : RootVC <UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,TagSelectorDelegate>

- (id)initWithInfo:(NSDictionary *)_info;

@end
