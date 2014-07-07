//
//  AddReminderViewController.m
//  PartyApp
//
//  Created by Varun on 7/07/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "AddReminderViewController.h"

@interface AddReminderViewController () {
    int selectedOption;
}

@end

@implementation AddReminderViewController

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
    [self initDefaults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Init Defaults

- (void)initDefaults {
    selectedOption = 0;
    
    // Setting up Bar Button Items
    UIImage *imgMenuButton = [[CommonFunctions sharedObject] imageWithName:@"backButton"
                                                                   andType:_pPNGType];
    UIImage *imgNotificationButton = [[CommonFunctions sharedObject] imageWithName:@"barButtonTick"
                                                                           andType:_pPNGType];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imgMenuButton style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imgNotificationButton style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

#pragma mark - IBAction for Options

- (IBAction)optionsButtonTouched:(id)sender {
    
    int tagButton = [sender tag];
    
    UIButton *selectedButton = (UIButton *)sender;
    [selectedButton setSelected:true];
    
    if (selectedOption) {
        UIButton *oldSelectedButton = (UIButton *)[viewOptions viewWithTag:selectedOption];
        [oldSelectedButton setSelected:false];
    }
    
    selectedOption = tagButton;
}

@end
