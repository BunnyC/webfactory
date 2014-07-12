//
//  AddReminderViewController.m
//  PartyApp
//
//  Created by Varun on 7/07/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "AddReminderViewController.h"

@interface AddReminderViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    int selectedOption;
    
    NSMutableArray *arrDates;
    NSMutableArray *arrMonths;
    NSMutableArray *arrYears;
    
    NSMutableArray *arrHours;
    NSMutableArray *arrMinutes;
    
    NSMutableArray *arrSeconds;
}

@end

@implementation AddReminderViewController

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
    [self initDefaults];
    [self setArrays];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Init Methods

- (void)initDefaults {
    selectedOption = 0;
    
    // Setting up Bar Button Items
    UIImage *imgMenuButton = [[CommonFunctions sharedObject] imageWithName:@"backButton"
                                                                   andType:_pPNGType];
    UIImage *imgNotificationButton = [[CommonFunctions sharedObject] imageWithName:@"barButtonTick"
                                                                           andType:_pPNGType];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imgMenuButton style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imgNotificationButton style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    UIImage *imageWhenWhereBack = [[CommonFunctions sharedObject] imageWithName:@"whenNWhere"
                                                                        andType:_pPNGType];
    
    [viewWhenNWhere setBackgroundColor:[UIColor colorWithPatternImage:imageWhenWhereBack]];
    
    UIImage *imageBackViewBottom = [[CommonFunctions sharedObject] imageWithName:@"viewBack"
                                                                         andType:_pPNGType];
    [viewBottom setBackgroundColor:[UIColor colorWithPatternImage:imageBackViewBottom]];
    
    [self setupTextView];
}

- (void)setArrays {
    arrDates = [[NSMutableArray alloc] init];
    arrMonths = [[NSMutableArray alloc] init];
    arrYears = [[NSMutableArray alloc] init];
    
    arrHours = [[NSMutableArray alloc] init];
    arrMinutes = [[NSMutableArray alloc] init];
    arrSeconds = [[NSMutableArray alloc] init];
    
//    NSDate *dateToCompare = [NSDate date];
//    NSDate *lastDate = [NSDate dateWithTimeInterval:365 * 24 * 60 * 60
//                                          sinceDate:[NSDate date]];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd/MM/yy"];
    
//    for (int i = 0; i < 31; i ++)
    
}

#pragma mark - Setup Text View

- (void)setupTextView {
    
    NSString *textWithLinks = @"These are your personal reminders Remind a Friend\nor Edit Preferences";
    NSMutableAttributedString *attrTextForgotLabel = [[NSMutableAttributedString alloc] initWithString:textWithLinks];
    
    UIFont *fontTextView = [UIFont fontWithName:@"Arial-BoldMT" size:9];
    
    NSDictionary *dictAttrRemind = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor yellowColor], NSForegroundColorAttributeName,
                                    @"remindAFriend", NSLinkAttributeName,
                                    fontTextView, NSFontAttributeName, nil];
    
    NSDictionary *dictAttrPreference = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor yellowColor], NSForegroundColorAttributeName,
                                        @"editPreference", NSLinkAttributeName,
                                        fontTextView, NSFontAttributeName, nil];
    
    NSDictionary *dictAttrTextSimple = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        fontTextView, NSFontAttributeName, nil];
    
    NSRange rangeRemind = [textWithLinks rangeOfString:@"Remind a Friend"];
    NSRange rangePreferences = [textWithLinks rangeOfString:@"Edit Preferences"];
    [attrTextForgotLabel addAttributes:dictAttrTextSimple range:NSMakeRange(0, textWithLinks.length)];
    [attrTextForgotLabel addAttributes:dictAttrRemind range:rangeRemind];
    [attrTextForgotLabel addAttributes:dictAttrPreference range:rangePreferences];
    
    [textViewLinks setAttributedText:attrTextForgotLabel];
    [textViewLinks setTextAlignment:NSTextAlignmentCenter];
}

#pragma mark - IBAction for Options

- (IBAction)optionsButtonTouched:(id)sender {
    
    int tagButton = [sender tag];
    UIButton *selectedButton = (UIButton *)sender;
    
    if (tagButton != selectedOption) {
        
        [selectedButton setSelected:true];
        
        if (selectedOption) {
            UIButton *oldSelectedButton = (UIButton *)[viewOptions viewWithTag:selectedOption];
            [oldSelectedButton setSelected:false];
        }
        
        selectedOption = tagButton;
    }
    else {
        [selectedButton setSelected:false];
        selectedOption = 0;
    }
}

- (IBAction)whenButtonTouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setSelected:![button isSelected]];
    
    CGRect frameWW = viewWhenNWhere.frame;
    frameWW.origin.y += frameWW.size.height + 10;
    
    CGRect frameAR = viewAddReminder.frame;
    
    [viewAddReminder setFrame:CGRectMake(0, frameWW.origin.y, frameAR.size.width, frameAR.size.height)];
    [viewAddReminder setHidden:false];
//    [scrollView addSubview:viewAddReminder];
    
    CGRect frameVB = viewBottom.frame;
    frameVB.origin.y += frameAR.size.height;
    
    [viewBottom setFrame:frameVB];
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(frameVB))];
}

- (IBAction)whereButtonTouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setSelected:![button isSelected]];
}

#pragma mark - Picker View Delegates & DataSource

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    int components = [pickerView tag];
    NSLog(@"Components : %d", components);
    return components;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return (pickerView.frame.size.width / [pickerView tag]);
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    int noOfRows = 0;
    int pickerViewTag = [pickerView tag];
    
    if (pickerViewTag == 1)
        noOfRows = 60;
    else if ( pickerViewTag == 2)
        noOfRows = component ? 60 : 24;
    else {
        int thirdComponent = [pickerView selectedRowInComponent:2] + 1;
        int secondComponent = [pickerView selectedRowInComponent:1];
        int selectedYear = thirdComponent + 2000;
        
        BOOL leapYear = false;
        if (selectedYear % 4 == 0)
            leapYear = (selectedYear % 100 == 0) ? (selectedYear % 400 == 0) : true;
        
        switch (component) {
            case 0:
                if (secondComponent < 7)
                    noOfRows = (secondComponent == 1) ? (leapYear ? 29 : 28) : ((secondComponent % 2) ? 30 : 31);
                else
                    noOfRows = (secondComponent % 2) ? 31 : 30;
                break;
            case 1:
                noOfRows = 12;
                break;
            case 2:
                noOfRows = 2100 - (2000 + thirdComponent);
                break;
            default:
                break;
        }
    }
    return noOfRows;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    
//    NSString *strValue = [NSString stringWithFormat:@"%02d", row + 1];
//    return strValue;
//}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *strValue = [NSString stringWithFormat:@"%02d", row + 1];
    NSDictionary *dictAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont fontWithName:_pFontArialMT size:8], NSFontAttributeName,
                              [UIColor whiteColor], NSForegroundColorAttributeName,
                              nil];
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:strValue attributes:dictAttr];
    return attrString;
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [pickerView reloadAllComponents];
}

@end
