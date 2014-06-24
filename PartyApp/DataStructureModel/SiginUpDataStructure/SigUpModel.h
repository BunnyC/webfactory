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
    id  _delegate;
    SEL _handler;
}

-(void)resgisterationWithTarget:(id)target Selector:(SEL)selector AndDetails:(NSMutableDictionary *)accountDetails;

@end
