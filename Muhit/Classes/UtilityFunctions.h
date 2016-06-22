//
//  UtilityFunctions.h
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h> 
#import <CommonCrypto/CommonDigest.h>

#define NO_MOVE -999
#define DEFAULT_DURATION 0

typedef enum{
    
    DeviceType_iPhone,
    DeviceType_iPad
    
}DeviceType;

@interface UtilityFunctions : NSObject

+(BOOL)isNumerical:(NSString*)stringToCheck;
+(BOOL)isLetter:(NSString*)stringToCheck;
+(BOOL)isAlphaNumerical:(NSString*)stringToCheck;
+(BOOL)isAlphaNumericalAndEnglishCapitalChars:(NSString *)stringToCheck;
+(NSString*)notNullString:(NSString*)stringToCheck;
+(NSString*)trim:(NSString*)stringToCheck;

+(BOOL) validateEmail: (NSString *) candidate;

+(BOOL)checkTextFieldForNameSurname:(UITextField*)textField string:(NSString*)string minLength:(int)min maxLength:(int)max;
+(BOOL)checkTextFieldForNumbers:(UITextField*)textField string:(NSString*)string minLength:(int)min maxLength:(int)max;
+(BOOL)checkTextFieldForTCKimlik:(UITextField*)textField string:(NSString*)string;
+(BOOL)checkTextFieldForCVC2:(UITextField*)textField string:(NSString*)string;

+(BOOL)isDateEarlier:(NSDate*)date fromDate:(NSDate*)fromDate;

+(void)moveViewBy:(UIView*)view x:(int)x y:(int)y;
+(void)moveViewTo:(UIView*)view x:(int)x y:(int)y;
+(void)moveViewBy:(UIView*)view x:(int)x y:(int)y withDuration:(double)duration;
+(void)moveViewTo:(UIView*)view x:(int)x y:(int)y withDuration:(double)duration;

+(void)setViewToSupersBottom:(UIView*)view;

+ (CGFloat)screenHeight;

+(bool)isIdiomPhone5;
+(bool)isiPhone5;
+(bool)isiPhone6;
+(bool)isiPhone6Plus;

+(NSString*)deviceType;
+(NSString*)deviceModel;
+(NSString*)vendorId;
+(NSString*)language;
+(NSString*)appVersion;
+(NSString*)osVersion;
+(NSString*)getDateFromDateTime:(NSString*)date;
+(NSString*)getTimeFromDateTime:(NSString*)d;
+(NSString*)getMeanTime:(NSString*)d;
+(NSString*)getFormattedDateString:(NSString*)d;
+(NSString*)getDetailedDateString:(NSString*)d;
+(NSString *)backwardReferencedTimeStringForDate:(NSDate *)date;
+(NSDate*)getCurrentDateFromDateTime:(NSString*)date;
+(NSString*)sha1:(NSString*)input;
+(NSString*)md5:(NSString*)input;

+ (void)addHud:(UIView*)view;
+ (void)removeHud;
+ (void)addHudTop;
+ (void)showAlertWithMessageOnly:(NSString *)message;
+ (void)showAlertWithMessage:(NSString *)message tag:(int)tag delegate:(id)delegate;
+ (void)showAlertWithMessage:(NSString *)message tag:(int)tag delegate:(id)delegate first:(NSString *)first second:(NSString *)second;

+(NSString *)urlencodeWithString:(NSString *)str;
+(CGFloat)heightOfTextForString:(NSString *)aString andFont:(UIFont *)aFont maxSize:(CGSize)aSize;
+(void) addPaddingToAllTextFieldsInView:(UIView*)view;
+(void) makeFacebookButton:(UIButton*)btn;
+(NSDictionary*)parseURLParams:(NSString *)query;
+(UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect;
+(UIImage*)resizeImage:(UIImage*)image withWidth:(CGFloat)width withHeight:(CGFloat)height;
+(void)logFrame:(UIView*)view identifier:(NSString*)identifier;
+(void)setBlackBackground:(UIImageView*)imgView;
+(void)setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners radius:(float)radius;

+ (BOOL)validateSignUpInputWithName:(NSString*)name
                            surname:(NSString*)surname
                              email:(NSString*)email
                           password:(NSString*)password
                    isFacebookLogin:(BOOL)isFacebookLogin;

+ (BOOL)validateLoginWithEmail:(NSString*)email password:(NSString*)password;

+ (BOOL)validateIssue:(NSString*)title problem:(NSString*)problem solution:(NSString*)solution;

+ (NSDictionary *)parsePlaces:(GMSAutocompletePrediction *)address;

+(void)setUserDefaultsWithDetails:(NSDictionary*)details;

+(NSString*)urlEscapeString:(NSString *)unencodedString;
+(NSString*)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary;
+(NSString*)getDistrictFromAddress:(NSString *)address;
+(NSString*)getHoodFromAddress:(NSString *)address;

+(CGSize)screenSize;
+(UIView*)titleViewWithTitle:(NSString*)title;

+(NSString*)getHoodFromGMSAddress:(NSDictionary *)address;
+(NSString*)getDistrictCityFromGMSAddress:(NSDictionary *)address;
@end
