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

@interface ProfileViewController () <QBActionStatusDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation ProfileViewController
@synthesize objUserDetail;
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
   
    // Do any additional setup after loading the view from its nib.
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:_pudLoggedIn]) {
        [self showLoginView];
    }
    else {
        [self showSplashScreen];
    }
       [self initDefaults];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSDictionary *userInfo=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    lblName.text=[userInfo objectForKey:@"full_name"];
    NSRange range=[[userInfo objectForKey:@"website"] rangeOfString:@"http://"];
    lblMotto.text=[[userInfo objectForKey:@"website"] substringFromIndex:range.location+range.length];
    lblActive.text=@"active";
    
    if(!objUserDetail)
    {
        NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userObj"];
        objUserDetail = (QBUUser *)[NSKeyedUnarchiver unarchiveObjectWithData:notesData];
    }
    
    
    
    //    if([[NSUserDefaults standardUserDefaults]objectForKey:_pUserInfoDic])
    //    {
    //        NSDictionary *userInfo=[[NSUserDefaults standardUserDefaults]objectForKey:_pUserInfoDic];
    //        [self updateUserInfo:userInfo];
    //    }
    
   // NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
   // NSDictionary *userInfo = [userDefs objectForKey:_pudUserInfo];
    //[lblName setText:[userInfo objectForKey:@"username"]];
    //[lblMotto setText:[userInfo objectForKey:@"custom_object"]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self sendPageRequest];
    // [self downloadFile];
}


-(void)sendPageRequest
{
    PagedRequest *pagedRequest = [[PagedRequest alloc] init];
    [pagedRequest setPerPage:20];
    [QBContent blobsWithPagedRequest:pagedRequest delegate:self];
    
}
-(void)downloadFile{
    
    int fileID = [(QBCBlob *)[[[DataManager instance] fileList] lastObject] ID];
    
    if(fileID > 0){
        
        // Download file from QuickBlox server
        [[NSUserDefaults standardUserDefaults]setInteger:fileID forKey:_pUserProfilePic];
        [QBContent TDownloadFileWithBlobID:fileID delegate:self];
    }
    else
    {
        UIImage *profileImage = [[CommonFunctions sharedObject] imageWithName:@"placeholder"
                                                                      andType:_pPNGType];
        [imageViewProfile setImage:profileImage];
        [QBAuth createSessionWithDelegate:self];
    }
}

