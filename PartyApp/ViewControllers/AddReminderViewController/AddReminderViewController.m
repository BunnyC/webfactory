//
//  AddReminderViewController.m
//  PartyApp
//
//  Created by Varun on 7/07/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "AddReminderViewController.h"

@interface AddReminderViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate> {
    
    int selectedOption;
    
    int currentDay;
    int currentMonth;
    int currentYear;
    
    BOOL repeatSelected;
    BOOL notesSelected;
    
    NSArray *arrReminderOptions;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Init Methods

- (void)initDefaults {
    
    CommonFunctions *commFunc = [CommonFunctions sharedObject];
    
    selectedOption = 0;
    
    repeatSelected = false;
    notesSelected = false;
    
    arrReminderOptions = [[NSArray alloc] initWithObjects:
                          @"Tomorrow",
                          @"Next Week",
                          @"Everyday",
                          @"Every Week", nil];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *strDateToday = [dateFormatter stringFromDate:today];
    NSArray *arrComponents = [strDateToday componentsSeparatedByString:@"/"];
    
    currentDay = [[arrComponents objectAtIndex:0] intValue];
    currentMonth = [[arrComponents objectAtIndex:1] intValue];
    currentYear = [[arrComponents objectAtIndex:2] intValue];
    
    // Setting up Bar Button Items
    UIImage *imgBackButton = [commFunc imageWithName:@"backButton" andType:_pPNGType];
    UIImage *imgNotificationButton = [commFunc imageWithName:@"barButtonTick" andType:_pPNGType];
    
    UIButton *leftBarButton = [commFunc buttonNavigationItemWithImage:imgBackButton
                                                            forTarget:self
                                                          andSelector:@selector(backButtonAction:)];
    UIButton *rightBarButton = [commFunc buttonNavigationItemWithImage:imgNotificationButton
                                                             forTarget:self
                                                           andSelector:nil];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    UIImage *imageWhenWhereBack = [commFunc imageWithName:@"whenNWhere" andType:_pPNGType];
    UIImage *imageBackViewBottom = [commFunc imageWithName:@"viewBack" andType:_pPNGType];
    
    UIImage *resizableImage = [imageWhenWhereBack resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2) resizingMode:UIImageResizingModeStretch];
    
    [viewWhenNWhere setBackgroundColor:[UIColor colorWithPatternImage:imageWhenWhereBack]];
    [viewBottom setBackgroundColor:[UIColor colorWithPatternImage:imageBackViewBottom]];
    [imageViewBack setImage:resizableImage];
    
//    [tableViewReminderInfo.layer setBorderColor:[UIColor blueColor].CGColor];
//    [tableViewReminderInfo.layer setBorderWidth:2.0f];
    
    [self setupTextView];
}

#pragma mark - Navigation Bar Methods

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    CGRect frameAR = viewAddReminder.frame;
    
    CGRect frameVB = viewBottom.frame;
    if ([button isSelected]) {
        frameWW.origin.y += (frameWW.size.height + 10);
        frameVB.origin.y = CGRectGetMaxY(frameWW) + frameAR.size.height + 10;
    }
    else {
        frameWW.origin.y -= (frameWW.size.height + 10);
        frameVB.origin.y = self.view.frame.size.height - frameVB.size.height;
    }
    
    [viewAddReminder setFrame:CGRectMake(0, frameWW.origin.y, frameAR.size.width, frameAR.size.height)];
    [viewAddReminder setHidden:![button isSelected]];
    [viewBottom setFrame:frameVB];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(frameVB))];
}

- (IBAction)whereButtonTouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setSelected:![button isSelected]];
}

- (void)sectionButtonTouched:(UIButton *)sender {
    int heightIncrement = (!repeatSelected && !notesSelected) ? 120: 0;
    if ([sender tag] == 0) {
        repeatSelected = true;
        notesSelected = false;
    }
    else {
        repeatSelected = false;
        notesSelected = true;
    }
    
//    CGRect frameTable = tableViewReminderInfo.frame;
//    frameTable.size.height += heightIncrement;
//    [tableViewReminderInfo setFrame:frameTable];
    
    CGRect frameViewReminder = viewAddReminder.frame;
    frameViewReminder.size.height += heightIncrement;
    [viewAddReminder setFrame:frameViewReminder];
    
    CGRect frameViewBottom = viewBottom.frame;
    frameViewBottom.origin.y += heightIncrement;
    [viewBottom setFrame:frameViewBottom];
    
    CGSize contentSize = scrollView.contentSize;
    contentSize.height += heightIncrement;
    
    [scrollView setContentSize:contentSize];
    
    
    [tableViewReminderInfo reloadData];
}

#pragma mark - Other Methods

