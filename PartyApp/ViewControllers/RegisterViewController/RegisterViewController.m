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
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonAction:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    NSString *tAndCPrivacyText = @"By Signing up you accept our Terms of Use and Privacy Policy";
    NSMutableAttributedString *attrTextTAndCPrivacy = [[NSMutableAttributedString alloc] initWithString:tAndCPrivacyText];
    
    NSDictionary *dictAttrTAndC = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor yellowColor], NSForegroundColorAttributeName,
                                   @"tandc", NSLinkAttributeName,
                                   [NSNumber numberWithInt:NSUnderlineStyleSingle], NSUnderlineStyleAttributeName, nil];
    NSDictionary *dictAttrPrivacy = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor yellowColor], NSForegroundColorAttributeName,
                                     @"privacy", NSLinkAttributeName,
                                     [NSNumber numberWithInt:NSUnderlineStyleSingle], NSUnderlineStyleAttributeName, nil];
    
    NSRange rangeTAndC = [tAndCPrivacyText rangeOfString:@"Terms of Use"];
    NSRange rangePrivacy = [tAndCPrivacyText rangeOfString:@"Privacy Policy"];
    [attrTextTAndCPrivacy addAttributes:dictAttrTAndC range:rangeTAndC];
    [attrTextTAndCPrivacy addAttributes:dictAttrPrivacy range:rangePrivacy];
    
    [txtViewTAndC setAttributedText:attrTextTAndCPrivacy];
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

#pragma mark - IBActions

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextButtonAction:(id)sender {
    
    QBUUser *objCreateUser=[[QBUUser alloc]init];
    
    [objCreateUser setLogin:txtFieldUsername.text];
    [objCreateUser setEmail:txtFieldEmail.text];
    [objCreateUser setPassword:txtFieldPassword.text];
    [objCreateUser setFullName:txtFieldMotto.text]; // FullName Used for Moto
//    [objCreateUser set]
//    [objCreateUser setMotto]

    [QBUsers signUp:objCreateUser delegate:self];
    
    /*
    UploadPhotoViewController *objUploadPhotoViewController = [[UploadPhotoViewController alloc] initWithNibName:@"UploadPhotoViewController" bundle:nil];
    [self.navigationController pushViewController:objUploadPhotoViewController animated:YES];
     */
}

#pragma mark - TextField Delegate Method

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - QuickBox Server Response
-(void)completedWithResult:(Result *)result
{
    if([result isKindOfClass:[QBUUserResult class]]){
        
        // Success result
		if(result.success){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration was successful. Please now sign in." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            
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
 
}

@end
