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
    id  _controller;
    SEL _handler;
    UIView *viewLoading;
}

-(void)loginWithTarget:(id)target
              selector:(SEL)selector
             andDetail:(NSDictionary *)loginDetail
    toShowWindowLoader:(BOOL)toShow;

@end
