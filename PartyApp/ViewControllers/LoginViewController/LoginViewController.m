//
//  LoginViewController.m
//  PartyApp
//
//  Created by Varun on 14/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "LoginModel.h"
#import "AppDelegate.h"
#import "ForgotPasswordViewController.h"
#import "ProfileViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SignUpModel.h"
#import "SplashScreenViewController.h"

@interface LoginViewController () <UITextFieldDelegate, UITextViewDelegate, QBActionStatusDelegate>

@end

@implementation LoginViewController

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
    [self.navigationController setNavigationBarHidden:true animated:true];
    [self setTitle:@"Login"];
    
    [self showSplashScreen];
    [self initDefaults];
}

- (void)showSplashScreen {
    SplashScreenViewController *splashView = [[SplashScreenViewController alloc] initWithNibName:@"SplashScreenViewController" bundle:nil];
    [self.navigationController presentViewController:splashView animated:false completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:true animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:false animated:YES];
}

-(void)dealloc {
    _delegate=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Defaults

- (void)initDefaults {
    
    UITapGestureRecognizer *tapOnScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetScrollView:)];
    [tapOnScrollView setNumberOfTapsRequired:1];
    [tapOnScrollView setNumberOfTouchesRequired:1];
    [scrollView addGestureRecognizer:tapOnScrollView];
    
    NSString *forgotPasswordText = @"Forgot Password? Click HERE";
    NSMutableAttributedString *attrTextForgotLabel = [[NSMutableAttributedString alloc] initWithString:forgotPasswordText];
    
    UIFont *fontTextView = [UIFont fontWithName:@"ArialMT" size:9];
    
    NSDictionary *dictAttrTextForgot = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor yellowColor], NSForegroundColorAttributeName,
                                        @"forgotpassword", NSLinkAttributeName,
                                        fontTextView, NSFontAttributeName, nil];
    
    NSDictionary *dictAttrTextSimple = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        fontTextView, NSFontAttributeName, nil];
    
    NSRange rangeClickHere = [forgotPasswordText rangeOfString:@"Click HERE"];
    NSRange rangeForgotPass = [forgotPasswordText rangeOfString:@"Forgot Password?"];
    [attrTextForgotLabel addAttributes:dictAttrTextForgot range:rangeClickHere];
    [attrTextForgotLabel addAttributes:dictAttrTextSimple range:rangeForgotPass];
    
    [txtViewForgotPassword setAttributedText:attrTextForgotLabel];
    [txtViewForgotPassword setTextAlignment:NSTextAlignmentCenter];
    
    [self setTextFieldBackgroundsWithTextField:nil];
    
    UIImage *backImage = [[CommonFunctions sharedObject] imageWithName:@"viewBack" andType:_pPNGType];
    UIColor *backColor = [UIColor colorWithPatternImage:backImage];
    [viewBottom setBackgroundColor:backColor];
    
    AppDelegate *appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] initWithPermissions:[NSArray arrayWithObjects:@"email", nil]];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
            }];
        }
    }
    
}

#pragma mark - Other Methods

- (NSString *)checkLoginFields {
    NSString *errorString = nil;
    if (txtFieldUsername.text.length < 5)
        errorString = @"Please enter username with atleast 5 characters";
    if (txtFieldPassword.text.length < 8) {
        if (errorString.length)
            errorString = [[[errorString stringByReplacingOccurrencesOfString:@"username" withString:@"username, password"] stringByReplacingOccurrencesOfString:@"characters" withString:@"characters respectively"] stringByReplacingOccurrencesOfString:@"5" withString:@"5 and 6"];
        else
            errorString=_pErrUserNameAndPasswordRequired;
    }
    return errorString;
}

