//
//  ServerConnection.h
//  TextFieldDemo
//
//  Created by Varun on 4/05/2014.
//  Copyright (c) 2014 Channi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConnection : NSObject  <NSURLConnectionDelegate> {
    id _controller;
    SEL _handler;
    NSMutableData *_responseData;
}

- (void)fetchDataWithRequest:(NSURLRequest *)request
                   forTarget:(id)target
                 andSelector:(SEL)selector;

@end
