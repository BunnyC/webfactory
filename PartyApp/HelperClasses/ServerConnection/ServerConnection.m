//
//  ServerConnection.m
//  JSONParsing
//
//  Created by Varun Channi on 1/15/14.
//  Copyright (c) 2014 NetSolutions. All rights reserved.
//

#import "ServerConnection.h"
#import "CommonFunctions.h"
//#import "ReachabilityManager.h"

@implementation ServerConnection

- (void)serverRequest:(id)target selector:(SEL)selector serverRequest:(NSMutableURLRequest *)request toShowWindowLoader:(BOOL)toShow {
    
    _controller = target;
    _handler = selector;
    
//    if ([ReachabilityManager isReachable]) {
        loadingView = nil;
        if(toShow)
            loadingView = [[CommonFunctions sharedObject] showLoadingView];
        
        NSURLConnection *catConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        _urlConnection = catConnection;
        
        
        [_urlConnection start];
        responseData =  _urlConnection ? [NSMutableData data] : nil;
//    }
//    else{
//        [[CommonFunctions shared]showSelfDismissingAlertViewWithMessage:@"Please check your internet connection."];
//    }
}


#pragma mark - NSURLConnection Delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    [_controller performSelectorOnMainThread:_handler
                                  withObject:_responseData
                               waitUntilDone:YES];
    
    [[CommonFunctions sharedObject] hideLoadingView:loadingView];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"Error : %@", error);
    [[CommonFunctions sharedObject] hideLoadingView:loadingView];
    
    if(error.code == NSURLErrorTimedOut
       || error.code == NSURLErrorNotConnectedToInternet
       || error.code == NSURLErrorBadServerResponse
       || error.code == NSURLErrorNotConnectedToInternet
       || error.code == NSURLErrorNetworkConnectionLost
       || error.code == NSURLErrorUnknown
       || error ){
        NSLog(@"Time out");
//        [[CommonFunctions sharedObject]showSelfDismissingAlertViewWithMessage: @"Oops! Something is wrong here. Please try again after few moments."];
    }
    else {
        [_controller performSelectorOnMainThread:_handler
                                      withObject:_responseData
                                   waitUntilDone:YES];
    }
}

@end