- (UIView *)addViewInPickerComponentWithText:(NSString *)textComponent {
    
    UIView *viewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 30)];
    [viewTitle setBackgroundColor:[UIColor clearColor]];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:viewTitle.frame];
    [labelTitle setFont:[UIFont fontWithName:_pFontArialMT size:12]];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setTextColor:[UIColor whiteColor]];
    [labelTitle setText:textComponent];
    
    [viewTitle addSubview:labelTitle];
    labelTitle = nil;
    
    return viewTitle;
}

#pragma mark - TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGRect frameScrollView = scrollView.frame;
    frameScrollView.size.height -= 216;
    [scrollView setFrame:frameScrollView];
    [scrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(tableViewReminderInfo.frame) + 50)
                        animated:true];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    CGRect frameScrollView = scrollView.frame;
    frameScrollView.size.height = self.view.frame.size.height;
    [scrollView setFrame:frameScrollView];
}

#pragma mark - Picker View Delegates & DataSource

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    int components = [pickerView tag];
    return components;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 15;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    int noOfRows = 0;
    int pickerViewTag = [pickerView tag];
    
    if (pickerViewTag == 1)
        noOfRows = 60;
    else if ( pickerViewTag == 2)
        noOfRows = component ? 60 : 24;
    else {
        int thirdComponent = [pickerView selectedRowInComponent:2];
        int secondComponent = [pickerView selectedRowInComponent:1];
        int selectedYear = thirdComponent + currentYear;
        
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
                noOfRows = 2100 - currentYear;
                break;
            default:
                break;
        }
    }
    return noOfRows;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    NSString *strValue = [NSString stringWithFormat:@"%02d", row + 1];
    if ([pickerView tag] == 3 && component == 2)
        strValue = [NSString stringWithFormat:@"%02d", row + 14];
    UIView *viewTitle = [self addViewInPickerComponentWithText:strValue];
    return viewTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [pickerView reloadAllComponents];
}

#pragma mark - UITableView Delegate & DataSource

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 292, 40)];
    [viewSection setBackgroundColor:[UIColor clearColor]];
    
    NSString *strImage = nil;
    NSString *strSelImage = nil;
    NSString *titleButton = nil;
    
    switch (section) {
        case 0:
            strImage = @"repeat";
            strSelImage = @"selRepeat";
            titleButton = @"  Repeat";
            break;
        case 1:
            strImage = @"iconNotes";
            strSelImage = @"iconSelNotes";
            titleButton = @"  Notes";
            break;
        default:
            break;
    }
    
    UIImage *imageButtonNormal = [[CommonFunctions sharedObject] imageWithName:strImage
                                                                       andType:_pPNGType];
    UIImage *imageButtonSelected = [[CommonFunctions sharedObject] imageWithName:strSelImage
                                                                         andType:_pPNGType];
    
    UIColor *colorSelected = [UIColor colorWithRed:234/255.0f green:178/255.0f blue:23/255.0f alpha:1.0f];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:colorSelected forState:UIControlStateSelected];
    [button setTitle:titleButton forState:UIControlStateNormal];
    [button setImage:imageButtonNormal forState:UIControlStateNormal];
    [button setImage:imageButtonSelected forState:UIControlStateSelected];
    [button setFrame:viewSection.frame];
    [button setTag:section];
    [button addTarget:self
               action:@selector(sectionButtonTouched:)
     forControlEvents:UIControlEventTouchUpInside];
    
    if ((section == 0 && repeatSelected) || (section == 1 && notesSelected))
        [button setSelected:true];
    
    [viewSection addSubview:button];
    
    return viewSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int noOfRows = 0;
    noOfRows = section ? (notesSelected ? 1 : 0) : (repeatSelected ? 4 : 0);
    return noOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = indexPath.section == 0 ? 30 : 120;
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell.textLabel setFont:[UIFont fontWithName:_pFontArialRoundedMT size:12]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    NSString *textCell = nil;
    
    if (indexPath.section == 0)
        textCell = [arrReminderOptions objectAtIndex:indexPath.row];
    else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        textCell = @"";
        
        UIImage *imageBack = [[CommonFunctions sharedObject] imageWithName:@"textViewBack"
                                                                   andType:_pPNGType];
        
        UIImageView *imageViewTextBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 292, 120)];
        [imageViewTextBack setImage:imageBack];
        
        UITextView *textViewCell = [[UITextView alloc] initWithFrame:CGRectMake(2, 2, 288, 116)];
        [textViewCell setBackgroundColor:[UIColor clearColor]];
        [textViewCell setTextColor:[UIColor whiteColor]];
        [textViewCell setDelegate:self];
        
        [cell.contentView addSubview:imageViewTextBack];
        [cell.contentView addSubview:textViewCell];
    }
    [cell.textLabel setText:textCell];
    return cell;
}

@end
