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

    QBASessionCreationRequest *extendedAuthRequest = [[QBASessionCreationRequest alloc] init];
    extendedAuthRequest.userLogin = [loginDetail objectForKey:@"UserName"];
    extendedAuthRequest.userPassword = [loginDetail objectForKey:@"Password"];
    
    [QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
//    [QBUsers logInWithUserLogin:[loginDetail objectForKey:@"UserName"]
//                       password:[loginDetail objectForKey:@"Password"]
//                       delegate:self];
    
}


#pragma mark -Server Response

/*
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
*/

-(void)completedWithResult:(Result *)result{
    // Success result
    if(result.success){
        
        // QuickBlox session creation  result
        if ([result isKindOfClass:[QBAAuthSessionCreationResult class]]) {
            
            // Success result
            if(result.success){
                
                // send request for getting user's filelist
//                PagedRequest *pagedRequest = [[PagedRequest alloc] init];
//                [pagedRequest setPerPage:20];
//                
//                [QBContent blobsWithPagedRequest:pagedRequest delegate:self];

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
            
            // Get User's files result
        } else if ([result isKindOfClass:[QBCBlobPagedResult class]]){
            
            // Success result
            if(result.success){
                QBCBlobPagedResult *res = (QBCBlobPagedResult *)result;
                
                // Save user's filelist
                [DataManager instance].fileList = [res.blobs mutableCopy];
                
                // hid splash screen

            }
        }
    }
}
@end
