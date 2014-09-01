//
//  AddToGroupViewController.m
//  PartyApp
//
//  Created by Gaganinder Singh on 20/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "AddToGroupViewController.h"
#import "AddToGroupCellTableViewCell.h"
#import "GroupProfileViewController.h"
#import "SWRevealViewController.h"
@interface AddToGroupViewController ()<QBActionStatusDelegate>
{
    CommonFunctions *commFunc;
    UIView *vwLoading;
}
@end

@implementation AddToGroupViewController

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
    [self.navigationItem setTitle:@"Groups"];
     commFunc = [CommonFunctions sharedObject];
    [self setupNavigationBar];
    addFooterViewRow=1;
    isShowSearchView=false;
    arrOfGroups=[[NSMutableArray alloc]init];

    isCreateGroupRequest=false;
    isUpdateGroupUserCountRequest=false;
    isFinishRequest=false;
    // Do any additional setup after loading the view from its nib.
}


- (void)setupNavigationBar {
   
    if(_isShowNavigationBarButton)
    {
        
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
        
        [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    }
//    UIImage *imgNotificationButton = [commFunc imageWithName:@"buttonSearch" andType:_pPNGType];
//    
//    UIButton *rightBarButton = [commFunc buttonNavigationItemWithImage:imgNotificationButton
//                                                             forTarget:self
//                                                           andSelector:@selector(rightbarButtonClicked)];
//    
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
//    
//    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
}
-(void)viewWillAppear:(BOOL)animated
{
     [self fetchGroups];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)btnOKClicked:(id)sender {
  
    
    
    
    /////
    
    
    
    QBCOCustomObject *objectAddUserToGroup = [QBCOCustomObject customObject];
    [objectAddUserToGroup setClassName:@"GroupUserTable"];
    
    [objectAddUserToGroup.fields setObject:[NSString stringWithFormat:@"%lu",_objUser.ID]
                                    forKey:@"GroupUserId"];
    
    [objectAddUserToGroup.fields setObject:[NSString stringWithFormat:@"%@",objGroup.ID]
     
                                    forKey:@"GroupID"];
    
    [objectAddUserToGroup.fields setObject:_objUser.login
                                    forKey:@"GroupUserName"];
    
    
    [objectAddUserToGroup.fields setObject:[NSString stringWithFormat:@"%lu",_objUser.blobID]
                                    forKey:@"GroupUserBlobId"];
    
    
    isUpdateGroupUserCountRequest=TRUE;
    [QBCustomObjects createObject:objectAddUserToGroup delegate:self];

}

- (IBAction)btnCancelClicked:(id)sender {
    
    [vwCustomAlertForAddGroup removeFromSuperview];
}

- (IBAction)saveNewGroup:(id)sender {
    
    [self createGroup];
}

- (void)btnAddFriendsClicked:(id)sender {
    
   
        addFooterViewRow=0;
    isShowSearchView=YES;
    [tblGroupList reloadData];
}


#pragma mark - Custom Method Web Services Call

-(void)fetchGroups
{
    vwLoading=[commFunc showLoadingView];
  
    [QBCustomObjects objectsWithClassName:@"PAGroupClass"  delegate:self];
}

-(void)createGroup
{
    
    QBUUser *objUser=[commFunc getQBUserObjectFromUserDefaults];
    QBCOCustomObject *objectLogNight = [QBCOCustomObject customObject];
    [objectLogNight setClassName:@"PAGroupClass"];
    
    [objectLogNight.fields setObject:txtGroupTitle.text
     
     
                              forKey:@"PAGroupName"];
    
    [objectLogNight.fields setObject:[NSString stringWithFormat:@"%lu",(unsigned long)objUser.ID]
     
                              forKey:@"PAGroupOwnerID"];
    
    [objectLogNight.fields setObject:txtGroupTitle.text
                              forKey:@"PAGroupTitle"];
    [objectLogNight.fields setObject:@"0"
                              forKey:@"PA_NumberOfUsers"];
    
    
    [QBCustomObjects createObject:objectLogNight delegate:self];
}

-(void)addUserToGroup
{
    
    [self.view addSubview:vwCustomAlertForAddGroup];
//    QBCOCustomObject *objectAddUserToGroup = [QBCOCustomObject customObject];
//    [objectAddUserToGroup setClassName:@"GroupUserTable"];
//    
//    [objectAddUserToGroup.fields setObject:[NSString stringWithFormat:@"%lu",_objUser.ID]
//                                    forKey:@"GroupUserId"];
//    
//    [objectAddUserToGroup.fields setObject:[NSString stringWithFormat:@"%@",objGroup.ID]
//     
//                                    forKey:@"GroupID"];
//    
//    [objectAddUserToGroup.fields setObject:_objUser.login
//                                    forKey:@"GroupUserName"];
//    
//    
//    [objectAddUserToGroup.fields setObject:[NSString stringWithFormat:@"%lu",_objUser.blobID]
//                                    forKey:@"GroupUserBlobId"];
//
//    
//    isUpdateGroupUserCountRequest=TRUE;
//    [QBCustomObjects createObject:objectAddUserToGroup delegate:self];
}


#pragma mark -TableView Delegate Method

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return vwHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!isShowSearchView)
    {
        return 0.0;
    }
    else
    {
        return 68.0;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrOfGroups.count+addFooterViewRow;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(arrOfGroups.count==indexPath.row)
    {
        if([commFunc isDeviceiPhone5])
          return 310.0f;
        else
            return 400;
    }
    else
        return 67.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(arrOfGroups.count==indexPath.row)
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
              footerView.backgroundColor=backColor;
            UIView *innerView=[[UIView alloc]init];
            
            //allocate the view if it doesn't exist yet
            
            innerView.frame =CGRectMake(tableView.frame.size.width/2-90, 20, 180,180);
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
            lbl.frame=CGRectMake(button.frame.origin.x-25, button.frame.origin.y+button.frame.size.height+70, button.frame.size.width+50, 20);
            lbl.text=@"Create Group";
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
        AddToGroupCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierCell];
        if(!cell)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AddToGroupCellTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        id obj=[arrOfGroups objectAtIndex:indexPath.row];
        [cell setCellValues:obj];
        
        
        return cell;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(arrOfGroups.count==indexPath.row)
    {
        addFooterViewRow=0;
        isShowSearchView=YES;
        [tblGroupList reloadData];
    }
    else
    {
        objGroup=(QBCOCustomObject *)[arrOfGroups objectAtIndex:indexPath.row];
        NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
        [getRequest setObject:[NSString stringWithFormat:@"%lu",(unsigned long)_objUser.ID] forKey:@"GroupUserId[ctn]"];
        
        isFetchGroupUsersRequest=TRUE;
        vwLoading=[commFunc showLoadingView];
        [QBCustomObjects objectsWithClassName:@"GroupUserTable" extendedRequest:getRequest delegate:self];
        
    }
}



