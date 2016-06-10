//
//  LanguageManager.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "LanguageManager.h"

static const NSString *localizedDictionaryPrefix = @"lang-";

@interface LanguageManager(){
	NSDictionary *localizedDictionary;
    NSArray *localeIdentifiers;
}

@end

@implementation LanguageManager

+ (LanguageManager *)instance{
    static LanguageManager *sharedLocalizationManager = nil;
	@synchronized(self)
    {
		if (sharedLocalizationManager == nil) {
			sharedLocalizationManager = [[LanguageManager alloc] init];
		}
	}
	return sharedLocalizationManager;
}

- (id)init{
    self = [super init];
    if (self) {
        [self onLocalizationChange];
    }
    return self;
}

- (void)changeLanguage:(LanguageType)language{
    if([self currentLanguage] != language) {
        [UD setObject:NUMBER_INT(language) forKey:USER_LANGUAGE];
        [self onLocalizationChange];
        [NC postNotificationName:kLocalizationChanged object:nil];
    }
}

- (NSArray *)localeIdentifiers{
    if(localeIdentifiers == nil) {
        localeIdentifiers = @[@"tr",@"en"];
    }
    return localeIdentifiers;
}

- (NSString *)currentLocaleIdentifier{
    return [[self localeIdentifiers] objectAtIndex:[self currentLanguage]];
}

- (NSLocale *)currentLocale{
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:[[self localeIdentifiers] objectAtIndex:[self currentLanguage]]];
    return locale;
}


- (LanguageType)currentLanguage{
    int lang = Turkish;
    if([UD objectForKey:USER_LANGUAGE]) {
        lang = [[UD objectForKey:USER_LANGUAGE] intValue];
    }
    else{
        NSString *selectedLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
        for(int index = 0; index < [[self localeIdentifiers] count] ; index ++) {
            if([[[self localeIdentifiers] objectAtIndex:index] isEqualToString:selectedLanguage]) {
                lang = index;
                [UD setObject:NUMBER_INT(lang) forKey:USER_LANGUAGE];
                break;
            }
        }
    }
    return lang;
}



- (void) onLocalizationChange{
    NSString *currentLocaleIdentifier = [[self currentLocale] localeIdentifier];
    localizedDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@", localizedDictionaryPrefix, currentLocaleIdentifier] ofType:@"plist"]];
}

- (NSString *)localizedStringForKey:(NSString *)key{
	NSString *localizedString = localizedDictionary[key];
    if (localizedString == nil) {
        DLog(@" REQUESTED KEY IS MISSING: '%@'", key);
        return key;
    } else {
        return localizedString;
    }
}

@end
