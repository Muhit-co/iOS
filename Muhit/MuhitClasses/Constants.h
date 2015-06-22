//
//  Constants.h
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//
#import <HexColors/HexColor.h>

static const float kmBetweenClientAndDriverToVibrate = 100;
static const CGFloat cornerRadius = 6;

#define APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define UD [NSUserDefaults standardUserDefaults]
#define NC [NSNotificationCenter defaultCenter]
#define MT [Muhit instance]
#define LocalizedString(key) [[LanguageManager instance] localizedStringForKey:key]
#define TRACKER [TrackManager sharedManager]

#define UF UtilityFunctions
#define ADD_HUD [UtilityFunctions addHud:[self view]];
#define REMOVE_HUD [UtilityFunctions removeHud];
#define ADD_HUD_TOP [UtilityFunctions addHudTop];
#define SHOW_ALERT(MESSAGE) [UtilityFunctions showAlertWithMessageOnly:(MESSAGE)];
#define SHOW_ALERT_WITH_TAG_AND_DELEGATE(MESSAGE, TAG, DELEGATE) [UtilityFunctions showAlertWithMessage:(MESSAGE) tag:(TAG) delegate:(DELEGATE)];

#define NUMBER_INT(val) [NSNumber numberWithInt:val]
#define NUMBER_DOUBLE(val) [NSNumber numberWithDouble:val]
#define NUMBER_FLOAT(val) [NSNumber numberWithFloat:val]
#define NUMBER_BOOL(val) [NSNumber numberWithBool:val]
#define STRING_W_STR(val) [NSString stringWithFormat:@"%@", val]
#define STRING_W_INT(val) [NSString stringWithFormat:@"%d", val]

#define USER_LANGUAGE @"UserSelectedLanguage"
#define AUTH @"oauth2"

#define isNotNull(variable) variable == [NSNull null] ? NO : (variable ? YES : NO)

#define CLR_LIGHT_BLUE [HXColor colorWithHexString:@"44a2e0"]
#define CLR_DARK_BLUE [HXColor colorWithHexString:@"245573"]
#define CLR_DARK_PUPRPLE [HXColor colorWithHexString:@"666677"]

#define PATH_FARE_CALCULATOR @"fareCalculator"
#define PATH_PAYMENT_TOOLS @"paymentTools"
#define PATH_ADD_CARD @"addCard"
#define PATH_ADD_BKM @"addBkm"
#define PATH_ADD_PAYPAL @"addPaypal"
#define PATH_ADD_DISCOUNT_CODE @"addDiscount"
#define PATH_FAV_ADDRESS @"favAddresses"
#define PATH_OLD_TRIPS @"oldTrips"
#define PATH_PROFILE @"profile"
#define PATH_SHARE @"share"
#define PATH_HOW_TO @"howTo"
#define PATH_NOTIFICATIONS @"notifications"


#define NC_LOGGED_OUT @"NC_LOGGED_OUT"

#define UD_FIRSTNAME @"UD_FIRSTNAME"
#define UD_SURNAME @"UD_SURNAME"
#define UD_HOOD_NAME @"UD_HOOD_NAME"
#define UD_HOOD_LAT @"UD_HOOD_LAT"
#define UD_HOOD_LON @"UD_HOOD_LON"
#define UD_ACCESS_TOKEN @"UD_ACCESS_TOKEN"
#define UD_REFRESH_TOKEN @"UD_REFRESH_TOKEN"
#define UD_ACCESS_TOKEN_LIFETIME @"UD_ACCESS_TOKEN_LIFETIME"
#define UD_ACCESS_TOKEN_TAKEN_DATE @"UD_ACCESS_TOKEN_TAKEN_DATE"


