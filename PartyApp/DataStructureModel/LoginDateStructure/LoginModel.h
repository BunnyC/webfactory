//
//  LoginModel.h
//  PartyApp
//
//  Created by Gaganinder Singh on 21/06/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject<QBActionStatusDelegate>
{
    id  _delegate;
    SEL _handler;
}

-(void)loginWithTarget:(id)target Selector:(SEL)selector Detail:(NSDictionary *)loginDetail;
@end
