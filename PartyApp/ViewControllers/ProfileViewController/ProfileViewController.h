//
//  ProfileViewController.h
//  PartyApp
//
//  Created by Varun on 18/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "BaseViewController.h"

@interface ProfileViewController : BaseViewController {
    
    __weak IBOutlet UIImageView *imageViewProfile;
    __weak IBOutlet UILabel *lblName;
    __weak IBOutlet UILabel *lblMotto;
    __weak IBOutlet UIView *viewActive;
    __weak IBOutlet UILabel *lblActive;
    __weak IBOutlet UIImageView *imgViewActive;
    __weak IBOutlet UIView *viewNotifications;
    __weak IBOutlet UIButton *btnNotifications;
    __weak IBOutlet UITableView *tableViewNotifications;
}

@end
