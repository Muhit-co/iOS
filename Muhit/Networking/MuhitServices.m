//
//  MuhitServices.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "MuhitServices.h"
#import "UtilityFunctions.h"

const int itemPerPage = 10;

@implementation MuhitServices

+(void)signUp:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password location:(NSString *)location handler:(GeneralResponseHandler)handler{
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithDictionary: @{
                                  KEY_FIRSTNAME : firstName,
                                  KEY_LASTNAME : lastName,
                                  KEY_EMAIL : email,
                                  KEY_PASSWORD : password
                                  }];
    
    if (location) {
        [requestDict setObject:location forKey:KEY_LOCATION];
    }
    
    [SERVICES postRequestWithMethod:SERVICE_SIGNUP requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)login:(NSString *)email password:(NSString *)password handler:(GeneralResponseHandler)handler{
    NSDictionary *requestDict = @{
                                  KEY_EMAIL : email,
                                  KEY_PASSWORD : password
                                  };
    
    [SERVICES postRequestWithMethod:SERVICE_LOGIN requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+ (void)loginWithFacebook:(NSString*)accessToken fbId:(NSString*)fbId handler:(GeneralResponseHandler)handler{
    NSDictionary *requestDict = @{
                                  KEY_FB_ACCESS_TOKEN : accessToken,
                                  KEY_FB_ID:fbId
                                  };
    
    [SERVICES postRequestWithMethod:SERVICE_LOGIN_WITH_FACEBOOK requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)getProfile:(NSString *)profileId handler:(GeneralResponseHandler)handler{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",SERVICE_PROFILE,profileId];
    
    [SERVICES getRequestWithMethod:url backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+ (void)updateProfile:(NSString *)firstName lastName:(NSString *)lastName password:(NSString *)password location:(NSString *)location photo:(NSString *)photo email:(NSString *)email username:(NSString *)username handler:(GeneralResponseHandler)handler{
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithDictionary:
                                        @{
                                          KEY_FIRSTNAME : firstName,
                                          KEY_LASTNAME : lastName,
                                          KEY_PASSWORD : password,
                                          KEY_USERNAME : username,
                                          KEY_EMAIL : email
                                          }];
    
    if (location) {
        [requestDict setObject:location forKey:KEY_LOCATION];
    }
    
    if (photo) {
        [requestDict setObject:photo forKey:KEY_PICTURE];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/update",SERVICE_PROFILE,[USER userId]];
    
    [SERVICES postRequestWithMethod:url requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)getIssues:(int)from type:(NSString*)type handler:(GeneralResponseHandler)handler{
    
    NSString *url = [NSString stringWithFormat:@"%@/%d/%d",SERVICE_GET_ISSUES,from,itemPerPage];
    
    [SERVICES getRequestWithMethod:url backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+ (void)addOrUpdateIssue:(NSString*)title problem:(NSString*)problem solution:(NSString*)solution location:(NSString*)location tags:(NSArray*)tags images:(NSArray*)images isAnonymous:(BOOL)isAnonymous coordinate:(NSString *)coordinate issueId:(NSString *)issueId handler:(GeneralResponseHandler)handler{
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithDictionary:
                                        @{
                                          KEY_ISSUE_TITLE : title,
                                          KEY_ISSUE_PROBLEM : problem,
                                          KEY_ISSUE_SOLUTION : solution,
                                          KEY_IS_ANONYMOUS: NUMBER_BOOL(isAnonymous)
                                          }];
    
    
    if (tags && tags.count>0) {
        [requestDict setObject:[tags componentsJoinedByString:@","] forKey:KEY_ISSUE_TAGS];
    }
    if (images && images.count>0) {
        [requestDict setObject:[images componentsJoinedByString:@","] forKey:KEY_ISSUE_IMAGES];
    }
    if (location) {
        [requestDict setObject:location forKey:KEY_LOCATION];
    }
    if (coordinate) {
        [requestDict setObject:coordinate forKey:KEY_COORDINATE];
    }
    
    [SERVICES postRequestWithMethod:SERVICE_ADD_ISSUE requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+ (void)deleteIssue:(NSString *)issueId handler:(GeneralResponseHandler)handler{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",SERVICE_DELETE_ISSUE,[USER userId],issueId];
	[SERVICES postRequestWithMethod:url requestDict:nil backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)getAnnouncements:(NSString *)userId handler:(GeneralResponseHandler)handler{
    
    NSString *url = [NSString stringWithFormat:@"user/show/%@/announcements",userId];
    
    [SERVICES getRequestWithMethod:url backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)getTagsWithhandler:(GeneralResponseHandler)handler{
    
    [SERVICES getRequestWithMethod:SERVICE_GET_TAGS backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)support:(NSString *)issueId handler:(GeneralResponseHandler)handler{
    
    NSString *url = [NSString stringWithFormat:@"issue/show/%@/support",issueId];
	[SERVICES postRequestWithMethod:url requestDict:nil backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)unSupport:(NSString *)issueId handler:(GeneralResponseHandler)handler{
    
    NSString *url = [NSString stringWithFormat:@"issue/show/%@/unsupport",issueId];
    [SERVICES postRequestWithMethod:url requestDict:nil backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+ (void)getSupporteds:(NSString *)userId handler:(GeneralResponseHandler)handler{
    NSString *url = [NSString stringWithFormat:@"user/show/%@/supported",userId];
    
    [SERVICES getRequestWithMethod:url backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+ (void)getCreateds:(NSString *)userId handler:(GeneralResponseHandler)handler{
    NSString *url = [NSString stringWithFormat:@"user/show/%@/created",userId];
    
    [SERVICES getRequestWithMethod:url backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+ (void)getHeadman:(NSString *)userId handler:(GeneralResponseHandler)handler{
    NSString *url = [NSString stringWithFormat:@"user/show/%@/headman",userId];
    
    [SERVICES getRequestWithMethod:url backgroundCall:NO repeatCall:NO responseHandler:handler];
}



/*********************************************************/
/*********************************************************/
/*****/												/*****/
/*****  			GOOGLE REQUESTS 				 *****/
/*****/												/*****/
/*********************************************************/
/*********************************************************/

+ (void)getAddressesWithInput:(NSString *)input handler:(GeneralResponseHandler)handler{
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&language=tr&key=AIzaSyDhFJMt6qYhCayG6MdiVZ5OqxG1CUjjNfY",input];
    
    [SERVICE_HANDLER getRequestWithURL:url responseHandler:^(NSDictionary *response, NSError *error) {
        handler(response,error);
    }];
}

+ (void)getAddressesWithLocation:(CLLocationCoordinate2D)coord handler:(GeneralResponseHandler)handler{
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%.6f,%.6f&language=tr",coord.latitude,coord.longitude];
    
    [SERVICE_HANDLER getRequestWithURL:url responseHandler:^(NSDictionary *response, NSError *error) {
        handler(response,error);
    }];
}

+ (void)getLocationWithAddress:(NSString*)address handler:(GeneralResponseHandler)handler{
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&language=tr",[UF urlencodeWithString:address]];
    
    [SERVICE_HANDLER getRequestWithURL:url responseHandler:^(NSDictionary *response, NSError *error) {
        handler(response,error);
    }];
}

/*********************************************************/
/*********************************************************/
/*****/												/*****/
/*****  			SERVICES FINISH 				 *****/
/*****/												/*****/
/*********************************************************/
/*********************************************************/

+(void)getRequestWithMethod:(NSString*)method backgroundCall:(BOOL)backgroundCall repeatCall:(BOOL)repeatCall responseHandler:(GeneralResponseHandler)responseHandler {
    
    NSString *url = [NSString stringWithFormat:@"%@/api/%@",[MT serviceURL],method];
    
    if([USER token] && [USER userId]){
        url = [NSString stringWithFormat:@"%@?api_token=%@&user_id=%@",url,[USER token],[USER userId]];
    }
    
    [SERVICE_HANDLER getRequest: url
                 backgroundCall: backgroundCall
                     repeatCall: repeatCall
                responseHandler: responseHandler];
}

+(void)postRequestWithMethod:(NSString*)method requestDict:requestDict backgroundCall:(BOOL)backgroundCall repeatCall:(BOOL)repeatCall responseHandler:(GeneralResponseHandler)responseHandler {
    
    NSString *url = [NSString stringWithFormat:@"%@/api/%@",[MT serviceURL],method];
    
    if (!requestDict) {
        requestDict = @{};
    }
    
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionaryWithDictionary:requestDict];
    
    [reqDict setObject:VAL_CLIENT_ID forKey: KEY_CLIENT_ID];
    [reqDict setObject:VAL_CLIENT_SECRET forKey: KEY_CLIENT_SECRET];
    
    if([USER token] && [USER userId]){
        [reqDict setObject:[USER token] forKey: KEY_API_TOKEN];
        [reqDict setObject:[USER userId] forKey: KEY_USER_ID];
    }
    
    [SERVICE_HANDLER postRequest: url
                     requestDict: reqDict
                  backgroundCall: backgroundCall
                      repeatCall: repeatCall
                 responseHandler: responseHandler];
}

@end
