//
//  SplashScreenViewController.m
//  PartyApp
//
//  Created by Gaganinder Singh on 22/06/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "ProfileViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface SplashScreenViewController () {
    NSUserDefaults *userDefs;
}

@end

@implementation SplashScreenViewController

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
    
    userDefs = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:TRUE];
    
    if (![userDefs boolForKey:_pudLoggedIn] || [userDefs boolForKey:@"LoginWithFacebook"])
        [QBAuth createSessionWithDelegate:self];
    else {
        
        NSMutableDictionary *userInfo = [userDefs objectForKey:_pudUserInfo];
        QBASessionCreationRequest *extendedAuthRequest = [[QBASessionCreationRequest alloc] init];
        extendedAuthRequest.userLogin = [userInfo objectForKey:@"login"]; // ID: 218651
        extendedAuthRequest.userPassword = [userDefs objectForKey:@"Password"];
        [QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Showing Login View

- (void)addNavigationAnimation {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
}

- (void)showLoginView {
    
    NSString *xibName = NSStringFromClass([LoginViewController class]);
    BOOL isiPhone5 = [[CommonFunctions sharedObject] isDeviceiPhone5];
    if (!isiPhone5)
        xibName = [NSString stringWithFormat:@"%@4", xibName];
    
    LoginViewController *objLoginView = [[LoginViewController alloc] initWithNibName:xibName bundle:nil];
    [self addNavigationAnimation];
    [self.navigationController pushViewController:objLoginView animated:NO];
}

#pragma mark - QBDelegate Methods

- (void)completedWithResult:(Result *)result {
    
    BOOL error = FALSE;
    
    if ([result isKindOfClass:[QBAAuthSessionCreationResult class]]) {
        if (result.success) {
            NSLog(@"Session created successfully");
            
            if ([userDefs boolForKey:@"LoginWithFacebook"]) {
                
                FBSession *fbSession = [FBSession activeSession];
                FBAccessTokenData *fbAccessTokenData = [fbSession accessTokenData];
                NSString *fbAccessToken = [fbAccessTokenData accessToken];
                [QBUsers logInWithSocialProvider:@"facebook"
                                     accessToken:fbAccessToken
                               accessTokenSecret:nil
                                        delegate:self];
            }
            else {
                if ([userDefs boolForKey:_pudLoggedIn]) {
                    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                    [self dismissViewControllerAnimated:true completion:nil];
                }
                else
                    [self showLoginView];
            }
        }
        else {
            error = TRUE;
        }
    }
    else if ([result isKindOfClass:[QBUUserLogInResult class]]) {
        if (result.success) {
            QBUUserLogInResult *loginResult = (QBUUserLogInResult *)result;
            QBUUser *userInfo = [loginResult user];
            
            [[CommonFunctions sharedObject] saveInformationInDefaultsForUser:userInfo];
            NSLog(@"User Info : %@", userInfo);
            [self dismissViewControllerAnimated:NO completion:nil];
        }
        else {
            error = TRUE;
        }
    }
    if (error) {
        [[[UIAlertView alloc] initWithTitle:@"Session Problem"
                                    message:@"Sorry can't create your session right now"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

@end
