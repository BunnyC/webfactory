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

- (UIView *)showLoadingView {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
    
    [appDelegate.window addSubview:loadingView];
    
    return loadingView;
}

- (void)hideLoadingView:(UIView *)loadingView {
    
    [[loadingView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [loadingView removeFromSuperview];
    
//    [loadingView removeFromSuperview];
//    loadingView = nil;
}

- (UIColor *)colorWithHexString:(NSString *)hexString {
    
    if ([hexString length] != 6) {
        return nil;
    }
    
    // Brutal and not-very elegant test for non hex-numeric characters
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-fA-F|0-9]" options:0 error:NULL];
    NSUInteger match = [regex numberOfMatchesInString:hexString options:NSMatchingReportCompletion range:NSMakeRange(0, [hexString length])];
    
    if (match != 0) {
        return nil;
    }
    
    NSRange rRange = NSMakeRange(0, 2);
    NSString *rComponent = [hexString substringWithRange:rRange];
    NSUInteger rVal = 0;
    NSScanner *rScanner = [NSScanner scannerWithString:rComponent];
    [rScanner scanHexInt:&rVal];
    float rRetVal = (float)rVal / 254;
    
    
    NSRange gRange = NSMakeRange(2, 2);
    NSString *gComponent = [hexString substringWithRange:gRange];
    NSUInteger gVal = 0;
    NSScanner *gScanner = [NSScanner scannerWithString:gComponent];
    [gScanner scanHexInt:&gVal];
    float gRetVal = (float)gVal / 254;
    
    NSRange bRange = NSMakeRange(4, 2);
    NSString *bComponent = [hexString substringWithRange:bRange];
    NSUInteger bVal = 0;
    NSScanner *bScanner = [NSScanner scannerWithString:bComponent];
    [bScanner scanHexInt:&bVal];
    float bRetVal = (float)bVal / 254;
    
    return [UIColor colorWithRed:rRetVal green:gRetVal blue:bRetVal alpha:1.0f];
    
}

#pragma mark - Button with Image & Selector

- (UIButton *)buttonNavigationItemWithImage:(UIImage *)image
                                  forTarget:(id)controller
                                andSelector:(SEL)selector {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 24, 21)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:controller
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Saving User Info in NSUserDefaults

- (void)saveInformationInDefaultsForUser:(QBUUser *)userInfo {
    
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    
    NSNumber *userID        = [NSNumber numberWithInt:userInfo.ID];
    NSNumber *extID         = [NSNumber numberWithInt:userInfo.externalUserID];
    NSNumber *blobID        = [NSNumber numberWithInt:userInfo.blobID];
    NSString *facebookID    = !userInfo.facebookID ? @"" : userInfo.facebookID;
    NSString *twitterID     = !userInfo.twitterID ? @"" : userInfo.twitterID;
    NSString *fullName      = !userInfo.fullName ? @"" : userInfo.fullName;
    NSString *email         = !userInfo.email ? @"" : userInfo.email;
    NSString *phone         = !userInfo.phone ? @"" : userInfo.phone;
    NSString *website       = !userInfo.website ? @"" : userInfo.website;
    NSMutableArray *arrTags = userInfo.tags.count == 0 ? [NSMutableArray array] : userInfo.tags;
    
    NSMutableDictionary *dictUserInfo = [[NSMutableDictionary alloc] init];
    
    [dictUserInfo setObject:userInfo.login      forKey:@"login"];
    [dictUserInfo setObject:userInfo.createdAt  forKey:@"createdAt"];
    [dictUserInfo setObject:userInfo.updatedAt  forKey:@"updatedAt"];
    [dictUserInfo setObject:userID              forKey:@"ID"];
    [dictUserInfo setObject:extID               forKey:@"externalUserID"];
    [dictUserInfo setObject:blobID              forKey:@"blobID"];
    [dictUserInfo setObject:fullName            forKey:@"fullName"];
    [dictUserInfo setObject:website             forKey:@"website"];
    [dictUserInfo setObject:phone               forKey:@"phone"];
    [dictUserInfo setObject:facebookID          forKey:@"facebookID"];
    [dictUserInfo setObject:twitterID           forKey:@"twitterID"];
    [dictUserInfo setObject:email               forKey:@"email"];
    [dictUserInfo setObject:arrTags             forKey:@"tags"];
    
    NSLog(@"Model Info : %@", userInfo);
    NSLog(@"User Info : %@", dictUserInfo);
    
//    [userDefs setObject:blobID forKey:_pudUserAvatar];
    [userDefs setBool:true forKey:_pudLoggedIn];
    [userDefs setObject:dictUserInfo forKey:_pudUserInfo];
    [userDefs synchronize];
}

- (QBUUser *)getQBUserObjectFromUserDefaults {
    
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dictUserInfo = [[NSMutableDictionary alloc] initWithDictionary:[userDefs objectForKey:_pudUserInfo]];
    
    QBUUser *userLogin = [[QBUUser alloc] init];
    userLogin.login             = [dictUserInfo objectForKey:@"login"];
    userLogin.createdAt         = [dictUserInfo objectForKey:@"createdAt"];
    userLogin.updatedAt         = [dictUserInfo objectForKey:@"updatedAt"];
    userLogin.ID                = [[dictUserInfo objectForKey:@"ID"] intValue];
    userLogin.externalUserID    = [[dictUserInfo objectForKey:@"externalUserID"] intValue];
    userLogin.blobID            = [[dictUserInfo objectForKey:@"blobID"] intValue];
    userLogin.fullName          = [dictUserInfo objectForKey:@"fullName"];
    userLogin.website           = [dictUserInfo objectForKey:@"website"];
    userLogin.phone             = [dictUserInfo objectForKey:@"phone"];
    userLogin.facebookID        = [dictUserInfo objectForKey:@"facebookID"];
    userLogin.twitterID         = [dictUserInfo objectForKey:@"twitterID"];
    userLogin.email             = [dictUserInfo objectForKey:@"email"];
    userLogin.tags              = [dictUserInfo objectForKey:@"tags"];
    
    dictUserInfo = nil;
    return userLogin;
}

@end
