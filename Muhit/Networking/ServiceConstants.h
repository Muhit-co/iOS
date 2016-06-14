//
//  ServiceConstants.h
//  Muhit
//
//  Created by Emre YANIK on 01/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//
/*********************************************************/
/*********************************************************/
/*****/												/*****/
/*****  				SERVICE METHODS 			 *****/
/*****/												/*****/
/*********************************************************/
/*********************************************************/
#pragma mark - SERVICE METHODS


#define VAL_CLIENT_ID @"1"
#define VAL_CLIENT_SECRET @"1"

#define SERVICE_SIGNUP @"register"
#define SERVICE_LOGIN @"login"
#define SERVICE_LOGIN_WITH_FACEBOOK @"login-with-facebook"
#define SERVICE_REFRESH_ACCESS_TOKEN @"auth/refresh-token"
#define SERVICE_GET_PROFILE @"members/profile"
#define SERVICE_UPDATE_PROFILE @"members/update-profile"
#define SERVICE_GET_TAGS @"tags"
#define SERVICE_GET_ISSUES @"issues/list"
#define SERVICE_ADD_ISSUE @"issues/create"
#define SERVICE_DELETE_ISSUE @"issues/delete"
#define SERVICE_GET_ANNOUNCEMENTS @"announcements"
#define SERVICE_SUPPORT @"support"
#define SERVICE_UNSUPPORT @"un-support"

/*********************************************************/
/*********************************************************/
/*****/												/*****/
/*****  				SERVICE KEYS 				 *****/
/*****/												/*****/
/*********************************************************/
/*********************************************************/
#pragma mark - SERVICE KEYS

#define KEY_COORDINATE @"coordinates"
#define KEY_PICTURE @"picture"
#define KEY_EMAIL @"email"
#define KEY_PASSWORD @"password"
#define KEY_USERNAME @"username"
#define KEY_FIRSTNAME @"first_name"
#define KEY_LASTNAME @"last_name"
#define KEY_ACTIVE_HOOD @"active_hood"
#define KEY_ISSUE_TITLE @"title"
#define KEY_ISSUE_DESC @"desc"
#define KEY_ISSUE_LOCATION @"location"
#define KEY_ISSUE_TAGS @"tags"
#define KEY_ISSUE_IMAGES @"images"
#define KEY_SEARCH @"search"
#define KEY_START @"start"
#define KEY_TAKE @"take"
#define KEY_IS_ANONYMOUS @"is_anonymous"
#define KEY_CLIENT_ID @"client_id"
#define KEY_CLIENT_SECRET @"client_secret"
#define KEY_ACCESS_TOKEN @"access_token"
#define KEY_REFRESH_TOKEN @"refresh_token"
#define KEY_ID @"id"

#define KEY_ERROR @"error"
#define KEY_MESSAGE @"msg"

typedef enum{
    BOOL_FALSE,
    BOOL_TRUE,
    BOOL_NO_INFO,
}Boolean_Options;

