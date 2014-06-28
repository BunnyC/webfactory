//
//  ForgotPasswordViewController.h
//  PartyApp
//
//  Created by Gaganinder Singh on 28/06/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : BaseViewController <QBActionStatusDelegate> {
    
    __weak IBOutlet UIScrollView *scrollView;
}

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@end
