//
//  WhenView.h
//  PartyApp
//
//  Created by Varun on 17/08/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WhenViewDelegate <NSObject>

@required
- (void)resizeTheViewWithViewType:(int)type;
- (void)selectedValuesInWhenView:(NSDictionary *)dictionary;
- (void)resizeScrollViewForEditing:(BOOL)forEditing;

@end

@interface WhenView : UIView

@property (assign, nonatomic) id<WhenViewDelegate> delegate;

@end
