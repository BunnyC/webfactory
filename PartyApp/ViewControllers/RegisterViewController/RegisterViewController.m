//
//  RegisterViewController.m
//  PartyApp
//
//  Created by Varun on 15/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "RegisterViewController.h"
#import "UploadPhotoViewController.h"

@interface RegisterViewController () <UITextViewDelegate>

@end

@implementation RegisterViewController

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
    [self setTitle:@"Create Account"];
    [self initDefaults];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initializing Defaults

- (void)initDefaults {
    
    if (![[CommonFunctions sharedObject] isDeviceiPhone5]) {
        for (UITextField *textField in scrollView.subviews) {
            if ([textField isKindOfClass:[UITextField class]]) {
                CGRect frameTextField = [textField frame];
                frameTextField.origin.y = frameTextField.origin.y - 45;
                [textField setFrame:frameTextField];
            }
        }
    }
    
    UITapGestureRecognizer *tapOnScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetScrollView:)];
    [tapOnScrollView setNumberOfTapsRequired:1];
    [tapOnScrollView setNumberOfTouchesRequired:1];
    [scrollView addGestureRecognizer:tapOnScrollView];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonAction:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    NSString *tAndCPrivacyText = @"By Signing up you accept our Terms of Use\nand Privacy Policy";
    NSMutableAttributedString *attrTextTAndCPrivacy = [[NSMutableAttributedString alloc] initWithString:tAndCPrivacyText];
    
    //    NSDictionary *dictAttrTextForgot = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                        [UIColor yellowColor], NSForegroundColorAttributeName,
    //                                        @"forgotpassword", NSLinkAttributeName,
    //                                        [UIFont systemFontOfSize:9], NSFontAttributeName, nil];
    //
    NSDictionary *dictAttrTextSimple = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        [UIFont systemFontOfSize:9], NSFontAttributeName, nil];
    NSDictionary *dictAttrTAndC = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor yellowColor], NSForegroundColorAttributeName,
                                   @"tandc", NSLinkAttributeName,
                                   [UIFont systemFontOfSize:9], NSFontAttributeName, nil];
    NSDictionary *dictAttrPrivacy = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor yellowColor], NSForegroundColorAttributeName,
                                     @"privacy", NSLinkAttributeName,
                                     [UIFont systemFontOfSize:9], NSFontAttributeName, nil];
    
    NSRange rangeSimple1 = [tAndCPrivacyText rangeOfString:@"By Signing up you accept our"];
    NSRange rangeSimple2 = [tAndCPrivacyText rangeOfString:@"and"];
    NSRange rangeTAndC = [tAndCPrivacyText rangeOfString:@"Terms of Use"];
    NSRange rangePrivacy = [tAndCPrivacyText rangeOfString:@"Privacy Policy"];
    
    [attrTextTAndCPrivacy addAttributes:dictAttrTextSimple range:rangeSimple1];
    [attrTextTAndCPrivacy addAttributes:dictAttrTextSimple range:rangeSimple2];
    [attrTextTAndCPrivacy addAttributes:dictAttrTAndC range:rangeTAndC];
    [attrTextTAndCPrivacy addAttributes:dictAttrPrivacy range:rangePrivacy];
    [txtViewTAndC setTextColor:[UIColor whiteColor]];
    
    [txtViewTAndC setAttributedText:attrTextTAndCPrivacy];
    [txtViewTAndC setTextAlignment:NSTextAlignmentCenter];
}

#pragma mark - UITextView Delegates

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    BOOL shouldInteract = true;
    if ([URL.absoluteString isEqualToString:@"tandc"]) {
        NSLog(@"T & C");
        shouldInteract = false;
    }
    else if ([URL.absoluteString isEqualToString:@"privacy"]) {
        NSLog(@"privacy");
        shouldInteract = false;
    }
    return shouldInteract;
}

#pragma mark - Field Validations

