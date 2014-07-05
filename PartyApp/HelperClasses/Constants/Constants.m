//
//  Constants.m
//  PartyApp
//
//  Created by Varun on 14/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "Constants.h"

@implementation Constants

//NSInteger const _pApplicationID         = 11405;
//NSString *const _pAuthorizationKey      = @"aNmg3TVv-A98-qW";
//NSString *const _pAuthorizationSecret   = @"BzpdOHDkpLVjXdj";
//NSString *const _pAccountKey            = @"eYyNwpmdQnAxbyiJs3CG";

NSInteger const _pApplicationID         = 11046;
NSString *const _pAuthorizationKey      = @"ymVqnBnjYPz8Rjx";
NSString *const _pAuthorizationSecret   = @"SSrdLfpR-LMC44H";
NSString *const _pAccountKey            = @"4LPybW9cxp5xaosSztxE";
NSString *const _pPNGType               = @"png";

#pragma mark - UserDefault Keys

NSString *const _pudLoggedIn            = @"IsLoggedIn";
NSString *const _pudSessionExpiryDate   = @"SessionExpiryDate";
NSString *const _pUserInfoDic           = @"UserProfileInfomation";
NSString *const _pUserProfilePic        = @"UserProfilePic";

#pragma mark - Message Text

NSString *const _pErrUserNameAndPasswordRequired= @"Please enter password with atleast 6 characters";
NSString *const _pErrInvalidUserNameAndPassword=@"Please enter correct username and password";

NSString *const _pSignUpSuccess=@"User has successfully signup";

NSString *const _pResetPasswordMgs=@"Reset password link has sent to your email";

@end
