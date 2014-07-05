//
//  SigUpModel.h
//  PartyApp
//
//  Created by Gaganinder Singh on 21/06/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SigUpModel : NSObject
{
    id  _controller;
    SEL _handler;
}

- (void)registerationForTarget:(id)target
                   withselector:(SEL)selector
                     andDetails:(NSDictionary *)accountDetails
             toShowWindowLoader:(BOOL)toShow;

@end