- (void)setTextFieldBackgroundsWithTextField:(UITextField *)textField {
    UIImage *selImage = [[CommonFunctions sharedObject] imageWithName:@"txtFldY"
                                                              andType:_pPNGType];
    UIImage *unselImage = [[CommonFunctions sharedObject] imageWithName:@"txtFldW"
                                                                andType:_pPNGType];
    
    for (UITextField *textFs in scrollView.subviews) {
        if ([textFs isKindOfClass:[UITextField class]]) {
            if (textFs != textField)
                [textFs setBackground:unselImage];
            else
                [textField setBackground:selImage];
        }
    }
}

#pragma mark - IBActions

- (IBAction)btnCreateAccountAction:(id)sender {
    
    RegisterViewController *objRegisterViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    
    [self.navigationController pushViewController:objRegisterViewController animated:YES];
}

- (IBAction)btnSignInAction:(id)sender {
    
    NSString *errorMessage = [self checkLoginFields];
    if (errorMessage) {
        [[[UIAlertView alloc] initWithTitle:@"Login Credentials"
                                    message:errorMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    }
    else {
        [QBUsers logInWithUserLogin:txtFieldUsername.text
                           password:txtFieldPassword.text
                           delegate:self];
    }
}

- (IBAction)btnConnectFacebookAction:(id)sender {
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.session closeAndClearTokenInformation];
    
    
    if (appDelegate.session.state != FBSessionStateCreated) {
        // Create a new, logged out session.
        appDelegate.session = [[FBSession alloc] init];
    }
    
    // if the session isn't open, let's open it now and present the login UX to the user
    [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {
        // and here we make sure to update our UX according to the new session state
        // [appDelegate getUserInformation];
        FBRequest *me = [[FBRequest alloc] initWithSession:session
                                                 graphPath:@"me"];
        
        
        [me startWithCompletionHandler:^(FBRequestConnection *connection,
                                         // we expect a user as a result, and so are using FBGraphUser protocol
                                         // as our result type; in order to allow us to access first_name and
                                         // birthday with property syntax
                                         NSDictionary<FBGraphUser> *user,
                                         NSError *error) {
            
            
            NSLog(@"User Detail %@",user);
            
            [self createAccount:(NSDictionary *)user];
            
            if (error) {
                NSLog(@"Couldn't get info : %@", error.localizedDescription);
                return;
            }
            //                ProfileViewController *objProfileView;
            //                for (id controller in self.navigationController
            //
            //
            //                     .viewControllers) {
            //
            //                    if([(ProfileViewController *)controller isKindOfClass:[ProfileViewController class]])
            //                    {
            //                        objProfileView=(ProfileViewController *)controller;
            //                        break;
            //                    }
            //                }
            //
            //                NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
            //                [userDefs setBool:TRUE forKey:_pudLoggedIn];
            //                [userDefs synchronize];
            //                [self.navigationController dismissViewControllerAnimated:YES completion:^{
            //                    //[objProfileView updateUserInfo:user];
            //                }];
            
        }];            ///////
    }];
    
    
    
    /*
     // If the session state is any of the two "open" states when the button is clicked
     if (FBSession.activeSession.state == FBSessionStateOpen
     || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
     
     // Close the session and remove the access token from the cache
     // The session state handler (in the app delegate) will be called automatically
     [FBSession.activeSession closeAndClearTokenInformation];
     
     // If the session state is not any of the two "open" states when the button is clicked
     } else {
     // Open a session showing the user the login UI
     // You must ALWAYS ask for public_profile permissions when opening a session
     [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
     allowLoginUI:YES
     completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
     
     // Retrieve the app delegate
     AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
     // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
     [appDelegate sessionStateChanged:session state:state error:error];
     }];
     }
     */
    
}

- (void)createAccount:(NSDictionary *)dic {
    loadingView = [[CommonFunctions sharedObject] showLoadingView];
    
    NSString *password = @"123456789";
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"Password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *fullName=[NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"name"],[dic objectForKey:@"last_name"]];
    NSDictionary *dictUser = [[NSDictionary alloc ]initWithObjectsAndKeys:[dic objectForKey:@"name"],@"login",fullName,@"full_name",[dic objectForKey:@"email"],@"email",password,@"password",@"Your moto has not set.",@"website",[dic objectForKey:@"id"],@"id",nil];
    //    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    //
    //    [dic setObject:_objUser.login forKey:@"login"];
    //    [dic setObject:_objUser.fullName forKey:@"full_name"];
    //    [dic setObject:_objUser.email forKey:@"email"];
    //    [dic setObject:_objUser.password forKey:@"password"];
    
    userInfo=dictUser;
    dictUser=[NSDictionary dictionaryWithObject:dictUser forKey:@"user"];
    
    
    SignUpModel *objSignUpModel = [[SignUpModel alloc] init];
    [objSignUpModel checkUserWithFacebook:self
                             withselector:@selector(serverRespnse:)
                               andDetails:dictUser
                       toShowWindowLoader:NO];
    
}

- (void)serverRespnse:(Result *)response {
    QBUUserLogInResult *res = (QBUUserLogInResult *)response;
    if(!res.user)
    {
        QBUUser *user=[[QBUUser alloc]init];
        user.login=@"test851";//[userInfo objectForKey:@"login"];
        user.fullName=[userInfo objectForKey:@"full_name"];
        user.email=@"test851@gmail.com";[userInfo objectForKey:@"email"];
        user.password=[userInfo objectForKey:@"password"];
        user.website=[userInfo objectForKey:@"website"];
        user.facebookID=[userInfo objectForKey:@"id"];
        
        [QBUsers signUp:user delegate:self];
        
        
    }
    else
    {
        [[CommonFunctions sharedObject] hideLoadingView:loadingView];
        
        NSLog(@"%@", res.user);
        [self updateUserInfo:res.user];
        [self dismissViewControllerAnimated:true completion:^{
            if([_delegate respondsToSelector:@selector(updateUserInfo:)])
            {
                [_delegate performSelector:@selector(updateUserInfo:) withObject:res.user];
            }
        }];
    }
    
}

#pragma mark - Other Methods

- (void)resetFramesForView {
    
    for (UITextField *textField in scrollView.subviews)
        if ([textField isKindOfClass:[UITextField class]])
            [textField resignFirstResponder];
    
    [scrollView setContentOffset:CGPointMake(0, -20)];
    [self setTextFieldBackgroundsWithTextField:nil];
}

#pragma mark - TextField Delegate Method

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // -20 is used due to status bar settings in iOS 7
    
    [self setTextFieldBackgroundsWithTextField:textField];
    if (scrollView.contentOffset.y == -20) {
        
        BOOL isiPhone5 = [[CommonFunctions sharedObject] isDeviceiPhone5];
        
        CGPoint offsetPoint = CGPointMake(0, txtFieldUsername.frame.origin.y / 4 - (isiPhone5 ? 25 : -20));
        [scrollView setContentOffset:offsetPoint];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //    [textField resignFirstResponder];
    [self resetFramesForView];
    return YES;
}

#pragma mark - TextView Delegates

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    BOOL shouldInteract = true;
    if ([URL.absoluteString isEqualToString:@"forgotpassword"]) {
        NSLog(@"Forgot Password");
        shouldInteract = false;
        ForgotPasswordViewController *forgotPasswordView=[[ForgotPasswordViewController alloc]initWithNibName:@"ForgotPasswordViewController" bundle:nil];
        [self.navigationController pushViewController:forgotPasswordView animated:YES];
    }
    return shouldInteract;
}

