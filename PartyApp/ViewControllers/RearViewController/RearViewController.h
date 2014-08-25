//
//  RearViewController.h
//  PartyApp
//
//  Created by Gaganinder Singh on 16/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "BaseViewController.h"
@class RearTableViewCell;

@interface RearViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *tblViewRear;
    
    NSArray *arrMenus;
  //  RearTableViewCell *cell;
         CommonFunctions *commFunc;
}

@property (nonatomic,assign) id delegate;
@end
