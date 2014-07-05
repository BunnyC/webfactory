//
//  ServerConnection.h
//  JSONParsing
//
//  Created by Varun Channi on 1/15/14.
//  Copyright (c) 2014 NetSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConnection : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate> {
    id _controller;
    SEL _handler;
    NSMutableData *_responseData;
    NSMutableData *responseData;
    UIView *loadingView;
}

@property (strong,nonatomic) NSURLConnection *urlConnection;


- (void)serverRequest:(id)target selector:(SEL)selector serverRequest:(NSMutableURLRequest *)request toShowWindowLoader:(BOOL)toShow;

@end
