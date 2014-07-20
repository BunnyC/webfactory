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
    
//    [spinnerProfileImage stopAnimating];
    
    if (self.objUser.blobID) {
        [spinnerProfileImage setHidden:false];
        [spinnerProfileImage startAnimating];
        [QBContent TDownloadFileWithBlobID:self.objUser.blobID delegate:self];
    }
    
    UIImage *imageCamera = [commFunc imageWithName:@"cameraImage" andType:_pPNGType];
    
    resultType=KSignUpResultNone;
    [imageViewProfile setImage:imageCamera];
    
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

#pragma mark - UITextView Delegates

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    BOOL shouldInteract = true;
    
    if ([URL.absoluteString isEqualToString:@"later"]) {
        imageUploadStatus=KImageUploadLater;
        if([userDefs boolForKey:_pudLoggedIn])
        {
            if(resultType == KSignUpCompletionDone || resultType == KUpdateUserSuccess)
            {
//                [self showProfileView];
            }
//            else
//                [self createUserSession];
        }
        else
            [self createUser];
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
    
//    RegisterViewController *registerView;
//    for (id obj in self.navigationController.viewControllers) {
//        if([(RegisterViewController *)obj isKindOfClass:[RegisterViewController class]])
//        {
//            registerView=(RegisterViewController *)obj;
//            break;
//        }
//    }
//    registerView.objUser=_objUser;
//    [self.navigationController popToViewController:registerView animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextButtonAction:(id)sender {
    
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
    NSData *imageData = UIImagePNGRepresentation(selectedImage);
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
    UIImage *imageToUpload = imageViewProfile.image;
    
    NSData *data = UIImagePNGRepresentation(imageToUpload);
    [QBContent TUploadFile:data
                  fileName:@"ProfileImage"
               contentType:@"image/png"
                  isPublic:YES
                  delegate:self];
}

#pragma mark - SignUp Methods

