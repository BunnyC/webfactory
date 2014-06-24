//
//  UploadPhotoViewController.h
//  PartyApp
//
//  Created by Varun on 17/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "BaseViewController.h"

@interface UploadPhotoViewController : BaseViewController {
    
    __weak IBOutlet UIImageView *imageViewProfile;
    __weak IBOutlet UILabel *lblAllYouNeed;
    __weak IBOutlet UILabel *lblAlmostDone;
    __weak IBOutlet UITextView *txtViewUploadLater;
}

@end
