//
//  GroupUsersViewController.h
//  PartyApp
//
//  Created by Gaganinder Singh on 30/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "BaseViewController.h"
@interface GroupUsersViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    __weak IBOutlet UITableView *tblGroupList;
    NSMutableArray *arrGrpUserList;
    UIView *vwloading;

    
}

@property (nonatomic,retain)QBCOCustomObject *objGroup;

@end
