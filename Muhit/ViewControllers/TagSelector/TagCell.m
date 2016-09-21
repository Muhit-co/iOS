//
//  ResponsiveCell.m
//  BiTaksi Src
//
//  Created by Emre YANIK on 08/09/14.
//  Copyright (c) 2014 BiTaksi. All rights reserved.
//

#import "TagCell.h"

@interface TagCell(){
    IBOutlet UILabel *lblTitle;
    IBOutlet UIView *viewBg,*viewTag;
    IBOutlet UIImageView *imgTick;
    IBOutlet NSLayoutConstraint *constTagWith;
}
@end

@implementation TagCell

- (id)init{
    if(self = [super init]){
        self = [[[NSBundle mainBundle] loadNibNamed:@"TagCell" owner:self options:nil] lastObject];
        viewTag.layer.cornerRadius = cornerRadius;
    }
    return self;
}

- (void)setWithTitle:(NSString*)title bgColor:(NSString*)bgColor{
    [lblTitle setText:title];
    float lblWidth = [lblTitle.text sizeWithAttributes:@{NSFontAttributeName:lblTitle.font}].width;
    constTagWith.constant = lblWidth+21;
    [self layoutIfNeeded];
    [viewTag setBackgroundColor:[HXColor hx_colorWithHexRGBAString:bgColor]];
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if (selected) {
        [imgTick setHidden:NO];
        [viewBg setHidden:NO];
    }
    else{
        [imgTick setHidden:YES];
        [viewBg setHidden:YES];
    }
    
    [super setSelected:selected animated:animated];
}

@end
