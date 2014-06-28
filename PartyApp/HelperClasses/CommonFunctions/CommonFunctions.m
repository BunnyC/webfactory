//
//  CommonFunctions.m
//  PartyApp
//
//  Created by Varun on 14/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "CommonFunctions.h"
#import "AppDelegate.h"

@implementation CommonFunctions

#pragma mark - Shared Instance

+ (id)sharedObject {
    static CommonFunctions *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

#pragma mark - Functions

- (BOOL)isDeviceiPhone5 {
    return ([UIScreen mainScreen].bounds.size.height == 568);
}

- (UIImage *)imageWithName:(NSString *)name andType:(NSString *)type {
    NSString *pathForFile = [[NSBundle mainBundle] pathForResource:name ofType:type];
    UIImage *image = [UIImage imageWithContentsOfFile:pathForFile];
    return image;
}

- (void)setLocalImageForImageView:(UIImageView *)imageView
                     withFileName:(NSString *)fileName
                          andType:(NSString *)type {
    
    if (![self isDeviceiPhone5])
        fileName = [NSString stringWithFormat:@"%@4", fileName];
    
    [imageView setImage:[self imageWithName:fileName andType:_pPNGType]];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIColor *)colorWithImageName:(NSString *)fileName andType:(NSString *)type {
    
    if (![self isDeviceiPhone5])
        fileName = [NSString stringWithFormat:@"%@4", fileName];
    
    UIColor *colorFromImage = [UIColor blackColor];
    NSString *pathForImage = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    UIImage *imageAtPath = [UIImage imageWithContentsOfFile:pathForImage];
//    CGSize screenSize = [UIScreen mainScreen].bounds.size;
//    UIImage *resizedImage = [self imageWithImage:imageAtPath
//                                    scaledToSize:CGSizeMake(320, screenSize.height - 64)];
//    colorFromImage = [UIColor colorWithPatternImage:resizedImage];
    colorFromImage = [UIColor colorWithPatternImage:imageAtPath];
    return colorFromImage;
}

- (BOOL)validateEmailID:(NSString *)emailID {
    emailID = [emailID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailID];
}

- (UIView *)showLoadingViewInViewController:(UIViewController *)viewController {
    
    CGRect frameScreen = [[UIScreen mainScreen] bounds];
    
    UIView *loadingView = [[UIView alloc] initWithFrame:frameScreen];
    [loadingView setBackgroundColor:[UIColor clearColor]];
    
    CGRect frameActivity = CGRectMake(frameScreen.size.width / 2 - 60 ,frameScreen.size.height / 2 - 40, 120, 80);
    
    UIView *viewActivity = [[UIView alloc] initWithFrame:frameActivity];
    [viewActivity setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.9f]];
    [viewActivity.layer setCornerRadius:5];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner setFrame:CGRectMake(frameActivity.size.width / 2 - 10, 15, 20, 20)];
    [spinner startAnimating];
    
    UILabel *labelActivity = [[UILabel alloc] initWithFrame:
                              CGRectMake(10, 40, viewActivity.frame.size.width - 20, 30)];
    [labelActivity setTextAlignment:NSTextAlignmentCenter];
    [labelActivity setBackgroundColor:[UIColor clearColor]];
    [labelActivity setFont:[UIFont boldSystemFontOfSize:16]];
    [labelActivity setTextColor:[UIColor whiteColor]];
    [labelActivity setText:@"Loading"];
    
    [viewActivity addSubview:spinner];
    [viewActivity addSubview:labelActivity];
    
    [loadingView addSubview:viewActivity];
    
    [[[viewController view] window] addSubview:loadingView];
    
    return loadingView;
}

- (void)hideLoadingView:(UIView *)loadingView {
    [loadingView removeFromSuperview];
    loadingView = nil;
}

@end
