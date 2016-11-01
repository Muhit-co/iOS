//
//  Constants.h
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//
#import <HexColors/HexColors.h>

static const CGFloat cornerRadius = 6;

#define IMAGE_PROXY @"http://d1vwk06lzcci1w.cloudfront.net"

#define APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define UD [NSUserDefaults standardUserDefaults]
#define NC [NSNotificationCenter defaultCenter]
#define MT [Muhit instance]
#define USER [User instance]
#define LM [LanguageManager instance]
#define LocalizedString(key) [[LanguageManager instance] localizedStringForKey:key]
#define TRACKER [TrackManager sharedManager]
#define PLACEHOLDER_IMAGE [UIImage imageNamed:@"profile-placeholder"]
#define LOCATION [LocationManager sharedManager]
#define CURRENT_LOCATION [LocationManager sharedManager].currentLocation.coordinate

#define UF UtilityFunctions
#define ADD_HUD [UtilityFunctions addHud:[self view]];
#define REMOVE_HUD [UtilityFunctions removeHud];
#define ADD_HUD_TOP [UtilityFunctions addHudTop];
#define SHOW_ALERT(MESSAGE) [UtilityFunctions showAlertWithMessageOnly:(MESSAGE)];
#define SHOW_ALERT_WITH_TAG_AND_DELEGATE(MESSAGE, TAG, DELEGATE) [UtilityFunctions showAlertWithMessage:(MESSAGE) tag:(TAG) delegate:(DELEGATE)];
#define SHOW_ALERT_WITH_TAG_DELEGATE_FIRST_SECOND(MESSAGE, TAG, DELEGATE,FIRST,SECOND) [UtilityFunctions showAlertWithMessage:(MESSAGE) tag:(TAG) delegate:(DELEGATE) first:(FIRST) second:(SECOND)];

#define NUMBER_INT(val) [NSNumber numberWithInt:val]
#define NUMBER_DOUBLE(val) [NSNumber numberWithDouble:val]
#define NUMBER_FLOAT(val) [NSNumber numberWithFloat:val]
#define NUMBER_BOOL(val) [NSNumber numberWithBool:val]
#define STRING_W_STR(val) [NSString stringWithFormat:@"%@", val]
#define STRING_W_INT(val) [NSString stringWithFormat:@"%d", val]

#define USER_LANGUAGE @"UserSelectedLanguage"
#define AUTH @"oauth2"

#define isNotNull(variable) variable == [NSNull null] ? NO : (variable ? YES : NO)
#define nilOrJson(VAL) [VAL isKindOfClass:[NSNull class]] ? nil : VAL

#define CLR_LIGHT_BLUE [HXColor hx_colorWithHexRGBAString:@"44A1E0"]
#define CLR_DARK_BLUE [HXColor hx_colorWithHexRGBAString:@"245672"]
#define CLR_DARK_PUPRPLE [HXColor hx_colorWithHexRGBAString:@"666677"]
#define CLR_WHITE [HXColor hx_colorWithHexRGBAString:@"FFFFFF"]

#define NC_GEOCODE_PICKED @"NC_GEOCODE_PICKED"

#define UD_FIRSTNAME @"UD_FIRSTNAME"
#define UD_SURNAME @"UD_SURNAME"
#define UD_HOOD_NAME @"UD_HOOD_NAME"
#define UD_HOOD_LAT @"UD_HOOD_LAT"
#define UD_HOOD_LON @"UD_HOOD_LON"
#define UD_API_TOKEN @"UD_API_TOKEN"
#define UD_LOCATION @"UD_LOCATION"
#define UD_USER_ID @"UD_USER_ID"
#define UD_USERNAME @"UD_USERNAME"
#define UD_EMAIL @"UD_USERNAME"
#define UD_USER_PICTURE @"UD_USER_PICTURE"

#define FONT_BLACK @"SourceSansPro-Black"
#define FONT_REGULAR @"SourceSansPro-Regular"
#define FONT_BOLD @"SourceSansPro-Bold"
#define FONT_SEMI_BOLD @"SourceSansPro-Semibold"
#define FONT_ITALIC @"SourceSansPro-Italic"

