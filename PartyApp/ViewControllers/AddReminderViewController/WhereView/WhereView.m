//
//  WhereView.m
//  PartyApp
//
//  Created by Varun on 17/08/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "WhereView.h"
#import "LocationInfoCell.h"
#import "AppDelegate.h"
#import "FetchPlaces.h"

#import "MapViewAnnotation.h"

@interface WhereView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    
    __weak IBOutlet PATextField *textFieldLocation;
    __weak IBOutlet UIView *viewMapView;
    __weak IBOutlet MKMapView *mapView;
    __weak IBOutlet UITableView *tableViewLocation;
    
    NSMutableArray *arrFetchedLocations;
    NSInteger indexOfLocationSelected;
    CLLocation *locationSelected;
}

@end

@implementation WhereView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)awakeFromNib {
    [self initVariablesWhereView];
}

- (void)initVariablesWhereView {
    indexOfLocationSelected = -1;
    
    [mapView setShowsUserLocation:YES];
    
//    [self.layer setBorderColor:[UIColor greenColor].CGColor];
//    [self.layer setBorderWidth:1.0f];
    
//    [tableViewLocation.layer setBorderColor:[UIColor blueColor].CGColor];
//    [tableViewLocation.layer setBorderWidth:1.0f];
}

#pragma mark - IBAction

