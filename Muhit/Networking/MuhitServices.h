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
#import <CoreLocation/CoreLocation.h>

#define SERVICES MuhitServices

@interface MuhitServices : NSObject

+ (void)signUp:(NSString*)firstName lastName:(NSString*)lastName email:(NSString*)email password:(NSString*)password activeHood:(NSString *)activeHood handler:(GeneralResponseHandler)handler;

+ (void)login:(NSString*)email password:(NSString*)password handler:(GeneralResponseHandler)handler;

+ (void)loginWithFacebook:(NSString*)accessToken fbId:(NSString*)fbId handler:(GeneralResponseHandler)handler;

+ (void)getProfile:(NSString*)profileId handler:(GeneralResponseHandler)handler;

+ (void)updateProfile:(NSString *)firstName lastName:(NSString *)lastName password:(NSString *)password activeHood:(NSString *)activeHood photo:(NSString *)photo handler:(GeneralResponseHandler)handler;

+ (void)getIssues:(int)from handler:(GeneralResponseHandler)handler;

+(void)getAnnouncements:(NSString *)userId handler:(GeneralResponseHandler)handler;

+ (void)addOrUpdateIssue:(NSString*)title problem:(NSString*)problem solution:(NSString*)solution location:(NSString*)location tags:(NSArray*)tags images:(NSArray*)images isAnonymous:(BOOL)isAnonymous coordinate:(NSString *)coordinate issueId:(NSString *)issueId handler:(GeneralResponseHandler)handler;

+ (void)getTagsWithhandler:(GeneralResponseHandler)handler;

+ (void)support:(NSString*)issueId handler:(GeneralResponseHandler)handler;

+ (void)unSupport:(NSString*)issueId handler:(GeneralResponseHandler)handler;

+ (void)getSupporteds:(NSString *)userId handler:(GeneralResponseHandler)handler;

+ (void)getCreateds:(NSString *)userId handler:(GeneralResponseHandler)handler;

+ (void)getHeadman:(NSString *)userId handler:(GeneralResponseHandler)handler;

+ (void)getAddressesWithLocation:(CLLocationCoordinate2D)coord handler:(GeneralResponseHandler)handler;

+ (void)getLocationWithAddress:(NSString*)address handler:(GeneralResponseHandler)handler;

@end
