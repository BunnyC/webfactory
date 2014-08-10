//
//  LocationCell.m
//  PartyApp
//
//  Created by Varun on 10/08/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "LocationCell.h"
#import "MapViewAnnotation.h"

double METERS_PER_MILE = 1609.344;

@implementation LocationCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)zoomToLocationWithLocation:(CLLocationCoordinate2D)zoomLocation
{
//    CLLocationCoordinate2D zoomLocation;
//    zoomLocation.latitude = 13.03297;
//    zoomLocation.longitude= 80.26518;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 7.5*METERS_PER_MILE,7.5*METERS_PER_MILE);
    [self.mapViewCell setRegion:viewRegion animated:YES];
    [self.mapViewCell regionThatFits:viewRegion];
}

- (void)addAnnotationInCellWithInfo:(NSDictionary *)info {
    
    NSDictionary *location = [[info objectForKey:@"geometry"] objectForKey:@"location"];

    CLLocationCoordinate2D coordinate;
    NSNumber *latitude = [location objectForKey:@"lat"];
    NSNumber *longitude = [location objectForKey:@"lng"];

    NSString *title = [info objectForKey:@"name"];
    coordinate.latitude = latitude.doubleValue;
    coordinate.longitude = longitude.doubleValue;
    
    MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:title
                                                               andCoordinate:coordinate];
    [self.mapViewCell showAnnotations:[NSArray arrayWithObject:annotation]
                             animated:YES];
//    [self.mapViewCell addAnnotation:annotation];
//    [self zoomToLocationWithLocation:coordinate];
}

- (IBAction)buttonDoneOrCancel:(id)sender {
}

@end
