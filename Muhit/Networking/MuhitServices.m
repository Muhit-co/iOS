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

+(void)signUp:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password activeHood:(NSString *)activeHood handler:(GeneralResponseHandler)handler{
    
    NSDictionary *requestDict = @{
                                  KEY_FIRSTNAME : firstName,
                                  KEY_LASTNAME : lastName,
                                  KEY_EMAIL : email,
                                  KEY_PASSWORD : password,
                                  KEY_ACTIVE_HOOD : activeHood
                                  };
    
    [SERVICES postRequestWithMethod:SERVICE_SIGNUP requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)login:(NSString *)email password:(NSString *)password handler:(GeneralResponseHandler)handler{
    NSDictionary *requestDict = @{
                                  KEY_EMAIL : email,
                                  KEY_PASSWORD : password
                                  };
    
    [SERVICES postRequestWithMethod:SERVICE_LOGIN requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+ (void)loginWithFacebook:(NSString*)accessToken handler:(GeneralResponseHandler)handler{
    NSDictionary *requestDict = @{
                                  KEY_ACCESS_TOKEN : accessToken
                                  };
    
    [SERVICES postRequestWithMethod:SERVICE_LOGIN_WITH_FACEBOOK requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)getProfile:(NSString *)profileId handler:(GeneralResponseHandler)handler{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",SERVICE_GET_PROFILE,profileId];
    
    [SERVICES getRequestWithMethod:url backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+ (void)updateProfile:(NSString *)firstName lastName:(NSString *)lastName password:(NSString *)password activeHood:(NSString *)activeHood picture:(NSString *)picture handler:(GeneralResponseHandler)handler{
    
    NSDictionary *requestDict = @{
                                  KEY_FIRSTNAME : firstName,
                                  KEY_LASTNAME : lastName,
                                  KEY_PASSWORD : password,
                                  KEY_ACTIVE_HOOD : activeHood,
                                  KEY_PICTURE : picture,
                                  };
    
    [SERVICES postRequestWithMethod:SERVICE_UPDATE_PROFILE requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)getIssues:(int)from handler:(GeneralResponseHandler)handler{
    
    NSString *url = [NSString stringWithFormat:@"%@/%d/%d",SERVICE_GET_ISSUES,from,itemPerPage];
    
    [SERVICES getRequestWithMethod:url backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+ (void)addOrUpdateIssue:(NSString*)title problem:(NSString*)problem solution:(NSString*)solution location:(NSString*)location tags:(NSArray*)tags images:(NSArray*)images isAnonymous:(BOOL)isAnonymous coordinate:(NSString *)coordinate issueId:(NSString *)issueId handler:(GeneralResponseHandler)handler{
    NSDictionary *requestDict = @{
                                  KEY_ISSUE_TITLE : title,
                                  KEY_ISSUE_PROBLEM : problem,
                                  KEY_ISSUE_SOLUTION : solution,
                                  KEY_ISSUE_LOCATION : location,
                                  KEY_ISSUE_TAGS : tags,
                                  KEY_ISSUE_IMAGES : images,
                                  KEY_IS_ANONYMOUS: NUMBER_BOOL(isAnonymous),
                                  KEY_COORDINATE: coordinate
                                  };
    if(!issueId){
        [SERVICES postRequestWithMethod:SERVICE_ADD_ISSUE requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
    }
    else{
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@",SERVICE_DELETE_ISSUE,[UD objectForKey:UD_USER_ID],issueId];
        [SERVICES getRequestWithMethod:url backgroundCall:NO repeatCall:NO responseHandler:^(NSDictionary *response, NSError *error) {
            if(!error){
                [SERVICES postRequestWithMethod:SERVICE_ADD_ISSUE requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
            }
        }];
    }
}

+(void)getAnnouncements:(int)from handler:(GeneralResponseHandler)handler{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%d/%d",SERVICE_GET_ANNOUNCEMENTS,[UD objectForKey:UD_HOOD_ID],from,itemPerPage];
    
    [SERVICES getRequestWithMethod:url backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)getTagsWithhandler:(GeneralResponseHandler)handler{
    
    [SERVICES getRequestWithMethod:SERVICE_GET_TAGS backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)support:(NSString *)issueId handler:(GeneralResponseHandler)handler{
    
    NSString *url = [NSString stringWithFormat:@"issues/%@/support",issueId];
    [SERVICES getRequestWithMethod:url backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)unSupport:(NSString *)issueId handler:(GeneralResponseHandler)handler{
    
    NSString *url = [NSString stringWithFormat:@"issues/%@/unsupport",issueId];
    [SERVICES getRequestWithMethod:url backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+ (void)getSupporteds:(NSString *)userId handler:(GeneralResponseHandler)handler{
    NSString *url = [NSString stringWithFormat:@"user/%@/supported",userId];
    
    [SERVICES getRequestWithMethod:url backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+ (void)getCreateds:(NSString *)userId handler:(GeneralResponseHandler)handler{
    NSString *url = [NSString stringWithFormat:@"user/%@/created",userId];
    
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

/*********************************************************/
/*********************************************************/
/*****/												/*****/
/*****  			SERVICES FINISH 				 *****/
/*****/												/*****/
/*********************************************************/
/*********************************************************/

+(void)getRequestWithMethod:(NSString*)method backgroundCall:(BOOL)backgroundCall repeatCall:(BOOL)repeatCall responseHandler:(GeneralResponseHandler)responseHandler {
    
    NSString *url = [NSString stringWithFormat:@"%@/api/%@",[MT serviceURL],method];
    
    if([UD objectForKey:UD_API_TOKEN] && [UD objectForKey:UD_USER_ID]){
        url = [NSString stringWithFormat:@"%@?api_token=%@&user_id=%@",url,[UD objectForKey:UD_API_TOKEN],[UD objectForKey:UD_USER_ID]];
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
    
    if([UD objectForKey:UD_API_TOKEN] && [UD objectForKey:UD_USER_ID]){
        [reqDict setObject:[UD objectForKey:UD_API_TOKEN] forKey: KEY_API_TOKEN];
        [reqDict setObject:[UD objectForKey:UD_USER_ID] forKey: KEY_USER_ID];
    }
    
    [SERVICE_HANDLER postRequest: url
                     requestDict: reqDict
                  backgroundCall: backgroundCall
                      repeatCall: repeatCall
                 responseHandler: responseHandler];
}

@end