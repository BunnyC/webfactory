//
//  CommonFunctions.h
//  PartyApp
//
//  Created by Varun on 14/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonFunctions : NSObject

#pragma mark - Shared Object

+ (id)sharedObject;

#pragma mark - Functions

- (BOOL)isDeviceiPhone5;

- (void)setLocalImageForImageView:(UIImageView *)imageView
                     withFileName:(NSString *)fileName
                          andType:(NSString *)type;

- (UIColor *)colorWithImageName:(NSString *)fileName
                        andType:(NSString *)type;

@end
