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
@synthesize isEditDetail;
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

    // Setting up Bar Button Items
    UIImage *imgBackButton = [[CommonFunctions sharedObject] imageWithName:@"backButton"
                                                                   andType:_pPNGType];
    UIImage *nextButtonImage = [[CommonFunctions sharedObject] imageWithName:@"nextButton"
                                                                     andType:_pPNGType];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imgBackButton style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:nextButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonAction:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    // Setting Text View to show attributed text
    NSString *tAndCPrivacyText = @"By Signing up you accept our Terms of Use\nand Privacy Policy";
    NSMutableAttributedString *attrTextTAndCPrivacy = [[NSMutableAttributedString alloc] initWithString:tAndCPrivacyText];
    
    UIFont *fontTextView = [UIFont fontWithName:@"ArialMT" size:9];
    NSDictionary *dictAttrTextSimple = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        fontTextView, NSFontAttributeName, nil];
    NSDictionary *dictAttrTAndC = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor yellowColor], NSForegroundColorAttributeName,
                                   @"tandc", NSLinkAttributeName,
                                   fontTextView, NSFontAttributeName, nil];
    NSDictionary *dictAttrPrivacy = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor yellowColor], NSForegroundColorAttributeName,
                                     @"privacy", NSLinkAttributeName,
                                     fontTextView, NSFontAttributeName, nil];
    
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
    
    [self setTextFieldBackgroundsWithTextField:nil];
    
    UIImage *backImage = [[CommonFunctions sharedObject] imageWithName:@"viewBack" andType:_pPNGType];
    UIColor *backColor = [UIColor colorWithPatternImage:backImage];
    [viewBottom setBackgroundColor:backColor];
    
    if(isEditDetail)
    {
        [self fillUserDetailForEdit];
    }
    
}


#pragma mark - Update User Detail For Edit

-(void)fillUserDetailForEdit
{
    
//    @"login",
//    @"email",
//    @"password",
//    @"custom_data"
    
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
//    NSDictionary *dicUserInfo=[userDefs objectForKey:_pUserInfoDic];
    NSDictionary *userInfo = [userDefs objectForKey:_pudUserInfo];
    
    txtFieldUsername.text=[userInfo objectForKey:@"login"];
    txtFieldEmail.text=[userInfo objectForKey:@"email"];
    txtFieldRepeatEmail.text=[userInfo objectForKey:@"email"];
    
    txtFieldPassword.text=[userDefs objectForKey:@"Password"];
    txtFieldRepeatPassword.text=[userDefs objectForKey:@"Password"];
    txtFieldMotto.text=[userInfo objectForKey:@"custom_data"];
    
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

#pragma mark - Other Methods

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
    if (strPassword.length < 8 && validated) {
        errorMessage = @"Password can't be less than 8 characters.";
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
    
    [self setTextFieldBackgroundsWithTextField:textField];
    
    int yOffset = textField.tag < 3 ? 0 : (textField.tag - 1) * (textField.tag == 3 ? 15 : 25);
    CGPoint offsetPoint = CGPointMake(0, yOffset);
    [scrollView setContentOffset:offsetPoint];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resetFramesForViews];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - IBActions

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextButtonAction:(id)sender {

    if ([self validateFields]) {
        
//        NSDictionary *dicUserDeatail = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                        txtFieldUsername.text,  @"Username",
//                                        txtFieldEmail.text,     @"Email",
//                                        txtFieldPassword.text,  @"Password",
//                                        txtFieldMotto.text,     @"Motto", nil];
        
        NSDictionary *dicUserDeatail = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        txtFieldUsername.text,  @"login",
                                        txtFieldEmail.text,     @"email",
                                        txtFieldPassword.text,  @"password",
                                        txtFieldMotto.text,     @"custom_data", nil];
        
        NSString *xibName = NSStringFromClass([UploadPhotoViewController class]);
        BOOL isiPhone5 = [[CommonFunctions sharedObject] isDeviceiPhone5];
        if (!isiPhone5)
            xibName = [NSString stringWithFormat:@"%@4", xibName];
        
        UploadPhotoViewController *objUploadPhotoViewController = [[UploadPhotoViewController alloc] initWithNibName:xibName bundle:nil];
        objUploadPhotoViewController.dicUserDetail=dicUserDeatail;
        [self.navigationController pushViewController:objUploadPhotoViewController animated:YES];
        
    }
}



#pragma mark - Tap Gesture on ScrollView

- (void)resetFramesForViews {
    [scrollView setContentOffset:CGPointMake(0, 0)];
    [self setTextFieldBackgroundsWithTextField:nil];
}

- (void)resetScrollView:(UITapGestureRecognizer *)recognizer {
    for (UITextField *textField in scrollView.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField resignFirstResponder];
            [self resetFramesForViews];
        }
    }
}

#pragma mark - UploadImage Delegate Method

-(void)clearTextBoxes
{
    txtFieldEmail.text=@"";
    txtFieldUsername.text=@"";
    txtFieldRepeatEmail.text=@"";
    txtFieldPassword.text=@"";
    txtFieldRepeatPassword.text=@"";
}
@end
