//
//  AppDelegate.m
//  PartyApp
//
//  Created by Varun on 14/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "SplashScreenViewController.h"
#import "LoginViewController.h"
#import "FXBlurView.h"

@implementation AppDelegate

#pragma mark - AppDelegate Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Quickblox Account Setting
    [QBSettings setApplicationID:_pApplicationID];
    [QBSettings setAuthorizationKey:_pAuthorizationKey];
    [QBSettings setAuthorizationSecret:_pAuthorizationSecret];
    [QBSettings setAccountKey:_pAccountKey];
   
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self setApplicationDefaults];
    
    NSString *xibName = NSStringFromClass([ProfileViewController class]);
    BOOL isiPhone5 = [[CommonFunctions sharedObject] isDeviceiPhone5];
    if (!isiPhone5)
        xibName = [NSString stringWithFormat:@"%@4", xibName];
   
    ProfileViewController *objProfileView = [[ProfileViewController alloc] initWithNibName:xibName bundle:nil];
    objProfileView.isComeFromSignUp = FALSE;
    self.navController = [[UINavigationController alloc] initWithRootViewController:objProfileView];
    [self.navController.navigationBar setTranslucent:false];
    [self.window setRootViewController:self.navController];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    
//    NSDate *sessionExpiratioDate = [QBBaseModule sharedModule].tokenExpirationDate;
//    NSDate *currentDate = [NSDate date];
//    NSTimeInterval interval = [currentDate timeIntervalSinceDate:sessionExpiratioDate];
//    if(interval > 0){
//        // recreate session here
        SplashScreenViewController *objSplashView = [[SplashScreenViewController alloc] initWithNibName:@"SplashScreenViewController" bundle:nil];
        UINavigationController *navContSplash = [[UINavigationController alloc] initWithRootViewController:objSplashView];
        [navContSplash.navigationBar setTranslucent:FALSE];
        [_navController presentViewController:navContSplash animated:NO completion:nil];
//    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
    
    return YES;
}

- (void)setApplicationDefaults {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                animated:true];
    
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    if (![userDefs objectForKey:_pudLoggedIn] && [userDefs boolForKey:_pudLoggedIn] == false)
        [userDefs setBool:false forKey:_pudLoggedIn];
    if (![userDefs objectForKey:_pudSessionExpiryDate])
        [userDefs setObject:[NSDate date] forKey:_pudSessionExpiryDate];
    [userDefs synchronize];
    
    //  Navigation Bar Setup
    UIColor *colorNavTitleText = [[CommonFunctions sharedObject] colorWithHexString:@"5f4b5e"];
    UIFont *fontNavTitleText = [UIFont fontWithName:@"ArialMT" size:14];
    
    NSDictionary *dictNavTitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                            colorNavTitleText, NSForegroundColorAttributeName,
                                            fontNavTitleText, NSFontAttributeName, nil];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:dictNavTitleAttributes];
    
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [FBSession.activeSession handleOpenURL:url];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
     [self.session close];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Location Manager Delegate Methods

#pragma mark
#pragma mark locationManager delegate methods


- (void)locationManager: (CLLocationManager *)manager
    didUpdateToLocation: (CLLocation *)newLocation
           fromLocation: (CLLocation *)oldLocation
{
    
//    float latitude = newLocation.coordinate.latitude;
//    strLatitude = [NSString stringWithFormat:@"%f",latitude];
//    float longitude = newLocation.coordinate.longitude;
//    strLongitude = [NSString stringWithFormat:@"%f", longitude];
    //[self returnLatLongString:strLatitude:strLongitude];
    self.locationCurrent = newLocation;
    self.locationServicesEnabled = YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.locationServicesEnabled = NO;
}

@end
