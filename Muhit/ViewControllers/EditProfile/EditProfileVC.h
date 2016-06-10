//
//  EditProfileVC.h
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "BSKeyboardControls.h"

@interface EditProfileVC : RootVC <BSKeyboardControlsDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

- (id)initWithInfo:(NSDictionary *)_info;

@end
