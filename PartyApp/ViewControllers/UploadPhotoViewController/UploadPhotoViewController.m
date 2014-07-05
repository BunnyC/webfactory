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

#define KUserName @"UserName"
#define KEmail    @"Email"
#define KPassword @"Password"
#define KMoto     @"Moto"


@interface UploadPhotoViewController ()

@end

@implementation UploadPhotoViewController

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
    
    UIImage *imageCamera = [[CommonFunctions sharedObject] imageWithName:@"cameraImage"
                                                                 andType:_pPNGType];

    resultType=KSignUpResultNone;
    [imageViewProfile setImage:imageCamera];
    
    UITapGestureRecognizer *tapToChooseImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageTapped:)];
    [tapToChooseImage setNumberOfTapsRequired:1];
    [tapToChooseImage setNumberOfTouchesRequired:1];
    [imageViewProfile addGestureRecognizer:tapToChooseImage];
    
    //  Setting up Navigation Item
    UIImage *imgBackButton = [[CommonFunctions sharedObject] imageWithName:@"backButton"
                                                                   andType:_pPNGType];
    UIImage *nextButtonImage = [[CommonFunctions sharedObject] imageWithName:@"nextButton"
                                                                     andType:_pPNGType];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imgBackButton style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:nextButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonAction:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    //  Setting up Attributed Text
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

#pragma mark - UITextView Delegates

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    BOOL shouldInteract = true;
    if ([URL.absoluteString isEqualToString:@"tandc"]) {
        NSLog(@"T & C");
        shouldInteract = false;
    }
    else if ([URL.absoluteString isEqualToString:@"privacy"]) {
        NSLog(@"privacy");
        shouldInteract = false;
    }
    return shouldInteract;
}

#pragma mark - Choose Image 

- (void)chooseImageTapped:(UITapGestureRecognizer *)recognizer {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - IBAction

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextButtonAction:(id)sender {
    
    loadingView = [[CommonFunctions sharedObject] showLoadingViewInViewController:self];
    switch (resultType) {
        case KSignUpResultNone:
            [self createUser];
            break;
            case KCreateUserFailed:
            [self createUser];
            break;
            case KCreateSessionFailed:
            [self createUserSession];
            break;
            case KImageUploadFailed:
            [self uploadProfileImage];
            break;
            case KSignUpCompletionDone:
            [self showProfileView];
            break;
            
        default:
            break;
    }
 
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// when photo is selected from gallery - > upload it to server
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage* selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData* imageData = UIImagePNGRepresentation(selectedImage);
    
    // Show image on gallery
    [imageViewProfile setImage:[UIImage imageWithData:imageData]];
    imageViewProfile.contentMode = UIViewContentModeScaleAspectFit;
    [self.imagePicker dismissViewControllerAnimated:NO completion:nil];
   
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    [self.view setUserInteractionEnabled:YES];
    [self.imagePicker dismissViewControllerAnimated:NO completion:nil];

}

#pragma mark -
#pragma mark QBActionStatusDelegate

-(void)completedWithResult:(Result *)result{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil, nil];
    
   
    
    if([result isKindOfClass:[QBUUserResult class]]){
      
        if(result.success){
            resultType=KCreateUserSuccess;
            [self createUserSession];
            
        }else{
            
            [[CommonFunctions sharedObject] hideLoadingView:loadingView];
            [buttonNext setEnabled:TRUE];
            [self.view setUserInteractionEnabled:YES];
            resultType=KCreateSessionFailed;
            alert.message=[result.errors description];
            [alert show];
            
        }
    }
    else if([result isKindOfClass:QBAAuthSessionCreationResult.class]){
        
        if(result.success)
        {
        resultType=KCreateSessionSuccess;
        //[buttonNext setEnabled:false];
        [progressViewImageUpload setHidden:false];
        [self.view setUserInteractionEnabled:NO];
        [self uploadProfileImage];
        
        }
        else
        {
            [[CommonFunctions sharedObject] hideLoadingView:loadingView];
            resultType=KCreateSessionFailed;
            alert.message=[result.errors description];
            [buttonNext setEnabled:TRUE];
             [progressViewImageUpload setHidden:TRUE];
            [self.view setUserInteractionEnabled:YES];
            [alert show];
        }

    }
    else
    {
        if(result.success)
        {
            [[CommonFunctions sharedObject] hideLoadingView:loadingView];
            resultType=KSignUpCompletionDone;
            [buttonNext setEnabled:TRUE];
            [self.view setUserInteractionEnabled:YES];
            alert.message=_pImgUploadingSuccess;
            [alert show];
        }
        else
        {
            [[CommonFunctions sharedObject] hideLoadingView:loadingView];
            [buttonNext setEnabled:TRUE];
            [self.view setUserInteractionEnabled:YES];
            resultType=KImageUploadFailed;
            [alert show];
        }
        
      
    }
}

-(void)setProgress:(float)progress{
    NSLog(@"progress: %f", progress);
    [progressViewImageUpload setProgress:progress];
}


#pragma mark - SignUp Methods

#pragma create user account with user details

-(void)createUser
{
    QBUUser *objCreateUser=[[QBUUser alloc]init];
    [objCreateUser setLogin:[_dicUserDetail objectForKey:KUserName]];
    [objCreateUser setEmail:[_dicUserDetail objectForKey:KEmail]];
    [objCreateUser setPassword:[_dicUserDetail objectForKey:KPassword]];
    [objCreateUser setFullName:[_dicUserDetail objectForKey:KUserName]];
    [QBUsers signUp:objCreateUser delegate:self];
    [buttonNext setEnabled:false];
 
}

#pragma create user session

-(void)createUserSession
{
    QBASessionCreationRequest *extendedAuthRequest = [QBASessionCreationRequest request];
    extendedAuthRequest.userLogin = [_dicUserDetail objectForKey:KUserName]; // ID: 218651
    extendedAuthRequest.userPassword =[_dicUserDetail objectForKey:KPassword];
    [QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
}

#pragma Image Uploading 

-(void)uploadProfileImage
{
    NSData *data=UIImagePNGRepresentation(imageViewProfile.image);
    [QBContent TUploadFile:data fileName:@"ProfileImage" contentType:@"image/png" isPublic:YES delegate:self];
}

#pragma show Profile View

-(void)showProfileView
{
    
    NSString *xibName = NSStringFromClass([ProfileViewController class]);
    BOOL isiPhone5 = [[CommonFunctions sharedObject] isDeviceiPhone5];
    if (!isiPhone5)
        xibName = [NSString stringWithFormat:@"%@4", xibName];
    
    [[NSUserDefaults standardUserDefaults]setBool:true forKey:_pudLoggedIn];
    
    ProfileViewController *objProfileView = [[ProfileViewController alloc] initWithNibName:xibName bundle:nil];
    
    NSDictionary * userInfo=[NSDictionary dictionaryWithObjectsAndKeys:[_dicUserDetail objectForKey:KUserName],@"first_name",[_dicUserDetail objectForKey:KMoto],@"moto", nil];
    [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:_pUserInfoDic];
    [[NSUserDefaults standardUserDefaults]synchronize];

    [self.navigationController pushViewController:objProfileView animated:YES];
}

#pragma mark - Delloc Method

-(void)dealloc
{
    
}
@end
