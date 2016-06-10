//
//  SupportedCell.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "SupportedCell.h"
#import "UIImageView+WebCache.h"

@interface SupportedCell (){
    IBOutlet UILabel *lblTitle,*lblDate;
    IBOutlet UIImageView *imgSupported,*imgArrow;
}
@end

@implementation SupportedCell

- (id)init{
    
    if(self = [super init]){
        self = [[[NSBundle mainBundle] loadNibNamed:@"SupportedCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setWithDictionary:(NSDictionary *)dict{
    [lblTitle setText:dict[@"title"]];
    [lblDate setText:dict[@"date"]];

    [imgSupported sd_setImageWithURL:[NSURL URLWithString:dict[@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"issuePlaceholder"]];
    imgSupported.layer.cornerRadius = cornerRadius;
    imgSupported.layer.masksToBounds = YES;
    
    [imgArrow setImage:[IonIcons imageWithIcon:ion_chevron_right size:15 color:CLR_LIGHT_BLUE]];
}

@end
