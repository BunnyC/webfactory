//
//  RequestBuilder.h
//  PartyApp
//
//  Created by Varun on 29/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestBuilder : NSObject

+ (NSMutableURLRequest *)requestWithURL:(NSString *)URL
                        withRequestType:(NSString *)requestType
                           withPostData:(NSString *)postData;

@end
