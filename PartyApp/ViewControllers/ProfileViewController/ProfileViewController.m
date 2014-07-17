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

@interface ProfileViewController () <QBActionStatusDelegate, UITableViewDataSource, UITableViewDelegate> {
    CommonFunctions *commFunc;
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
    [self setTitle:@"Party Friends"];
    
//    [self showSplashScreen];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:_pudLoggedIn])
        [self showLoginView];
    
    [self initDefaults];
    
    NSDictionary *userInfo=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    lblName.text=[userInfo objectForKey:@"full_name"];
    NSRange range=[[userInfo objectForKey:@"website"] rangeOfString:@"http://"];
    lblMotto.text=[[userInfo objectForKey:@"website"] substringFromIndex:range.location+range.length];
    lblActive.text=@"active";
    
    if(!objUserDetail){
        NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userObj"];
        objUserDetail = (QBUUser *)[NSKeyedUnarchiver unarchiveObjectWithData:notesData];
    }
}

-(void)viewDidAppear:(BOOL)animated {

    [self sendPageRequest];
    // [self downloadFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - QB Methods

-(void)sendPageRequest {
    
    PagedRequest *pagedRequest = [[PagedRequest alloc] init];
    [pagedRequest setPerPage:20];
    [QBContent blobsWithPagedRequest:pagedRequest delegate:self];
    [spinnerImageView setHidden:false];
    [spinnerImageView startAnimating];
}

-(void)downloadFile{
    
    int fileID = [(QBCBlob *)[[[DataManager instance] fileList] lastObject] ID];
    if(fileID > 0){
        // Download file from QuickBlox server
        [[NSUserDefaults standardUserDefaults]setInteger:fileID forKey:_pUserProfilePic];
        [QBContent TDownloadFileWithBlobID:fileID delegate:self];
    }
    else {
        [spinnerImageView stopAnimating];
        [spinnerImageView setHidden:true];
        UIImage *profileImage = [[CommonFunctions sharedObject] imageWithName:@"placeholder"
                                                                      andType:_pPNGType];
        [imageViewProfile setImage:profileImage];
        [QBAuth createSessionWithDelegate:self];
    }
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
    
    [self setupNavigationBar];
    
    UIImage *imgViewNotif = [commFunc imageWithName:@"notifTop" andType:_pPNGType];
    UIImage *imgResized = [imgViewNotif resizableImageWithCapInsets:UIEdgeInsetsMake(40, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    [imgViewBackNotif setImage:imgResized];
    
    [viewNotifications setBackgroundColor:[UIColor clearColor]];
    [self.view sendSubviewToBack:viewNotifications];
    
    [tableViewNotifications.layer setCornerRadius:2];
    [imageViewProfile.layer setCornerRadius:imageViewProfile.frame.size.width / 2];
    UIImage *profileImage = [commFunc imageWithName:@"placeholder" andType:_pPNGType];
    [imageViewProfile setImage:profileImage];
    
    if(_isComeFromSignUp) {
        if(_dicUserInfo)
            [self updateUserProfileData:_dicUserInfo];
        else
            [self updateUserInfo:objUserDetail];
    }
    
    UIPanGestureRecognizer *panViewBottom = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBottomView:)];
    [panViewBottom setMinimumNumberOfTouches:1];
    [panViewBottom setMaximumNumberOfTouches:1];
    [viewNotifications addGestureRecognizer:panViewBottom];
    
    [viewNotifications.layer setBorderColor:[UIColor whiteColor].CGColor];
    [viewNotifications.layer setBorderWidth:2];
}

- (void)showLoginView {
    
    NSString *xibName = NSStringFromClass([LoginViewController class]);
    BOOL isiPhone5 = [[CommonFunctions sharedObject] isDeviceiPhone5];
    if (!isiPhone5)
        xibName = [NSString stringWithFormat:@"%@4", xibName];
    
    LoginViewController *objLoginView = [[LoginViewController alloc] initWithNibName:xibName bundle:nil];
    objLoginView.delegate=self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginView];
    [navigationController.navigationBar setTranslucent:false];
    [self.navigationController presentViewController:navigationController animated:NO completion:nil];
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

    if(!objUserDetail)
        objUserDetail=[[QBUUser alloc]init];
    
    objUserDetail.ID=[[userInfo objectForKey:@"id"]integerValue];
    objUserDetail.fullName=[userInfo objectForKey:@"full_name"];
    objUserDetail.email=[userInfo objectForKey:@"email"];
    objUserDetail.login=[userInfo objectForKey:@"login"];
    objUserDetail.website=[userInfo objectForKey:@"website"];
}

#pragma mark loginView Delegate

-(void)updateUserInfo:(QBUUser *)objUser {
    objUserDetail=objUser;
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
    AddReminderViewController *objAddReminderView = [[AddReminderViewController alloc] initWithNibName:@"AddReminderViewController" bundle:nil];
    [self.navigationController pushViewController:objAddReminderView animated:YES];
}

- (IBAction)editAccountAction:(id)sender {
    
    RegisterViewController *objRegisterView=[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    
    objRegisterView.objUser=objUserDetail;
    objRegisterView.imgProfilePic=imageViewProfile.image;
    [self.navigationController pushViewController:objRegisterView animated:YES];
}

- (IBAction)logoutAction:(id)sender {
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
    }
    UIImage *profileImage = [[CommonFunctions sharedObject] imageWithName:@"placeholder"
                                                                  andType:_pPNGType];
    [imageViewProfile setImage:profileImage];
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setBool:false forKey:_pudLoggedIn];
    [userDefs synchronize];
    
    [self showLoginView];
}

- (IBAction)notificationsAction:(id)sender {
    [self handleRecentReminderViewForRecognizer:FALSE];
    
}

#pragma mark - QB Delegate Method

-(void)completedWithResult:(Result *)result{
    // Download file result
    if ([result isKindOfClass:QBCFileDownloadTaskResult.class]) {
        [spinnerImageView stopAnimating];
        [spinnerImageView setHidden:true];
        // Success result
        if (result.success) {
            QBCFileDownloadTaskResult *res = (QBCFileDownloadTaskResult *)result;
            if ([res file]) {
                // Add image to gallery
                [[DataManager instance] savePicture:[UIImage imageWithData:[res file]]];
                UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[res file]]];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageViewProfile.image=imageView.image;
                // [[[DataManager instance] fileList] removeLastObject];
            }
        }
    }
    else if ([result isKindOfClass:[QBCBlobPagedResult class]]){
        
        // Success result
        if(result.success){
            QBCBlobPagedResult *res = (QBCBlobPagedResult *)result;
            
            // Save user's filelist
            [DataManager instance].fileList = [res.blobs mutableCopy];
            
            NSLog(@"%@", [DataManager instance].fileList);
            [self downloadFile];
            // hid splash screen
            
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
