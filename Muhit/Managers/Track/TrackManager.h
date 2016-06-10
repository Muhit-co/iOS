//
//  TrackManager.h
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAI.h"

#define CTG_LOGIN @"Login"
#define CTG_FORGOT @"Forgot_Password"
#define CTG_SIGNUP @"Sign_Up"
#define CTG_MAIN @"Mainscreen"
#define CTG_TAXI_SEARCH @"Taxi_Search"
#define CTG_TAXI_ARRIVING @"Taxi_Arriving"
#define CTG_ONGOING @"On_Going"
#define CTG_PAYMENT @"Payment"
#define CTG_RATE @"Rate"
#define CTG_MENU @"Menu"
#define CTG_PROFILE @"Profile"
#define CTG_CHANGE_PASS @"Change_Password"
#define CTG_DELETE_PROFILE @"Delete_Profile"
#define CTG_TRIP_HISTORY @"Trip_History"
#define CTG_TRIP_DETAIL @"Trip_History_Detail"
#define CTG_DISCOUNT_CODES @"Discount_Codes"
#define CTG_FAVORITES @"Favourites"
#define CTG_SIGNOUT @"Signout"
#define CTG_FARE_CALC @"Fare_Calculator"
#define CTG_PAYMENT_TOOLS @"Payment_Tools"
#define CTG_ADD_CREDIT @"Add_Credit_Card"
#define CTG_SHARE @"Share"
#define CTG_LANGUAGE @"Language"
#define CTG_ABOUT_US @"About_Us"
#define CTG_FEEDBACK @"Feedback"
#define CTG_HOWTO @"How_To_Use"
#define CTG_FAQ @"Faq"

@interface TrackManager : NSObject

+ (id)sharedManager;

- (void)trackEventWithCategory:(NSString*)category desc:(NSString*)description label:(NSString*)label value:(NSNumber*)value;
- (void)trackEventWithCategory:(NSString*)category desc:(NSString*)description label:(NSString*)label;
- (void)trackEventWithCategory:(NSString*)category desc:(NSString*)description;
- (void)setScreenName:(NSString*)screenName;

@end
