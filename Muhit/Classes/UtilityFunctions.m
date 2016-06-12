//
//  UtilityFunctions.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import <sys/utsname.h>

@implementation UtilityFunctions

+(BOOL)isNumerical:(NSString*)stringToCheck{
    
    BOOL returnValue = TRUE;
    
    NSCharacterSet *Set = [NSCharacterSet decimalDigitCharacterSet];
    
    for (int i = 0; i < [stringToCheck length]; i++) {
        returnValue = [Set characterIsMember:[stringToCheck characterAtIndex:i]] && returnValue; 
    }
    
    return returnValue;
}

+(BOOL)isLetter:(NSString*)stringToCheck{
    
    BOOL returnValue = TRUE;
    
    NSCharacterSet *Set = [NSCharacterSet letterCharacterSet];
    
    for (int i = 0; i < [stringToCheck length]; i++) {
        returnValue = [Set characterIsMember:[stringToCheck characterAtIndex:i]] && returnValue; 
    }
    
    return returnValue;
}

+(BOOL)isAlphaNumerical:(NSString*)stringToCheck{
    
    BOOL returnValue = TRUE;
    
    NSCharacterSet *Set = [NSCharacterSet alphanumericCharacterSet];
    
    for (int i = 0; i < [stringToCheck length]; i++) {
        returnValue = [Set characterIsMember:[stringToCheck characterAtIndex:i]] && returnValue; 
    }
    
    return returnValue;
}

+(BOOL)isAlphaNumericalAndEnglishCapitalChars:(NSString *)stringToCheck{
    
    BOOL returnValue = TRUE;
    
    NSRange lcEnglishRange;
    
    NSCharacterSet *lcEnglishLetters;    
    
    lcEnglishRange.location = (unsigned int)'A';
    
    lcEnglishRange.length = 26;
    
    lcEnglishLetters = [NSCharacterSet characterSetWithRange:lcEnglishRange];
    
    for (int i = 0; i < [stringToCheck length]; i++) {
        returnValue = ([lcEnglishLetters characterIsMember:[stringToCheck characterAtIndex:i]] || [self isNumerical:stringToCheck] ) && returnValue;
    }
    
    return returnValue;
}

+(NSString*)notNullString:(NSString*)stringToCheck{
    
    if(stringToCheck != nil)
        return stringToCheck;
    
    return @"";    
}

