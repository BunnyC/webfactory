//
//  UploadPhotoViewController.m
//  PartyApp
//
//  Created by Varun on 17/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "UploadPhotoViewController.h"
#import "ProfileViewController.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
//#import "SignUpModel.h"

@interface UploadPhotoViewController () {
    CommonFunctions *commFunc;
    NSUserDefaults *userDefs;
    BOOL registeringNewUser;
}

@end

@implementation UploadPhotoViewController
@synthesize imgProfilePic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Create Account"];
    [self initDefaults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initializing Defaults

- (void)initDefaults {
    
    commFunc = [CommonFunctions sharedObject];
    userDefs = [NSUserDefaults standardUserDefaults];
    
    [self setupNavigationItems];
    [self setupTextViewForUploadView];
    
    if (self.objUser.blobID) {
        [spinnerProfileImage setHidden:false];
        [spinnerProfileImage startAnimating];
        [QBContent TDownloadFileWithBlobID:self.objUser.blobID delegate:self];
    }
    
    else if (self.objUser.facebookID.length) {
        NSString *strFBImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", _objUser.facebookID];
        //        NSString *strFBImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/793557416/picture?type=large"];
        NSURL *urlFBImage = [NSURL URLWithString:strFBImageURL];
        NSData *dataImage = [NSData dataWithContentsOfURL:urlFBImage];
        [imageViewProfile setImage:[UIImage imageWithData:dataImage]];
        [spinnerProfileImage stopAnimating];
    }
    else {
        UIImage *imageCamera = [commFunc imageWithName:@"cameraImage" andType:_pPNGType];
        
        resultType=KSignUpResultNone;
        [imageViewProfile setImage:imageCamera];
    }
    
    UITapGestureRecognizer *tapToChooseImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageTapped:)];
    [tapToChooseImage setNumberOfTapsRequired:1];
    [tapToChooseImage setNumberOfTouchesRequired:1];
    [imageViewProfile addGestureRecognizer:tapToChooseImage];
}


- (void)setupNavigationItems {
    UIImage *imgBackButton = [commFunc imageWithName:@"backButton" andType:_pPNGType];
    UIImage *imgNextButton = [commFunc imageWithName:@"nextButton" andType:_pPNGType];
    
    UIButton *leftBarButton = [commFunc buttonNavigationItemWithImage:imgBackButton
                                                            forTarget:self
                                                          andSelector:@selector(backButtonAction:)];
    
    UIButton *rightBarButton = [commFunc buttonNavigationItemWithImage:imgNextButton
                                                             forTarget:self
                                                           andSelector:@selector(nextButtonAction:)];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void)setupTextViewForUploadView {
    NSString *uploadLaterText = @"Don't want to add photo now? Upload Later";
    NSMutableAttributedString *attrTextLater = [[NSMutableAttributedString alloc] initWithString:uploadLaterText];
    
    UIFont *fontTextView = [UIFont fontWithName:@"ArialMT" size:9];
    
    NSDictionary *dictAttrLater = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor yellowColor], NSForegroundColorAttributeName,
                                   fontTextView, NSFontAttributeName,
                                   @"later", NSLinkAttributeName, nil];
    
    NSDictionary *dictAttrTextSimple = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        fontTextView, NSFontAttributeName, nil];
    
    NSRange rangeLater = [uploadLaterText rangeOfString:@"Upload Later"];
    NSRange rangeSimple = [uploadLaterText rangeOfString:@"Don't want to add photo now?"];
    [attrTextLater addAttributes:dictAttrLater range:rangeLater];
    [attrTextLater addAttributes:dictAttrTextSimple range:rangeSimple];
    
    [txtViewUploadLater setAttributedText:attrTextLater];
    [txtViewUploadLater setTextAlignment:NSTextAlignmentCenter];
}

//- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
//{
//    NSData *data1 = UIImagePNGRepresentation(image1);
//    NSData *data2 = UIImagePNGRepresentation(image2);
//    
//    return [data1 isEqual:data2];
//}

#pragma mark - Resizing Image

- (UIImage *)resizedImageWithImage:(UIImage *)image {

    CGSize newSize = CGSizeMake(183, 156);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - UITextView Delegates

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    BOOL shouldInteract = true;
    
    if ([URL.absoluteString isEqualToString:@"later"]) {
        [self performSelector:@selector(nextButtonClick)];
        shouldInteract = false;
    }
    return shouldInteract;
}

#pragma mark -  Image Methods

- (void)chooseImageTapped:(UITapGestureRecognizer *)recognizer {
    
    imageUploadStatus=KImageUploadNow;
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIColor *colorNavTitleText = [[CommonFunctions sharedObject] colorWithHexString:@"5f4b5e"];
    UIFont *fontNavTitleText = [UIFont fontWithName:@"ArialMT" size:14];
    NSDictionary *dictNavTitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                            colorNavTitleText, NSForegroundColorAttributeName,
                                            fontNavTitleText, NSFontAttributeName, nil];
    
    [self.imagePicker.navigationBar setTintColor:[UIColor whiteColor]];
    [self.imagePicker.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.imagePicker.navigationBar setTitleTextAttributes:dictNavTitleAttributes];
    [self.imagePicker.navigationBar setTranslucent:false];
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}


#pragma mark - IBAction

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextButtonAction:(id)sender {
    [self nextButtonClick];
   }

