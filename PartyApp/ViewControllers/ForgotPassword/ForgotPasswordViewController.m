//
//  ForgotPasswordViewController.m
//  PartyApp
//
//  Created by Gaganinder Singh on 28/06/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController () <UITextFieldDelegate> {
    UIView *loadingView;
}

@end

@implementation ForgotPasswordViewController

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
    
    [self setTitle:@"Forgot Password"];
    [self initDefaults];
    
}

#pragma mark- Send Email When forgot password

- (IBAction)btnForgotPasswordAction:(id)sender {
    
    BOOL validEmail = [[CommonFunctions sharedObject] validateEmailID:self.txtEmail.text];
    if (validEmail) {
        loadingView = [[CommonFunctions sharedObject] showLoadingView];
        [QBUsers resetUserPasswordWithEmail:self.txtEmail.text delegate:self];
        [self resetFramesForView];
    }
    else {
        UIAlertView *newAlertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Email ID entered is not valid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [newAlertView show];
    }
}

#pragma mark - Other Methods

- (void)initDefaults {
    UITapGestureRecognizer *tapOnScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetScrollView:)];
    [tapOnScrollView setNumberOfTapsRequired:1];
    [tapOnScrollView setNumberOfTouchesRequired:1];
    [scrollView addGestureRecognizer:tapOnScrollView];
    
    UIImage *imgBackButton = [[CommonFunctions sharedObject] imageWithName:@"backButton"
                                                                   andType:_pPNGType];
    
    UIButton *leftBarButton = [[CommonFunctions sharedObject] buttonNavigationItemWithImage:imgBackButton forTarget:self andSelector:@selector(backButtonAction:)];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    [self setTextFieldBackgroundsWithTextField:nil];
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

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self setTextFieldBackgroundsWithTextField:textField];
    BOOL isiPhone5 = [[CommonFunctions sharedObject] isDeviceiPhone5];
    [scrollView setContentOffset:CGPointMake(0, isiPhone5 ? 0 : 100)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resetFramesForView];
    return true;
}

#pragma mark -
#pragma mark QBActionStatusDelegate

- (void)completedWithResult:(Result *)result{
    [[CommonFunctions sharedObject] hideLoadingView:loadingView];
    if(result.success && [result isKindOfClass:Result.class]){
        [self.txtEmail setText:@""];
        [self showMessage:_pResetPasswordMgs withTitle:@"Forgot Password"];
        NSLog(@"Reset password OK");
    }else{
        NSLog(@"Errors=%@", result.errors);
    }
}


// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tap Gesture on ScrollView

- (void)resetScrollView:(UITapGestureRecognizer *)recognizer {
    [self resetFramesForView];
}

- (void)resetFramesForView {
    [self.txtEmail resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0, 0)];
    [self setTextFieldBackgroundsWithTextField:nil];
}

@end
