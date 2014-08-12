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
#import "AppDelegate.h"
#import "NotificationCell.h"
#import "RegisterViewController.h"
#import "AddReminderViewController.h"
#import "SplashScreenViewController.h"

#import <FacebookSDK/FacebookSDK.h>

@interface ProfileViewController () <QBActionStatusDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    CommonFunctions *commFunc;
    NSUserDefaults *userDefs;
    UIView *loadingView;
}

@end

@implementation ProfileViewController

#pragma mark - View Methods

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
    [self setTitle:@"Party Friends"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Other Methods

- (void)setupNavigationBar {
    
    UIImage *imgMenuButton = [commFunc imageWithName:@"buttonMenu" andType:_pPNGType];
    UIImage *imgNotificationButton = [commFunc imageWithName:@"buttonBell" andType:_pPNGType];
    
    UIButton *leftBarButton = [commFunc buttonNavigationItemWithImage:imgMenuButton
                                                            forTarget:self
                                                          andSelector:nil];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIButton *rightBarButton = [commFunc buttonNavigationItemWithImage:imgNotificationButton
                                                             forTarget:self
                                                           andSelector:nil];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void)initDefaults {

    // Setting up Bar Button Items
    
    commFunc = [CommonFunctions sharedObject];
    userDefs = [NSUserDefaults standardUserDefaults];
    
    _objUserDetail = [commFunc getQBUserObjectFromUserDefaults];
    lblName.text = _objUserDetail.fullName;
    
    NSString *mottoText = @"This app is awesome";
    if ([_objUserDetail.website length]) {
        NSRange range = [_objUserDetail.website rangeOfString:@"http://"];
        mottoText = [_objUserDetail.website substringFromIndex:range.location+range.length];
    }
    lblMotto.text = mottoText;
    lblActive.text = @"active";
    
    if (_objUserDetail.blobID) {
        NSString *avatarID = [userDefs objectForKey:_pudUserAvatar];
        [spinnerImageView setHidden:true];
        [spinnerImageView stopAnimating];
        if (_objUserDetail.blobID != avatarID.intValue || ![userDefs objectForKey:_pudAvatarPath]) {
            [spinnerImageView setHidden:false];
            [spinnerImageView startAnimating];
            [QBContent TDownloadFileWithBlobID:_objUserDetail.blobID delegate:self];
        }
        else {
            NSString *imgPath = [userDefs objectForKey:_pudAvatarPath];
            UIImage *imageProfile = [UIImage imageWithContentsOfFile:imgPath];
            [imageViewProfile setImage:imageProfile];
        }
    }
    else if (_objUserDetail.facebookID.length) {
        NSString *strFBImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", _objUserDetail.facebookID];
//        NSString *strFBImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/793557416/picture?type=large"];
        NSURL *urlFBImage = [NSURL URLWithString:strFBImageURL];
        NSData *dataImage = [NSData dataWithContentsOfURL:urlFBImage];
        [imageViewProfile setImage:[UIImage imageWithData:dataImage]];
        [spinnerImageView stopAnimating];
    }
    else {
        [spinnerImageView stopAnimating];
        [spinnerImageView setHidden:true];
        UIImage *profileImage = [[CommonFunctions sharedObject] imageWithName:@"placeholder"
                                                                      andType:_pPNGType];
        [imageViewProfile setImage:profileImage];
    }
    
    [imageViewProfile.layer setCornerRadius:imageViewProfile.frame.size.width / 2];
    
    if(!_objUserDetail){
        NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userObj"];
        _objUserDetail = (QBUUser *)[NSKeyedUnarchiver unarchiveObjectWithData:notesData];
    }
    
    
    [self setupNavigationBar];
    
    UIImage *imgViewNotif = [commFunc imageWithName:@"notifTop" andType:_pPNGType];
    UIImage *imgResized = [imgViewNotif resizableImageWithCapInsets:UIEdgeInsetsMake(40, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    [imgViewBackNotif setImage:imgResized];
    
    [viewNotifications setBackgroundColor:[UIColor clearColor]];
    [self.view sendSubviewToBack:viewNotifications];
    
    [tableViewNotifications.layer setCornerRadius:2];
    
    if(_isComeFromSignUp) {
        if(_dicUserInfo)
            [self updateUserProfileData:_dicUserInfo];
        else
            [self updateUserInfo:_objUserDetail];
    }
    
    UIPanGestureRecognizer *panViewBottom = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBottomView:)];
    [panViewBottom setMinimumNumberOfTouches:1];
    [panViewBottom setMaximumNumberOfTouches:1];
    [viewNotifications addGestureRecognizer:panViewBottom];
    
    //    [viewNotifications.layer setBorderColor:[UIColor whiteColor].CGColor];
    //    [viewNotifications.layer setBorderWidth:2];
}

- (void)showLoginView {
    
    SplashScreenViewController *objSplashView = [[SplashScreenViewController alloc] initWithNibName:@"SplashScreenViewController" bundle:nil];
    UINavigationController *navContSplash = [[UINavigationController alloc] initWithRootViewController:objSplashView];
    [navContSplash.navigationBar setTranslucent:FALSE];
    [self.navigationController presentViewController:navContSplash animated:NO completion:nil];
}

-(void)handleRecentReminderViewForRecognizer:(BOOL)forRecognizer {
    
    CGRect frameView = self.view.frame;
    CGRect newFrameForNotifView = viewNotifications.frame;
    CGRect frameTable = tableViewNotifications.frame;
    frameTable.origin.y = 52;
    
    int offsetAsPer3Rows = (65 * 3) + 14 + 52;
    
    BOOL toMoveUp = FALSE;
    if (forRecognizer)
        toMoveUp = (self.view.frame.size.height - viewNotifications.frame.origin.y > 160);
    else
        toMoveUp = (newFrameForNotifView.origin.y >= frameView.size.height - 52);
    
    if (toMoveUp) {
        newFrameForNotifView.origin.y = self.view.frame.size.height - offsetAsPer3Rows;
        newFrameForNotifView.size.height = offsetAsPer3Rows;
        frameTable.size.height = 65 * 3;
        [self.view bringSubviewToFront:viewNotifications];
    }
    else {
        newFrameForNotifView.origin.y = self.view.frame.size.height - 52;
        newFrameForNotifView.size.height = 52;
        frameTable.size.height = 0;
        [self.view sendSubviewToBack:viewNotifications];
    }
    
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [viewNotifications setFrame:newFrameForNotifView];
                         [tableViewNotifications setFrame:frameTable];
                     }
                     completion:nil];
}

