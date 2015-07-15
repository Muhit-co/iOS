//
//  AnnouncementCell.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "AnnouncementCell.h"

@interface AnnouncementCell(){
    IBOutlet UILabel *lblTitle,*lblDate,*lblDescription;
    IBOutlet UIImageView *imgIcon;
}
@end

@implementation AnnouncementCell

- (id)init{
    
    if(self = [super init]){
        self = [[[NSBundle mainBundle] loadNibNamed:@"AnnouncementCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setWithDictionary:(NSDictionary *)dict{
    [lblTitle setText:dict[@"title"]];
    [lblDate setText:[UF getDetailedDateString:dict[@"created_at"]]];
	[lblDescription setText:dict[@"content"]];
    [imgIcon setImage:[IonIcons imageWithIcon:ion_chatbox size:23 color:CLR_LIGHT_BLUE]];
}

@end
