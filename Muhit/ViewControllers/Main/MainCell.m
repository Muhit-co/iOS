//
//  MainCell.m
//  Muhit
//
//  Created by Emre YANIK on 04/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "MainCell.h"
#import "UIImageView+WebCache.h"

@interface MainCell (){
    IBOutlet UILabel *lblTitle,*lblDate,*lblCount;
    IBOutlet UIImageView *imgIssue,*imgTypeIcon;
    IBOutlet UIView *viewType,*viewTags,*viewTag1,*viewTag2,*viewTag3;
    IBOutlet NSLayoutConstraint *constViewTypeWidth;
    float totalTagsWidth;
}
@end


@implementation MainCell

- (id)init{
    
    if(self = [super init]){
        self = [[[NSBundle mainBundle] loadNibNamed:@"MainCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setWithDictionary:(NSDictionary *)dict{
    
    [lblTitle setText:dict[@"title"]];
    [lblDate setText:dict[@"date"]];
    [lblCount setText:dict[@"count"]];
    [imgIssue sd_setImageWithURL:[NSURL URLWithString:dict[@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"issuePlaceholder"]];
    imgIssue.layer.cornerRadius = cornerRadius;
    imgIssue.layer.masksToBounds = YES;

    viewType.layer.cornerRadius = cornerRadius;
    CGSize textSize = [[lblCount text] sizeWithAttributes:@{NSFontAttributeName:[lblCount font]}];
    constViewTypeWidth.constant = 40 + textSize.width+3;
    
    int type = [dict[@"type"] intValue];
    if (type == 0) {
        [viewType setBackgroundColor:[HXColor colorWithHexString:@"44a2e0"]];
        [imgTypeIcon setImage:[IonIcons imageWithIcon:ion_lightbulb size:20 color:[HXColor colorWithHexString:@"FFFFFF"]]];
    }
    else if (type == 1){
        [viewType setBackgroundColor:[HXColor colorWithHexString:@"c677ea"]];
        [imgTypeIcon setImage:[IonIcons imageWithIcon:ion_wrench size:20 color:[HXColor colorWithHexString:@"FFFFFF"]]];
    }
    else{
        [viewType setBackgroundColor:[HXColor colorWithHexString:@"27ae61"]];
        [imgTypeIcon setImage:[IonIcons imageWithIcon:ion_checkmark_circled size:20 color:[HXColor colorWithHexString:@"FFFFFF"]]];
    }
    
    /* Tags Area */
    
    totalTagsWidth = 0;

    if ([dict[@"tags"] count]==3) {
        [self setTags:viewTag1 tag:dict[@"tags"][0]];
        [self setTags:viewTag2 tag:dict[@"tags"][1]];
        [self setTags:viewTag3 tag:dict[@"tags"][2]];
    }
    else if ([dict[@"tags"] count]==2){
        [self setTags:viewTag1 tag:dict[@"tags"][0]];
        [self setTags:viewTag2 tag:dict[@"tags"][1]];
        [viewTag3 removeFromSuperview];
    }
    else if ([dict[@"tags"] count]==1){
        [self setTags:viewTag1 tag:dict[@"tags"][0]];
        [viewTag2 removeFromSuperview];
        [viewTag3 removeFromSuperview];
    }
    else{
        [viewTag1 removeFromSuperview];
        [viewTag2 removeFromSuperview];
        [viewTag3 removeFromSuperview];
    }
}

-(void)setTags:(UIView *)view tag:(NSDictionary *)tag{
    view.layer.cornerRadius = 15/2;
    [view setBackgroundColor:[HXColor colorWithHexString:tag[@"background"]]];
}

@end
