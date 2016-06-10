//
//  PlacesCell.m
//  Muhit
//
//  Created by Emre YANIK on 17/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "PlacesCell.h"

@interface PlacesCell (){
    IBOutlet UILabel *lblAddress,*lblDetail;
    IBOutlet UIImageView *imgLocation;
    IBOutlet UIView *viewLine;
}

@end

@implementation PlacesCell

- (id)init{
    
    if(self = [super init]){
        self = [[[NSBundle mainBundle] loadNibNamed:@"PlacesCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setWithDictionary:(GMSAutocompletePrediction *)address cellOrder:(NSString *)cellOrder{
    
    [imgLocation setImage:[IonIcons imageWithIcon:ion_location size:20 color:CLR_DARK_PUPRPLE]];
    
    if ([cellOrder isEqualToString:@"last"]){
        [viewLine setHidden:YES];
    }
    else{
        [viewLine setHidden:NO];
    }
    
    NSDictionary *parsedAddress = [UF parsePlaces:address];

    [lblAddress setText:parsedAddress[@"hood"]];
    [lblDetail setText:parsedAddress[@"detail"]];
}
@end
