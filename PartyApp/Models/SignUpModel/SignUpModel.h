//
//  SigUpModel.h
//  PartyApp
//
//  Created by Gaganinder Singh on 21/06/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUpModel : NSObject<QBActionStatusDelegate>
{
    id  _controller;
    SEL _handler;
}

- (void)registerationForTarget:(id)target
                   withselector:(SEL)selector
                     andDetails:(NSDictionary *)accountDetails
             toShowWindowLoader:(BOOL)toShow;


- (void)UpdateUserWithTarget:(id)target
                  withselector:(SEL)selector
                    andDetails:(NSDictionary *)accountDetails
          toShowWindowLoader:(BOOL)toShow User_id:(NSString *)userid;

- (void)checkUserWithFacebook:(id)target
                  withselector:(SEL)selector
                    andDetails:(NSDictionary *)accountDetails
            toShowWindowLoader:(BOOL)toShow;
@end
