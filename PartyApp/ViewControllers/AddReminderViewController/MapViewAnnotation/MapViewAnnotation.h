//
//  MapViewAnnotation.h
//  PartyApp
//
//  Created by Varun on 10/08/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *annotationTitle;
@property (nonatomic, readonly) CLLocationCoordinate2D annotationCoordinate;

- (id)initWithTitle:(NSString *)annTitle andCoordinate:(CLLocationCoordinate2D)annCoordinate;

@end
