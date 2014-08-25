//
//  WhereView.h
//  PartyApp
//
//  Created by Varun on 17/08/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WhereViewDelegate <NSObject>

@required
- (void)resizeTheViewWithViewType:(int)type;
- (void)selectedLocationInWhereView:(CLLocation *)selectedLocation;
- (void)resizeScrollViewForEditing:(BOOL)forEditing;

@end

@interface WhereView : UIView

@property (assign, nonatomic) id<WhereViewDelegate> delegate;

@end