- (void)panBottomView:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    
    int offsetAsPer3Rows = (65 * 3) + 14 + 52;
    
    CGRect frameBoundary = CGRectMake(0,
                                      (self.view.frame.size.height - offsetAsPer3Rows),
                                      viewNotifications.frame.size.width,
                                      254);
    
    CGPoint pointTranslated = CGPointMake(recognizer.view.frame.origin.x, recognizer.view.frame.origin.y + translation.y);
    
    if (CGRectContainsPoint(frameBoundary, pointTranslated)) {
        recognizer.view.center = CGPointMake(recognizer.view.center.x,
                                             recognizer.view.center.y + translation.y);
        
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        
        UIView *panView = recognizer.view;
        
        CGRect framePanView = panView.frame;
        framePanView.size.height = self.view.frame.size.height - framePanView.origin.y;
        [panView setFrame:framePanView];
        
        CGRect frameTableView = tableViewNotifications.frame;
        frameTableView.origin.y = 52;
        frameTableView.size.height = (framePanView.size.height - 66) > 0 ? framePanView.size.height - 66 : 0;
        [tableViewNotifications setFrame:frameTableView];
        
        [self.view bringSubviewToFront:viewNotifications];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self handleRecentReminderViewForRecognizer:TRUE];
    }
}

#pragma mark - Update UserInformation

-(void)updateUserProfileData:(NSDictionary *)userInfo {
    
    if(!_objUserDetail)
        _objUserDetail=[[QBUUser alloc]init];
    
    _objUserDetail.ID       = [[userInfo objectForKey:@"id"]integerValue];
    _objUserDetail.fullName = [userInfo objectForKey:@"full_name"];
    _objUserDetail.email    = [userInfo objectForKey:@"email"];
    _objUserDetail.login    = [userInfo objectForKey:@"login"];
    _objUserDetail.website  = [userInfo objectForKey:@"website"];
}

#pragma mark loginView Delegate

-(void)updateUserInfo:(QBUUser *)objUser {
    _objUserDetail = objUser;
}

#pragma mark - IBActions

