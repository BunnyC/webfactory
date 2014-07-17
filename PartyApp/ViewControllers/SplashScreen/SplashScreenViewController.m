//
//  SplashScreenViewController.m
//  PartyApp
//
//  Created by Gaganinder Singh on 22/06/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "ProfileViewController.h"

@interface SplashScreenViewController ()

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
    
    [QBAuth createSessionWithDelegate:self];
}

- (void)loginUser {
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    
    [QBUsers logInWithUserLogin:[userDefs objectForKey:@"login"]
                       password:[userDefs objectForKey:@"password"]
                       delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoginView {
    
    NSString *xibName = NSStringFromClass([LoginViewController class]);
    BOOL isiPhone5 = [[CommonFunctions sharedObject] isDeviceiPhone5];
    if (!isiPhone5)
        xibName = [NSString stringWithFormat:@"%@4", xibName];
    
    LoginViewController *objLoginView = [[LoginViewController alloc] initWithNibName:xibName bundle:nil];
//    objLoginView.delegate=self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginView];
    [navigationController.navigationBar setTranslucent:false];
    [self.navigationController presentViewController:navigationController animated:NO completion:nil];
}

#pragma mark - QBDelegate Methods

- (void)completedWithResult:(Result *)result {
    BOOL error = FALSE;
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    
    if ([result isKindOfClass:[QBAAuthSessionCreationResult class]]) {
        if (result.success) {
            NSLog(@"Session created successfully");
            if ([userDefs boolForKey:_pudLoggedIn])
                [self loginUser];
            else
                [self dismissViewControllerAnimated:true completion:nil];
        }
        else {
            error = TRUE;
        }
    }
    else if ([result isKindOfClass:[QBUUserLogInResult class]]) {
        if (result.success) {
            QBUUserLogInResult *loginResult = (QBUUserLogInResult *)result;
            QBUUser *userInfo = [loginResult user];
            
            id null = (id)[NSNull null];
            
            userInfo.facebookID = (userInfo.facebookID == null) ? @"" : userInfo.facebookID;
            userInfo.twitterID = (userInfo.twitterID == null) ? @"" : userInfo.twitterID;
            userInfo.fullName = (userInfo.fullName == null) ? @"" : userInfo.fullName;
            userInfo.email = (userInfo.email == null) ? @"" : userInfo.email;
            userInfo.login = (userInfo.login == null) ? @"" : userInfo.login;
            userInfo.phone = (userInfo.phone == null) ? @"" : userInfo.phone;
            userInfo.website = (userInfo.website == null) ? @"" : userInfo.website;
            
            NSLog(@"User Info : %@", userInfo);
            [userDefs setObject:userInfo forKey:@"userInfo"];
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
