//
//  ProfileViewController.m
//  PartyApp
//
//  Created by Varun on 18/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "LogNightViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@interface ProfileViewController () <QBActionStatusDelegate>

@end

@implementation ProfileViewController

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
    [self.navigationController setNavigationBarHidden:FALSE animated:true];
    [self setTitle:@"Party Friends"];
    // Do any additional setup after loading the view from its nib.
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:_pudLoggedIn]) {
        [self showLoginView];
    }
    
    imageViewProfile.layer.borderColor= [UIColor blueColor].CGColor;
    imageViewProfile.layer.borderWidth=1.5;
    
}

#pragma mark - Update UserInformation
-(void)updateUserProfileData:(NSDictionary *)userInfo
{
    lblName.text=[NSString stringWithFormat:@"%@ %@",[userInfo objectForKey:@"first_name"],[userInfo objectForKey:@"last_name"]];
    lblActive.text=@"active";
    lblMotto.text=[NSString stringWithFormat:@"%@",@"Share your moto"];
}


#pragma mark loginView Delegate

-(void)updateUserInfo:(NSDictionary *)dic
{
    lblName.text=[NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"first_name"],[dic objectForKey:@"last_name"]];
    lblActive.text=@"active";
    lblMotto.text=[NSString stringWithFormat:@"%@",@"Share your moto"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Login View

- (void)showLoginView {
    
    NSString *xibName = NSStringFromClass([LoginViewController class]);
    BOOL isiPhone5 = [[CommonFunctions sharedObject] isDeviceiPhone5];
    if (!isiPhone5)
        xibName = [NSString stringWithFormat:@"%@4", xibName];
    
    LoginViewController *objLoginView = [[LoginViewController alloc] initWithNibName:xibName bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginView];
    [navigationController.navigationBar setTranslucent:false];
    [self presentViewController:navigationController animated:NO completion:nil];
}

#pragma mark - IBActions
- (IBAction)logNightAction:(id)sender {
    LogNightViewController *objLogNight = [[LogNightViewController alloc] initWithNibName:@"LogNightViewController" bundle:nil];
    [self.navigationController pushViewController:objLogNight animated:YES];
}
- (IBAction)setReminderAction:(id)sender {
}
- (IBAction)editAccountAction:(id)sender {
}
- (IBAction)logoutAction:(id)sender {

    FBSession *session=[FBSession activeSession];
    [session closeAndClearTokenInformation];
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setBool:false forKey:_pudLoggedIn];
    [userDefs synchronize];
    
    [self showLoginView];
}
- (IBAction)notificationsAction:(id)sender {
    int heightForView = 60;
    if (viewNotifications.frame.origin.y > 290) {
        heightForView = 280;
    }
}

@end
