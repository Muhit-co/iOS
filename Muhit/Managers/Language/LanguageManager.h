//
//  LanguageManager.h
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

static NSString *kLocalizationChanged = @"localizationChanged";

typedef enum {
    BTTurkish = 0,
    BTEnglish = 1
} BTLanguageType;

@interface LanguageManager : NSObject

+ (LanguageManager *) instance;

- (NSString *)localizedStringForKey:(NSString *)key;
- (NSString *)localizedFileName:(NSString *)fileName extension:(NSString *)extension;

- (void) changeLanguage:(BTLanguageType)language;
- (NSLocale *)currentLocale;
- (NSLocale *)turkishLocale;
- (BTLanguageType)currentLanguage;
- (NSArray *) localeIdentifiers;
- (NSString *)currentLocaleIdentifier;

@end
