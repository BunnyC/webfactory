//
//  SigUpModel.m
//  PartyApp
//
//  Created by Gaganinder Singh on 21/06/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "SigUpModel.h"
#import "WebService.h"

@implementation SigUpModel

- (void)registerationForTarget:(id)target
                  withselector:(SEL)selector
                    andDetails:(NSDictionary *)accountDetails
            toShowWindowLoader:(BOOL)toShow {
    
    _controller = target;
    _handler = selector;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:accountDetails
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *serviceUrl = [NSString stringWithFormat:@"%@%@", _pURLBase, _pURLSignUp];
    
    NSMutableURLRequest *request = [RequestBuilder sendRequest:serviceUrl
                                                   requestType:@"POST"
                                               combinedDataStr:jsonString];
    
    ServerConnection *serverConn = [[ServerConnection alloc] init];
    [serverConn serverRequest:self
                     selector:@selector(serverResponseForSignUp:)
                serverRequest:request
           toShowWindowLoader:toShow];
}

-(void)serverResponseForSignUp:(NSMutableData *)responseData {
    
    NSError *error = nil;
    NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData
                                                                        options:NSJSONReadingAllowFragments
                                                                          error:&error];
    
    NSDictionary *responseReceived = nil;
    
    if ([responseDict objectForKey:@"user"]) {
        NSMutableDictionary *dictUserInfo = [[NSMutableDictionary alloc] initWithDictionary:[responseDict objectForKey:@"user"]];

        for (NSString *keyName in [dictUserInfo allKeys])
            if ([dictUserInfo objectForKey:keyName] == (id)[NSNull null])
                [dictUserInfo setObject:@"" forKey:keyName];
        
        NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
        [userDefs setObject:dictUserInfo forKey:_pudUserInfo];
        [userDefs synchronize];
        responseReceived = dictUserInfo;
    }
    else {
        
        NSMutableArray *arrErrors = [[NSMutableArray alloc] init];
        
        NSDictionary *errorInfo = [responseDict objectForKey:@"errors"];
        NSArray *arrAllKeys = [errorInfo allKeys];
        
        for (int i = 0; i < [arrAllKeys count]; i ++) {
            NSArray *arrForKey = [errorInfo objectForKey:[arrAllKeys objectAtIndex:i]];
            NSString *keyName = [arrAllKeys objectAtIndex:i];
            NSString *errorMsg = [NSString stringWithFormat:@"%@ %@", [keyName capitalizedString], [arrForKey componentsJoinedByString:@", "]];
            [arrErrors addObject:errorMsg];
        }
        
        NSDictionary *dictError = [NSDictionary dictionaryWithObject:arrErrors
                                                              forKey:@"errors"];
        responseReceived = dictError;
    }
    
    [_controller performSelectorOnMainThread:_handler
                                  withObject:responseReceived
                               waitUntilDone:YES];
    
}

@end