#pragma mark - Quickblox delegate Method
-(void)completedWithResult:(Result *)result
{
    if(result.success && [result isKindOfClass:QBCOCustomObjectPagedResult.class]){
      
        
       
        if(isFetchGroupUsersRequest)
        {
            if(isUpdateGroupUserCountRequest)
            {
                
                if (isFinishRequest)
                {
                    GroupProfileViewController *obj;
                    
                    if([commFunc isDeviceiPhone5])
                    {
                        obj=[[GroupProfileViewController alloc]initWithNibName:@"GroupProfileViewController" bundle:nil];

                    }
                    else
                    {
                       obj=[[GroupProfileViewController alloc]initWithNibName:@"GroupProfileViewController4" bundle:nil];
                    }
                       
                    isFetchGroupUsersRequest=FALSE;
                    isUpdateGroupUserCountRequest=FALSE;
                    isFinishRequest=FALSE;
                    obj.objGroup=objGroup;
                    obj.objUser=_objUser;
                    [vwCustomAlertForAddGroup removeFromSuperview];
                    [self.navigationController pushViewController:obj animated:YES];
                }
                else
                {
                    
                    QBCOCustomObject *objectAddUserToGroup =objGroup;
                    
                    NSInteger numberOfUser=[[objGroup.fields objectForKey:@"PA_NumberOfUsers"] integerValue]+1;
                    
                    
                    [objectAddUserToGroup.fields setObject:[NSString stringWithFormat:@"%lu",numberOfUser]
                                                    forKey:@"PA_NumberOfUsers"];
                    isFinishRequest=TRUE;
                    [QBCustomObjects updateObject:objectAddUserToGroup delegate:self];
                    
                }
            }
            else
            {
                QBCOCustomObjectPagedResult *getObjectsResult = (QBCOCustomObjectPagedResult *)result;
                NSLog(@"Objects: %@, count: %lu", getObjectsResult.objects, getObjectsResult.count);
                
                if( getObjectsResult.objects.count!=0)
                {
                    BOOL isExist=FALSE;
                    for (QBCOCustomObject *obj in getObjectsResult.objects)
                    {
                        NSLog(@"%@",[obj.fields objectForKey:@"GroupID"]);
                        NSLog(@"%@",objGroup.ID);
                        
                        if([[NSString stringWithFormat:@"%@",[obj.fields objectForKey:@"GroupID"]] isEqualToString:objGroup.ID])
                        {
                            isExist=TRUE;
                        }
                        
                    }
                    
                    if(!isExist){
                        
                        [self addUserToGroup];
                    }
                    else
                    {
//                        [[[UIAlertView alloc] initWithTitle:@""
//                                                    message:@"User already exist "
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil ] show];
                        
                        GroupProfileViewController *obj;
                        
                        if([commFunc isDeviceiPhone5])
                        {
                            obj=[[GroupProfileViewController alloc]initWithNibName:@"GroupProfileViewController" bundle:nil];
                            
                        }
                        else
                        {
                            obj=[[GroupProfileViewController alloc]initWithNibName:@"GroupProfileViewController4" bundle:nil];
                        }
                        
                        isFetchGroupUsersRequest=FALSE;
                        isUpdateGroupUserCountRequest=FALSE;
                        isFinishRequest=FALSE;
                        obj.objGroup=objGroup;
                        obj.objUser=_objUser;
                        [vwCustomAlertForAddGroup removeFromSuperview];
                        [self.navigationController pushViewController:obj animated:YES];
                    }

                }
                else
                {
                    [self addUserToGroup];
                }
            }
            
        }
        else
        {
            QBCOCustomObjectPagedResult *getObjectsResult = (QBCOCustomObjectPagedResult *)result;
              [arrOfGroups removeAllObjects];
           [arrOfGroups addObjectsFromArray:getObjectsResult.objects];
              [tblGroupList reloadData];
        }
        
        
        
    }
    else if(result.success && [result isKindOfClass:QBCOCustomObjectResult.class])
    {
     
        if(isFetchGroupUsersRequest)
        {
            if(isUpdateGroupUserCountRequest)
            {
                
                if (isFinishRequest)
                {
                    GroupProfileViewController *obj;
                    
                    if([commFunc isDeviceiPhone5])
                    {
                        obj=[[GroupProfileViewController alloc]initWithNibName:@"GroupProfileViewController" bundle:nil];
                        
                    }
                    else
                    {
                        obj=[[GroupProfileViewController alloc]initWithNibName:@"GroupProfileViewController4" bundle:nil];
                    }
                    
                    isFetchGroupUsersRequest=FALSE;
                    isUpdateGroupUserCountRequest=FALSE;
                    isFinishRequest=FALSE;
                    obj.objGroup=objGroup;
                    obj.objUser=_objUser;
                    [vwCustomAlertForAddGroup removeFromSuperview];
                    [self.navigationController pushViewController:obj animated:YES];
                }
                else
                {
                    
                    QBCOCustomObject *objectAddUserToGroup =objGroup;
                    
                    NSInteger numberOfUser=[[objGroup.fields objectForKey:@"PA_NumberOfUsers"] integerValue]+1;
                    
                    
                    [objectAddUserToGroup.fields setObject:[NSString stringWithFormat:@"%lu",numberOfUser]
                                                    forKey:@"PA_NumberOfUsers"];
                    isFinishRequest=TRUE;
                    [QBCustomObjects updateObject:objectAddUserToGroup delegate:self];
                    
                }
            }
        }
        else
        {
            QBCOCustomObjectResult *getObjectsResult = (QBCOCustomObjectResult *)result;
            
            [arrOfGroups addObject:getObjectsResult.object];
            
            [tblGroupList reloadData];
        }
        
  
    }
    else{
        NSLog(@"errors=%@", result.errors);
    }
    [vwLoading removeFromSuperview];
}

@end
