//
//  LoginModel.m
//  PartyApp
//
//  Created by Gaganinder Singh on 21/06/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

-(void)loginWithTarget:(id)target Selector:(SEL)selector Detail:(NSDictionary *)loginDetail
{
    _delegate=target;
    _handler=selector;
    
    [QBUsers logInWithUserLogin:[loginDetail objectForKey:@"UserName"]
                       password:[loginDetail objectForKey:@"Password"]
                       delegate:self];
    
}


#pragma mark -Server Response

-(void)completedWithResult:(Result *)result
{
    if([result isKindOfClass:[QBUUserLogInResult class]]){
		
        [[NSUserDefaults standardUserDefaults] setBool:result.success
                                                forKey:_pudLoggedIn];
        
        // Success result
        if(result.success){
            
            QBUUserLogInResult *res = (QBUUserLogInResult *)result;
            
            // save current user
            NSLog(@"UserName: %@ ",res.user);
            
            [_delegate performSelectorOnMainThread:_handler
                                        withObject:result
                                     waitUntilDone:YES];
        
            // Errors
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                            message:[result.errors description]
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles: nil];
            alert.tag = 1;
            [alert show];
   
        }
    }
   
}

@end
