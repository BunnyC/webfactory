//
//  UploadPhotoViewController.h
//  PartyApp
//
//  Created by Varun on 17/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "BaseViewController.h"
typedef enum {
    KCreateUserSuccess,
    KCreateUserFailed,
    KCreateSessionSuccess,
    KCreateSessionFailed,
    KImageUploadSuccess,
    KImageUploadFailed,
    KSignUpResultNone,
    KImageUploadLater,
    KSignUpCompletionDone
    
}signUpResultType ;

@interface UploadPhotoViewController : BaseViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, QBActionStatusDelegate,UIAlertViewDelegate> {
    
    __weak IBOutlet UIImageView *imageViewProfile;
    __weak IBOutlet UILabel *lblAllYouNeed;
    __weak IBOutlet UILabel *lblAlmostDone;
    __weak IBOutlet UITextView *txtViewUploadLater;
    __weak IBOutlet UIProgressView *progressViewImageUpload;
    __weak IBOutlet UIButton *buttonNext;
      UIView *loadingView;
    BOOL isSignUpSuccess;
    signUpResultType resultType;

}
@property (nonatomic,retain) UIImagePickerController* imagePicker;
@property (nonatomic,retain)NSDictionary *dicUserDetail;
- (IBAction)openImageGallery:(id)sender;

@end
