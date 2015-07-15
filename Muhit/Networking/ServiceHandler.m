//
//  ServiceHandler.m
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "ServiceHandler.h"
#import "UtilityFunctions.h"

#define ALERT_TRY_POST_TAG 1
#define ALERT_TRY_GET_TAG 2

@interface ServiceHandler () {

    BOOL alertActive;
    NSString *lastRequestURL;
    NSDictionary *lastRequestDict;
    BOOL lastRequestBackgroundCall,lastRequestRepeatCall;
    GeneralResponseHandler lastRequestHandler;
}

@end

@implementation ServiceHandler

#pragma mark Singleton Methods

+ (id)sharedHandler {
    static ServiceHandler *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        alertActive = false;
    }
    return self;
}

- (void)getRequest:(NSString*)url backgroundCall:(BOOL)backgroundCall repeatCall:(BOOL)repeatCall responseHandler:(GeneralResponseHandler)responseHandler{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [[manager requestSerializer] setValue:[NSString stringWithFormat:@"Bearer %@",[UD objectForKey:UD_ACCESS_TOKEN]] forHTTPHeaderField:@"Authorization"];
    [[manager responseSerializer] setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json", nil]];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager GET: url
      parameters: nil
         success: ^(AFHTTPRequestOperation *operation, id responseObject) {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             
             DLog(@"url: %@ : %@",[url lastPathComponent], responseObject);
             NSDictionary *responseDict = (NSDictionary*)responseObject;
             responseHandler(responseDict[@"data"],nil);
         }
         failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"errorDesc:%@",error.description);
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             
             if(error && (error.code == -1001 || error.code == -1009 || error.code == -1004)){
                 if (!backgroundCall && !alertActive) {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                     message:@"İnternet bağlantınızı kontrol ediniz"
                                                                    delegate:self
                                                           cancelButtonTitle:@"İptal"
                                                           otherButtonTitles:@"Yeniden Dene",nil];
                     alert.tag = ALERT_TRY_GET_TAG;
                     lastRequestURL = url;
                     lastRequestBackgroundCall = backgroundCall;
                     lastRequestRepeatCall = repeatCall;
                     lastRequestHandler = responseHandler;
                     alertActive = true;
                     [alert show];
                 }
             }
             else{
                 NSDictionary *dictError = @{@"error":[operation responseObject]};
                 responseHandler(dictError,error);
             }
         }];

}

- (void)postRequest:(NSString*)url requestDict:(NSDictionary*)requestDict backgroundCall:(BOOL)backgroundCall repeatCall:(BOOL)repeatCall responseHandler:(GeneralResponseHandler)responseHandler{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [[manager requestSerializer] setValue:[NSString stringWithFormat:@"Bearer %@",[UD objectForKey:UD_ACCESS_TOKEN]] forHTTPHeaderField:@"Authorization"];
    [[manager responseSerializer] setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json", nil]];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager POST: url
       parameters: requestDict
          success: ^(AFHTTPRequestOperation *operation, id responseObject) {
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

              DLog(@"url: %@ : %@",[url lastPathComponent], responseObject);
              NSDictionary *responseDict = (NSDictionary*)responseObject;
              responseHandler(responseDict[@"data"],nil);
          }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"errorCode:%@",error.description);
              NSLog(@"errorResponse:%@",operation.responseObject);
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

              if(error && (error.code == -1001 || error.code == -1009 || error.code == -1004)){
                  if (!backgroundCall && !alertActive) {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                      message:@"İnternet bağlantınızı kontrol ediniz"
                                                                     delegate:self
                                                            cancelButtonTitle:@"İptal"
                                                            otherButtonTitles:@"Yeniden Dene",nil];
                      alert.tag = ALERT_TRY_POST_TAG;
                      lastRequestURL = url;
                      lastRequestDict = requestDict;
                      lastRequestBackgroundCall = backgroundCall;
                      lastRequestRepeatCall = repeatCall;
                      lastRequestHandler = responseHandler;
                      alertActive = true;
                      [alert show];
                  }
              }
              else{
                  NSDictionary *dictError = @{@"error":[operation responseObject]};
                  responseHandler(dictError,error);
              }
          }];
}

- (void)getRequestWithURL:(NSString*)url responseHandler:(GeneralResponseHandler)responseHandler {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET: url
      parameters: nil
         success: ^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *responseDict = (NSDictionary*)responseObject;
             responseHandler(responseDict,nil);
         }
         failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
             DLog(@"%@",error);
             responseHandler(nil,error);
         }];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if ([alertView tag] == ALERT_TRY_POST_TAG && buttonIndex == 1) {
        [self postRequest:lastRequestURL requestDict:lastRequestDict backgroundCall:lastRequestBackgroundCall repeatCall:lastRequestRepeatCall responseHandler:lastRequestHandler];
        alertActive = false;
    }
    
    if ([alertView tag] == ALERT_TRY_GET_TAG && buttonIndex == 1) {
        [self getRequest:lastRequestURL backgroundCall:lastRequestBackgroundCall repeatCall:lastRequestRepeatCall responseHandler:lastRequestHandler];
        alertActive = false;
    }

    alertActive = false;
}

- (void)dealloc {
}

@end