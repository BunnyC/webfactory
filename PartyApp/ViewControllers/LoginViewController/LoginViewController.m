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

@interface LoginViewController () <UITextFieldDelegate, UITextViewDelegate, QBActionStatusDelegate> {
    NSDictionary *dictUserFB;
}

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
    [self initDefaults];
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    if (![userDefs boolForKey:_pudLoggedIn])
        [self.navigationController setNavigationBarHidden:true animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:false animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Defaults

- (void)initDefaults {
    
    [self setupTextViewForLoginView];
    
    UITapGestureRecognizer *tapOnScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetScrollView:)];
    [tapOnScrollView setNumberOfTapsRequired:1];
    [tapOnScrollView setNumberOfTouchesRequired:1];
    [scrollView addGestureRecognizer:tapOnScrollView];
    
    UIImage *backImage = [[CommonFunctions sharedObject] imageWithName:@"viewBack"
                                                               andType:_pPNGType];
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

- (void)setupTextViewForLoginView {
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

#pragma mark - To Check if fb user exists

- (void)checkIfUserExists {
    PagedRequest *pagedRequest = [PagedRequest request];
    pagedRequest.perPage = 50;
    pagedRequest.page = 1;

    NSArray *arrEmail = [NSArray arrayWithObject:[dictUserFB objectForKey:@"email"]];
    [QBUsers usersWithEmails:arrEmail
                pagedRequest:pagedRequest
                    delegate:self];
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
        simpleLogin = true;
        loadingView = [[CommonFunctions sharedObject] showLoadingView];
        [QBUsers logInWithUserLogin:txtFieldUsername.text
                           password:txtFieldPassword.text
                           delegate:self];
        [[NSUserDefaults standardUserDefaults] setObject:txtFieldPassword.text
                                                  forKey:@"Password"];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"LoginWithFacebook"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self resetFramesForView];
}

- (IBAction)btnConnectFacebookAction:(id)sender {
    
    simpleLogin = false;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.session closeAndClearTokenInformation];
    
    
    if (appDelegate.session.state != FBSessionStateCreated)
        appDelegate.session = [[FBSession alloc] init];
    
    // if the session isn't open, let's open it now and present the login UX to the user
    [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {
        // and here we make sure to update our UX according to the new session state
        // [appDelegate getUserInformation];
        loadingView = [[CommonFunctions sharedObject] showLoadingView];
        FBRequest *me = [[FBRequest alloc] initWithSession:session
                                                 graphPath:@"me"];
        
        [me startWithCompletionHandler:^(FBRequestConnection *connection,
                                         // we expect a user as a result, and so are using FBGraphUser protocol
                                         // as our result type; in order to allow us to access first_name and
                                         // birthday with property syntax
                                         NSDictionary<FBGraphUser> *user,
                                         NSError *error) {
            
            NSLog(@"User Detail %@",user);
            dictUserFB = [[NSDictionary alloc] initWithDictionary:user];
//            [self createAccount:(NSDictionary *)user];
            [self checkIfUserExists];
            
            if (error) {
                [[CommonFunctions sharedObject] hideLoadingView:loadingView];
                
                NSString *errorMsgFB = @"Can't access your info right now.";
                UIAlertView *alertFBError = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                                       message:errorMsgFB
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil, nil];
                [alertFBError show];
                NSLog(@"Couldn't get info : %@", error.localizedDescription);
                return;
            }
        }];
    }];
}

- (void)createAccount:(NSDictionary *)dictFBUser {
    
    NSMutableArray *arrTags = [NSMutableArray arrayWithObjects:
                               @"PartyFriends", @"Party", @"Friends", @"Awesome", nil];
    
    NSString *userFBID = [dictFBUser objectForKey:@"id"];
    [[NSUserDefaults standardUserDefaults] setObject:userFBID forKey:@"Password"];
    
    QBUUser *userFB = [QBUUser user];
    userFB.login = userFBID;
    userFB.email = [dictFBUser objectForKey:@"email"];
    userFB.facebookID = userFBID;
    userFB.fullName = [dictFBUser objectForKey:@"name"];
    userFB.password = userFBID;
    userFB.website = @"http://This is Awesome";
    userFB.tags = arrTags;
    
    [QBUsers signUp:userFB delegate:self];
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

#pragma mark - QBSession Delegate Method

-(void)completedWithResult:(Result *)result {
    
    BOOL error = FALSE;
    
    if ([result isKindOfClass:[QBUUserLogInResult class]]) {
        [[CommonFunctions sharedObject] hideLoadingView:loadingView];
        if (result.success) {
            
            QBUUserLogInResult *loginResult = (QBUUserLogInResult *)result;
            QBUUser *loginInfo = [loginResult user];
            
            [[CommonFunctions sharedObject] saveInformationInDefaultsForUser:loginInfo];
            [self.navigationController popToRootViewControllerAnimated:NO];
//            [[NSUserDefaults standardUserDefaults] setBool:true forKey:_pudLoggedIn];
//            [self dismissViewControllerAnimated:true completion:nil];
        }
        else
            error = TRUE;
        
        if (error) {
            NSString *errorMsg = simpleLogin ? @"Please check your username and password" : @"Problem signing with your facebook account right now, try after sometime.";
            [[[UIAlertView alloc] initWithTitle:@"Login Problem"
                                        message:errorMsg
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        }
    }
    else if ([result isKindOfClass:[QBUUserResult class]]) {
        if (result.success) {
            //        [spinner stopAnimating];
            QBUUserResult *userResult = (QBUUserResult *)result;
            NSLog(@"userResult : %@", userResult.user);
            [[CommonFunctions sharedObject] saveInformationInDefaultsForUser:userResult.user];
            [[CommonFunctions sharedObject] hideLoadingView:loadingView];
            [self.navigationController popToRootViewControllerAnimated:NO];
//            [self createUserSession];
//            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else if ([result isKindOfClass:[QBUUserPagedResult class]]){
        if(result.success) {
            QBUUserPagedResult *usersResult = (QBUUserPagedResult *)result;
            NSArray *arrUsers = usersResult.users;
            if (arrUsers.count) {
                QBUUser *fetchedUser = (QBUUser *)[arrUsers objectAtIndex:0];
                if ([[dictUserFB objectForKey:@"id"] intValue] == fetchedUser.facebookID.intValue) {
                    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
                    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"LoginWithFacebook"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [QBUsers logInWithSocialProvider:@"facebook"
                                         accessToken:fbAccessToken
                                   accessTokenSecret:nil
                                            delegate:self];
                }
                else {
                    [[[UIAlertView alloc] initWithTitle:@"Error"
                                                message:@"The email id associated with this account is already taken."
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil, nil] show];
                }
            }
            else
                [self createAccount:dictUserFB];
        }
        else{
            NSLog(@"errors=%@", result.errors);
        }
    }
    else if ([result isKindOfClass:[QBAAuthSessionCreationResult class]]) {
        if (result.success) {
            NSLog(@"Created");
        }
        else {
            NSString *errorMessage = @"Unable to create session for user, please try after sometime";
            UIAlertView *alertSessionAlert = [[UIAlertView alloc] initWithTitle:@"Session"
                                                                        message:errorMessage
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil, nil];
            [alertSessionAlert show];
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:_pudLoggedIn];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

#pragma mark - Tap Gesture on ScrollView

- (void)resetScrollView:(UITapGestureRecognizer *)recognizer {
    [self resetFramesForView];
}

@end
