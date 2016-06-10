//
//  PlacesView.h
//  Muhit
//
//  Created by Emre YANIK on 17/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlacesView;

@protocol PlacesViewDelegate <NSObject>

@optional
- (void) placesView:(PlacesView *)placesView selectedAddress:(GMSAutocompletePrediction *)selectedAddress;
@end


@interface PlacesView : UIView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) id<PlacesViewDelegate>delegate;
-(void)show;
@end
