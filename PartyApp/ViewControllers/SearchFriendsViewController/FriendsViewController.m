//
//  FriendsViewController.m
//  PartyApp
//
//  Created by Gaganinder Singh on 17/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "FriendsViewController.h"
#import "SWRevealViewController.h"
#import "SearchFriendsTableViewCell.h"
#import "FriendsProfileViewController.h"
#import "FriendsListViewController.h"


@interface FriendsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int numberofrow;
}

@end

@implementation FriendsViewController

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
//    arrFriedslist =[[NSMutableArray alloc]initWithObjects:@"Friends",@"Friends",@"Friends",@"Friends",@"Friends", @"Friends",@"Friends",@"Friends",@"Friends",nil];
    
    arrSearchFriedslist =[[NSMutableArray alloc]init];
    arrFriendsList=[[NSMutableArray alloc]init];
    isFriendsSearchViewVisible=FALSE;
    [self fetchFriendList];
    numberofrow=1;
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupNavigationBar];
    FBSession *session=[FBSession activeSession];
    
   // [self sessionStateChanged:session state:FBSessionStateOpen error:nil];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

-(void)fetchFacebookFriends
{
//    [FBRequestConnection startWithGraphPath:@"/me/friendlists"
//                                 parameters:nil
//                                 HTTPMethod:@"GET"
//                          completionHandler:^(
//                                              FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error
//                                              ) {
//                              NSLog(@"%@",result);
//                              /* handle the result */
//                          }];
    
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_friends", @"email"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         if (!error && (state == FBSessionStateOpen || state == FBSessionStateOpenTokenExtended)) {
             
         } else if (error) {
            
             // Handle errors
            
         }
     }];

}


-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error {
    switch (state) {
        case FBSessionStateOpen: {
            if (self != nil) {
                [[FBRequest requestForMe] startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                    if (error) {
                        //error
                    }else{
                        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
                        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,NSDictionary* result,NSError *error) {
                            NSArray* friends = [result objectForKey:@"data"];
                            
                           
                            
                           
                        }];
                    }
                }];
            }
            FBCacheDescriptor *cacheDescriptor = [FBFriendPickerViewController cacheDescriptor];
            [cacheDescriptor prefetchAndCacheForSession:session];
        }
            break;
        case FBSessionStateClosed: {
        
            UIViewController *topViewController = [self.navigationController topViewController];
            UIViewController *modalViewController = [topViewController modalViewController];
            if (modalViewController != nil) {
                [topViewController dismissViewControllerAnimated:YES completion:nil];
            }
            //[self.navigationController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self performSelector:@selector(fetchFacebookFriends) withObject:nil afterDelay:0.5f];
        }
            break;
        case FBSessionStateClosedLoginFailed: {
         
            [self performSelector:@selector(fetchFacebookFriends) withObject:nil afterDelay:0.5f];
        }
            break;
        default:
            break;
    }
    
    
    if (error) {
        
    }
}

