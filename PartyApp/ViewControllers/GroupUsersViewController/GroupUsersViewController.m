//
//  GroupUsersViewController.m
//  PartyApp
//
//  Created by Gaganinder Singh on 30/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "GroupUsersViewController.h"
#import "GroupUserCell.h"

@interface GroupUsersViewController ()
{

    CommonFunctions *commFunc;
    
}
@end

@implementation GroupUsersViewController

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
    commFunc=[CommonFunctions sharedObject];
       [self.navigationItem setTitle:@"Groups Users"];
    arrGrpUserList=[[NSMutableArray alloc]init];
    [self fetchGroupUserList];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetch Group Users
-(void)fetchGroupUserList
{
    
        NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
        [getRequest setObject:_objGroup.ID forKey:@"GroupID[ctn]"];
       vwloading=[commFunc showLoadingView];
        [QBCustomObjects objectsWithClassName:@"GroupUserTable"
                              extendedRequest:getRequest delegate:self];
    
}

#pragma mark - TableView Delegate Methods

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrGrpUserList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"cell";
     GroupUserCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    
    if(!cell)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"GroupUserCell" owner:self options:nil];
        cell=[nib lastObject];
    }
    
    [cell setCellValues:[arrGrpUserList objectAtIndex:
                         indexPath.row]];
    return cell;
    
}



-(void)completedWithResult:(Result *)result{
    
   
     if(result.success && [result isKindOfClass:QBCOCustomObjectPagedResult.class])
     {
        [arrGrpUserList removeAllObjects];
        QBCOCustomObjectPagedResult *getObjectsResult = (QBCOCustomObjectPagedResult *)result;
        NSLog(@"Objects: %@, count: %lu", getObjectsResult.objects, getObjectsResult.count);
        [arrGrpUserList addObjectsFromArray:getObjectsResult.objects];
        [vwloading removeFromSuperview];
        [tblGroupList reloadData];
     
    }
    
}

@end
