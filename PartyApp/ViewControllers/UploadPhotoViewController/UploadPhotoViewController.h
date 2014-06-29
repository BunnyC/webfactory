//
//  UploadPhotoViewController.h
//  PartyApp
//
//  Created by Varun on 17/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "BaseViewController.h"


@interface UploadPhotoViewController : BaseViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, QBActionStatusDelegate,UIAlertViewDelegate> {
    
    __weak IBOutlet UIImageView *imageViewProfile;
    __weak IBOutlet UILabel *lblAllYouNeed;
    __weak IBOutlet UILabel *lblAlmostDone;
    __weak IBOutlet UITextView *txtViewUploadLater;
    __weak IBOutlet UIButton *chooseImage;
    __weak IBOutlet UIProgressView *progressViewImageUpload;
}
@property (nonatomic,retain) UIImagePickerController* imagePicker;

- (IBAction)openImageGallery:(id)sender;

@end
