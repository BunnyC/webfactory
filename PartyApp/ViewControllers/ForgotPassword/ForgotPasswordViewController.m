//
//  ForgotPasswordViewController.m
//  PartyApp
//
//  Created by Gaganinder Singh on 28/06/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

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
    [self.navigationController setNavigationBarHidden:true animated:true];
    [self setTitle:@"Login"];
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark- Send Email When forgot password
- (IBAction)btnForgotPasswordAction:(id)sender {
    
    [QBUsers resetUserPasswordWithEmail:@"gaganinder.singh110@gmail.com" delegate:self];
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

@end
