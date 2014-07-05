//
//  Constants.h
//  PartyApp
//
//  Created by Varun on 14/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

FOUNDATION_EXPORT NSInteger const _pApplicationID;
FOUNDATION_EXPORT NSString *const _pAuthorizationKey;
FOUNDATION_EXPORT NSString *const _pAuthorizationSecret;
FOUNDATION_EXPORT NSString *const _pAccountKey;
FOUNDATION_EXPORT NSString *const _pPNGType;

FOUNDATION_EXPORT NSString *const _pudLoggedIn;
FOUNDATION_EXPORT NSString *const _pudSessionExpiryDate;
FOUNDATION_EXPORT NSString *const _pudSessionToken;
FOUNDATION_EXPORT NSString *const _pudUserInfo;
FOUNDATION_EXPORT NSString *const _pUserInfoDic;
FOUNDATION_EXPORT NSString *const _pUserProfilePic;

FOUNDATION_EXPORT NSString *const _pErrUserNameAndPasswordRequired;
FOUNDATION_EXPORT NSString *const _pErrInvalidUserNameAndPassword;
FOUNDATION_EXPORT NSString *const _pSignUpSuccess;
FOUNDATION_EXPORT NSString *const _pResetPasswordMgs;

FOUNDATION_EXPORT NSString *const _pURLBase;
FOUNDATION_EXPORT NSString *const _pURLSignUp;

@end
