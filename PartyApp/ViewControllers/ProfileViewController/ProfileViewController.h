//
//  ProfileViewController.h
//  PartyApp
//
//  Created by Varun on 18/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"

@interface ProfileViewController : BaseViewController {
    
    __weak IBOutlet UIImageView *imageViewProfile;
    __weak IBOutlet UILabel *lblName;
    __weak IBOutlet UILabel *lblMotto;
    __weak IBOutlet UIView *viewActive;
    __weak IBOutlet UILabel *lblActive;
    __weak IBOutlet UIImageView *imgViewActive;
    __weak IBOutlet UIActivityIndicatorView *spinnerImageView;
    __weak IBOutlet UIView *viewNotifications;
    __weak IBOutlet UIButton *btnNotifications;
    __weak IBOutlet UITableView *tableViewNotifications;
    __weak IBOutlet UIButton *btnLogNight;
    __weak IBOutlet UIImageView *imgViewBackNotif;
    
    UIImage *profilePic;
}

@property (nonatomic,retain) NSDictionary *dicUserInfo;
@property (nonatomic,assign)BOOL isComeFromSignUp;
@property (nonatomic,retain)QBUUser *objUserDetail;

- (void)updateUserInfo:(QBUUser *)objUser;

@end

