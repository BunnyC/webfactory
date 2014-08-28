//
//  AddReminderViewController.m
//  PartyApp
//
//  Created by Varun on 7/07/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "AddReminderViewController.h"
#import "UILabel+WhiteUIDatePickerLabels.h"

#import "AppDelegate.h"

#import "WhenView.h"
#import "WhereView.h"

NSString *classReminder = @"PAReminder";

@interface AddReminderViewController () <QBActionStatusDelegate, WhenViewDelegate, WhereViewDelegate> {
    
    NSInteger selectedOption;
    
    BOOL repeatSelected;
    BOOL notesSelected;
    
    CommonFunctions *commFunc;
    
    NSDate *dateSelected;
    int valueSelectedToRepeat;
    NSString *strAddedNote;
    CLLocation *locationSelected;
    
    UIView *loadingView;
    UITextView *cellTextView;
    UIImageView *imageViewCellBack;
    
    WhenView *whenView;
    WhereView *whereView;
    
    CGRect frameDefault;
    BOOL locationServicesEnabled;
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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    commFunc = [CommonFunctions sharedObject];
    [self setupNavigationItems];
    [self initDefaults];
    [self setupTextView];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Methods

- (void)setupNavigationItems {
    
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
}

- (void)initDefaults {
    
    selectedOption = 0;
    
    frameDefault = scrollView.frame;
    
    repeatSelected = false;
    notesSelected = false;
    valueSelectedToRepeat = -1;
    strAddedNote = @"";
    
    if ([CLLocationManager locationServicesEnabled] ) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        locationServicesEnabled = appDelegate.locationServicesEnabled;
        if (!locationServicesEnabled)
            [self showLocationError];
    }
    else {
        [self showLocationError];
    }
    
    UIImage *imageWhenWhereBack = [commFunc imageWithName:@"whenNWhere" andType:_pPNGType];
    UIImage *imageBackViewBottom = [commFunc imageWithName:@"viewBack" andType:_pPNGType];
    
    [viewWhenNWhere setBackgroundColor:[UIColor colorWithPatternImage:imageWhenWhereBack]];
    [viewBottom setBackgroundColor:[UIColor colorWithPatternImage:imageBackViewBottom]];
}

- (void)showLocationError {
    
    locationServicesEnabled = NO;
    NSString *msgError = [NSString stringWithFormat:@"The app is not permitted to use Location Services.\nEnable location services for app from settings and come back again on this view to add location."];
    
    [[[UIAlertView alloc] initWithTitle:@"Location Permission"
                                message:msgError
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil ] show];
    
    locationSelected = [[CLLocation alloc] initWithLatitude:0.0f longitude:0.0f];
}

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

#pragma mark - Navigation Bar Methods

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBAction for Options

- (IBAction)createReminderAction:(id)sender {
    
    //    RType : String (Transport, Night, Personal etc)
    //    RAlarmTime : String (DateTime for Alarm)
    //    RRepeat : Integer(10 - Tomorrow, 70 - Next Week, 1 - Everyday, 7 - Everyweek)
    //    RNotes : String (Notes)
    //    RLocation : Location (Saving location of Reminder)
    
    BOOL validated = YES;
    NSString *msgError = @"";
    if (!selectedOption && validated) {
        msgError = @"Please select an option from Transport, Night Personal etc.";
        validated = NO;
    }
    else if (validated && (!strAddedNote || [strAddedNote length] == 0)) {
        msgError = @"Please add a note for the reminder";
        validated = NO;
    }
    else if (validated && !dateSelected) {
        msgError = @"Please select a date";
        validated = NO;
    }
    else if (validated && !locationSelected) {
        msgError = @"Location selected is not valid";
        validated = NO;
    }
    
    if (validated) {
        
        NSString *reminderType = nil;
        switch (selectedOption) {
            case 1: reminderType = @"Transport";    break;
            case 2: reminderType = @"Night";        break;
            case 3: reminderType = @"Personal";     break;
            case 4: reminderType = @"Food & Drink"; break;
            case 5: reminderType = @"Friends";      break;
            case 6: reminderType = @"Custom";        break;
            default:    break;
        }
        
        int repeatValue = 10;
        switch (valueSelectedToRepeat - 1) {
            case 0: repeatValue = 10;   break;
            case 1: repeatValue = 70;   break;
            case 2: repeatValue = 1;    break;
            case 3: repeatValue = 7;    break;
            default:repeatValue = 10;   break;
        }
        
        QBCOCustomObject *objectLogNight = [QBCOCustomObject customObject];
        [objectLogNight setClassName:classReminder];
        [objectLogNight.fields setObject:reminderType
                                  forKey:@"RType"];
        [objectLogNight.fields setObject:dateSelected
                                  forKey:@"RAlarmTime"];
        [objectLogNight.fields setObject:[NSNumber numberWithBool:repeatValue]
                                  forKey:@"RRepeat"];
        [objectLogNight.fields setObject:strAddedNote
                                  forKey:@"RNotes"];
        [objectLogNight.fields setObject:locationSelected
                                  forKey:@"RLocation"];
        [QBCustomObjects createObject:objectLogNight delegate:self];
        
        loadingView = [[CommonFunctions sharedObject] showLoadingView];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:msgError
                                   delegate:nil cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    }
}

