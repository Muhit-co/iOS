//
//  LanguageManager.h
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

static NSString *kLocalizationChanged = @"localizationChanged";

typedef enum {
    Turkish = 0,
    English = 1
} LanguageType;

@interface LanguageManager : NSObject

+ (LanguageManager *) instance;

- (NSString *)localizedStringForKey:(NSString *)key;

- (void) changeLanguage:(LanguageType)language;
- (NSLocale *)currentLocale;
- (LanguageType)currentLanguage;
- (NSArray *) localeIdentifiers;
- (NSString *)currentLocaleIdentifier;

@end
