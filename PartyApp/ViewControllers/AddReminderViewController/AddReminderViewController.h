//
//  AddReminderViewController.h
//  PartyApp
//
//  Created by Varun on 7/07/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddReminderViewController : BaseViewController {
    
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIView *viewOptions;
    __weak IBOutlet UIView *viewWhenNWhere;
    __weak IBOutlet UIView *viewBottom;
    
    //  When & Where View
    __weak IBOutlet UIButton *buttonWhen;
    __weak IBOutlet UIButton *buttonWhere;
    
    //  View Bottom
    __weak IBOutlet UITextView *textViewLinks;
    
    //  Alarm View
    __weak IBOutlet UIView *viewAddReminder;
    __weak IBOutlet UIView *viewPickers;
    __weak IBOutlet UIPickerView *pickerDate;
    __weak IBOutlet UIPickerView *pickerTime;
    __weak IBOutlet UIPickerView *pickerSeconds;
    __weak IBOutlet UITableView *tableViewReminderInfo;
    
}

@end
