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
    UIColor *colorBack = [UIColor colorWithPatternImage:imageCamera];
    [imageViewProfile setBackgroundColor:colorBack];
    
    UITapGestureRecognizer *tapToChooseImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageTapped:)];
    [tapToChooseImage setNumberOfTapsRequired:1];
    [tapToChooseImage setNumberOfTouchesRequired:1];
    [imageViewProfile addGestureRecognizer:tapToChooseImage];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonAction:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    NSString *uploadLaterText = @"Don't want to add photo now? Upload Later";
    NSMutableAttributedString *attrTextLater = [[NSMutableAttributedString alloc] initWithString:uploadLaterText];
    
    NSDictionary *dictAttrLater = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor yellowColor], NSForegroundColorAttributeName,
                                   [UIFont systemFontOfSize:10], NSFontAttributeName,
                                   @"later", NSLinkAttributeName, nil];
    
    NSDictionary *dictAttrTextSimple = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        [UIFont systemFontOfSize:10], NSFontAttributeName, nil];
    
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
    
    NSString *xibName = NSStringFromClass([ProfileViewController class]);
    BOOL isiPhone5 = [[CommonFunctions sharedObject] isDeviceiPhone5];
    if (!isiPhone5)
        xibName = [NSString stringWithFormat:@"%@4", xibName];
    
    ProfileViewController *objProfileView = [[ProfileViewController alloc] initWithNibName:xibName bundle:nil];
    [self.navigationController pushViewController:objProfileView animated:YES];
}

- (IBAction)openImageGallery:(id)sender {
    
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

     [QBContent TUploadFile:imageData fileName:@"ProfileImage" contentType:@"image/png" isPublic:YES delegate:self];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    [self.imagePicker dismissViewControllerAnimated:NO completion:nil];

}

#pragma -markc check QBsession

- (void)checkQBSession:(myCompletion) compblock{
    
    QBASessionCreationRequest *extendedAuthRequest = [[QBASessionCreationRequest alloc] init];
    extendedAuthRequest.userLogin = @"gaganinder.singh";
    extendedAuthRequest.userPassword = @"Devhub1234!";
    
    [QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
    compblock(YES);
}

#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
-(void)completedWithResult:(Result *)result{
    
    // Download file result
    if ([result isKindOfClass:QBCFileDownloadTaskResult.class]) {
        
        // Success result
        if (result.success) {
            
            QBCFileDownloadTaskResult *res = (QBCFileDownloadTaskResult *)result;
            if ([res file]) {
                
                // Add image to gallery
                [[DataManager instance] savePicture:[UIImage imageWithData:[res file]]];
                UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[res file]]];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                
                //
                [[[DataManager instance] fileList] removeLastObject];
                
               
            }
        }else{
            [[[DataManager instance] fileList] removeLastObject];
           
        }
    }
    else
    {
        if(result.success){
            
            // QuickBlox session creation  result
            if ([result isKindOfClass:[QBAAuthSessionCreationResult class]]) {
                
                // Success result
                if(result.success){
                    
                    // send request for getting user's filelist
                    PagedRequest *pagedRequest = [[PagedRequest alloc] init];
                    [pagedRequest setPerPage:20];
                    
                    [QBContent blobsWithPagedRequest:pagedRequest delegate:self];
                    
                  
                }
                
                // Get User's files result
            } else if ([result isKindOfClass:[QBCBlobPagedResult class]]){
                
                // Success result
                if(result.success){
                    QBCBlobPagedResult *res = (QBCBlobPagedResult *)result;
                    
                    // Save user's filelist
                    [DataManager instance].fileList = [res.blobs mutableCopy];
                    
                    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
                    [userDefs setBool:TRUE forKey:_pudLoggedIn];
                    
                    NSString *xibName = NSStringFromClass([ProfileViewController class]);
                    BOOL isiPhone5 = [[CommonFunctions sharedObject] isDeviceiPhone5];
                    if (!isiPhone5)
                        xibName = [NSString stringWithFormat:@"%@4", xibName];
                    
                    ProfileViewController *objProfileView = [[ProfileViewController alloc] initWithNibName:xibName bundle:nil];
                    
                    [self.navigationController pushViewController:objProfileView animated:YES];
                    
                    
                    // hid splash screen
//                    [self performSelector:@selector(hideSplashScreen) withObject:self afterDelay:1];
                }
            }
        }
    }
}

-(void)setProgress:(float)progress{
    NSLog(@"progress: %f", progress);
    [progressViewImageUpload setProgress:progress];
}
@end
