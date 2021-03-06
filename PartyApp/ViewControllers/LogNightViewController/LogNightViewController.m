//
//  LogNightViewController.m
//  PartyApp
//
//  Created by Varun on 20/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "LogNightViewController.h"
#import "LogNightCell.h"
#import <FacebookSDK/FacebookSDK.h>

NSString *className = @"PALogNight";

//NSString *className = @"TempClass";

@interface LogNightViewController () <UITableViewDataSource, UITableViewDelegate, QBActionStatusDelegate> {
    
    BOOL locationErrorShown;
    int finalRatingValue;
    CLLocationManager *locationManager;
    CLLocation *thisLocation;
    UIView *loadingView;
    
    CommonFunctions *commFunc;
}

@property (strong, nonatomic) NSMutableDictionary *dictOptions;

@end

@implementation LogNightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem.rightBarButtonItem setEnabled:false];
    
    ///[self createUserSession];
    [self initDefaults];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchCurrentLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Defaults

- (void)initDefaults {
    
    [self setTitle:@"Log Your Night"];
    locationErrorShown = false;
    [self setupRatingViewWithValue:0];
    
    //  Setting up Navigation Item
    
    commFunc = [CommonFunctions sharedObject];
    
    [self setupNavigationBarInLogNightView];
    
    NSNumber *numberValue = [NSNumber numberWithInt:0];
    
    NSMutableDictionary *dictLocation = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"location", @"SelImage",
                                         @"unselLocation", @"UnSelImage",
                                         numberValue, @"Selected", nil];
    
    NSMutableDictionary *dictNotify = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"selCommentIcon", @"SelImage",
                                       @"commentIcon", @"UnSelImage",
                                       numberValue, @"Selected", nil];
    
    NSMutableDictionary *dictFacebook = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"selFacebookIcon", @"SelImage",
                                         @"facebookIcon", @"UnSelImage",
                                         numberValue, @"Selected", nil];
    
    self.dictOptions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                        dictLocation, @"1. Allow Location",
                        dictNotify, @"2. Notify Friends",
                        dictFacebook, @"3. Post on Facebook", nil];
    txtViewNotes.inputAccessoryView=inputAccessoryView;
    
}

