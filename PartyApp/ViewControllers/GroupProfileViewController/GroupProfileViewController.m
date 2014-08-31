//
//  GroupProfileViewController.m
//  PartyApp
//
//  Created by Gaganinder Singh on 30/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "GroupProfileViewController.h"
#import "SWRevealViewController.h"
@interface GroupProfileViewController ()
{
    CommonFunctions *commFunc;
}

@end

@implementation GroupProfileViewController

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
    [self setupNavigationBar];
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma -mark Setup NavigationBar

- (void)setupNavigationBar {
    
    commFunc=[CommonFunctions sharedObject];
    
    UIImage *imgMenuButton = [commFunc imageWithName:@"buttonMenu" andType:_pPNGType];
    UIImage *imgNotificationButton = [commFunc imageWithName:@"buttonBell" andType:_pPNGType];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    UIButton *leftBarButton = [commFunc buttonNavigationItemWithImage:imgMenuButton
                                                            forTarget:revealController
                                                          andSelector:@selector(revealToggle:)];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIButton *rightBarButton = [commFunc buttonNavigationItemWithImage:imgNotificationButton
                                                             forTarget:self
                                                           andSelector:@selector(btnBellClikced)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}


- (IBAction)btnViewGroupMember:(id)sender {
}

- (IBAction)btnSetReminderAction:(id)sender {
}

- (IBAction)btnGroupChatAction:(id)sender {
}

- (IBAction)btnLeaveGroupAction:(id)sender {
}
@end
