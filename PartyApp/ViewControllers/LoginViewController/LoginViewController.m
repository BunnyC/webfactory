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
//        loadingView=[[CommonFunctions sharedObject]showLoadingView];
//        
//        NSMutableDictionary *dictLoginDetail=[[NSMutableDictionary alloc]init];
//        [dictLoginDetail setValue:txtFieldUsername.text forKey:@"login"];
//        [dictLoginDetail setValue:txtFieldPassword.text forKey:@"password"];
//
//        LoginModel *objLoginModel=[[LoginModel alloc]init];
//        [objLoginModel loginWithTarget:self
//                              selector:@selector(serverResponseOfLogin:)
//                             andDetail:dictLoginDetail
//                    toShowWindowLoader:true];
//        
//        [self resetFramesForView];
        
        [QBUsers logInWithUserLogin:txtFieldUsername.text password:txtFieldPassword.text delegate:self];
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
                    //[objProfileView updateUserInfo:user];
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
//    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
//    if (appDelegate.session.isOpen) {
//        // valid account UI is shown whenever the session is open
//        [self.buttonLoginLogout setTitle:@"Log out" forState:UIControlStateNormal];
//        [self.textNoteOrLink setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
//                                      appDelegate.session.accessTokenData.accessToken]];
//    } else {
//        // login-needed account UI is shown whenever the session is closed
//        [self.buttonLoginLogout setTitle:@"Log in" forState:UIControlStateNormal];
//        [self.textNoteOrLink setText:@"Login to create a link to fetch account data"];
//    }
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
        
        
//      [self createUserSession];
        
//        [[NSUserDefaults standardUserDefaults] setBool:true forKey:_pudLoggedIn];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [[NSUserDefaults standardUserDefaults] setBool:true forKey:_pudLoggedIn];
//        
//        
//        
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//          // [_delegate performSelector:@selector(updateUserInfo:) withObject:dictUserLoginResult];
//        
//        }];
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
    
//    if (userLoginResult.success) {
//        
//        QBUUserLogInResult *res = (QBUUserLogInResult *)userLoginResult;
//        
//        NSString *moto=[res.user.fullName isKindOfClass:[NSNull class]]?@"share you moto":res.user.fullName;
//        
//        userInfo=[NSDictionary dictionaryWithObjectsAndKeys:res.user.fullName,@"first_name",moto,@"custom_data",res.user.email,@"email",txtFieldPassword.text,@"Password", nil];
//        
//        NSString *password=res.user.password;
//        [[NSUserDefaults standardUserDefaults] setObject:txtFieldPassword.text forKey:@"Password"];
//    
//        
//        [[NSUserDefaults standardUserDefaults] setBool:true forKey:_pudLoggedIn];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//        [self dismissViewControllerAnimated:true completion:^{
//            if([_delegate respondsToSelector:@selector(updateUserInfo:)])
//            {
//                [_delegate performSelector:@selector(updateUserInfo:) withObject:userInfo];
//            }
//        }];
//    }
    //    NSLog(@"User Detail %@", userDetail);
}


-(void)createUserSession {

    QBASessionCreationRequest *extendedAuthRequest = [QBASessionCreationRequest request];
    extendedAuthRequest.userLogin = txtFieldUsername.text; // ID: 218651
    extendedAuthRequest.userPassword =txtFieldPassword.text;
    [QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
}

#pragma mark - QBSession Delegate Method

-(void)completedWithResult:(Result *)result
{
    [self.view endEditing:YES];

    [loadingView removeFromSuperview];
    if (result.success) {
    
            QBUUserLogInResult *res = (QBUUserLogInResult *)result;
    
            NSLog(@"%@", res.user);
         [self updateUserInfo:res.user];
         [self dismissViewControllerAnimated:true completion:^{
            if([_delegate respondsToSelector:@selector(updateUserInfo:)])
            {
                [_delegate performSelector:@selector(updateUserInfo:) withObject:res.user];
            }
        }];
    }
    else {
        
        //[scrollView setContentOffset:CGPointMake(0, 0)];

        txtFieldUsername.text=@"";
        txtFieldPassword.text=@"";
         [self resetFramesForView];
        UIImage *unselImage =[[CommonFunctions sharedObject]imageWithName:@"txtFldW" andType:_pPNGType];
        [txtFieldUsername setBackground:unselImage];
        [txtFieldPassword setBackground:unselImage];
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:_pErrInvalidUserNameAndPassword
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
        [errorAlert show];
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
