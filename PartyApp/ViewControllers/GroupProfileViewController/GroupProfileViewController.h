//
//  GroupProfileViewController.h
//  PartyApp
//
//  Created by Gaganinder Singh on 30/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "BaseViewController.h"

@interface GroupProfileViewController : BaseViewController
{
  
    
    __weak IBOutlet UILabel *lbl_NumberOfMembers;
    __weak IBOutlet UILabel *grpName;
    __weak IBOutlet UIImageView *imgVwGrpProfilePic;

    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    
}


- (IBAction)btnViewGroupMember:(id)sender;
- (IBAction)btnSetReminderAction:(id)sender;
- (IBAction)btnGroupChatAction:(id)sender;
- (IBAction)btnLeaveGroupAction:(id)sender;


@end
