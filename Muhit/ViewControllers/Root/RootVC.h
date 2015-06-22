//
//  RootVC.h
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface RootVC : UIViewController{
    IBOutlet UIScrollView *scrollRoot;
}

- (void) setMuhitLogo;
- (void) back;
- (void) setLocalizedStrings;
- (void)resetScrollOffset;

@end
