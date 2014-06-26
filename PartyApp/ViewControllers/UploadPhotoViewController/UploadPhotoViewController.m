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
@synthesize imagePicker;
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
    imageViewProfile.layer.borderWidth=1.5;
    imageViewProfile.layer.borderColor=[UIColor blueColor].CGColor;
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
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonAction:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    NSString *uploadLaterText = @"Don't want to add photo now? Upload Later";
    NSMutableAttributedString *attrTextLater = [[NSMutableAttributedString alloc] initWithString:uploadLaterText];
    
    NSDictionary *dictAttrLater = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor yellowColor], NSForegroundColorAttributeName,
                                   @"later", NSLinkAttributeName,
                                   [NSNumber numberWithInt:NSUnderlineStyleSingle], NSUnderlineStyleAttributeName, nil];
    
    NSRange rangeLater = [uploadLaterText rangeOfString:@"Upload Later"];
    [attrTextLater addAttributes:dictAttrLater range:rangeLater];
    
    [txtViewUploadLater setAttributedText:attrTextLater];
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

#pragma mark - IBAction

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextButtonAction:(id)sender {
    
    
    
    ProfileViewController *objProfileView = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    [self.navigationController pushViewController:objProfileView animated:YES];
}



- (IBAction)openImageGallery:(id)sender {
    
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePicker animated:YES completion:nil];
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
  
    [imagePicker dismissViewControllerAnimated:NO completion:nil];


    // Upload file to QuickBlox server
    [self checkQBSession:^(BOOL finished) {
        if(finished){
            [QBContent TUploadFile:imageData fileName:@"ProfileImage" contentType:@"image/png" isPublic:NO delegate:self];
        }
    }];
   
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    [imagePicker dismissViewControllerAnimated:NO completion:nil];

}

#pragma -markc check QBsession
-(void) checkQBSession:(myCompletion) compblock{
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [delegate refreshQBSession];
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
}

-(void)setProgress:(float)progress{
    NSLog(@"progress: %f", progress);
}
@end