+(NSString*)trim:(NSString*)stringToCheck{
    return [stringToCheck stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+(BOOL)validateEmail:(NSString *) candidate {
    if (candidate.length==0) {
        return YES;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:candidate];
}

+(BOOL)checkTextFieldForNameSurname:(UITextField*)textField string:(NSString*)string minLength:(int)min maxLength:(int)max{
    
    max = (max == 0) ? INT_MAX : max;
    
    if ([string length] == 0) {
        if ([textField.text length] > min) {
            return YES;
        }
        return NO;
    }
    
    if ([textField.text length] < max) {
        if ([self isLetter:string] || [string isEqualToString:@" "])
            return YES;
        else
            return NO;
    }
    else
        return NO;
    
    
    return YES;
}

+(BOOL)checkTextFieldForNumbers:(UITextField*)textField string:(NSString*)string minLength:(int)min maxLength:(int)max{
    max = (max == 0) ? INT_MAX : max;
    
    if ([string length] == 0) {
        if ([textField.text length] > min) {
            return YES;
        }
        return NO;
    }
    
    if ([textField.text length] < max) {
        if ([self isNumerical:string])
            return YES;
        else
            return NO;
    }
    else
        return NO;
    
    
    return YES;
}

+(BOOL)checkTextFieldForTCKimlik:(UITextField*)textField string:(NSString*)string{
    
    if ([string length] == 0) {
        return YES;        
    }
    
    if ([textField.text length] < 11) {
        if ([self isNumerical:string])
            return YES;
        else
            return NO;
    }
    else
        return NO;
    
    
    return YES;
}

+(BOOL)checkTextFieldForCVC2:(UITextField*)textField string:(NSString*)string{
    
    if ([string length] == 0) {
        return YES;        
    }
    
    if ([textField.text length] < 3) {
        if ([self isNumerical:string])
            return YES;
        else
            return NO;
    }
    else
        return NO;    
    
    return YES;
}

+(BOOL)isDateEarlier:(NSDate*)date fromDate:(NSDate*)fromDate{
    
    if ([date compare:fromDate] == NSOrderedDescending) {
        return YES;
    }
    
    return NO;
}

+(void)moveViewBy:(UIView*)view x:(int)x y:(int)y{
    
    [self moveViewBy:view x:x y:y withDuration:DEFAULT_DURATION];
}

+(void)moveViewTo:(UIView*)view x:(int)x y:(int)y{
    
    [self moveViewTo:view x:x y:y withDuration:DEFAULT_DURATION];
}

+(void)moveViewBy:(UIView*)view x:(int)x y:(int)y withDuration:(double)duration{
    
    x = (x == NO_MOVE) ? 0 : x;
    y = (y == NO_MOVE) ? 0 : y;
    
    CGPoint origin = view.frame.origin;
    CGSize size = view.frame.size;
    
    [UIView beginAnimations:@"MoveViewBy" context:nil];
    [UIView setAnimationDuration:duration];
    
    [view setFrame:CGRectMake(origin.x + x, origin.y + y, size.width, size.height)];
    
    [UIView commitAnimations]; 
}

+(void)moveViewTo:(UIView*)view x:(int)x y:(int)y withDuration:(double)duration{
    
    CGPoint origin = view.frame.origin;
    CGSize size = view.frame.size;
    
    x = (x == NO_MOVE) ? origin.x : x;
    y = (y == NO_MOVE) ? origin.y : y;
    
    [UIView beginAnimations:@"MoveViewTo" context:nil];
    [UIView setAnimationDuration:duration];
    
    [view setFrame:CGRectMake(x, y, size.width, size.height)];
    
    [UIView commitAnimations];    
}

+(void)setViewToSupersBottom:(UIView*)view{
    
    UIView *superview = [view superview];
    
    [view setFrame:CGRectMake(0,
                              superview.frame.origin.y + superview.frame.size.height - view.frame.size.height,
                              view.frame.size.width,
                              view.frame.size.height)
     ];
}

+(NSString*)deviceType{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return @"iPhone";
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return @"iPad";
    }
    return @"iPhone";
}

+(NSString*)deviceModel{
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSDictionary *commonNamesDictionary =
    @{
      @"i386":     @"iPhone Simulator",
      @"x86_64":   @"iPad Simulator",
      
      @"iPhone1,1":    @"iPhone",
      @"iPhone1,2":    @"iPhone 3G",
      @"iPhone2,1":    @"iPhone 3GS",
      @"iPhone3,1":    @"iPhone 4",
      @"iPhone3,2":    @"iPhone 4(Rev A)",
      @"iPhone3,3":    @"iPhone 4(CDMA)",
      @"iPhone4,1":    @"iPhone 4S",
      @"iPhone5,1":    @"iPhone 5(GSM)",
      @"iPhone5,2":    @"iPhone 5(GSM+CDMA)",
      @"iPhone5,3":    @"iPhone 5c(GSM)",
      @"iPhone5,4":    @"iPhone 5c(GSM+CDMA)",
      @"iPhone6,1":    @"iPhone 5s(GSM)",
      @"iPhone6,2":    @"iPhone 5s(GSM+CDMA)",
      @"iPhone7,1":    @"iPhone 6 Plus",
      @"iPhone7,2":    @"iPhone 6",
      
      @"iPad1,1":  @"iPad",
      @"iPad2,1":  @"iPad 2(WiFi)",
      @"iPad2,2":  @"iPad 2(GSM)",
      @"iPad2,3":  @"iPad 2(CDMA)",
      @"iPad2,4":  @"iPad 2(WiFi Rev A)",
      @"iPad2,5":  @"iPad Mini(WiFi)",
      @"iPad2,6":  @"iPad Mini(GSM)",
      @"iPad2,7":  @"iPad Mini(GSM+CDMA)",
      @"iPad3,1":  @"iPad 3(WiFi)",
      @"iPad3,2":  @"iPad 3(GSM+CDMA)",
      @"iPad3,3":  @"iPad 3(GSM)",
      @"iPad3,4":  @"iPad 4(WiFi)",
      @"iPad3,5":  @"iPad 4(GSM)",
      @"iPad3,6":  @"iPad 4(GSM+CDMA)",
      @"iPad4,1":  @"iPad Air(WiFi)",
      @"iPad4,2":  @"iPad Air(GSM)",
      @"iPad4,3":  @"iPad Air(China)",
      @"iPad4,4":  @"iPad Mini 2(WiFi)",
      @"iPad4,5":  @"iPad Mini 2(GSM)",
      @"iPad4,6":  @"iPad Mini 2(China)",
      @"iPad4,7":  @"iPad Mini 3(WiFi)",
      @"iPad4,8":  @"iPad Mini 3(GSM)",
      @"iPad5,3":  @"iPad Air 3(WiFi)",
      @"iPad5,4":  @"iPad Air 2(GSM)",
      
      @"iPod1,1":  @"iPod 1st Gen",
      @"iPod2,1":  @"iPod 2nd Gen",
      @"iPod3,1":  @"iPod 3rd Gen",
      @"iPod4,1":  @"iPod 4th Gen",
      @"iPod5,1":  @"iPod 5th Gen",
      };
    
    NSString *deviceName = commonNamesDictionary[machineName];
    
    if (deviceName == nil) {
        deviceName = machineName;
    }
    
    return deviceName;
}

+(NSString*)vendorId{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+(CGFloat)screenHeight{
    return [UIScreen mainScreen].bounds.size.height - 20;
}

+(bool)isIdiomPhone5{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height * [[UIScreen mainScreen] scale];
        
        if (screenHeight == 1136) {
            return true;
        }
        else{
            return false;
        }
    }
    else{
        return false;
    }
    
    return false;
}

+(bool)isiPhone5{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height * [[UIScreen mainScreen] scale];
        if (screenHeight == 1136) {
            return true;
        }
        else{
            return false;
        }
    }
    else{
        return false;
    }
    return false;
}