-(void)createUser
{
    loadingView = [[CommonFunctions sharedObject] showLoadingView];
    
    NSString *password = _objUser.password;
    [userDefs setObject:password forKey:@"Password"];
    [userDefs synchronize];
    
//    QBUUser *user = [QBUUser user];
//    user.login = _objUser.login;
//    user.blobID = _objUser.blobID;
//    user.password = _objUser.password;
//    user.email = _objUser.email;
//    user.website = _objUser.website;
//    user.fullName = _objUser.fullName;
//    
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
    if (registeringNewUser)
        [self.navigationController popToRootViewControllerAnimated:NO];
    else
        [self.navigationController popToRootViewControllerAnimated:YES];
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
            [self.navigationController popViewControllerAnimated:YES];
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


//-(void)updatingProfileDetailHandler:(Result *)result
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                    message:@""
//                                                   delegate:nil
//                                          cancelButtonTitle:@"Ok"
//                                          otherButtonTitles:nil, nil];
//    if([result isKindOfClass:[QBUUserResult class]])
//    {
//        
//        if(result.success){
//            resultType=KUpdateUserSuccess;
//            
//            for (id view in self.navigationController.viewControllers) {
//                if([(RegisterViewController *)view isKindOfClass:[RegisterViewController class]])
//                {
//                    [(RegisterViewController *)view clearTextBoxes];
//                    break;
//                }
//            }
//            
//            QBUUserLogInResult *res = (QBUUserLogInResult *)result;
//            _objUser=res.user;
//            [progressViewImageUpload setHidden:false];
//            [self.view setUserInteractionEnabled:NO];
//
//            
//            [self updateProfilePic];
//           
//            
//        }else{
//            
//            [[CommonFunctions sharedObject] hideLoadingView:loadingView];
//            [buttonNext setEnabled:TRUE];
//            [self.view setUserInteractionEnabled:YES];
//            resultType=KCreateSessionFailed;
//            alert.title=@"Errors";
//            alert.message=[result.errors description];
//            [alert show];
//            
//        }
//    }
//    /*
//    else if([result isKindOfClass:QBAAuthSessionCreationResult.class]){
//        
//        if(result.success)
//        {
//            resultType=KCreateSessionSuccess;
//            //[buttonNext setEnabled:false];
//            [progressViewImageUpload setHidden:false];
//            [self.view setUserInteractionEnabled:NO];
//            [self uploadProfileImage];
//            
//        }
//        else
//        {
//            [[CommonFunctions sharedObject] hideLoadingView:loadingView];
//            resultType=KCreateSessionFailed;
//            alert.message=[result.errors description];
//            [buttonNext setEnabled:TRUE];
//            [progressViewImageUpload setHidden:TRUE];
//            alert.title=@"Errors";
//            [self.view setUserInteractionEnabled:YES];
//            [alert show];
//        }
//        
//    }
//     */
//    else
//    {
//        if(result.success)
//        {
//            [[CommonFunctions sharedObject] hideLoadingView:loadingView];
//            alert.title=@"";
//            resultType=KUpdateUserSuccess;
//            [buttonNext setEnabled:TRUE];
//            [self.view setUserInteractionEnabled:YES];
//            alert.message=_pSignUpSuccess;
//            [alert show];
//        }
//        else
//        {
//            [[CommonFunctions sharedObject] hideLoadingView:loadingView];
//            [buttonNext setEnabled:TRUE];
//            alert.title=@"Errors";
//            [self.view setUserInteractionEnabled:YES];
//            resultType=KImageUploadFailed;
//            [alert show];
//        }
//        
//        
//    }
//}

//-(void)signUpHandler:(Result *)result
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                    message:@""
//                                                   delegate:nil
//                                          cancelButtonTitle:@"Ok"
//                                          otherButtonTitles:nil, nil];
//    if([result isKindOfClass:[QBUUserResult class]]){
//        
//        if(result.success){
//            resultType=KCreateUserSuccess;
//            for (id view in self.navigationController.viewControllers) {
//                if([(RegisterViewController *)view isKindOfClass:[RegisterViewController class]])
//                {
//                    [(RegisterViewController *)view clearTextBoxes];
//                    break;
//                }
//            }
//            
////            [self createUserSession];
//            
//        }else{
//            
//            [[CommonFunctions sharedObject] hideLoadingView:loadingView];
//            [buttonNext setEnabled:TRUE];
//            [self.view setUserInteractionEnabled:YES];
//            resultType=KCreateSessionFailed;
//            alert.title=@"Errors";
//            alert.message=[result.errors description];
//            [alert show];
//            
//        }
//    }
//    else if([result isKindOfClass:QBAAuthSessionCreationResult.class]){
//        
//        if(result.success)
//        {
//            resultType=KCreateSessionSuccess;
//            //[buttonNext setEnabled:false];
//            [progressViewImageUpload setHidden:false];
//            [self.view setUserInteractionEnabled:NO];
//            [self uploadProfileImage];
//            
//        }
//        else
//        {
//            [[CommonFunctions sharedObject] hideLoadingView:loadingView];
//            resultType=KCreateSessionFailed;
//            alert.message=[result.errors description];
//            [buttonNext setEnabled:TRUE];
//            [progressViewImageUpload setHidden:TRUE];
//            alert.title=@"Errors";
//            [self.view setUserInteractionEnabled:YES];
//            [alert show];
//        }
//        
//    }
//    else
//    {
//        if(result.success)
//        {
//            [[CommonFunctions sharedObject] hideLoadingView:loadingView];
//            alert.title=@"";
//            resultType=KSignUpCompletionDone;
//            [buttonNext setEnabled:TRUE];
//            [self.view setUserInteractionEnabled:YES];
//            alert.message=_pSignUpSuccess;
//            [alert show];
//        }
//        else
//        {
//            [[CommonFunctions sharedObject] hideLoadingView:loadingView];
//            [buttonNext setEnabled:TRUE];
//            alert.title=@"Errors";
//            [self.view setUserInteractionEnabled:YES];
//            resultType=KImageUploadFailed;
//            [alert show];
//        }
//        
//        
//    }
//}

-(void)setProgress:(float)progress{
    NSLog(@"progress: %f", progress);
    [progressViewImageUpload setProgress:progress];
}

//-(void)updateUserDetails
//{
//   
//    loadingView = [[CommonFunctions sharedObject] showLoadingView];
//   
//    [QBUsers updateUser:_objUser delegate:self];
//
//    
////    SigUpModel *objSignUpModel = [[SigUpModel alloc] init];
////    [objSignUpModel UpdateUserWithTarget:self
////                              withselector:@selector(serverResponseForSignUp:)
////                                andDetails:dictUser
////                        toShowWindowLoader:NO];
//    
//    [buttonNext setEnabled:false];
//
//}

//-(void)updateProfilePic
//{
//    if(imageUploadStatus==KImageUploadNow)
//    {
//        NSData *data=UIImagePNGRepresentation(imageViewProfile.image);
//        
//        QBCBlob *file =(QBCBlob *)[[[DataManager instance] fileList] lastObject];
//        
//        [QBContent TUpdateFileWithData:data file:file delegate:self];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@""
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Ok"
//                                              otherButtonTitles:nil, nil];
//        [[CommonFunctions sharedObject] hideLoadingView:loadingView];
//        resultType=KUpdateUserSuccess;
//        [buttonNext setEnabled:TRUE];
//        [self.view setUserInteractionEnabled:YES];
//        alert.message=_pUpdateProfileSuccess;
//        [alert show];
//    }
//
//}

//- (void)serverResponseForSignUp:(NSDictionary *)responseDict {
//    
//    if (![responseDict objectForKey:@"errors"]) {
//        dicInfo=responseDict;
////        [self createUserSession];
//    }
//    else {
//        NSArray *arrErrors = [responseDict objectForKey:@"errors"];
//        NSString *strErrors = [arrErrors componentsJoinedByString:@", "];
//        
//        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                             message:strErrors
//                                                            delegate:nil
//                                                   cancelButtonTitle:@"OK"
//                                                   otherButtonTitles:nil, nil];
//        [errorAlert show];
//        [self.navigationController popViewControllerAnimated:YES];
//        
//        [[CommonFunctions sharedObject] hideLoadingView:loadingView];
//    }
//}

//#pragma Image Uploading
//
//-(void)uploadProfileImage
//{
//    if(imageUploadStatus==KImageUploadNow)
//
//    {
//        NSData *data=UIImagePNGRepresentation(imageViewProfile.image);
//        [QBContent TUploadFile:data fileName:@"ProfileImage" contentType:@"image/png" isPublic:YES delegate:self];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@""
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Ok"
//                                              otherButtonTitles:nil, nil];
//        [[CommonFunctions sharedObject] hideLoadingView:loadingView];
//        resultType=KSignUpCompletionDone;
//        [buttonNext setEnabled:TRUE];
//        [self.view setUserInteractionEnabled:YES];
//        alert.message=_pSignUpSuccess;
//        [alert show];
//    }
//}



#pragma show Profile View

//-(void)showProfileView {
//    
//    NSString *xibName = NSStringFromClass([ProfileViewController class]);
//    BOOL isiPhone5 = [[CommonFunctions sharedObject] isDeviceiPhone5];
//    if (!isiPhone5)
//        xibName = [NSString stringWithFormat:@"%@4", xibName];
//    
//
//    
//    if([userDefs boolForKey:_pudLoggedIn])
//    {
//        
//        
//        NSMutableDictionary *userDetail=[[NSMutableDictionary alloc]init];
//        [userDetail setValue:_objUser.login forKey:@"login"];
//        [userDetail setValue:_objUser.email forKey:@"email"];
//        [userDetail setValue:_objUser.fullName forKey:@"full_name"];
//        [userDetail setValue:_objUser.website forKey:@"website"];
//        [self updateUserInfo:userDetail];
//        ProfileViewController *profileView;
//        for (id obj in self.navigationController.viewControllers) {
//            if([(ProfileViewController *)obj isKindOfClass:[ProfileViewController class]])
//            {
//                profileView=(ProfileViewController *)obj;
//                break;
//            }
//        }
//        
//        profileView.objUserDetail=_objUser;
//        [self.navigationController popToViewController:profileView animated:YES];
//    }
//    else
//    {
//        [userDefs setBool:true forKey:_pudLoggedIn];
//        
//        [self updateUserInfo:dicInfo];
//        ProfileViewController *objProfileView = [[ProfileViewController alloc] initWithNibName:xibName bundle:nil];
//        objProfileView.dicUserInfo=dicInfo;
//        objProfileView.isComeFromSignUp=true;
//        [self.navigationController pushViewController:objProfileView animated:YES];
//        
//    }
//
//
//}


//-(void)updateUserInfo:(NSDictionary *)user
//{
//    NSMutableDictionary *userDetail=[[NSMutableDictionary alloc]init];
//    [userDetail setValue:[user valueForKey:@"login"] forKey:@"login"];
//    [userDetail setValue:[user valueForKey:@"email"] forKey:@"email"];
//    [userDetail setValue:[user valueForKey:@"full_name"] forKey:@"full_name"];
//    [userDetail setValue:[user valueForKey:@"website"] forKey:@"website"];
//    
//    [userDefs setObject:userDetail forKey:@"userDetail"];
//    [userDefs setBool:true forKey:_pudLoggedIn];
//    [userDefs synchronize];
//}
//#pragma mark - Delloc Method
//
//-(void)dealloc
//{
//    
//}
@end
