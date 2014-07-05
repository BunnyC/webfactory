//
//  RequestBuilder.h
//  JSONParsing
//
//  Created by Varun Channi on 1/15/14.
//  Copyright (c) 2014 NetSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestBuilder : NSObject

+ (NSMutableURLRequest *)sendRequest:(NSString*)requestURL
                         requestType:(NSString*)requestType
                     combinedDataStr:(NSString*)combinedDataStr;

@end