+(bool)isiPhone6{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height * [[UIScreen mainScreen] scale];
        if (screenHeight == 1334) {
            return true;
        }
        else{
            return false;
        }
    }
    else{
        return false;
    }
    return false;
}

+(bool)isiPhone6Plus{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height * [[UIScreen mainScreen] scale];
        if (screenHeight == 2208) {
            return true;
        }
        else{
            return false;
        }
    }
    else{
        return false;
    }
    return false;
}

+(NSString*)language{
    
    NSString *language;
    
    @try {
        language = [[NSLocale preferredLanguages] objectAtIndex:0];
    }
    @catch (NSException *exception) {
        language = @"";
    }
    @finally {
        
    }
    return language;
}

+(NSString*)appVersion{
    
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

+(NSString*)osVersion{
    return [[UIDevice currentDevice] systemVersion];
}

+(NSString*)getDateFromDateTime:(NSString*)d{
    
    NSDate *currentDate = [self getCurrentDateFromDateTime:d];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    NSString *date = [f stringFromDate:currentDate];
    
    return date;
}

+(NSString*)getTimeFromDateTime:(NSString*)d{
    
    NSDate *currentDate = [self getCurrentDateFromDateTime:d];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"HH:mm"];
    
    NSString *time = [f stringFromDate:currentDate];
    
    return time;
}

+(NSString*)getMeanTime:(NSString*)d {
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [f dateFromString:d];
    
    [f setLocale:[NSLocale localeWithLocaleIdentifier:@"tr"]];
    [f setDateStyle:NSDateFormatterMediumStyle];
    [f setTimeStyle:NSDateFormatterShortStyle];
    
    return  [f stringFromDate:date];
}

