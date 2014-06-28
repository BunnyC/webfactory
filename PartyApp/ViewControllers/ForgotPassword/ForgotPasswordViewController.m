//
//  ForgotPasswordViewController.m
//  PartyApp
//
//  Created by Gaganinder Singh on 28/06/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController () <UITextFieldDelegate>

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
    if (validEmail)
        [QBUsers resetUserPasswordWithEmail:self.txtEmail.text delegate:self];
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
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    BOOL isiPhone5 = [[CommonFunctions sharedObject] isDeviceiPhone5];
    [scrollView setContentOffset:CGPointMake(0, isiPhone5 ? 0 : 100)];
}

#pragma mark -
#pragma mark QBActionStatusDelegate

- (void)completedWithResult:(Result *)result{
    if(result.success && [result isKindOfClass:Result.class]){
        NSLog(@"Reset password OK");
    }else{
        NSLog(@"Errors=%@", result.errors);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tap Gesture on ScrollView

- (void)resetScrollView:(UITapGestureRecognizer *)recognizer {
    [self.txtEmail resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0, 0)];
}

@end
