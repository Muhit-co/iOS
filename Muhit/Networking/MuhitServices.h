//
//  MuhitServices.h
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceHandler.h"
#import "ServiceConstants.h"

#define SERVICES MuhitServices

@interface MuhitServices : NSObject

+ (void)signUp:(NSString*)firstName lastName:(NSString*)lastName email:(NSString*)email password:(NSString*)password activeHood:(NSString *)activeHood handler:(GeneralResponseHandler)handler;

+ (void)login:(NSString*)email password:(NSString*)password handler:(GeneralResponseHandler)handler;

+ (void)loginWithFacebook:(NSString*)accessToken handler:(GeneralResponseHandler)handler;

+ (void)getProfile:(NSString*)profileId handler:(GeneralResponseHandler)handler;

+ (void)updateProfile:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password activeHood:(NSString *)activeHood handler:(GeneralResponseHandler)handler;

+ (void)getIssues:(int)from handler:(GeneralResponseHandler)handler;

+ (void)getAnnouncements:(int)from handler:(GeneralResponseHandler)handler;

+ (void)addIssue:(NSString*)title description:(NSString*)description location:(NSString*)location tags:(NSArray*)tags images:(NSArray*)images handler:(GeneralResponseHandler)handler;

+ (void)getTags:(NSString*)query handler:(GeneralResponseHandler)handler;

+ (void)getCities:(NSString*)query handler:(GeneralResponseHandler)handler;

+ (void)getDistricts:(NSString*)query handler:(GeneralResponseHandler)handler;

+ (void)getHoods:(NSString*)query handler:(GeneralResponseHandler)handler;

@end