+(NSString*)getFormattedDateString:(NSString*)d{
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [f dateFromString:d];
    
    [f setLocale:[NSLocale localeWithLocaleIdentifier:@"tr"]];
    [f setDateStyle:NSDateFormatterLongStyle];
    [f setTimeStyle:NSDateFormatterNoStyle];
    
    return  [f stringFromDate:date];
}

+(NSString*)getDetailedDateString:(NSString*)d{
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [f dateFromString:d];
    NSDate *now = [NSDate date];
    
    NSTimeInterval totalSeconds = [now timeIntervalSinceDate:date];
    
    if (totalSeconds<60) {
        return [NSString stringWithFormat:@"%d sn önce",(int)totalSeconds];
    }
    else if (totalSeconds<60*60){
        return [NSString stringWithFormat:@"%d dk önce",(int)totalSeconds/60];
    }
    else if (totalSeconds<60*60*24){
        return [NSString stringWithFormat:@"%d sa önce",(int)totalSeconds/(60*60)];
    }
    else if (totalSeconds<60*60*24*2){
        return @"Dün";
    }
    else if (totalSeconds<60*60*24*3){
        return @"2 gün önce";
    }
    else{
        NSInteger year = [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date] year];
        NSInteger currentYear = [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:now] year];
        
        [f setLocale:[NSLocale localeWithLocaleIdentifier:@"tr"]];
        [f setDateStyle:NSDateFormatterMediumStyle];
        [f setTimeStyle:NSDateFormatterNoStyle];
        
        if (year == currentYear) {
            NSString *str = [f stringFromDate:date];
            return [str substringToIndex:[str length] - 5];
        }
        else{
            return  [f stringFromDate:date];
        }
    }
}

+ (NSString *)backwardReferencedTimeStringForDate:(NSDate *)date {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setLocale:[[LanguageManager instance] currentLocale]];
    [f setDateFormat:@"dd MMM (EEE) HH:mm"];
    
    NSString *string = [f stringFromDate:date];
    
    return string;
}

+(NSDate*)getCurrentDateFromDateTime:(NSString*)date{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    
    [f setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.000Z'"];
    
    NSDate *_d = [f dateFromString:date];
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:_d];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:_d];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    NSDate *currentDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:_d];
    
    return currentDate;
}