- (BOOL)validateFields {
    BOOL validated = true;
    
    NSString *strUsername = txtFieldUsername.text;
    NSString *strEmail = txtFieldEmail.text;
    NSString *strEmailRep = txtFieldRepeatEmail.text;
    NSString *strPassword = txtFieldPassword.text;
    NSString *strPasswordRep = txtFieldRepeatPassword.text;
    NSString *strMotto = txtFieldMotto.text;
    
    NSString *errorMessage = nil;
    
    // Checking Username
    if (strUsername.length < 5 && validated) {
        errorMessage = @"Username can't be less than 5 characters.";
        validated = false;
    }
    
    // Checking Email IDs
    if (![[CommonFunctions sharedObject] validateEmailID:strEmail] && validated) {
        errorMessage = @"Email id is invalid";
        validated = false;
    }
    else {
        if (![strEmail isEqualToString:strEmailRep] && validated) {
            errorMessage = @"Email ids don't match";
            validated = false;
        }
    }
    
    // Checking Passwords
    if (strPassword.length < 6 && validated) {
        errorMessage = @"Password can't be less than 6 characters.";
        validated = false;
    }
    else {
        if (![strPassword isEqualToString:strPasswordRep] && validated) {
            errorMessage = @"Passwords entered don't match";
            validated = false;
        }
    }
    
    // Checking Moto
    if (strMotto.length < 1 && validated) {
        errorMessage = @"Motto can't be empty";
        validated = false;
    }
    
    if (!validated) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:errorMessage
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    }
    return validated;
}

#pragma mark - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    int yOffset = textField.tag < 3 ? 0 : (textField.tag - 1) * (textField.tag == 3 ? 15 : 25);
    CGPoint offsetPoint = CGPointMake(0, yOffset);
    [scrollView setContentOffset:offsetPoint];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - IBActions

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextButtonAction:(id)sender {

    if ([self validateFields]) {
        QBUUser *objCreateUser=[[QBUUser alloc]init];
        
        [objCreateUser setLogin:txtFieldUsername.text];
        [objCreateUser setEmail:txtFieldEmail.text];
        [objCreateUser setPassword:txtFieldPassword.text];
        [objCreateUser setFullName:txtFieldUsername.text]; // FullName Used for Moto
        [objCreateUser setTags:[NSMutableArray arrayWithObjects:txtFieldMotto.text, nil]];
        [QBUsers signUp:objCreateUser delegate:self];
        
        }
}

#pragma mark - QuickBox Server Response

-(void)completedWithResult:(Result *)result
{
    if([result isKindOfClass:[QBUUserResult class]]){
        
        // Success result
		if(result.success){
          
            QBASessionCreationRequest *extendedAuthRequest = [QBASessionCreationRequest request];
            extendedAuthRequest.userLogin = txtFieldUsername.text; // ID: 218651
            extendedAuthRequest.userPassword = txtFieldPassword.text;
            [QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
            // Errors
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                            message:[result.errors description]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
		}
	}
    else if(result.success && [result isKindOfClass:QBAAuthSessionCreationResult.class]){
        
        NSString *xibName = NSStringFromClass([UploadPhotoViewController class]);
        BOOL isiPhone5 = [[CommonFunctions sharedObject] isDeviceiPhone5];
        if (!isiPhone5)
            xibName = [NSString stringWithFormat:@"%@4", xibName];
        
        UploadPhotoViewController *objUploadPhotoViewController = [[UploadPhotoViewController alloc] initWithNibName:xibName bundle:nil];
        
        [self.navigationController pushViewController:objUploadPhotoViewController animated:YES];
        
        // Success, You have got User session
    }
    
}

#pragma mark - Tap Gesture on ScrollView

- (void)resetScrollView:(UITapGestureRecognizer *)recognizer {
    for (UITextField *textField in scrollView.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField resignFirstResponder];
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }
    }
}

@end
