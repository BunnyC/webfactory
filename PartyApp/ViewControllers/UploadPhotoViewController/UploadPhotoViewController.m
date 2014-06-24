//
//  UploadPhotoViewController.m
//  PartyApp
//
//  Created by Varun on 17/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "UploadPhotoViewController.h"
#import "ProfileViewController.h"

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



@end
