//
//  GroupUsersViewController.m
//  PartyApp
//
//  Created by Gaganinder Singh on 30/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "GroupUsersViewController.h"
#import "SearchFriendsTableViewCell.h"
@interface GroupUsersViewController ()

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
//    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
//    [getRequest setObject:[NSString stringWithFormat:@"%lu",(unsigned long)] forKey:@"FR_WithUser_ID[ctn]"];
//    
//    
//    
//    [getRequest setObject:@"rating" forKey:@"sort_asc"];
//    vwloading=[commFunc showLoadingView];
//    [QBCustomObjects objectsWithClassName:@"PAFriendListClass" extendedRequest:getRequest delegate:self];
    
    
    // [QBAuth createSessionWithDelegate:self];
}

#pragma mark - TableView Delegate Methods

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrGrpUserList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"cell";
    SearchFriendsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    
    if(!cell)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SearchFriendsTableViewCell" owner:self options:nil];
        cell=[nib lastObject];
    }
    
    [cell setCellValues:[arrGrpUserList objectAtIndex:
                         indexPath.row]];
    return cell;
    
}

@end
