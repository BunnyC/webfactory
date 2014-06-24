//
//  CommonFunctions.m
//  PartyApp
//
//  Created by Varun on 14/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "CommonFunctions.h"

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

- (void)setLocalImageForImageView:(UIImageView *)imageView
                     withFileName:(NSString *)fileName
                          andType:(NSString *)type {
    
    if (![self isDeviceiPhone5])
        fileName = [NSString stringWithFormat:@"%@4", fileName];
    
    NSString *pathForFile = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    UIImage *image = [UIImage imageWithContentsOfFile:pathForFile];
    [imageView setImage:image];
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
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIImage *resizedImage = [self imageWithImage:imageAtPath
                                    scaledToSize:CGSizeMake(320, screenSize.height - 64)];
    colorFromImage = [UIColor colorWithPatternImage:resizedImage];
    return colorFromImage;
}



@end
