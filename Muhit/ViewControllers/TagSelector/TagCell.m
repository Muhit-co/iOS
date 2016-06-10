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
}
@end

@implementation TagCell

- (id)init{
    if(self = [super init]){
        self = [[[NSBundle mainBundle] loadNibNamed:@"TagCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setWithTitle:(NSString*)title bgColor:(NSString*)bgColor{
    [lblTitle setText:[title toUpper]];
    [[self contentView] setBackgroundColor:[HXColor colorWithHexString:bgColor]];
}

@end
