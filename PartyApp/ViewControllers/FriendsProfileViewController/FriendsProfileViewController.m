//
//  FriendsProfileViewController.m
//  PartyApp
//
//  Created by Gaganinder Singh on 20/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "FriendsProfileViewController.h"
#import "SWRevealViewController.h"
#import "AddReminderViewController.h"
#import "AddToGroupViewController.h"


@interface FriendsProfileViewController ()
{
    CommonFunctions *commFunc;
}
@end

@implementation FriendsProfileViewController

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
    [self setup];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    
    commFunc = [CommonFunctions sharedObject];
    self.navigationItem.title=@"Friends Profile";
    lbl_FrName.text=_qbuser.login;
    lbl_Status.text=@"Active";
    if(_isAlreadyFriend)
    {
        [btnAddFriendsANDSetReminder
         setBackgroundImage:[UIImage imageNamed:@"whiteButton.png"] forState:UIControlStateNormal];
        [btnAddFriendsANDSetReminder setTitle:@"Set Reminder" forState:UIControlStateNormal];
        [btnAddFriendsANDSetReminder setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    }
    imgVwFriendProfilePic.layer.cornerRadius=imgVwFriendProfilePic.frame.size.width/2;
    
    NSString *mottoText = @"This app is awesome";
    if ([_qbuser.website length]) {
        NSRange range = [_qbuser.website rangeOfString:@"http://"];
        mottoText = [_qbuser.website substringFromIndex:range.location+range.length];
    }
    lbl_FrMoto.text=mottoText;
    activityIndicator.hidden=NO;
    [activityIndicator startAnimating];
     [QBContent TDownloadFileWithBlobID:_qbuser.blobID delegate:self];

}


- (IBAction)addFriendsViewController:(id)sender {
    
    if(_isAlreadyFriend)
    {
        AddReminderViewController *objAddReminder;
        if([commFunc isDeviceiPhone5])
        {
            objAddReminder =[[AddReminderViewController alloc]initWithNibName:@"AddReminderViewController" bundle:nil];
        }
        else
        {
            objAddReminder =[[AddReminderViewController alloc]initWithNibName:@"AddReminderViewController4" bundle:nil];
        }
            
        [self.navigationController pushViewController:objAddReminder animated:YES];
    }
    else
    {
      [self.view addSubview:addFriendCustomPopUp];
    }
    
}

- (IBAction)addFriendsCustomPopUpClicked:(id)sender {
    if([sender tag]==0)
    {
        [addFriendCustomPopUp removeFromSuperview];
    }
    else
    {
        
        QBUUser *objUser=[commFunc getQBUserObjectFromUserDefaults];
        QBCOCustomObject *objectLogNight = [QBCOCustomObject customObject];
        [objectLogNight setClassName:@"PAFriendListClass"];
        
        [objectLogNight.fields setObject:_qbuser.login
                                  forKey:@"FR_Name"];
        [objectLogNight.fields setObject:_qbuser.email
         
                                  forKey:@"FR_EMAIL"];
        [objectLogNight.fields setObject:_qbuser.website
                                  forKey:@"FR_MOTO"];
        [objectLogNight.fields setObject:[NSString stringWithFormat:@"%lu",_qbuser.ID]
         
                                  forKey:@"Fr_ID"];
        
        [objectLogNight.fields setObject:[NSString stringWithFormat:@"%lu",_qbuser.blobID]
                                  forKey:@"FR_BlobID"];
        
        [objectLogNight.fields setObject:[NSString stringWithFormat:@"%lu",objUser.ID]
                                  forKey:@"FR_WithUser_ID"];
        [QBCustomObjects createObject:objectLogNight delegate:self];
        
       
    }
}

- (IBAction)btnMessageAction:(id)sender {
    
    [commFunc showUnderDevelopmentAlert];
   }

- (IBAction)btnAddToGroupAction:(id)sender {
    
    //[commFunc showUnderDevelopmentAlert];
    AddToGroupViewController *obj=[[AddToGroupViewController alloc]initWithNibName:@"AddToGroupViewController" bundle:nil];
    obj.objUser=_qbuser;
    obj.isShowNavigationBarButton=NO;
    [self.navigationController pushViewController:obj animated:YES];

}

#pragma mark - FriendsViewController Delegate
-(void)loadFriends
{
    for (UIViewController *obj in self.navigationController.viewControllers) {
        if([(FriendsViewController *)obj isKindOfClass:[FriendsViewController class]])
        {
            [(FriendsViewController *)obj loadFriends];
        }
    }
    
}

-(void)completedWithResult:(Result *)result{
    // Download file result
    
    if ([result isKindOfClass:[QBCFileDownloadTaskResult class]]){
        
        if(result.success){
            QBCFileDownloadTaskResult *res = (QBCFileDownloadTaskResult *)result;
            NSData *fileData = res.file;
            
            UIImage *imageProfile = [UIImage imageWithData:fileData];
            [imgVwFriendProfilePic setImage:imageProfile];
            
            activityIndicator.hidden=YES;
            [activityIndicator stopAnimating];
            
            
        }
    }
    else if([result isKindOfClass:[QBCOCustomObjectResult class]])
    {
         if(result.success)
         {
            [addFriendCustomPopUp removeFromSuperview];
             
             _isAlreadyFriend=true;
            [btnAddFriendsANDSetReminder
                  setBackgroundImage:[UIImage imageNamed:@"whiteButton.png"] forState:UIControlStateNormal];
                 [btnAddFriendsANDSetReminder setTitle:@"Set Reminder" forState:UIControlStateNormal];
                 [btnAddFriendsANDSetReminder setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
            // [self loadFriends];
             [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"friendsAdded"];
             [[NSUserDefaults standardUserDefaults]synchronize];
         }
    }
}


-(void)dealloc
{
    _qbuser =nil;
}
@end
