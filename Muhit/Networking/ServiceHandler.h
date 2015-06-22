//
//  ServiceHandler.h
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#define SERVICE_HANDLER [ServiceHandler sharedHandler]

typedef void(^GeneralResponseHandler) (NSDictionary *response, NSError *error);
typedef void(^GeocodeHandler) (NSString *address, NSError *error);
typedef void(^RouteMatrixHandler) (NSDictionary *routeMatrix, NSError *error);

@interface ServiceHandler : NSObject

+ (id)sharedHandler;

- (void)postRequest:(NSString*)url requestDict:(NSDictionary*)requestDict backgroundCall:(BOOL)backgroundCall repeatCall:(BOOL)repeatCall responseHandler:(GeneralResponseHandler)responseHandler;

- (void)getRequestWithURL:(NSString*)url responseHandler:(GeneralResponseHandler)responseHandler;

@end
