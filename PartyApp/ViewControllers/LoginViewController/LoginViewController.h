//
//  LoginViewController.h
//  PartyApp
//
//  Created by Varun on 14/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : BaseViewController<UITextFieldDelegate> {
    __weak IBOutlet UITextField *txtFieldUsername;
    
    __weak IBOutlet UITextField *txtFieldPassword;
    __weak IBOutlet UILabel *lblForgotPassword;
    __weak IBOutlet UITextView *txtViewForgotPassword;
}

@end
