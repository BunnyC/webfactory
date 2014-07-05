//
//  RequestBuilder.m
//  JSONParsing
//
//  Created by Varun Channi on 1/15/14.
//  Copyright (c) 2014 NetSolutions. All rights reserved.
//

#import "RequestBuilder.h"

@implementation RequestBuilder

+ (NSMutableURLRequest *)sendRequest:(NSString*)requestURL
                         requestType:(NSString*)requestType
                     combinedDataStr:(NSString*)combinedDataStr {
    
    requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:requestURL];
    NSString *postLength=@"";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:60];
    [request setURL:url];
    NSLog(@"HTTP body Fields : %@", combinedDataStr);
    if([requestType isEqualToString:@"POST"]) {
        NSData *postData = [combinedDataStr dataUsingEncoding:NSASCIIStringEncoding
                                         allowLossyConversion:YES];
        postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[postData length]];
        [request setHTTPMethod:@"POST"];
//        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
    }
    else
        [request setHTTPMethod:@"GET"];
    
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    NSString *sessionToken = [userDefs objectForKey:_pudSessionToken];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"0.1.0"            forHTTPHeaderField:@"QuickBlox-REST-API-Version"];
    [request setValue:sessionToken        forHTTPHeaderField:@"QB-Token"];
    
    return request;
}

@end
