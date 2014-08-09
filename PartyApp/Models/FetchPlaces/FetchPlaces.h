//
//  FetchPlaces.h
//  PartyApp
//
//  Created by Varun on 10/08/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchPlaces : NSObject {
    id  _controller;
    SEL _handler;
}

- (void)fetchPlacesInController:(id)target
                   withselector:(SEL)selector
                        withURL:(NSString *)strURL
             toShowWindowLoader:(BOOL)toShow;
@end
