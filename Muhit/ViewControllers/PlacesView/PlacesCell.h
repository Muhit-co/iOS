//
//  PlacesCell.h
//  Muhit
//
//  Created by Emre YANIK on 17/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacesCell : UITableViewCell

- (void)setWithDictionary:(GMSAutocompletePrediction *)address cellOrder:(NSString *)cellOrder;

@end
