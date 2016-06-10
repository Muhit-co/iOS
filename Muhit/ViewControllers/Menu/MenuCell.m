//
//  MenuCell.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "MenuCell.h"

@interface MenuCell (){
    IBOutlet UILabel *lblTitle;
    IBOutlet UIImageView *imgIcon;
    IBOutlet UIImageView *imgDown;
    IBOutlet NSLayoutConstraint *iconLeadingConstraint;
}
@end


@implementation MenuCell

- (id)init{
    
    if(self = [super init]){
        self = [[[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setTitle:(NSString *)title icon:(NSString *)icon{
    lblTitle.text = title;
    imgIcon.image = [IonIcons imageWithIcon:icon
                                       size:18
                                      color:CLR_WHITE];
    
}

@end