- (IBAction)optionsButtonTouched:(id)sender {
    
    NSInteger tagButton = [sender tag];
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

#pragma mark - When/Where Delegates

- (void)resizeTheViewWithViewType:(int)type {
    
    UIView *subViewType = (type == 1) ? whenView : whereView;
    
    int originForBottomView = 0;
    CGRect frameSubView = subViewType.frame;
    frameSubView.origin.y = CGRectGetMaxY(viewWhenNWhere.frame) + 10;
    [subViewType setFrame:frameSubView];
    [scrollView addSubview:subViewType];
    
    originForBottomView = CGRectGetMaxY(frameSubView) + 20;
    
    CGRect frameBottomView = viewBottom.frame;
    frameBottomView.origin.y = originForBottomView;
    [viewBottom setFrame:frameBottomView];
    
    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, CGRectGetMaxY(frameBottomView))];
}

- (void)resizeScrollViewForEditing:(BOOL)forEditing {
    CGRect frameForScrollView = frameDefault;
    if (forEditing) {
        frameForScrollView = frameDefault;
        int difference = frameDefault.size.height - frameForScrollView.size.height;
        frameForScrollView.size.height = difference > 10 ? frameForScrollView.size.height : frameDefault.size.height - 100;
        
        int offsetForScrollOffset = 100;
        if (![whereView isHidden]) {
            UITableView *tableView = (UITableView *)[whereView viewWithTag:2000];
            if (tableView.frame.size.height > 50)
                offsetForScrollOffset = -tableView.frame.size.height;
            //            if (![mapView isHidden])
            //                offsetForScrollOffset = -200;
        }
        
        
        CGPoint offset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height + offsetForScrollOffset);
        [scrollView setContentOffset:offset animated:YES];
    }
    [scrollView setFrame:frameForScrollView];
}

- (void)selectedValuesInWhenView:(NSDictionary *)dictionary {
    //    datePicker.date, @"SelectedDate",
    //    strAddedNote, @"SelectedNote",
    //    selectedRepeat, @"SelectedRepeat", nil];
    
    valueSelectedToRepeat = [[dictionary objectForKey:@"SelectedRepeat"] intValue];
    strAddedNote = [dictionary objectForKey:@"SelectedNote"];
    dateSelected = [dictionary objectForKey:@"SelectedDate"];
    
    NSLog(@"Dictionary : %@", dictionary);
}

- (void)selectedLocationInWhereView:(CLLocation *)selectedLocation {
    locationSelected = selectedLocation;
}

#pragma mark - IBActions

- (IBAction)whenButtonTouched:(id)sender {
    
    [self resizeScrollViewForEditing:NO];
    
    if (![whereView isHidden])
        [whereView removeFromSuperview];
    
    UIButton *button = (UIButton *)sender;
    [button setSelected:![button isSelected]];
    
    if (!whenView) {
        UINib *nib = [UINib nibWithNibName:@"WhenView" bundle:nil];
        WhenView *objWhenView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        whenView = objWhenView;
    }
    
    int originForBottomView = 0;
    
    if ([button isSelected]) {
        CGRect frameWhenView = whenView.frame;
        frameWhenView.origin.y = CGRectGetMaxY(viewWhenNWhere.frame) + 10;
        [whenView setFrame:frameWhenView];
        [scrollView addSubview:whenView];
        
        originForBottomView = CGRectGetMaxY(frameWhenView) + 20;
    }
    else {
        [whenView removeFromSuperview];
        originForBottomView = CGRectGetMinY(viewWhenNWhere.frame) + 106;
    }
    
    [whenView setDelegate:self];
    
    CGRect frameBottomView = viewBottom.frame;
    frameBottomView.origin.y = originForBottomView;
    [viewBottom setFrame:frameBottomView];
    
    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, CGRectGetMaxY(frameBottomView))];
}

- (IBAction)whereButtonTouched:(id)sender {
    if (locationServicesEnabled) {
        [self resizeScrollViewForEditing:NO];
        
        if (![whenView isHidden])
            [whenView removeFromSuperview];
        
        UIButton *button = (UIButton *)sender;
        [button setSelected:![button isSelected]];
        
        if (!whereView) {
            UINib *nib = [UINib nibWithNibName:@"WhereView" bundle:nil];
            WhereView *objWhereView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
            whereView = objWhereView;
        }
        
        int originForBottomView = 0;
        
        if ([button isSelected]) {
            CGRect frameWhereView = whereView.frame;
            frameWhereView.origin.y = CGRectGetMaxY(viewWhenNWhere.frame) + 10;
            [whereView setFrame:frameWhereView];
            [scrollView addSubview:whereView];
            
            originForBottomView = CGRectGetMaxY(frameWhereView) + 20;
        }
        else {
            [whereView removeFromSuperview];
            originForBottomView = CGRectGetMinY(viewWhenNWhere.frame) + 106;
        }
        
        [whereView setDelegate:self];
        
        CGRect frameBottomView = viewBottom.frame;
        frameBottomView.origin.y = originForBottomView;
        [viewBottom setFrame:frameBottomView];
        
        [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, CGRectGetMaxY(frameBottomView))];
    }
    else
        [self showLocationError];
}

#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
-(void)completedWithResult:(Result*)result {
    [[CommonFunctions sharedObject] hideLoadingView:loadingView];
    [[[UIAlertView alloc] initWithTitle:@"Reminder"
                                message:@"Saved Successfully"
                               delegate:nil
                      cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show ];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