- (IBAction)logNightAction:(id)sender {
    
    NSString *xibName = NSStringFromClass([LogNightViewController class]);
    BOOL isiPhone5 = [[CommonFunctions sharedObject] isDeviceiPhone5];
    if (!isiPhone5)
        xibName = [NSString stringWithFormat:@"%@4", xibName];
    
    LogNightViewController *objLogNight = [[LogNightViewController alloc] initWithNibName:xibName bundle:nil];
    
    [self.navigationController pushViewController:objLogNight animated:YES];
}

- (IBAction)setReminderAction:(id)sender {
    
    NSString *xibName = [commFunc isDeviceiPhone5] ? @"AddReminderViewController" : @"AddReminderViewController";
    AddReminderViewController *objAddReminderView = [[AddReminderViewController alloc] initWithNibName:xibName bundle:nil];
    [self.navigationController pushViewController:objAddReminderView animated:YES];
}

- (IBAction)editAccountAction:(id)sender {
    
    RegisterViewController *objRegisterView = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    
    objRegisterView.objUser = _objUserDetail;
    objRegisterView.imgProfilePic = imageViewProfile.image;
    [self.navigationController pushViewController:objRegisterView animated:YES];
}

- (IBAction)logoutAction:(id)sender {
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    
//    // this button's job is to flip-flop the session from open to closed
//    if (appDelegate.session.isOpen) {
//        // if a user logs out explicitly, we delete any cached token information, and next
//        // time they run the applicaiton they will be presented with log in UX again; most
//        // users will simply close the app or switch away, without logging out; this will
//        // cause the implicit cached-token login to occur on next launch of the application
//        [appDelegate.session closeAndClearTokenInformation];
//    }
////    UIImage *profileImage = [[CommonFunctions sharedObject] imageWithName:@"placeholder"
////                                                                  andType:_pPNGType];
////    [imageViewProfile setImage:profileImage];
    
    [userDefs removeObjectForKey:_pudUserInfo];
    [userDefs removeObjectForKey:@"Password"];
    [userDefs setBool:NO forKey:_pudLoggedIn];
    [userDefs setBool:NO forKey:@"LoginWithFacebook"];
    [userDefs synchronize];
    
    loadingView = [commFunc showLoadingView];
    
    [QBUsers logOutWithDelegate:self];
}

- (IBAction)notificationsAction:(id)sender {
    [self handleRecentReminderViewForRecognizer:FALSE];
}

#pragma mark - Logout Alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 1) {
        if (buttonIndex == 1) {
            [QBUsers logOutWithDelegate:self];
        }
    }
}

#pragma mark - QB Delegate Method

-(void)completedWithResult:(Result *)result{
    // Download file result
    [commFunc hideLoadingView:loadingView];
    if ([result isKindOfClass:[QBCFileDownloadTaskResult class]]){
        [spinnerImageView stopAnimating];
        if(result.success){
            QBCFileDownloadTaskResult *res = (QBCFileDownloadTaskResult *)result;
            NSData *fileData = res.file;
            
            UIImage *imageProfile = [UIImage imageWithData:fileData];
            [imageViewProfile setImage:imageProfile];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"avatar.png"];
            [fileData writeToFile:savedImagePath atomically:NO];
            
            NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"avatar.png"];
            
            NSString *strAvatarID = [NSString stringWithFormat:@"%ld", (long)_objUserDetail.blobID];
            [userDefs setObject:strAvatarID forKey:_pudUserAvatar];
            [userDefs setObject:imagePath forKey:_pudAvatarPath];
            [userDefs synchronize];
        }
    }
    else if ([result isKindOfClass:[QBUUserLogOutResult class]]){
		QBUUserLogOutResult *res = (QBUUserLogOutResult *)result;
        
		if(res.success){
		    [self showLoginView];
		}else{
            UIAlertView *errorLogoutAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                       message:@"Cannot logout right now"
                                                                      delegate:self
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:@"Retry", nil];
            [errorLogoutAlert setTag:1];
            [errorLogoutAlert show];
            errorLogoutAlert = nil;
            NSLog(@"errors=%@", result.errors);
		}
	}
}

-(void)setProgress:(float)progress{
    NSLog(@"progress: %f", progress);
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    NotificationCell *cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSArray *arrXib = [[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:self options:nil];
        cell = [arrXib objectAtIndex:0];
    }
    return cell;
}

@end
