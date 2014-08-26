//
//  FriendsProfileViewController.h
//  PartyApp
//
//  Created by Gaganinder Singh on 20/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsViewController.h"
@interface FriendsProfileViewController : BaseViewController<QBActionStatusDelegate>
{
    
    IBOutlet UIView *addFriendCustomPopUp;
    __weak IBOutlet UILabel *lbl_Status;
    __weak IBOutlet UILabel *lbl_FrName;
    __weak IBOutlet UIImageView *imgVwFriendProfilePic;
    __weak IBOutlet UILabel *lbl_FrMoto;
    __weak IBOutlet UIButton *btnAddFriendsANDSetReminder;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    
}

@property (nonatomic,strong) QBUUser *qbuser;
@property (nonatomic,assign) BOOL isAlreadyFriend;
- (IBAction)addFriendsViewController:(id)sender;
- (IBAction)addFriendsCustomPopUpClicked:(id)sender;
- (IBAction)btnMessageAction:(id)sender;
- (IBAction)btnAddToGroupAction:(id)sender;


@end
