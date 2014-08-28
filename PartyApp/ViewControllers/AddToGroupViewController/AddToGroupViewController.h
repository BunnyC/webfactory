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
    
    
}
- (IBAction)btnAddGroupAction:(id)sender;

@end
