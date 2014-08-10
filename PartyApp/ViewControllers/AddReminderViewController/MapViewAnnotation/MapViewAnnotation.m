//
//  MapViewAnnotation.m
//  PartyApp
//
//  Created by Varun on 10/08/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize title;
@synthesize coordinate;

- (id)initWithTitle:(NSString *)annTitle
      andCoordinate:(CLLocationCoordinate2D)annCoordinate {
    
    self = [super init];
    _annotationTitle = annTitle;
    _annotationCoordinate = annCoordinate;
    
    return self;
}

@end
