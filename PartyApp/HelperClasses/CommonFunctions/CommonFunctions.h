//
//  CommonFunctions.h
//  PartyApp
//
//  Created by Varun on 14/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBUUser;

@interface CommonFunctions : NSObject

#pragma mark - Shared Object

+ (id)sharedObject;

#pragma mark - Functions


- (BOOL)isDeviceiPhone5;

- (UIImage *)imageWithName:(NSString *)name andType:(NSString *)type;

- (void)setLocalImageForImageView:(UIImageView *)imageView
                     withFileName:(NSString *)fileName
                          andType:(NSString *)type;

- (UIColor *)colorWithImageName:(NSString *)fileName
                        andType:(NSString *)type;

- (BOOL)validateEmailID:(NSString *)emailID;

- (UIView *)showLoadingView;
- (void)hideLoadingView:(UIView *)loadingView;

- (UIColor *)colorWithHexString:(NSString *)hexString;

- (UIButton *)buttonNavigationItemWithImage:(UIImage *)image
                                  forTarget:(id)controller
                                andSelector:(SEL)selector;

#pragma mark - Saving/Fetching UserInfo in/from UserDefaults

- (void)saveInformationInDefaultsForUser:(QBUUser *)userInfo;
- (QBUUser *)getQBUserObjectFromUserDefaults;

@end
