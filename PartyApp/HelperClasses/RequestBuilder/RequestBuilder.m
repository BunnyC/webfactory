//
//  RequestBuilder.m
//  PartyApp
//
//  Created by Varun on 29/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "RequestBuilder.h"

@implementation RequestBuilder

//+ (NSMutableURLRequest *)requestWithURL:(NSString *)urlString
//                        withRequestType:(NSString *)requestType
//                           withPostData:(NSString *)postData {
//    
//    NSURL *requestURL = [NSURL URLWithString:urlString];
//    
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
//    
//    NSString *qbSessionToken = [[NSUserDefaults standardUserDefaults] objectForKey:_pud]
//    
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"0.1.0" forHTTPHeaderField:@"QuickBlox-REST-API-Version"];
//    [request setValue:<#(NSString *)#> forHTTPHeaderField:<#(NSString *)#>]
//    if ([requestType isEqualToString:@"POST"]) {
//        [request setHTTPMethod:@"POST"];
//        
//    }
//    [request setValue:@"your value" forHTTPHeaderField:@"for key"];//change this according to your need.
//    [request setHTTPBody:postData];
//}

//+(NSMutableURLRequest *)SendRequest:(NSString*)recievedRequestURL requestType :(NSString*)requestType combinedDataStr:(NSString*) combinedDataStr
//{
//    NSURL *url=[NSURL URLWithString:recievedRequestURL];
//    
//    NSString *postLength=@"";
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:url];
//    
//    if([requestType isEqualToString:@"POST"])
//    {
//        NSData *postData = [combinedDataStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//        postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//        [request setHTTPMethod:@"POST"];
//        
//        
//        NSString *accessToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"tokenlogin"];
//        //
//        [request setValue:accessToken forHTTPHeaderField:@"AuthToken"];
//        
//        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//        [request setHTTPBody:postData];
//    }
//    else
//    {
//        [request setHTTPMethod:@"GET"];
//    }
//    [request setValue:@"Origin" forHTTPHeaderField:@"Origin"];
//    
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    
//    
//    return request;
//    
//}

@end
