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
    UIView *vwLoading;
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
    [self initilizationMethod];
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
    [self.navigationItem setTitle:@"Groups Profile"];
//    UIImage *imgMenuButton = [commFunc imageWithName:@"buttonMenu" andType:_pPNGType];
//    UIImage *imgNotificationButton = [commFunc imageWithName:@"buttonBell" andType:_pPNGType];
//    
//    SWRevealViewController *revealController = [self revealViewController];
//    [revealController panGestureRecognizer];
//    [revealController tapGestureRecognizer];
//    UIButton *leftBarButton = [commFunc buttonNavigationItemWithImage:imgMenuButton
//                                                            forTarget:revealController
//                                                          andSelector:@selector(revealToggle:)];
//    
//    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
//    //[self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
//    
//    UIButton *rightBarButton = [commFunc buttonNavigationItemWithImage:imgNotificationButton
//                                                             forTarget:self
//                                                           andSelector:@selector(btnBellClikced)];
//    
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
  //  [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

-(void)initilizationMethod
{
   // imgVwGrpProfilePic.image=[UIImage imageNamed:@"side3.png"];
    lbl_NumberOfMembers.text=[NSString stringWithFormat:@"%@ members",[[_objGroup.fields objectForKey:@"PA_NumberOfUsers"] isKindOfClass:[NSNull class]]?@"0":[_objGroup.fields objectForKey:@"PA_NumberOfUsers"]];
    
    grpName.text=[_objGroup.fields objectForKey:@"PAGroupName"];
     [imgVwGrpProfilePic.layer setCornerRadius:imgVwGrpProfilePic.frame.size.width / 2];
}
- (IBAction)btnViewGroupMember:(id)sender {
    
    GroupUsersViewController *obj=[[GroupUsersViewController alloc]initWithNibName:
                                   @"GroupUsersViewController" bundle:nil];
    obj.objGroup=_objGroup;
    [self.navigationController pushViewController:obj animated:YES];

}

- (IBAction)btnSetReminderAction:(id)sender {
    
    [commFunc showUnderDevelopmentAlert];
}

- (IBAction)btnGroupChatAction:(id)sender {
        [commFunc showUnderDevelopmentAlert];
}

- (IBAction)btnLeaveGroupAction:(id)sender {
    
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:_objGroup.ID forKey:@"GroupID[ctn]"];
    vwLoading=[commFunc showLoadingView];
    
    [QBCustomObjects objectsWithClassName:@"GroupUserTable"
                          extendedRequest:getRequest delegate:self];

    
    
}



-(void)completedWithResult:(Result *)result{
    
    
    if([result isKindOfClass:QBCOCustomObjectPagedResult.class])
    {
        if(result.success )
        {
            
            QBCOCustomObjectPagedResult *getObjectsResult = (QBCOCustomObjectPagedResult *)result;
            NSLog(@"Objects: %@, count: %lu", getObjectsResult.objects, getObjectsResult.count);
            
            if( getObjectsResult.objects.count!=0)
            {
                
                for (QBCOCustomObject *obj in getObjectsResult.objects)
                {
                    NSLog(@"%ld",(long)[[obj.fields objectForKey:@"GroupUserId"] integerValue]);
                    NSLog(@"%ld",_objUser.ID);
                    
                    if([[obj.fields objectForKey:@"GroupUserId"] integerValue]==_objUser.ID)
                    {
                        
                        [QBCustomObjects deleteObjectWithID:obj.ID className:@"GroupUserTable" delegate:self];
                        
                        return;
                        
                    }
                    
                }
                
            }
            
        }
    }
    else if([result isKindOfClass:QBCOCustomObjectResult.class])
    {
        if(result.success)
        {
            if(!isFinishRequest)
            {
                
                NSInteger numberOfUser=[[_objGroup.fields objectForKey:@"PA_NumberOfUsers"] integerValue]-1;
                
                
                
                [_objGroup.fields setObject:[NSString stringWithFormat:@"%lu",numberOfUser]
                                     forKey:@"PA_NumberOfUsers"];
                isFinishRequest=TRUE;
                [QBCustomObjects updateObject:_objGroup delegate:self];
            }
            else
            {
                
                int numb =([[_objGroup.fields objectForKey:@"PA_NumberOfUsers"] integerValue]-1<0?0:[[_objGroup.fields objectForKey:@"PA_NumberOfUsers"] integerValue]-1);
                
                lbl_NumberOfMembers.text=[NSString stringWithFormat:@"%d members",numb];
            }
        }
        
    }
    [vwLoading removeFromSuperview];
}




@end