+(NSString*)sha1:(NSString*)input{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+(NSString*)md5:(NSString*)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

+ (void)addHud:(UIView*)view {
    if (![MT HUD]) {
        [MT setHUD:[[MBProgressHUD alloc] init]];
    }
    
    [[MT HUD] setFrame:view.bounds];
    [view addSubview:[MT HUD]];
    [[MT HUD] bringToFront];
    [[MT HUD] bringToFront];
    [[MT HUD] show:YES];
    [[MT HUD] bringToFront];
}

+ (void)removeHud{
    if ([MT HUD]) {
        [[MT HUD] hide:YES];
        [self performSelector:@selector(removeHudAfterDelay) withObject:nil afterDelay:0.3];
    }
}

+ (void)removeHudAfterDelay{
    [[MT HUD] removeFromSuperview];
}

+ (void)addHudTop{
    [self addHud:[[UIApplication sharedApplication] keyWindow]];
}

+ (void)showAlertWithMessageOnly:(NSString*)message {
    [[[UIAlertView alloc] initWithTitle: @""
                                message: message
                               delegate: nil
                      cancelButtonTitle: LocalizedString(@"ok")
                      otherButtonTitles: nil] show];
}

+ (void)showAlertWithMessage: (NSString*)message
                         tag: (int)tag
                    delegate: (id)delegate {
    
    UIAlertView *alert =  [[UIAlertView alloc] initWithTitle: @""
                                                     message: message
                                                    delegate: delegate
                                           cancelButtonTitle: LocalizedString(@"ok")
                                           otherButtonTitles: nil];
    [alert setTag: tag];
    [alert show];
}

+ (NSString *)urlencodeWithString:(NSString *)str {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[str UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

+(CGFloat)heightOfTextForString:(NSString *)aString andFont:(UIFont *)aFont maxSize:(CGSize)aSize{
    
    CGSize sizeOfText = [aString boundingRectWithSize: aSize
                                              options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes: [NSDictionary dictionaryWithObject:aFont
                                                                                   forKey:NSFontAttributeName]
                                              context: nil].size;
    
    return ceilf(sizeOfText.height);
}
#pragma clang diagnostic pop

+(void) addPaddingToAllTextFieldsInView:(UIView*)view {
    
    for(id currentView in [view subviews]){
        if([currentView isKindOfClass:[UITextField class]]) {
            [currentView setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)]];
            [currentView setLeftViewMode:UITextFieldViewModeAlways];
        }
        else{
            for(id subSubView in [view subviews]){
                [self addPaddingToAllTextFieldsInView:subSubView];
            }
        }
    }
}

+(void) makeFacebookButton:(UIButton*)btn{
    UIImage *originalImage = [UIImage imageNamed:@"fbButton.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(5,5,6,5);
    UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [btn setBackgroundImage:stretchableImage forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor]];
    [btn setTitleShadowColor:[UIColor whiteColor]];
    [[btn titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [[btn titleLabel] setShadowOffset:CGSizeMake(0, 0)];
}


+ (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

+ (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

+ (UIImage*)resizeImage:(UIImage*)image withWidth:(CGFloat)width withHeight:(CGFloat)height{
    CGSize newSize = CGSizeMake(width, height);
    CGFloat widthRatio = newSize.width/image.size.width;
    CGFloat heightRatio = newSize.height/image.size.height;
    
    if(widthRatio > heightRatio){
        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
    }
    else{
        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
+(void)logFrame:(UIView*)view identifier:(NSString*)identifier{
    NSLog(@"%@ Frame=> x:%.0f y:%.0f || width:%.0f height:%.0f",identifier,view.frame.origin.x,view.frame.origin.y,view.frame.size.width,view.frame.size.height);
}



+(void) setBlackBackground:(UIImageView*)imgView{
    [imgView setImage:[[UIImage imageNamed:@"blackBg"] resizableImageWithCapInsets: UIEdgeInsetsMake(7, 7, 7, 7) resizingMode:UIImageResizingModeStretch]];
}

+(void)setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners radius:(float)radius{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius,radius)];
    
    CAShapeLayer* shape = [CAShapeLayer layer];
    shape.bounds = view.bounds;
    [shape setPath:rounded.CGPath];
    
    view.layer.mask = shape;
}

+(void)xorCrypto:(NSData *)input{
    NSString* key = @"bitaksi";
    unsigned char* pBytesInput = (unsigned char*)[input bytes];
    unsigned char* pBytesKey   = (unsigned char*)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    unsigned int vlen = (unsigned int)[input length];
    unsigned int klen = (unsigned int)[key length];
    unsigned int k = vlen % klen;
    unsigned char c;
    
    for (unsigned int v = 0; v < vlen; v++) {
        c = pBytesInput[v] ^ pBytesKey[k];
        pBytesInput[v] = c;
        
        k = (++k < klen ? k : 0);
    }
}

+ (BOOL)validateSignUpInputWithName:(NSString*)name
                            surname:(NSString*)surname
                              email:(NSString*)email
                           password:(NSString*)password
                    isFacebookLogin:(BOOL)isFacebookLogin{
    
    NSMutableArray *messages = [NSMutableArray array];
    
    if (name && surname && ([name length] == 0 || [surname length] == 0)) {
        [messages addObject:LocalizedString(@"Geçerli bir ad-soyad girmelisiniz")];
    }
    
    if (!isFacebookLogin && password && [password length] < 4) {
        [messages addObject:LocalizedString(@"Şifreniz en az 4 haneli olmalıdır")];
    }
    
    if (email.length>0) {
        if([self validateEmail:email] == false) {
            [messages addObject:LocalizedString(@"Geçerli bir e-posta adresi girmelisiniz")];
        }
    }
    
    if ([messages count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[messages componentsJoinedByString:@"\n"]
                                                       delegate:nil
                                              cancelButtonTitle:LocalizedString(@"ok")
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

+ (BOOL)validateLoginWithEmail:(NSString*)email password:(NSString*)password{
    
    NSMutableArray *messages = [NSMutableArray array];
    
    if (password && [password length] < 4) {
        [messages addObject:LocalizedString(@"Şifreniz en az 4 haneli olmalıdır")];
    }
    
    if (email.length>0) {
        if([self validateEmail:email] == false) {
            [messages addObject:LocalizedString(@"Geçerli bir e-posta adresi girmelisiniz")];
        }
    }
    
    if ([messages count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[messages componentsJoinedByString:@"\n"]
                                                       delegate:nil
                                              cancelButtonTitle:LocalizedString(@"ok")
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

+ (BOOL)isAccessTokenValid{
    NSLog(@"token expire:%f",[UD doubleForKey:UD_ACCESS_TOKEN_LIFETIME]);
    double interval = [[NSDate date] timeIntervalSinceDate:[UD objectForKey:UD_ACCESS_TOKEN_TAKEN_DATE]];
    NSLog(@"token interval:%f",interval);
    if (ABS(interval)+10 > [UD doubleForKey:UD_ACCESS_TOKEN_LIFETIME]){
        return NO;
    }
    else{
        return YES;
    }
}

+ (NSDictionary *)parsePlaces:(GMSAutocompletePrediction *)address{
    
    NSArray * arrTexts = [address.attributedFullText.string componentsSeparatedByString:@", "];
    NSUInteger index = [address.types indexOfObject:@"administrative_area_level_4"];
    
    NSString *detail=@"";
    for (NSString *str in arrTexts) {
        if (![str isEqualToString:arrTexts[index]]) {
            if (detail.length==0) {
                detail = [NSString stringWithFormat:@"%@",str];
            }
            else{
                detail = [NSString stringWithFormat:@"%@, %@",detail,str];
            }
        }
    }
    
    return @{@"hood":arrTexts[index],
             @"detail":detail};
}

+(void)setUserDefaultsWithDetails:(NSDictionary*)details{
    [UD setObject:[NSDate date] forKey:UD_ACCESS_TOKEN_TAKEN_DATE];
    [UD setObject:details[AUTH][@"access_token"] forKey:UD_ACCESS_TOKEN];
    [UD setObject:details[AUTH][@"refresh_token"] forKey:UD_REFRESH_TOKEN];
    [UD setObject:details[AUTH][@"expires_in"] forKey:UD_ACCESS_TOKEN_LIFETIME];
    [UD setObject:details[USER][@"first_name"] forKey:UD_FIRSTNAME];
    [UD setObject:details[USER][@"last_name"] forKey:UD_SURNAME];
    [UD setObject:details[USER][@"id"] forKey:UD_USER_ID];
    [UD setObject:details[USER][@"picture"] forKey:UD_USER_PICTURE];
    
    if (details[USER][@"active_hood"] == [NSNull null]) {
        [UD setObject:nil forKey:UD_HOOD_ID];
    }
    else{
        [UD setObject:details[USER][@"active_hood"] forKey:UD_HOOD_ID];
    }
}

+(NSString*)urlEscapeString:(NSString *)unencodedString
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, NULL,kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return s;
}


+(NSString*)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary
{
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:urlString];
    
    for (id key in dictionary) {
        NSString *keyString = [key description];
        NSString *valueString = [[dictionary objectForKey:key] description];
        
        if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
            [urlWithQuerystring appendFormat:@"?%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        } else {
            [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        }
    }
    return urlWithQuerystring;
}

@end
