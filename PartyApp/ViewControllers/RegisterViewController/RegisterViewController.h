//
//  RegisterViewController.h
//  PartyApp
//
//  Created by Varun on 15/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : BaseViewController<QBActionStatusDelegate,UITextFieldDelegate> {
    
    __weak IBOutlet UITextField *txtFieldUsername;
    __weak IBOutlet UITextField *txtFieldEmail;
    __weak IBOutlet UITextField *txtFieldRepeatEmail;
    __weak IBOutlet UITextField *txtFieldPassword;
    __weak IBOutlet UITextField *txtFieldRepeatPassword;
    __weak IBOutlet UITextField *txtFieldMotto;
    __weak IBOutlet UITextView *txtViewTAndC;
}

@end