#pragma mark - Server Response

-(void)serverResponseOfLogin:(NSDictionary *)dictUserLoginResult;
{
    
    if (![dictUserLoginResult objectForKey:@"errors"]) {
        
        NSLog(@"user dic %@",dictUserLoginResult);
        
        NSString *login=[[dictUserLoginResult objectForKey:@"login"]isKindOfClass:[NSNull class]]?@"":[dictUserLoginResult objectForKey:@"login"];
        
        NSString *password=txtFieldPassword.text;
        
        NSString *email=[[dictUserLoginResult objectForKey:@"email"]isKindOfClass:[NSNull class]]?@"":[dictUserLoginResult objectForKey:@"email"];
        
        NSString *blog_id=[[dictUserLoginResult objectForKey:@"blob_id"]isKindOfClass:[NSNull class]]?@"":[dictUserLoginResult objectForKey:@"blob_id"];
        
        NSString *externalId=[[dictUserLoginResult objectForKey:@"external_user_id"]isKindOfClass:[NSNull class]]?@"":[dictUserLoginResult objectForKey:@"external_user_id"];
        
        NSString *facebook_id=[[dictUserLoginResult objectForKey:@"facebook_id"]isKindOfClass:[NSNull class]]?@"":[dictUserLoginResult objectForKey:@"facebook_id"];
        
        NSString *twitter_id=[[dictUserLoginResult objectForKey:@"twitter_id"]isKindOfClass:[NSNull class]]?@"":[dictUserLoginResult objectForKey:@"twitter_id"];
        
        NSString *full_name=[[dictUserLoginResult objectForKey:@"full_name"]isKindOfClass:[NSNull class]]?@"":[dictUserLoginResult objectForKey:@"full_name"];
        
        
        NSString *phone=[[dictUserLoginResult objectForKey:@"phone"]isKindOfClass:[NSNull class]]?@"":[dictUserLoginResult objectForKey:@"phone"];
        
        NSString *website=[[dictUserLoginResult objectForKey:@"website"]isKindOfClass:[NSNull class]]?@"":[dictUserLoginResult objectForKey:@"website"];
        
        NSString *customdata=[[dictUserLoginResult objectForKey:@"custom_data"]isKindOfClass:[NSNull class]]?@"":[dictUserLoginResult objectForKey:@"custom_data"];
        
        NSString *tag=[[dictUserLoginResult objectForKey:@"user_tags"]isKindOfClass:[NSNull class]]?@"":[dictUserLoginResult objectForKey:@"user_tags"];
        
        NSDictionary *detail=[[NSDictionary alloc]initWithObjectsAndKeys:login,@"login",password,@"password",email,@"email",blog_id,@"blog_id",externalId,@"external_user_id",facebook_id,@"facebook_id",twitter_id,@"twitter_id",full_name,@"full_name",phone,@"phone",website,@"website",customdata,@"custom_data",tag,@"user_tags", nil];
        
        
        NSDictionary *dictUser=[NSDictionary dictionaryWithObject:detail forKey:@"user"];
        
        SignUpModel *objSignUpModel = [[SignUpModel alloc] init];
        [objSignUpModel UpdateUserWithTarget:self
                                withselector:@selector(serverResponseOfLogin:)
                                  andDetails:dictUser
                          toShowWindowLoader:NO User_id:[dictUserLoginResult objectForKey:@"id"]];
    }
    else {
        NSArray *arrErrors = [dictUserLoginResult objectForKey:@"errors"];
        NSString *strErrors = [arrErrors componentsJoinedByString:@", "];
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:strErrors
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
        [errorAlert show];
    }
    
    NSLog(@"Result : %@", dictUserLoginResult);
}

