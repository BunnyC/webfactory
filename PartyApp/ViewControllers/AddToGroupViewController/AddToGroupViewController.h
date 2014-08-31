//
//  AddToGroupViewController.h
//  PartyApp
//
//  Created by Gaganinder Singh on 20/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "BaseViewController.h"

@interface AddToGroupViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    __weak IBOutlet UITableView *tblGroupList;
    __weak IBOutlet UIView *vwAddGroup;
    NSMutableArray *arrOfGroups;
    IBOutlet UIView *vwHeader;
    __weak IBOutlet PATextField *txtGroupTitle;
    IBOutlet UIView *vwCustomAlertForAddGroup;
    BOOL isCreateGroupRequest;

    BOOL isFetchGroupUsersRequest;
    BOOL isUpdateGroupUserCountRequest;
    BOOL isRequest;
    
    QBCOCustomObject *objGroup;
    
    
}

@property (retain,nonatomic) QBUUser *objUser;


- (IBAction)btnOKClicked:(id)sender;

- (IBAction)btnCancelClicked:(id)sender;

- (IBAction)saveNewGroup:(id)sender;
- (IBAction)btnAddGroupAction:(id)sender;

@end
