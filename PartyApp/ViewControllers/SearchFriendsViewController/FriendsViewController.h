//
//  FriendsViewController.h
//  PartyApp
//
//  Created by Gaganinder Singh on 17/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "BaseViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@interface FriendsViewController : BaseViewController<QBActionStatusDelegate>
{
    __weak IBOutlet UIView *vwAddFriend;
   __weak IBOutlet UIView *vwSearchFriends;
    CommonFunctions *commFunc;
    __weak IBOutlet UITableView *tblViewFriendsList;
    __weak IBOutlet PATextField *txtSearchFriends;
    IBOutlet UIView *vwheaderView;
    
    UIView * footerView;
    NSMutableArray *arrSearchFriedslist;
    NSMutableArray *arrFriendsList;
    BOOL isFriendsSearchViewVisible;
    UIView *vwloading;
}

- (IBAction)btnSearchClicked:(id)sender;
- (IBAction)btnAddFriendsClicked:(id)sender;

@end