- (void)setupNavigationBar {
  
    self.navigationItem.title=@"Friends";
    
    commFunc = [CommonFunctions sharedObject];
    UIImage *imgMenuButton = [commFunc imageWithName:@"buttonMenu" andType:_pPNGType];
    UIImage *imgNotificationButton = [commFunc imageWithName:@"locationIcon" andType:_pPNGType];
    
   SWRevealViewController *revealController = [self revealViewController];
   [revealController panGestureRecognizer];
   [revealController tapGestureRecognizer];
    UIButton *leftBarButton = [commFunc buttonNavigationItemWithImage:imgMenuButton
                                                            forTarget:revealController
                                                          andSelector:@selector(revealToggle:)];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    leftBarButtonItem.tintColor=[UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIButton *rightBarButton = [commFunc buttonNavigationItemWithImage:imgNotificationButton
                                                             forTarget:self
                                                           andSelector:@selector(rightbarButtonClicked)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];

}


-(void)rightbarButtonClicked
{
    FriendsListViewController *objFriendsListVw=[[FriendsListViewController alloc]initWithNibName:@"FriendsListViewController" bundle:nil];
    [self.navigationController pushViewController:objFriendsListVw animated:YES];
}


-(BOOL)checkIsSelectedUserHasAlreadyFriendsOfloggedUser:(NSString *)email
{
    BOOL isFriend=false;
    for (QBCOCustomObject *obj in arrFriendsList)
    {
       if([[obj.fields objectForKey:@"FR_EMAIL"]isEqualToString:email])
       {
           isFriend=true;
           break;
       }
    }
    
    return isFriend;
}
#pragma mark - IBAction

- (IBAction)btnSearchClicked:(id)sender{
    
    
    if(txtSearchFriends.text.length!=0)
    {
        if([commFunc validateEmailID:txtSearchFriends.text])
        {
           // [QBAuth createSessionWithDelegate:self];
            vwloading=[commFunc showLoadingView];
             [QBUsers usersWithEmails:[NSArray arrayWithObjects:txtSearchFriends.text, nil] delegate:self];
            
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:_pErrInvalidUserEmailId                                  delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        }
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"Please specify emailId"                                delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        
    }

}

- (IBAction)btnAddFriendsClicked:(id)sender {
    
    isFriendsSearchViewVisible=true;
    numberofrow=0;
    [tblViewFriendsList reloadData];
    vwAddFriend.hidden=YES;
    vwSearchFriends.hidden=NO;
    [self.view bringSubviewToFront:vwSearchFriends];
    [self.view sendSubviewToBack:vwAddFriend];
}

#pragma mark - TableView Delegate Method

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(isFriendsSearchViewVisible)
        return 60.0f;
    else
        return 0.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return vwheaderView;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(arrSearchFriedslist.count==indexPath.row)
    {
        return 200.0;
    }
    else
    {
        return 67.0;
    }
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrSearchFriedslist.count+numberofrow;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(arrSearchFriedslist.count==indexPath.row)
    {
        static NSString *identifierCell=@"cellLast";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierCell];
        if(!cell)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
        }
        
        if(footerView == nil) {
            footerView  = [[UIView alloc] init];
            UIColor *backColor = [[CommonFunctions sharedObject] colorWithImageName:@"appBackground"
                                                                            andType:@"png"];
            //  footerView.backgroundColor=backColor;
            UIView *innerView=[[UIView alloc]init];
            
            //allocate the view if it doesn't exist yet
            
            innerView.frame =CGRectMake(tableView.frame.size.width/2-90, 0, 180,180);
            innerView.layer.borderColor=[UIColor whiteColor].CGColor;
            innerView.layer.borderWidth=0.5f;
            innerView.layer.cornerRadius=5.0;
            //we would like to show a gloosy red button, so get the image first
            UIImage *image = [[UIImage imageNamed:@"fr-img3.png"]
                              stretchableImageWithLeftCapWidth:8 topCapHeight:8];
            
            //create the button
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            
            //the button should be as big as a table view cell
            [button setFrame:CGRectMake(innerView.frame.size.width/2-31.5,90-31.5, 63, 63)];
            
            //set title, font size and font color
            
            //set action of the button
            [button addTarget:self action:@selector(btnAddFriendsClicked:)
        
            forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *lbl=[[UILabel alloc]init];
            lbl.frame=CGRectMake(button.frame.origin.x-10, button.frame.origin.y+button.frame.size.height+70, button.frame.size.width+20, 20);
            lbl.text=@"Add Friends";
            lbl.font =[UIFont fontWithName:@"Arial-BoldMT" size:14];
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.textColor=[UIColor whiteColor];
            
            [innerView addSubview:lbl];
            
            //add the button to the view
            [innerView setBackgroundColor:[UIColor clearColor]];
            [innerView addSubview:button];
            [footerView addSubview:innerView];
            
            footerView.backgroundColor=[UIColor clearColor];
            
            
        }
        
        [cell.contentView addSubview:footerView];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        static NSString *identifierCell=@"cell";
        SearchFriendsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierCell];
        if(!cell)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SearchFriendsTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        id obj=[arrSearchFriedslist objectAtIndex:indexPath.row];
        [cell setCellValues:obj];
        
        
        return cell;
    }
   
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(arrSearchFriedslist.count==indexPath.row)
    {
        [self btnAddFriendsClicked:self];
    }
    else
    {
    FriendsProfileViewController *objFriendsPro=[[FriendsProfileViewController
                                                  alloc]initWithNibName:@"FriendsProfileViewController" bundle:nil];
    
        
        
        if([[arrSearchFriedslist objectAtIndex:indexPath.row] isKindOfClass:[QBUUser  class]])
        {
           objFriendsPro.qbuser=[arrSearchFriedslist objectAtIndex:indexPath.row];
        }
        else
        {
            QBCOCustomObject *obj=[arrSearchFriedslist objectAtIndex:indexPath.row];
            QBUUser *user=[[QBUUser alloc]init];
            user.ID= [[obj.fields objectForKey:@"Fr_ID"] integerValue];
            user.login=[obj.fields objectForKey:@"FR_Name"];
            user.email=[obj.fields objectForKey:@"FR_EMAIL"];
            user.website=[obj.fields objectForKey:@"FR_MOTO"];
            user.blobID=[[obj.fields objectForKey:@"FR_BlobID"] integerValue];
            
            objFriendsPro.qbuser=user;

        }
       
   
        objFriendsPro.isAlreadyFriend=[self checkIsSelectedUserHasAlreadyFriendsOfloggedUser:objFriendsPro.qbuser.email];
    [self.navigationController pushViewController:objFriendsPro animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
}

#pragma mark - Web Services Calls

-(void)fetchFriendList
{
    QBUUser *objUser=[commFunc getQBUserObjectFromUserDefaults];
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSString stringWithFormat:@"%lu",(unsigned long)objUser.ID] forKey:@"username[ctn]"];
    [getRequest setObject:@"5" forKey:@"limit"];
    [getRequest setObject:[NSNumber numberWithBool:NO] forKey:@"documentary"];
    [getRequest setObject:@"rating" forKey:@"sort_asc"];
    
    vwloading=[commFunc showLoadingView];
    [QBCustomObjects objectsWithClassName:@"PAFriendListClass" extendedRequest:getRequest delegate:self];
  

   // [QBAuth createSessionWithDelegate:self];
}

