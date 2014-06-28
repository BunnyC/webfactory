//
//  RegisterViewController.h
//  PartyApp
//
//  Created by Varun on 15/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : BaseViewController<QBActionStatusDelegate,UITextFieldDelegate> {
    
    __weak IBOutlet PATextField *txtFieldUsername;
    __weak IBOutlet PATextField *txtFieldEmail;
    __weak IBOutlet PATextField *txtFieldRepeatEmail;
    __weak IBOutlet PATextField *txtFieldPassword;
    __weak IBOutlet PATextField *txtFieldRepeatPassword;
    __weak IBOutlet PATextField *txtFieldMotto;
    __weak IBOutlet UITextView *txtViewTAndC;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIView *viewBottom;
}

@end
