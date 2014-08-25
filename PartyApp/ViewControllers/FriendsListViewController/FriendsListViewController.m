//
//  FriendsListViewController.m
//  PartyApp
//
//  Created by Gaganinder Singh on 23/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "FriendsListViewController.h"
#import "SearchFriendsTableViewCell.h"
#import "FriendsProfileViewController.h"
@interface FriendsListViewController ()
{
    CommonFunctions *commFunc;
}
@end

@implementation FriendsListViewController

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
    arrFriedslist=[[NSMutableArray alloc]init];
    [self fetchFriendList];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationBar {
    
    self.navigationItem.title=@"Friends";
    
    commFunc = [CommonFunctions sharedObject];
    UIImage *imgNotificationButton = [commFunc imageWithName:@"buttonSearch" andType:_pPNGType];
   
    UIButton *rightBarButton = [commFunc buttonNavigationItemWithImage:imgNotificationButton
                                                             forTarget:self
                                                           andSelector:@selector(rightbarButtonClicked)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
}


-(void)rightbarButtonClicked
{
    [commFunc showUnderDevelopmentAlert];
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 67.0;
    
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrFriedslist.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *identifierCell=@"cell";
        SearchFriendsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierCell];
        if(!cell)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SearchFriendsTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        id obj=[arrFriedslist objectAtIndex:indexPath.row];
        [cell setCellValues:obj];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QBCOCustomObject *obj=[arrFriedslist objectAtIndex:indexPath.row];
    QBUUser *user=[[QBUUser alloc]init];
    user.ID= [[obj.fields objectForKey:@"Fr_ID"] integerValue];
    user.login=[obj.fields objectForKey:@"FR_Name"];
    user.email=[obj.fields objectForKey:@"FR_EMAIL"];
    user.website=[obj.fields objectForKey:@"FR_MOTO"];
    user.blobID=[[obj.fields objectForKey:@"FR_BlobID"] integerValue];
    
    
    FriendsProfileViewController *objFriendsPro=[[FriendsProfileViewController
                                                  alloc]initWithNibName:@"FriendsProfileViewController" bundle:nil];
    
    
    
    objFriendsPro.qbuser=user;
    
    objFriendsPro.isAlreadyFriend=TRUE;
    [self.navigationController pushViewController:objFriendsPro animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    
   
    if(result.success && [result isKindOfClass:QBCOCustomObjectPagedResult.class]){
        
        QBCOCustomObjectPagedResult *getObjectsResult = (QBCOCustomObjectPagedResult *)result;
        NSLog(@"Objects: %@, count: %lu", getObjectsResult.objects, getObjectsResult.count);
        [arrFriedslist addObjectsFromArray:getObjectsResult.objects];
      
        [tblVwFriendList reloadData];
        
    }else{
        NSLog(@"errors=%@", result.errors);
    }
    [vwloading removeFromSuperview];
}
@end