- (void)initDefaults {
    
    // Setting up Bar Button Items
    UIImage *imgMenuButton = [[CommonFunctions sharedObject] imageWithName:@"buttonMenu"
                                                                   andType:_pPNGType];
    UIImage *imgNotificationButton = [[CommonFunctions sharedObject] imageWithName:@"buttonBell"
                                                                           andType:_pPNGType];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imgMenuButton style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imgNotificationButton style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    UIImage *imgViewNotif = [[CommonFunctions sharedObject] imageWithName:@"notifTop"
                                                                  andType:_pPNGType];
    UIImage *imgResized = [imgViewNotif resizableImageWithCapInsets:UIEdgeInsetsMake(40, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    [imgViewBackNotif setImage:imgResized];
    
    [viewNotifications setBackgroundColor:[UIColor clearColor]];
    [self.view sendSubviewToBack:viewNotifications];
    
    [tableViewNotifications.layer setCornerRadius:2];
    [imageViewProfile.layer setCornerRadius:imageViewProfile.frame.size.width / 2];
    UIImage *profileImage = [[CommonFunctions sharedObject] imageWithName:@"placeholder"
                                                                  andType:_pPNGType];
    [imageViewProfile setImage:profileImage];
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [viewNotifications addGestureRecognizer:panGesture];
    
    

    if(_isComeFromSignUp)
    {
        if(_dicUserInfo)
        [self updateUserProfileData:_dicUserInfo];
        else
        [self updateUserInfo:objUserDetail];
    }
   
//    UISwipeGestureRecognizer *swipeUp=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipPanGestureHandler:)];
//    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
//    [viewNotifications addGestureRecognizer:swipeUp];
//    
//    UISwipeGestureRecognizer *swipeDown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipPanGestureHandler:)];
//    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
//    [viewNotifications addGestureRecognizer:swipeDown];
    
}

#pragma mark - Update UserInformation
-(void)updateUserProfileData:(NSDictionary *)userInfo
{

   // lblName.text=name;
   
   // lblMotto.text=moto;
    if(!objUserDetail)
    {
        objUserDetail=[[QBUUser alloc]init];
    }
    objUserDetail.ID=[[userInfo objectForKey:@"id"]integerValue];
    objUserDetail.fullName=[userInfo objectForKey:@"full_name"];
    objUserDetail.email=[userInfo objectForKey:@"email"];
    objUserDetail.login=[userInfo objectForKey:@"login"];
    objUserDetail.website=[userInfo objectForKey:@"website"];
}


#pragma mark loginView Delegate

-(void)updateUserInfo:(QBUUser *)objUser
{
    objUserDetail=objUser;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    
}

//- (void)swipPanGestureHandler:(UIGestureRecognizer *)recognizer
//{
//    [self handleRecentReminderView];
//}
//
//-(void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
//{
//    
//    CGPoint translation = [recognizer translationInView:self.view];
//    
//    int translationValue=(int
//                          )(recognizer.view.center.y + translation.y);
//    
//    if(translationValue>btnLogNight.frame.origin.y+btnLogNight.frame.size.height && translationValue<self.view.frame.size.height-20+recognizer.view.frame.size.height/4)
//    {
//        
//        
//        recognizer.view.center = CGPointMake(recognizer.view.center.x,
//                                             recognizer.view.center.y + translation.y);
//        
//        
//        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
//        
//        
//    }
//    
//    
//    if (recognizer.state == UIGestureRecognizerStateEnded) {
//        
//        CGPoint velocity = [recognizer velocityInView:self.view];
//        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
//        CGFloat slideMult = magnitude / 200;
//        
//        
//        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
//        
//        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
//        
//        CGPoint finalPoint = CGPointMake(recognizer.view.center.x,
//                                         recognizer.view.center.y + (velocity.y * slideFactor));
//        
//        finalPoint.y = MIN(MAX(finalPoint.y, btnLogNight.frame.origin.y+btnLogNight.frame.size.height), (self.view.bounds.size.height-25)+recognizer.view.frame.size.height/4);
//        
//        NSLog(@"%f",finalPoint.y);
//        
//        
//        [UIView animateWithDuration:slideFactor/2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            
//            
//            recognizer.view.center = finalPoint;
//            
//            
//        } completion:nil];
//        
//    }
//    
//}

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
    objLoginView.delegate=self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginView];
    [navigationController.navigationBar setTranslucent:false];
    [self presentViewController:navigationController animated:NO completion:nil];
}

#pragma mark - Show Splash Screen

- (void)showSplashScreen {
    SplashScreenViewController *splashView = [[SplashScreenViewController alloc] initWithNibName:@"SplashScreenViewController"
                                                                                          bundle:nil];
    [self.navigationController presentViewController:splashView animated:false completion:nil];
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
    [self handleRecentReminderView];
    
}

-(void)completedWithResult:(Result *)result{
    // Download file result
    if ([result isKindOfClass:QBCFileDownloadTaskResult.class]) {
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

-(void)handleRecentReminderView
{
    CGRect frameView = self.view.frame;
    CGRect newFrameForNotifView = viewNotifications.frame;
    CGRect frameTable = tableViewNotifications.frame;
    frameTable.origin.y = 52;
    
    int offsetAsPer3Rows = (65 * 3) + 14;
    
    if (newFrameForNotifView.origin.y >= frameView.size.height - 52) {
        newFrameForNotifView.origin.y = newFrameForNotifView.origin.y - offsetAsPer3Rows;
        newFrameForNotifView.size.height = newFrameForNotifView.size.height + offsetAsPer3Rows;
        frameTable.size.height = 65 * 3;
        [self.view bringSubviewToFront:viewNotifications];
    }
    else {
        [self.view sendSubviewToBack:viewNotifications];
        newFrameForNotifView.origin.y = self.view.frame.size.height - 52;
        newFrameForNotifView.size.height = 52;
        frameTable.size.height = 0;
        
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
