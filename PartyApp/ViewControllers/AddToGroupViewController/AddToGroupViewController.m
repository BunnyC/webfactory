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
    
    arrOfGroups=[[NSMutableArray alloc]initWithObjects:@"Dane Group",@"Fan Group", nil];
    [self setup];
    isCreateGroupRequest=false;
    isUpdateGroupUserCountRequest=false;
    isFinishRequest=false;
    // Do any additional setup after loading the view from its nib.
}

-(void)setup
{
    [self fetchGroups];
    commFunc= [CommonFunctions sharedObject];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)btnOKClicked:(id)sender {
}

- (IBAction)btnCancelClicked:(id)sender {
}

- (IBAction)saveNewGroup:(id)sender {
    
    [self createGroup];
}

- (IBAction)btnAddGroupAction:(id)sender {
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


#pragma mark -TableView Delegate Method

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return vwHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 67.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrOfGroups.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    objGroup=(QBCOCustomObject *)[arrOfGroups objectAtIndex:indexPath.row];
   
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSString stringWithFormat:@"%lu",(unsigned long)_objUser.ID] forKey:@"GroupUserId[ctn]"];

    isFetchGroupUsersRequest=TRUE;
    vwLoading=[commFunc showLoadingView];
    [QBCustomObjects objectsWithClassName:@"GroupUserTable" extendedRequest:getRequest delegate:self];

}



#pragma mark - Quickblox delegate Method
-(void)completedWithResult:(Result *)result
{
    if(result.success && [result isKindOfClass:QBCOCustomObjectPagedResult.class]){
        [arrOfGroups removeAllObjects];
        
       
        if(isFetchGroupUsersRequest)
        {
            if(isUpdateGroupUserCountRequest)
            {
                
                if (isFinishRequest)
                {
                    GroupProfileViewController *obj=[[GroupProfileViewController alloc]initWithNibName:@"GroupProfileViewController" bundle:nil];
                    isFetchGroupUsersRequest=FALSE;
                    isUpdateGroupUserCountRequest=FALSE;
                    isFinishRequest=FALSE;
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
                    for (QBCOCustomObject *obj in getObjectsResult.objects)
                    {
                        BOOL isExist=FALSE;
                        if([[NSString stringWithFormat:@"%@",obj.ID] isEqualToString:objGroup.ID])
                        {
                            isExist=TRUE;
                        }
                        
                        if(!isExist){
                            
                            [self addUserToGroup];
                        }
                        else
                        {
                            [[[UIAlertView alloc] initWithTitle:@""
                                                        message:@"User already exist "
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil ] show];
                        }
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
            NSLog(@"Objects: %@, count: %lu", getObjectsResult.objects, getObjectsResult.count);
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
                    GroupProfileViewController *obj=[[GroupProfileViewController alloc]initWithNibName:@"GroupProfileViewController" bundle:nil];
                    isFetchGroupUsersRequest=FALSE;
                    isUpdateGroupUserCountRequest=FALSE;
                    isFinishRequest=FALSE;
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
                    for (QBCOCustomObject *obj in getObjectsResult.objects)
                    {
                        BOOL isExist=FALSE;
                        if([[NSString stringWithFormat:@"%@",obj.ID] isEqualToString:objGroup.ID])
                        {
                            isExist=TRUE;
                        }
                        
                        if(!isExist){
                            
                            [self addUserToGroup];
                        }
                        else
                        {
                            [[[UIAlertView alloc] initWithTitle:@""
                                                        message:@"User already exist "
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil ] show];
                        }
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
