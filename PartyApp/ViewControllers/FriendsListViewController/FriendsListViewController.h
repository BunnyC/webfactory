//
//  FriendsListViewController.h
//  PartyApp
//
//  Created by Gaganinder Singh on 23/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "BaseViewController.h"

@interface FriendsListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,QBActionStatusDelegate>
{
    
    __weak IBOutlet UITableView *tblVwFriendList;
    UIView *vwloading;
    NSMutableArray *arrFriedslist;
    
    
}

@end