- (IBAction)doneButtonAction:(id)sender {
    
    [viewMapView setHidden:YES];
    [textFieldLocation resignFirstResponder];
    
    if ([_delegate respondsToSelector:@selector(resizeTheViewWithViewType:)])
        [_delegate resizeTheViewWithViewType:2];
    
    NSLog(@"Lat : %f", mapView.userLocation.location.coordinate.latitude);
    NSLog(@"Lng : %f", mapView.userLocation.location.coordinate.longitude);
    
    if ([[textFieldLocation text] length]) {
        
        CLLocationCoordinate2D currentCoordinate = mapView.userLocation.location.coordinate;
        
        NSString *keyword = [textFieldLocation.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//        NSString *stringToHit = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=AIzaSyCHTaIkOrh6LFZt5dpDqxE2V6YkRuIr1nI", keyword];
    
        NSString *stringToHit = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=10000&name=%@&sensor=false&key=AIzaSyCHTaIkOrh6LFZt5dpDqxE2V6YkRuIr1nI", currentCoordinate.latitude, currentCoordinate.longitude, keyword];
        
        FetchPlaces *objFetchPlaces = [[FetchPlaces alloc] init];
        [objFetchPlaces fetchPlacesInController:self
                                   withselector:@selector(placesResult:)
                                        withURL:stringToHit
                             toShowWindowLoader:YES];
        indexOfLocationSelected = -1;
    }
    else {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"Please enter some keyword to search."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    }
}

- (IBAction)reminderSetAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(selectedLocationInWhereView:)]) {
        if (!locationSelected)
            [[[UIAlertView alloc] initWithTitle:@"Location Error"
                                        message:@"No location selected."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        else
            [_delegate selectedLocationInWhereView:locationSelected];
    }
}

- (IBAction)reminderCancelAction:(id)sender {
    locationSelected = nil;
}

- (void)placesResult:(NSMutableDictionary *)dictResponse {
    
    if (arrFetchedLocations) {
        [arrFetchedLocations removeAllObjects];
        arrFetchedLocations = nil;
    }
    if ([[dictResponse objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"No results found with this keyword."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    }
    else {
        arrFetchedLocations = [[NSMutableArray alloc] initWithArray:[dictResponse objectForKey:@"results"]];
        [tableViewLocation reloadData];
    }
    
    int tableHeight = 44;
    if (arrFetchedLocations.count) {
        int heightOffset = (int)arrFetchedLocations.count * 44;
        if (arrFetchedLocations.count > 4)
            heightOffset = 176;
        tableHeight += heightOffset;
    }
    CGRect frameTB = tableViewLocation.frame;
    frameTB.size.height = tableHeight;
    [tableViewLocation setFrame:frameTB];
    
    CGRect frameSelf = self.frame;
    frameSelf.size.height = CGRectGetMaxY(frameTB);
    [self setFrame:frameSelf];
    
    if ([_delegate respondsToSelector:@selector(resizeTheViewWithViewType:)])
        [_delegate resizeTheViewWithViewType:2];
//    [self setLocationFramesAsPerUpdatesWithSelection:YES];
}

#pragma mark - Adding Annotation

- (void)addAnnotationInMapViewWithInfo:(NSDictionary *)info {

    [viewMapView setHidden:NO];
    CGRect frameMapView = viewMapView.frame;
    frameMapView.origin.y = CGRectGetMaxY(tableViewLocation.frame) + 10;
    
    [viewMapView setFrame:frameMapView];
    
    CGRect frameSelf = self.frame;
    frameSelf.size.height = CGRectGetMaxY(frameMapView);
    
    [self setFrame:frameSelf];
    
    if ([_delegate respondsToSelector:@selector(resizeTheViewWithViewType:)])
        [_delegate resizeTheViewWithViewType:2];


    NSDictionary *location = [[info objectForKey:@"geometry"] objectForKey:@"location"];
    
    CLLocationCoordinate2D coordinate;
    NSNumber *latitude = [location objectForKey:@"lat"];
    NSNumber *longitude = [location objectForKey:@"lng"];
    
    NSString *title = [info objectForKey:@"name"];
    coordinate.latitude = latitude.doubleValue;
    coordinate.longitude = longitude.doubleValue;

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 800, 800);
    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate;
    point.title = title;
    point.subtitle = [info objectForKey:@"vicinity"];
    
    [mapView addAnnotation:point];
    
    locationSelected = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                  longitude:coordinate.longitude];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(resizeScrollViewForEditing:)])
        [_delegate resizeScrollViewForEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(resizeScrollViewForEditing:)])
        [_delegate resizeScrollViewForEditing:NO];
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrFetchedLocations count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"Cell";
    id cell = nil;
    
    UITableViewCell *simpleCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    LocationInfoCell *cellLocationInfo = nil;
    
    if (indexPath.row == 0) {
        if (simpleCell == nil) {
            simpleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            [simpleCell.textLabel setTextColor:[UIColor whiteColor]];
            [simpleCell setBackgroundColor:[UIColor clearColor]];
            [simpleCell.contentView setBackgroundColor:[UIColor clearColor]];
        }
        
        [simpleCell.textLabel setFont:[UIFont fontWithName:_pFontArialRoundedMT size:15]];
        [simpleCell.imageView setImage:[UIImage imageNamed:@"unselLocation"]];
        [simpleCell.imageView setContentMode:UIViewContentModeCenter];
        
        [simpleCell.textLabel setText:@"Current Location"];
        
        cell = simpleCell;
    }
    else if (indexPath.row <= arrFetchedLocations.count) {
        
        if (cellLocationInfo == nil)
            cellLocationInfo = [[[NSBundle mainBundle] loadNibNamed:@"LocationInfoCell"
                                                              owner:self
                                                            options:nil] objectAtIndex:0];
        
        NSDictionary *indexDict = [arrFetchedLocations objectAtIndex:indexPath.row - 1];
        [cellLocationInfo fillLocationInfoCellWithName:[indexDict objectForKey:@"name"]
                                            andAddress:[indexDict objectForKey:@"vicinity"]];
        cell = cellLocationInfo;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > 0) {
        indexOfLocationSelected = indexPath.row - 1;
    }
    else {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        CLLocation *locationCurrent = appDelegate.locationCurrent;
        
        NSDictionary *dictLocation = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:locationCurrent.coordinate.latitude], @"lat",
                                      [NSNumber numberWithFloat:locationCurrent.coordinate.longitude], @"lng", nil];
        
        NSDictionary *geometry = [NSDictionary dictionaryWithObject:dictLocation
                                                             forKey:@"location"];
        
        NSMutableDictionary *dictLocationInfo = [[NSMutableDictionary alloc] init];
        [dictLocationInfo setObject:geometry forKey:@"geometry"];
        [dictLocationInfo setObject:@"Current Location" forKey:@"vicinity"];
        
        [self addAnnotationInMapViewWithInfo:dictLocationInfo];
    }
    [self addAnnotationInMapViewWithInfo:[arrFetchedLocations objectAtIndex:indexOfLocationSelected]];
}

@end
