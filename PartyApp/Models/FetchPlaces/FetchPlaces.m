//
//  FetchPlaces.m
//  PartyApp
//
//  Created by Varun on 10/08/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "FetchPlaces.h"
#import "WebService.h"

@implementation FetchPlaces

- (void)fetchPlacesInController:(id)target
                   withselector:(SEL)selector
                        withURL:(NSString *)strURL
             toShowWindowLoader:(BOOL)toShow {
    
    _controller = target;
    _handler = selector;
    
    NSMutableURLRequest *request = [RequestBuilder sendRequest:strURL
                                                   requestType:@"GET"
                                               combinedDataStr:nil];
    
    ServerConnection *serverConn = [[ServerConnection alloc] init];
    [serverConn serverRequest:self
                     selector:@selector(serverResponseForPlaces:)
                serverRequest:request
           toShowWindowLoader:toShow];
}

- (void)serverResponseForPlaces:(NSMutableData *)responseData {
    
    NSError *error = nil;
    NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData
                                                                        options:NSJSONReadingAllowFragments
                                                                          error:&error];
    
    [_controller performSelectorOnMainThread:_handler
                                  withObject:responseDict
                               waitUntilDone:YES];
}

@end