- (void)setupNavigationBarInLogNightView {
    UIImage *imgBackButton = [commFunc imageWithName:@"backButton" andType:_pPNGType];
    UIImage *imgNextButton = [commFunc imageWithName:@"barButtonTick" andType:_pPNGType];
    
    UIButton *leftBarButton = [commFunc buttonNavigationItemWithImage:imgBackButton
                                                            forTarget:self
                                                          andSelector:@selector(backButtonAction:)];
    UIButton *rightBarButton = [commFunc buttonNavigationItemWithImage:imgNextButton
                                                             forTarget:self
                                                           andSelector:@selector(logThisNightAction:)];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

#pragma mark - Location Manager Methods

- (void)fetchCurrentLocation {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        [locationManager startUpdatingLocation];
    }
    else{
        if (!locationErrorShown) {
            [self showLocationDisabledAlert];
            locationErrorShown = true;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    thisLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    NSLog(@"Error Desc : %@", error.description);
}

- (void)showLocationDisabledAlert {
    
    NSString *locationDisabledMsg = @"Location Services are disabled for this app, you can turn it on from Settings -> Privacy -> Location -> PartyApp";
    
    UIAlertView *errorAlertLocation= [[UIAlertView alloc] initWithTitle:@"Location Disabled"
                                                                message:locationDisabledMsg
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
    [errorAlertLocation show];
}

#pragma mark - Setup Rating View

- (void)setupRatingViewWithValue:(int)ratingValue {
    
    finalRatingValue = ratingValue;
    int xValue = 0;
    int vWidth = 64;
    
    UIImage *unSelImage = [[CommonFunctions sharedObject] imageWithName:@"unselImg"
                                                                andType:_pPNGType];
    
    for (int i = 0; i < 5; i ++) {
        
        CGRect frameImageView = CGRectMake(xValue + 8, 8, 47, 47);
        
        UIImageView *imageViewRating = [[UIImageView alloc] initWithFrame:frameImageView];
        [imageViewRating setContentMode:UIViewContentModeScaleAspectFit];
        [imageViewRating setUserInteractionEnabled:true];
        [imageViewRating setImage:unSelImage];
        [imageViewRating setTag:(i + 1)];
        
        UITapGestureRecognizer *tapOnimage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnImage:)];
        [tapOnimage setNumberOfTapsRequired:1];
        [tapOnimage setNumberOfTouchesRequired:1];
        [imageViewRating addGestureRecognizer:tapOnimage];
        
        [viewRatings addSubview:imageViewRating];
        xValue += vWidth;
    }
}

#pragma mark - Navigation Bar Methods

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Logging Night

- (NSString *)checkFields {
    NSString *errorMsg = nil;
    if (!finalRatingValue)
        errorMsg = @"Add Rating";
    
    if (![txtViewNotes.text length]) {
        if (errorMsg)
            errorMsg = [NSString stringWithFormat:@"%@ and a Note", errorMsg];
        else
            errorMsg = @"Add a note";
    }
    return errorMsg;
}

- (void)logThisNightAction:(id)sender {
    
    NSString *errorMsg = [self checkFields];
    
    if (!errorMsg) {
        
        BOOL facebookPost = [[[self.dictOptions objectForKey:@"3. Post on Facebook"] objectForKey:@"Selected"] intValue];
        if(facebookPost)
        {
            [self sharePostOnFacebook];
           
        }
        
         [self performSelectorInBackground:@selector(saveValuesOnServer) withObject:nil];
    }
    else {
        NSString *fullMsg = [NSString stringWithFormat:@"You forgot to %@ for the night.", errorMsg];
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:fullMsg
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
        [errorAlert show];
    }
}


-(void)saveValuesOnServer
{
    BOOL location = [[[self.dictOptions objectForKey:@"1. Allow Location"] objectForKey:@"Selected"] intValue];
    BOOL notifyFriends = [[[self.dictOptions objectForKey:@"2. Notify Friends"] objectForKey:@"Selected"] intValue];
    BOOL facebookPost = [[[self.dictOptions objectForKey:@"3. Post on Facebook"] objectForKey:@"Selected"] intValue];
    
    id forLocation = location ? thisLocation : @"";
    
    QBCOCustomObject *objectLogNight = [QBCOCustomObject customObject];
    [objectLogNight setClassName:className];
    [objectLogNight.fields setObject:[NSNumber numberWithInt:finalRatingValue]
                              forKey:@"LN_Rating"];
    [objectLogNight.fields setObject:txtViewNotes.text
                              forKey:@"LN_Notes"];
    [objectLogNight.fields setObject:[NSNumber numberWithBool:notifyFriends]
                              forKey:@"LN_NotifyFriends"];
    [objectLogNight.fields setObject:[NSNumber numberWithBool:facebookPost]
                              forKey:@"LN_PostFacebook"];
    [objectLogNight.fields setObject:forLocation
                              forKey:@"LN_Location"];
    [QBCustomObjects createObject:objectLogNight delegate:self];
    
    loadingView = [[CommonFunctions sharedObject] showLoadingView];
}
#pragma -mark accessory View Button Methods
- (IBAction)accessoryViewButtonClicked:(id)sender {
    
    switch ([sender tag]) {
        case 0:
        {
            [txtViewNotes resignFirstResponder];
        }
        break;
        
        case 1:
        {
          [txtViewNotes setText:@""];
 
        }
        break;
        
        case 2:
        {
         [self logThisNightAction:self];
        [txtViewNotes resignFirstResponder];
        }
        break;
            
        default:
            break;
    }
    
    
}

#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
-(void)completedWithResult:(Result*)result{
    
    if([result isKindOfClass:QBCOCustomObjectResult.class]){
        
        // Success result
        if(result.success){
            
            UIAlertView *alertAdded = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                 message:@"Your night is successfully logged"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
            [alertAdded show];
            
            QBCOCustomObjectResult *res = (QBCOCustomObjectResult *)result;
            
            NSLog(@"new obj: %@", res.object);
//            [self.navigationController popViewControllerAnimated:YES];
            [self setupRatingViewWithValue:0];
            NSArray *arrKeys = [_dictOptions allKeys];
            for (int i = 0; i < [arrKeys count]; i ++) {
                NSMutableDictionary *indexDict = [_dictOptions objectForKey:[arrKeys objectAtIndex:i]];
                [indexDict setObject:[NSNumber numberWithInt:0] forKey:@"Selected"];
            }
            [tableViewOptions reloadData];
            [txtViewNotes setText:@"Add a note"];
        }
        [[CommonFunctions sharedObject] hideLoadingView:loadingView];
    }
}


#pragma mark - Tapped On Image Action

- (void)tappedOnImage:(UITapGestureRecognizer *)recognizer {
    
    int tagOfTappedImage = (finalRatingValue == [recognizer.view tag]) ? finalRatingValue - 1 : (int)[recognizer.view tag];
    finalRatingValue = tagOfTappedImage;
    
    for (UIImageView *imageView in viewRatings.subviews) {
        if ([imageView tag] <= tagOfTappedImage) {
            [UIView animateWithDuration:0.15f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^ {
                                 CGRect frameImage = imageView.frame;
                                 frameImage.origin.x -= 8;
                                 frameImage.origin.y -= 8;
                                 frameImage.size.width = 64;
                                 frameImage.size.height = 64;
                                 
                                 UIImage *selImage = [[CommonFunctions sharedObject] imageWithName:@"selImg" andType:_pPNGType];
                                 [imageView setImage:selImage];
                                 [imageView setFrame:frameImage];
                             }
                             completion:^(BOOL finished) {
                                 if (finished) {
                                     [UIView animateWithDuration:0.1f
                                                      animations: ^{
                                                          CGRect frameImage = imageView.frame;
                                                          frameImage.origin.x += 8;
                                                          frameImage.origin.y += 8;
                                                          frameImage.size.width = 47;
                                                          frameImage.size.height = 47;
                                                          
                                                          [imageView setFrame:frameImage];
                                                      }];
                                 }
                             }];
        }
        else {
            UIImage *unSelImage = [[CommonFunctions sharedObject] imageWithName:@"unselImg"
                                                                        andType:_pPNGType];
            [imageView setImage:unSelImage];
        }
    }
}

#pragma mark - UITableView Delegates & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dictOptions allKeys] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row == 2 ? 39 : 40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewSectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 31)];
    
    UIImage *imageBack = [[CommonFunctions sharedObject] imageWithName:@"sharingOptions"
                                                               andType:_pPNGType];
    [viewSectionHeader setBackgroundColor:[UIColor colorWithPatternImage:imageBack]];
    return viewSectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    LogNightCell *cell = (LogNightCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        
        NSArray *arrXib = [[NSBundle mainBundle] loadNibNamed:@"LogNightCell"
                                                        owner:self
                                                      options:nil];
        cell = [arrXib objectAtIndex:0];
        
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    NSArray *arrOptions = [[self.dictOptions allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSString *keyMain = [arrOptions objectAtIndex:indexPath.row];
    NSDictionary *dictAtIndex = [self.dictOptions objectForKey:keyMain];
    int selected = [[dictAtIndex objectForKey:@"Selected"] intValue];
    
    if (selected) {
        UIImage *imageAcc = [commFunc imageWithName:@"tick" andType:_pPNGType];
        [cell.imageViewAcc setImage:imageAcc];
    }
    else {
        [cell.imageViewAcc setImage:nil];
    }
    
    UIView *viewSelected = [[UIView alloc] initWithFrame:cell.frame];
    [viewSelected setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [cell setSelectedBackgroundView:viewSelected];
    
    NSString *keyName = selected ? @"SelImage" : @"UnSelImage";
    NSString *imageName = [dictAtIndex objectForKey:keyName];
    UIImage *imageMain = [commFunc imageWithName:imageName andType:_pPNGType];
    [cell.imageViewMain setImage:imageMain];
    
    NSString *strTextLabel = [arrOptions objectAtIndex:indexPath.row];
    NSRange rangeSpace = [strTextLabel rangeOfString:@" "];
    
    [cell.labelText setText:[strTextLabel substringFromIndex:rangeSpace.location]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *arrOptions = [[self.dictOptions allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSString *keyMain = [arrOptions objectAtIndex:indexPath.row];
    NSMutableDictionary *dictAtIndex = [self.dictOptions objectForKey:keyMain];
    int currentValue = [[dictAtIndex objectForKey:@"Selected"] intValue];
    
    NSNumber *newVal = [NSNumber numberWithInt:((currentValue + 1) % 2)];
    [dictAtIndex setObject:newVal forKey:@"Selected"];
    
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    [tableView reloadData];
    [tableView performSelector:@selector(reloadData)
                    withObject:nil
                    afterDelay:0.15];
    
}


-(void)sharePostOnFacebook
{
    
    // Check if the Facebook app is installed and we can present the share dialog
    
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];

    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:nil
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
//                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              /*
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                               */
                                                          }
                                                      }
                                                  }];
    }
}

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UIView *touchedView = [[touches anyObject] view];
    if (![touchedView isKindOfClass:[UITextView class]] && [txtViewNotes isFirstResponder]) {
        [txtViewNotes resignFirstResponder];
    }
}


@end
