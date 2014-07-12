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
    KUpdateUserSuccess,
    KCreateUserFailed,
    KCreateSessionSuccess,
    KCreateSessionFailed,
    KImageUploadSuccess,
    KImageUploadFailed,
    KSignUpResultNone,
    KSignUpCompletionDone,
    KUpdateCompletionDone
    
}signUpResultType ;


typedef enum{
    KImageUploadLater,
    KImageUploadNow
}ImageUploadStatus;

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
    ImageUploadStatus imageUploadStatus;
    NSDictionary *dicInfo;

}

@property (nonatomic,retain) UIImagePickerController* imagePicker;
@property (nonatomic,retain)QBUUser *objUser;
@property (nonatomic,weak)UIImage *imgProfilePic;

@end




