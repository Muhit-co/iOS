//
//  MuhitServices.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "MuhitServices.h"
#import "UtilityFunctions.h"

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
    
    NSDictionary *requestDict = @{
                                  KEY_ID : profileId
                                  };
    
    [SERVICES postRequestWithMethod:SERVICE_GET_PROFILE requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)updateProfile:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password activeHood:(NSString *)activeHood handler:(GeneralResponseHandler)handler{
    
    NSDictionary *requestDict = @{
                                  KEY_FIRSTNAME : firstName,
                                  KEY_LASTNAME : lastName,
                                  KEY_EMAIL : email,
                                  KEY_PASSWORD : password,
                                  KEY_ACTIVE_HOOD : activeHood
                                  };
    
    [SERVICES postRequestWithMethod:SERVICE_SIGNUP requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)getIssues:(int)from number:(int)number handler:(GeneralResponseHandler)handler{
    
    NSDictionary *requestDict = @{
                                  KEY_START : NUMBER_INT(from),
                                  KEY_TAKE : NUMBER_INT(number)
                                  };
    
    [SERVICES postRequestWithMethod:SERVICE_GET_ISSUES requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)addIssue:(NSString *)title description:(NSString *)description location:(NSString *)location tags:(NSArray *)tags images:(NSArray *)images handler:(GeneralResponseHandler)handler{
    NSDictionary *requestDict = @{
                                  KEY_ISSUE_TITLE : title,
                                  KEY_ISSUE_DESC : description,
                                  KEY_ISSUE_LOCATION : location,
                                  KEY_ISSUE_TAGS : tags,
                                  KEY_ISSUE_IMAGES : images
                                  };
    
    [SERVICES postRequestWithMethod:SERVICE_ADD_ISSUE requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)getTags:(NSString*)query handler:(GeneralResponseHandler)handler{

    NSDictionary *requestDict = @{
                                  KEY_SEARCH : query
                                  };

    [SERVICES postRequestWithMethod:SERVICE_GET_TAGS requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)getCities:(NSString*)query handler:(GeneralResponseHandler)handler{
    
    NSDictionary *requestDict = @{
                                  KEY_SEARCH : query
                                  };
    
    [SERVICES postRequestWithMethod:SERVICE_GET_CITIES requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)getDistricts:(NSString*)query handler:(GeneralResponseHandler)handler{
    
    NSDictionary *requestDict = @{
                                  KEY_SEARCH : query
                                  };
    
    [SERVICES postRequestWithMethod:SERVICE_GET_DISTRICTS requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+(void)getHoods:(NSString*)query handler:(GeneralResponseHandler)handler{
    
    NSDictionary *requestDict = @{
                                  KEY_SEARCH : query
                                  };
    
    [SERVICES postRequestWithMethod:SERVICE_GET_HOODS requestDict:requestDict backgroundCall:NO repeatCall:NO responseHandler:handler];
}

+ (BOOL)refreshAccessTokenSync{
    
    NSMutableDictionary *jsonRequest = [NSMutableDictionary dictionaryWithDictionary:@{
                                       		KEY_REFRESH_TOKEN : [UD objectForKey:UD_REFRESH_TOKEN],
                                           	KEY_CLIENT_ID : VAL_CLIENT_ID,
                               				KEY_CLIENT_SECRET : VAL_CLIENT_SECRET}];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/%@",[MT serviceURL],SERVICE_REFRESH_ACCESS_TOKEN]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:jsonRequest options:NSJSONWritingPrettyPrinted error:nil];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSError *requestError;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&requestError];
    if (!requestError) {
        NSError* dataError;
        NSDictionary* response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&dataError];
        if (!dataError) {
            NSLog(@"refreshTokenResponse: %@",response);
            [UD setObject:response[AUTH][@"access_token"] forKey:UD_ACCESS_TOKEN];
            [UD setObject:response[AUTH][@"refresh_token"] forKey:UD_REFRESH_TOKEN];
            [UD setObject:response[AUTH][@"expires"] forKey:UD_ACCESS_TOKEN_LIFETIME];
            [UD setObject:[NSDate date] forKey:UD_ACCESS_TOKEN_TAKEN_DATE];
            return YES;
        }
        else{
            return NO;
        }
    }
    else{
        return NO;
    }
}

/*********************************************************/
/*********************************************************/
/*****/												/*****/
/*****  			GOOGLE REQUESTS 				 *****/
/*****/												/*****/
/*********************************************************/
/*********************************************************/

+ (void)getAddressesWithInput:(NSString *)input handler:(GeneralResponseHandler)handler{
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&language=tr&key=AIzaSyALCF1Bh451Q9OMZdDRL_fg_od31rogS50",input];
    
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

+(void)postRequestWithMethod:(NSString*)method requestDict:requestDict backgroundCall:(BOOL)backgroundCall responseHandler:(GeneralResponseHandler)responseHandler {

    [self postRequestWithMethod:method requestDict:requestDict backgroundCall:backgroundCall repeatCall:NO responseHandler:responseHandler];
}

+(void)postRequestWithMethod:(NSString*)method requestDict:requestDict backgroundCall:(BOOL)backgroundCall repeatCall:(BOOL)repeatCall responseHandler:(GeneralResponseHandler)responseHandler {
    
    NSString *url = [NSString stringWithFormat:@"%@/api/%@",[MT serviceURL],method];
    
    if (!requestDict) {
        requestDict = @{};
    }
    
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionaryWithDictionary:requestDict];
    
    [reqDict setObject:VAL_CLIENT_ID forKey: KEY_CLIENT_ID];
    [reqDict setObject:VAL_CLIENT_SECRET forKey: KEY_CLIENT_SECRET];
    
    if ([UD objectForKey:UD_ACCESS_TOKEN]) {
        if (![UF isAccessTokenValid]) {
            BOOL isRefreshedAccessToken = [self refreshAccessTokenSync];
            if (isRefreshedAccessToken) {
                [reqDict setObject:[UD objectForKey:UD_ACCESS_TOKEN] forKey:KEY_ACCESS_TOKEN];
            }
            else{
                responseHandler(nil,[NSError errorWithDomain:@"muhit" code:1 userInfo:nil]);
            }
        }
        else{
            [reqDict setObject:[UD objectForKey:UD_ACCESS_TOKEN] forKey:KEY_ACCESS_TOKEN];
        }
    }
    
    NSLog(@"%@ : %@",method,reqDict);
    
    [SERVICE_HANDLER postRequest: url
                     requestDict: reqDict
                  backgroundCall: backgroundCall
                      repeatCall: repeatCall
                 responseHandler: responseHandler];
}

@end