//
//  IssueCell.m
//  Muhit
//
//  Created by Emre YANIK on 04/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "IssueCell.h"
#import "UIImageView+WebCache.h"

@interface IssueCell (){
    IBOutlet UILabel *lblTitle,*lblDate,*lblCount;
    IBOutlet UIImageView *imgIssue,*imgTypeIcon;
    IBOutlet UIView *viewType,*viewTags,*viewTag1,*viewTag2,*viewTag3;
    IBOutlet NSLayoutConstraint *constViewTypeWidth;
    float totalTagsWidth;
}
@end


@implementation IssueCell

- (id)init{
    
    if(self = [super init]){
        self = [[[NSBundle mainBundle] loadNibNamed:@"IssueCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setWithDictionary:(NSDictionary *)dict{
    
    [lblTitle setText:dict[@"title"]];
    [lblDate setText:[UF getDetailedDateString:dict[@"created_at"]]];
    [lblCount setText:[dict[@"supporter_counter"] stringValue]];
    if (dict[@"images"] && [dict[@"images"] count]>0) {
        NSString *imgUrl = [NSString stringWithFormat:@"%@/140x140/%@",IMAGE_PROXY,dict[@"images"][0][@"image"]];
        [imgIssue sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"issuePlaceholder"]];
    }
    else{
        [imgIssue setImage:[UIImage imageNamed:@"issuePlaceholder"]];
    }
    
    imgIssue.layer.cornerRadius = cornerRadius;
    imgIssue.layer.masksToBounds = YES;
    
    viewType.layer.cornerRadius = cornerRadius;
    CGSize textSize = [[lblCount text] sizeWithAttributes:@{NSFontAttributeName:[lblCount font]}];
    constViewTypeWidth.constant = 40 + textSize.width+3;
    [self layoutIfNeeded];
    
    if ([dict[@"status"] isEqualToString:@"new"]) {
        [viewType setBackgroundColor:[HXColor hx_colorWithHexRGBAString:@"44a2e0"]];
        [imgTypeIcon setImage:[IonIcons imageWithIcon:ion_lightbulb size:20 color:CLR_WHITE]];
    }
    else if ([dict[@"status"] isEqualToString:@"developing"]){
        [viewType setBackgroundColor:[HXColor hx_colorWithHexRGBAString:@"c677ea"]];
        [imgTypeIcon setImage:[IonIcons imageWithIcon:ion_wrench size:20 color:CLR_WHITE]];
    }
    else{
        [viewType setBackgroundColor:[HXColor hx_colorWithHexRGBAString:@"27ae61"]];
        [imgTypeIcon setImage:[IonIcons imageWithIcon:ion_checkmark_circled size:20 color:CLR_WHITE]];
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
    
    [self layoutIfNeeded];
}

-(void)setTags:(UIView *)view tag:(NSDictionary *)tag{
    view.layer.cornerRadius = 15/2;
    [view setBackgroundColor:[HXColor hx_colorWithHexRGBAString:tag[@"background"]]];
}

@end
