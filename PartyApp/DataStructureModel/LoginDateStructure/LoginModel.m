//
//  LoginModel.m
//  PartyApp
//
//  Created by Gaganinder Singh on 21/06/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "LoginModel.h"
#import "WebService.h"

@implementation LoginModel

-(void)loginWithTarget:(id)target
              selector:(SEL)selector
             andDetail:(NSDictionary *)loginDetail
    toShowWindowLoader:(BOOL)toShow {
    
    _controller=target;
    _handler=selector;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:loginDetail
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *serviceUrl = [NSString stringWithFormat:@"%@%@", _pURLBase, _pURLLogin];
    
    NSMutableURLRequest *request = [RequestBuilder sendRequest:serviceUrl
                                                   requestType:@"POST"
                                               combinedDataStr:jsonString];
    
    ServerConnection *serverConn = [[ServerConnection alloc] init];
    [serverConn serverRequest:self
                     selector:@selector(serverResponseForLogin:)
                serverRequest:request
           toShowWindowLoader:toShow];
    
}

#pragma mark - Server Response

- (void)serverResponseForLogin:(NSMutableData *)responseData {
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
        [arrErrors addObject:@"Login credentials don't match our database."];
        NSDictionary *dictError = [NSDictionary dictionaryWithObject:arrErrors
                                                              forKey:@"errors"];
        responseReceived = dictError;
    }
    
    [_controller performSelectorOnMainThread:_handler
                                  withObject:responseReceived
                               waitUntilDone:YES];
}

@end