-(void)nextButtonClick
{
    loadingView = [[CommonFunctions sharedObject] showLoadingView];
    BOOL loggedIn = [userDefs boolForKey:_pudLoggedIn];
    
    if (!loggedIn) {
        registeringNewUser = true;
        [self createUser];
    }
    else {
        if (_userInfoChanged) {
            if (toUploadImage)
                [self uploadAvatarForUser];
            else
                [QBUsers updateUser:_objUser delegate:self];
        }
        else
            [self popThisView];
    }

}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    toUploadImage = true;
    _userInfoChanged = true;
    
    UIImage *selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *resizedImage = [self resizedImageWithImage:selectedImage];
    NSData *imageData = UIImagePNGRepresentation(resizedImage);
    imageUploadStatus = KImageUploadNow;
    
    [imageViewProfile setImage:[UIImage imageWithData:imageData]];
    imageViewProfile.contentMode = UIViewContentModeScaleAspectFit;
    [self.imagePicker dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    toUploadImage = false;
    imageUploadStatus=KImageUploadLater;
    [self.view setUserInteractionEnabled:YES];
    [self.imagePicker dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Uploading Image 

- (void)uploadAvatarForUser {
    [progressViewImageUpload setHidden:false];
    UIImage *imageToUpload = imageViewProfile.image;
    
    NSData *data = UIImagePNGRepresentation(imageToUpload);
    [QBContent TUploadFile:data
                  fileName:@"ProfileImage"
               contentType:@"image/png"
                  isPublic:YES
                  delegate:self];
}

#pragma mark - SignUp Methods

-(void)createUser {
    
    NSString *password = _objUser.password;
    [userDefs setObject:password forKey:@"Password"];
    [userDefs synchronize];
    
    [QBUsers signUp:_objUser delegate:self];
    [buttonNext setEnabled:false];
}

#pragma mark - Create User Session

-(void)createUserSession {

    NSMutableDictionary *userInfo = [userDefs objectForKey:_pudUserInfo];
    
    QBASessionCreationRequest *extendedAuthRequest = [QBASessionCreationRequest request];
    extendedAuthRequest.userLogin = [userInfo objectForKey:@"login"]; // ID: 218651
    extendedAuthRequest.userPassword = [userDefs objectForKey:@"Password"];
    [QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
    
//    NSMutableDictionary *userInfo = [userDefs objectForKey:_pudUserInfo];
//    [QBUsers logInWithUserLogin:[userInfo objectForKey:@"login"]
//                       password:[userDefs objectForKey:@"Password"]
//                       delegate:self];
}

#pragma mark - Poping the View

- (void)popThisView {
    [commFunc hideLoadingView:loadingView];
    [self.navigationController popToRootViewControllerAnimated:!registeringNewUser];
}

#pragma mark - QBActionStatusDelegate

-(void)completedWithResult:(Result *)result{

    if ([result isKindOfClass:[QBAAuthSessionCreationResult class]]) {
        if (result.success) {
            NSLog(@"Session created successfully");
            if (toUploadImage)
                [self uploadAvatarForUser];
            else
                [self popThisView];
        }
    }
//    if ([result isKindOfClass:[QBUUserLogInResult class]]) {
//        if (result.success) {
//            QBUUserLogInResult *loginResult = (QBUUserLogInResult *)result;
//            QBUUser *userInfo = [loginResult user];
//            
//            [commFunc saveInformationInDefaultsForUser:userInfo];
//            self.objUser = userInfo;
//            if (toUploadImage)
//                [self uploadAvatarForUser];
//            else
//                [self popThisView];
//        }
//    }
    else if ([result isKindOfClass:[QBUUserResult class]]) {
        if (result.success) {
        //        [spinner stopAnimating];
            QBUUserResult *userResult = (QBUUserResult *)result;
            NSLog(@"userResult : %@", userResult.user);
            [commFunc saveInformationInDefaultsForUser:userResult.user];
            _objUser = userResult.user;
            if (registeringNewUser)
                [self createUserSession];
            else
                [self popThisView];
        }
        else {
            NSLog(@"Error : %@", result.errors);
            NSArray *arrErrors = result.errors;
            NSString *errorMsg = [arrErrors componentsJoinedByString:@", "];
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Sign Up Error"
                                                                 message:errorMsg
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
            [errorAlert show];
//            [self.navigationController popViewControllerAnimated:YES];
            [self popThisView];
        }
    }
    else if([result isKindOfClass:[QBCFileUploadTaskResult class]]){
        if (result.success) {
        
            QBCBlob *uploadedFile  = ((QBCFileUploadTaskResult *)result).uploadedBlob;
            QBCBlobObjectAccess *blobAccess = (QBCBlobObjectAccess *)uploadedFile.blobObjectAccess;
            NSUInteger blobID = blobAccess.blobID;
            _objUser.blobID = blobID;
            registeringNewUser = false;
            NSLog(@"User Info : %@", _objUser);
            [QBUsers updateUser:_objUser delegate:self];
        }
    }
    else if([result isKindOfClass:[QBCFileDownloadTaskResult class]]){
        [spinnerProfileImage stopAnimating];
        if(result.success){
            QBCFileDownloadTaskResult *res = (QBCFileDownloadTaskResult *)result;
            NSData *fileData = res.file;
            
            UIImage *imageProfile = [UIImage imageWithData:fileData];
            [imageViewProfile setImage:imageProfile];
        }
    }
}

-(void)setProgress:(float)progress{
    NSLog(@"progress: %f", progress);
    [progressViewImageUpload setProgress:progress];
}

@end
