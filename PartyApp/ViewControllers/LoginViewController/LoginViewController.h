//
//  LoginViewController.h
//  PartyApp
//
//  Created by Varun on 14/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>

@optional
-(void)updateUserInfo:(NSDictionary *)dic;

@end
@interface LoginViewController : BaseViewController<UITextFieldDelegate,QBActionStatusDelegate> {
    __weak IBOutlet PATextField *txtFieldUsername;
    __weak IBOutlet PATextField *txtFieldPassword;
    __weak IBOutlet UITextView *txtViewForgotPassword;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIView *viewBottom;
    
    NSDictionary *userInfo;
    UIView *loadingView;
    
}

@property (nonatomic,strong) id<LoginViewDelegate> delegate;

@end
