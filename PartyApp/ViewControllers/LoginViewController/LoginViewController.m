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

    
    [self initDefaults];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:true animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:false animated:YES];
}

- (void)didReceiveMemoryWarning
{
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
    
    //[self updateView];
    
    AppDelegate *appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                //[self updateView];
            }];
        }
    }

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
        NSMutableDictionary *dicLoginDetail=[[NSMutableDictionary alloc]init];
        [dicLoginDetail setValue:txtFieldUsername.text forKey:@"UserName"];
        [dicLoginDetail setValue:txtFieldPassword.text forKey:@"Password"];
        [txtFieldPassword resignFirstResponder];
        [txtFieldPassword resignFirstResponder];
        LoginModel *objLoginModel=[[LoginModel alloc]init];
        [objLoginModel loginWithTarget:self selector:@selector(serverResponse:) andDetail:dicLoginDetail toShowWindowLoader:YES];
        
        
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
            //[self updateView];
           // [appDelegate getUserInformation];
            
        
            ///////
            FBRequest *me = [[FBRequest alloc] initWithSession:session
                                                     graphPath:@"me"];
            [me startWithCompletionHandler:^(FBRequestConnection *connection,
                                             // we expect a user as a result, and so are using FBGraphUser protocol
                                             // as our result type; in order to allow us to access first_name and
                                             // birthday with property syntax
                                             NSDictionary<FBGraphUser> *user,
                                             NSError *error) {
                
                if (error) {
                    NSLog(@"Couldn't get info : %@", error.localizedDescription);
                    return;
                }
                ProfileViewController *objProfileView;
                for (id controller in self.navigationController
                     
                     
                     .viewControllers) {
                    
                    if([(ProfileViewController *)controller isKindOfClass:[ProfileViewController class]])
                    {
                        objProfileView=(ProfileViewController *)controller;
                        break;
                    }
                }
                
                NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
                [userDefs setBool:TRUE forKey:_pudLoggedIn];
                [userDefs synchronize];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [objProfileView updateUserProfileData:user];
                }];
            
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

#pragma mark - Other Methods

- (void)resetFramesForView {
    
    for (UITextField *textField in scrollView.subviews)
        if ([textField isKindOfClass:[UITextField class]])
            [textField resignFirstResponder];
    
    [scrollView setContentOffset:CGPointMake(0, -20)];
    [self setTextFieldBackgroundsWithTextField:nil];
}

- (void)updateView {
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
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
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Server Response

-(void)serverResponse:(Result *)userLoginResult;
{
    if (userLoginResult.success) {
        
        QBUUserLogInResult *res = (QBUUserLogInResult *)userLoginResult;
        
        NSString *moto=[res.user.fullName isKindOfClass:[NSNull class]]?@"share you moto":res.user.fullName;
        
        userInfo=[NSDictionary dictionaryWithObjectsAndKeys:res.user.fullName,@"first_name",moto,@"custom_data",res.user.email,@"email",txtFieldPassword.text,@"Password", nil];
        
        NSString *password=res.user.password;
        [[NSUserDefaults standardUserDefaults] setObject:txtFieldPassword.text forKey:@"Password"];
        
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:_pudLoggedIn];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self dismissViewControllerAnimated:true completion:^{
            if([_delegate respondsToSelector:@selector(updateUserInfo:)])
            {
                [_delegate performSelector:@selector(updateUserInfo:) withObject:userInfo];
            }
        }];
    }
    //    NSLog(@"User Detail %@", userDetail);
}

#pragma mark - Tap Gesture on ScrollView

- (void)resetScrollView:(UITapGestureRecognizer *)recognizer {
    for (UITextField *textField in scrollView.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField resignFirstResponder];
            [scrollView setContentOffset:CGPointMake(0, -20)];
            [self setTextFieldBackgroundsWithTextField:nil];
        }
    }
}


@end
