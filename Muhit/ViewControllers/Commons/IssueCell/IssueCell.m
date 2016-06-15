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
    IBOutlet NSLayoutConstraint *constViewTypeWidth,*constViewTagsWidth,*constDateLeft;
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
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0.8;
    
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: CLR_LIGHT_BLUE,
                              NSFontAttributeName: [UIFont fontWithName:FONT_BOLD size:16],
                              NSParagraphStyleAttributeName: paragraphStyle
                              };
    
    [lblTitle setAttributedText:[[NSAttributedString alloc] initWithString:dict[@"title"] attributes:attribs]];
    [lblDate setText:[UF getDetailedDateString:dict[@"created_at"]]];
    [lblCount setText:[dict[@"supporter_count"] stringValue]];
    if (dict[@"images"] && [dict[@"images"] count]>0) {
        NSString *imgUrl = [NSString stringWithFormat:@"%@/100x100/%@",IMAGE_PROXY,dict[@"images"][0][@"image"]];
        [imgIssue sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"issue-placeholder"]];
    }
    else{
        [imgIssue setImage:[UIImage imageNamed:@"issue-placeholder"]];
    }
    
    imgIssue.layer.cornerRadius = cornerRadius;
    imgIssue.layer.masksToBounds = YES;
    viewType.layer.cornerRadius = cornerRadius;
    
    CGSize textSize = [[lblCount text] sizeWithAttributes:@{NSFontAttributeName:[lblCount font]}];
    constViewTypeWidth.constant = 35 + textSize.width+3;
    [self layoutIfNeeded];
    
    if ([dict[@"status"] isEqualToString:@"new"]) {
        if ([lblCount.text isEqualToString:@"0"]) {
            [viewType setBackgroundColor:CLR_WHITE];
            viewType.layer.borderWidth = 1;
            viewType.layer.borderColor = [[HXColor hx_colorWithHexRGBAString:@"CCCCDD"] CGColor];
            [lblCount setTextColor:CLR_LIGHT_BLUE];
            [imgTypeIcon setImage:[IonIcons imageWithIcon:ion_lightbulb size:18 color:CLR_LIGHT_BLUE]];
        }
        else{
            [viewType setBackgroundColor:CLR_LIGHT_BLUE];
            [imgTypeIcon setImage:[IonIcons imageWithIcon:ion_lightbulb size:18 color:CLR_WHITE]];
        }
    }
    else if ([dict[@"status"] isEqualToString:@"developing"]){
        [viewType setBackgroundColor:[HXColor hx_colorWithHexRGBAString:@"C678EA"]];
        [imgTypeIcon setImage:[IonIcons imageWithIcon:ion_wrench size:18 color:CLR_WHITE]];
    }
    else{
        [viewType setBackgroundColor:[HXColor hx_colorWithHexRGBAString:@"27AE60"]];
        [imgTypeIcon setImage:[IonIcons imageWithIcon:ion_checkmark_circled size:18 color:CLR_WHITE]];
    }
    
    /* Tags Area */
    
    if ([dict[@"tags"] count]==3) {
        [self setTags:viewTag1 tag:dict[@"tags"][0]];
        [self setTags:viewTag2 tag:dict[@"tags"][1]];
        [self setTags:viewTag3 tag:dict[@"tags"][2]];
        constViewTagsWidth.constant = 40;
    }
    else if ([dict[@"tags"] count]==2){
        [self setTags:viewTag1 tag:dict[@"tags"][0]];
        [self setTags:viewTag2 tag:dict[@"tags"][1]];
        [viewTag3 removeFromSuperview];
        constViewTagsWidth.constant = 25;
    }
    else if ([dict[@"tags"] count]==1){
        [self setTags:viewTag1 tag:dict[@"tags"][0]];
        [viewTag2 removeFromSuperview];
        [viewTag3 removeFromSuperview];
        constViewTagsWidth.constant = 10;
    }
    else{
        [viewTag1 removeFromSuperview];
        [viewTag2 removeFromSuperview];
        [viewTag3 removeFromSuperview];
        constViewTagsWidth.constant = 0;
        constDateLeft.constant = 0;
    }
    
    [self layoutIfNeeded];
}

-(void)setTags:(UIView *)view tag:(NSDictionary *)tag{
    view.layer.cornerRadius = 5;
    [view setBackgroundColor:[HXColor hx_colorWithHexRGBAString:tag[@"background"]]];
}

@end
