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
    BOOL isShowSearchView;

    BOOL isFetchGroupUsersRequest;
    BOOL isUpdateGroupUserCountRequest;
    BOOL isFinishRequest;
    UIView *footerView;
    QBCOCustomObject *objGroup;
    NSInteger addFooterViewRow;
    BOOL isShowNavigationBarButton;
    
    
}

@property (retain,nonatomic) QBUUser *objUser;
@property (nonatomic) BOOL isShowNavigationBarButton;

- (IBAction)btnOKClicked:(id)sender;

- (IBAction)btnCancelClicked:(id)sender;

- (IBAction)saveNewGroup:(id)sender;


@end