#pragma mark - QBSession Delegate Method

-(void)completedWithResult:(Result *)result {
    
    BOOL error = FALSE;
    [loadingView removeFromSuperview];
    
    if ([result isKindOfClass:[QBUUserLogInResult class]]) {
        if (result.success) {
            
            NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
            
            QBUUserLogInResult *loginResult = (QBUUserLogInResult *)result;
            QBUUser *loginInfo = [loginResult user];
            
            id null = (id)[NSNull null];
            
            NSNumber *userID = [NSNumber numberWithInt:loginInfo.ID];
            NSNumber *extID = [NSNumber numberWithInt:loginInfo.externalUserID];
            NSNumber *blobID = [NSNumber numberWithInt:loginInfo.blobID];
            NSString *fID = !loginInfo.facebookID ? @"" : loginInfo.facebookID;
            NSString *tID = !loginInfo.twitterID ? @"" : loginInfo.twitterID;
            NSString *fullName = (loginInfo.fullName == null) ? @"" : loginInfo.fullName;
            NSString *email = (loginInfo.email == null) ? @"" : loginInfo.email;
            NSString *phone = !loginInfo.phone ? @"" : loginInfo.phone;
            NSString *website = (loginInfo.website == null) ? @"" : loginInfo.website;
            
            NSMutableDictionary *dictUserInfo = [[NSMutableDictionary alloc] init];
            [dictUserInfo setObject:userID              forKey:@"ID"];
            [dictUserInfo setObject:loginInfo.createdAt forKey:@"createdAt"];
            [dictUserInfo setObject:loginInfo.updatedAt forKey:@"updatedAt"];
            [dictUserInfo setObject:extID               forKey:@"externalUserID"];
            [dictUserInfo setObject:blobID              forKey:@"blobID"];
            [dictUserInfo setObject:loginInfo.login     forKey:@"login"];
            [dictUserInfo setObject:fullName            forKey:@"fullName"];
            [dictUserInfo setObject:website             forKey:@"website"];
            [dictUserInfo setObject:phone               forKey:@"phone"];
            [dictUserInfo setObject:fID                 forKey:@"facebookID"];
            [dictUserInfo setObject:tID                 forKey:@"twitterID"];
            [dictUserInfo setObject:email               forKey:@"email"];
            [dictUserInfo setObject:[NSArray array]     forKey:@"tags"];
            
            NSLog(@"Model Info : %@", loginInfo);
            NSLog(@"User Info : %@", dictUserInfo);
            [userDefs setObject:dictUserInfo forKey:@"userInfo"];
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else {
            error = TRUE;
        }
        
        if (error)
            [[[UIAlertView alloc] initWithTitle:@"Session Problem"
                                        message:@"Sorry can't create your session right now"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma -mark store User Dictionary;
-(void)updateUserInfo:(QBUUser *)user
{
    NSMutableDictionary *userDetail=[[NSMutableDictionary alloc]init];
    [userDetail setValue:user.login forKey:@"login"];
    [userDetail setValue:user.email forKey:@"email"];
    [userDetail setValue:user.fullName forKey:@"full_name"];
    [userDetail setValue:user.website forKey:@"website"];
    
    //    NSString *fbID=[user.facebookID isKindOfClass:[NSNull class]]?@"":user.facebookID;
    //    NSString *twID=[user.twitterID isKindOfClass:[NSNull class]]?@"":user.twitterID;
    //    NSString *phID=[user.phone isKindOfClass:[NSNull class]]?@"":user.phone;
    //    NSString *pwdID=[user.password isKindOfClass:[NSNull class]]?@"":user.password;
    //    NSString *oldPwdID=[user.oldPassword isKindOfClass:[NSNull class]]?@"":user.oldPassword;
    //
    //    [userDetail setValue:fbID forKey:@"facebookID"];
    //    [userDetail setValue:twID forKey:@"twitterID"];
    //    [userDetail setValue:phID forKey:@"phone"];
    //    [userDetail setValue:pwdID forKey:@"password"];
    //    [userDetail setValue:oldPwdID forKey:@"oldPassword"];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userObj"];
    
    [[NSUserDefaults standardUserDefaults]setObject:userDetail forKey:@"userDetail"];
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:txtFieldPassword.text forKey:@"Password"];
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:_pudLoggedIn];
    
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - Tap Gesture on ScrollView

- (void)resetScrollView:(UITapGestureRecognizer *)recognizer {
    
    [self resetFramesForView];
}

@end
