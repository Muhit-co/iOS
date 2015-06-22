//
//  LanguageManager.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "LanguageManager.h"

static const NSString *localizedDictionaryPrefix = @"lang-";
static const BTLanguageType kDefaultLanguage = BTTurkish;

@interface LanguageManager()

@property (nonatomic, retain) NSDictionary *localizedDictionary;
@property (strong, nonatomic) NSArray *localeIdentifiers;

@end

@implementation LanguageManager

+ (LanguageManager *)instance
{
    static LanguageManager *sharedLocalizationManager = nil;
	@synchronized(self)
    {
		if (sharedLocalizationManager == nil) {
			sharedLocalizationManager = [[LanguageManager alloc] init];
		}
	}
	return sharedLocalizationManager;
}

- (void) changeLanguage:(BTLanguageType)language
{
    if([self currentLanguage] != language) {
        [UD setObject:NUMBER_INT(language) forKey:USER_LANGUAGE];
        [self onLocalizationChange];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocalizationChanged object:nil];
    }
}

- (NSArray *)localeIdentifiers
{
    if(_localeIdentifiers == nil) {
        _localeIdentifiers = @[@"tr",@"en"];
    }
    return _localeIdentifiers;
}

- (NSLocale *)currentLocale
{
    NSLocale *aLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[self localeIdentifiers] objectAtIndex:[self currentLanguage]]];
    return aLocale;
}

- (NSLocale *)turkishLocale
{
    NSLocale *aLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[self localeIdentifiers] objectAtIndex:BTTurkish]];
    return aLocale;
}

- (BTLanguageType)currentLanguage
{
    int lang = BTTurkish;
    if([UD objectForKey:USER_LANGUAGE]) {
        lang = [[UD objectForKey:USER_LANGUAGE] intValue];
    }
    else{
        NSString *selectedLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
        for(int index = 0; index < [[self localeIdentifiers] count] ; index ++) {
            if([[[self localeIdentifiers] objectAtIndex:index] isEqualToString:selectedLanguage]) {
                lang = index;
                break;
            }
        }
    }
    return lang;
}

- (NSString *)currentLocaleIdentifier
{
    return [[self localeIdentifiers] objectAtIndex:[self currentLanguage]];
}

- (id)init
{
    self = [super init]; 
	if (self) {
        [self onLocalizationChange];
	}			
	return self; 
}

- (void) onLocalizationChange
{
    NSString *currentLocaleIdentifier = [[self currentLocale] localeIdentifier];

    DLog(@"current locale %@",currentLocaleIdentifier);
    
    [[[NSUserDefaults alloc] initWithSuiteName:@"group.bitaksi"] setObject:currentLocaleIdentifier forKey:@"LANG"];

    _localizedDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@", localizedDictionaryPrefix, currentLocaleIdentifier] ofType:@"plist"]];
    
}

- (NSString *)localizedStringForKey:(NSString *)key
{
	NSString *localizedString = [self.localizedDictionary objectForKey:key];
    if (localizedString == nil) {
        DLog(@" REQUESTED KEY IS MISSING: '%@'", key);
        return key;
    } else {
        return localizedString;
    }
}

- (NSString *)localizedFileName:(NSString *)fileName extension:(NSString *)extension
{
    if([self currentLanguage] == kDefaultLanguage) {
        return [fileName stringByAppendingString:extension];
    } else {
        return [[[fileName stringByAppendingString:@"_"] stringByAppendingString:[self currentLocaleIdentifier]] stringByAppendingString:extension];
    }
}

@end