#pragma mark - QuickBlox Search Responser

-(void)completedWithResult:(Result *)result{

    if ([result isKindOfClass:[QBAAuthSessionCreationResult class]]) {
        if (result.success) {
            NSLog(@"Session created successfully");
           
            }
    }
    if( [result isKindOfClass:QBUUserPagedResult.class])
    {
        if(result.success)
        {
            
         QBUUserPagedResult *userObjectsResult = (QBUUserPagedResult *)result;
        for (int i=0; i<userObjectsResult.users.count;i++)
        {
         [arrSearchFriedslist addObject:[userObjectsResult.users objectAtIndex:i]];
        }
        [vwloading removeFromSuperview];
        [tblViewFriendsList reloadData];
            
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:nil
                                                  message:@"User does not exist"                                   delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil, nil] show];
        }
        
        
    }
    else if(result.success && [result isKindOfClass:QBCOCustomObjectPagedResult.class]){
        [arrFriendsList removeAllObjects];
        QBCOCustomObjectPagedResult *getObjectsResult = (QBCOCustomObjectPagedResult *)result;
        NSLog(@"Objects: %@, count: %lu", getObjectsResult.objects, getObjectsResult.count);
        [arrFriendsList addObjectsFromArray:getObjectsResult.objects];
        arrSearchFriedslist =[arrFriendsList copy];
             [vwloading removeFromSuperview];
        [tblViewFriendsList reloadData];
        
        
    }
    
}
@end
