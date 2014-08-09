//
//  AddReminderViewController.m
//  PartyApp
//
//  Created by Varun on 7/07/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "AddReminderViewController.h"
#import "UILabel+WhiteUIDatePickerLabels.h"

#import "FetchPlaces.h"
#import "LocationCell.h"
#import "LocationInfoCell.h"

@interface AddReminderViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate> {
    
    NSInteger selectedOption;
    
    BOOL repeatSelected;
    BOOL notesSelected;
    
    NSArray *arrReminderOptions;
    NSMutableDictionary *dictReminderOptions;
    CommonFunctions *commFunc;
    
    int valueSelectedToRepeat;
    NSMutableArray *arrFetchedLocations;
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
    
    repeatSelected = false;
    notesSelected = false;
    valueSelectedToRepeat = -1;
    
    arrReminderOptions = [[NSArray alloc] initWithObjects:
                          @"Tomorrow", @"Next Week", @"Everyday", @"Every Week", nil];
    
    dictReminderOptions = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [arrReminderOptions count]; i ++) {
        
        NSMutableDictionary *indexDict = [[NSMutableDictionary alloc] init];
        [indexDict setObject:[arrReminderOptions objectAtIndex:i] forKey:@"Title"];
        [indexDict setObject:[NSNumber numberWithInt:0] forKey:@"Selected"];
        
        [dictReminderOptions setObject:indexDict forKey:[NSNumber numberWithInt:i]];
        indexDict = nil;
    }
    
    UIImage *imageWhenWhereBack = [commFunc imageWithName:@"whenNWhere" andType:_pPNGType];
    UIImage *imageBackViewBottom = [commFunc imageWithName:@"viewBack" andType:_pPNGType];
    
    UIImage *resizableImage = [imageWhenWhereBack resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2) resizingMode:UIImageResizingModeStretch];
    
    [viewWhenNWhere setBackgroundColor:[UIColor colorWithPatternImage:imageWhenWhereBack]];
    [viewBottom setBackgroundColor:[UIColor colorWithPatternImage:imageBackViewBottom]];
    [imageViewBack setImage:resizableImage];
    
    //    [viewAddReminder.layer setBorderColor:[UIColor blueColor].CGColor];
    //    [viewAddReminder.layer setBorderWidth:1.0f];
    //
    //    [tableViewReminderInfo.layer setBorderColor:[UIColor redColor].CGColor];
    //    [tableViewReminderInfo.layer setBorderWidth:1.f];
    
    [viewAddLocation.layer setBorderColor:[UIColor blueColor].CGColor];
    [viewAddLocation.layer setBorderWidth:1.0f];
    [tableViewLocation.layer setBorderColor:[UIColor redColor].CGColor];
    [tableViewLocation.layer setBorderWidth:1.f];
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
    
    [viewAddLocation setHidden:YES];
    [viewAddReminder setFrame:CGRectMake(0, frameWW.origin.y, frameAR.size.width, frameAR.size.height)];
    [viewAddReminder setHidden:![button isSelected]];
    [viewBottom setFrame:frameVB];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(frameVB))];
}

- (void)setLocationFramesAsPerUpdatesWithSelection:(BOOL)selection {
    CGRect frameWW = viewWhenNWhere.frame;
    CGRect frameAL = viewAddLocation.frame;
    CGRect frameVB = viewBottom.frame;
    
    int heightIncrement = (int)arrFetchedLocations.count * 44;
    if (arrFetchedLocations.count > 5)
        heightIncrement = 220;
    
    frameAL.size.height += arrFetchedLocations.count > 1 ? heightIncrement - 44 : 0;
    
    if (selection) {
        frameWW.origin.y += (frameWW.size.height + 10);
        frameVB.origin.y = CGRectGetMaxY(frameWW) + frameAL.size.height + 10;
    }
    else {
        frameWW.origin.y -= (frameWW.size.height + 10);
        frameVB.origin.y = self.view.frame.size.height - frameVB.size.height;
    }
    
    [viewAddReminder setHidden:YES];
    [viewAddLocation setFrame:CGRectMake(0, frameWW.origin.y, frameAL.size.width, frameAL.size.height)];
    [viewAddLocation setHidden:!selection];
    [viewBottom setFrame:frameVB];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(frameVB))];
}

- (IBAction)whereButtonTouched:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    [button setSelected:![button isSelected]];
    
    [self setLocationFramesAsPerUpdatesWithSelection:[button isSelected]];
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
    
    BOOL selected = NO;
    NSArray *arrKeys = [dictReminderOptions allKeys];
    for (int i = 0; i < [arrKeys count]; i ++) {
        NSDictionary *indexDict = [dictReminderOptions objectForKey:[NSNumber numberWithInt:i]];
        if ([[indexDict objectForKey:@"Selected"] integerValue]) {
            selected = YES;
            break;
        }
    }
    
    heightIncrement += selected ? 30 : 0;
    
    CGRect frameTable = tableViewReminderInfo.frame;
    frameTable.size.height += heightIncrement;
    [tableViewReminderInfo setFrame:frameTable];
    
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

- (void)placesResult:(NSMutableDictionary *)dictResponse {
    
    if (arrFetchedLocations) {
        [arrFetchedLocations removeAllObjects];
        arrFetchedLocations = nil;
    }
    if ([[dictResponse objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"No results found with this keyword."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    }
    else {
        arrFetchedLocations = [dictResponse objectForKey:@"results"];
        [tableViewLocation reloadData];
    }
    [self setLocationFramesAsPerUpdatesWithSelection:YES];
}

- (IBAction)doneButtonTouched:(id)sender {
    
    [textFieldLocation resignFirstResponder];
    if ([[textFieldLocation text] length]) {
        NSString *keyword = [textFieldLocation.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSString *stringToHit = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?keyword=%@&location=37.787930,-122.4074990&radius=5000&key=AIzaSyCHTaIkOrh6LFZt5dpDqxE2V6YkRuIr1nI", keyword];
        
        FetchPlaces *objFetchPlaces = [[FetchPlaces alloc] init];
        [objFetchPlaces fetchPlacesInController:self
                                   withselector:@selector(placesResult:)
                                        withURL:stringToHit
                             toShowWindowLoader:YES];
        
    }
    else {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"Please enter some keyword to search."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    }
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

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint offset = CGPointMake(0, scrollView.contentSize.height - ([UIScreen mainScreen].bounds.size.height - 64));
    [scrollView setContentOffset:offset];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (tableView == tableViewReminderInfo) ? 2 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (tableView == tableViewReminderInfo) ? 40 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *viewSection = nil;
    if (tableView == tableViewReminderInfo) {
        viewSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 292, 40)];
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
        [button.titleLabel setFont:[UIFont fontWithName:_pFontArialMT size:15]];
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
    }
    return viewSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger noOfRows = 0;
    if (tableView == tableViewReminderInfo) {
        NSUInteger countKeys = [[dictReminderOptions allKeys] count];
        noOfRows = section ? (notesSelected ? 1 : 0) : (repeatSelected ? countKeys : (valueSelectedToRepeat > -1 ? 1 : 0));
    }
    else {
        noOfRows = [arrFetchedLocations count] + 1;
    }
    return noOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = indexPath.section == 0 ? 30 : 120;
    if (tableView == tableViewReminderInfo) {
        rowHeight = indexPath.section == 0 ? 30 : 120;
    }
    else {
        rowHeight = 44;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"Cell";
    id cell = nil;
    if (tableView == tableViewReminderInfo) {
        
        UITableViewCell *simpleCell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (simpleCell == nil) {
            
            simpleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            [simpleCell.textLabel setTextColor:[UIColor whiteColor]];
            [simpleCell setBackgroundColor:[UIColor clearColor]];
            [simpleCell.contentView setBackgroundColor:[UIColor clearColor]];
        }
        [simpleCell.textLabel setFont:[UIFont fontWithName:_pFontArialRoundedMT size:12]];
        NSString *textCell = nil;
        
        if (indexPath.section == 0) {
            
            int indexValue = (int)indexPath.row;
            if (!repeatSelected && valueSelectedToRepeat > -1) {
                indexValue = valueSelectedToRepeat;
            }
            else if (repeatSelected && valueSelectedToRepeat == (int)indexPath.row)
                [simpleCell.textLabel setTextColor:[UIColor colorWithRed:234/255.0f green:178/255.0f blue:23/255.0f alpha:1.0f]];
            
            NSDictionary *dictIndex = [dictReminderOptions objectForKey:[NSNumber numberWithInt:indexValue]];
            textCell = [dictIndex objectForKey:@"Title"];
        }
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
            
            [simpleCell.contentView addSubview:imageViewTextBack];
            [simpleCell.contentView addSubview:textViewCell];
        }
        [simpleCell.layer setBorderColor:[UIColor redColor].CGColor];
        [simpleCell.layer setBorderWidth:1.0f];
        [simpleCell.textLabel setText:textCell];
        cell = simpleCell;
    }
    else {
        
        UITableViewCell *simpleCell = [tableView dequeueReusableCellWithIdentifier:cellID];
        LocationCell *cellLocation = nil;
        LocationInfoCell *cellLocationInfo = nil;
        
        if (indexPath.row == 0) {
            if (simpleCell == nil) {
                simpleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                [simpleCell.textLabel setTextColor:[UIColor whiteColor]];
                [simpleCell setBackgroundColor:[UIColor clearColor]];
                [simpleCell.contentView setBackgroundColor:[UIColor clearColor]];
            }
            
            [simpleCell.textLabel setFont:[UIFont fontWithName:_pFontArialRoundedMT size:15]];
            [simpleCell.imageView setImage:[UIImage imageNamed:@"unselLocation"]];
            [simpleCell.imageView setContentMode:UIViewContentModeCenter];
            
            [simpleCell.textLabel setText:@"Current Location"];
            
            cell = simpleCell;
        }
        else if (indexPath.row <= arrFetchedLocations.count) {
            if (cellLocationInfo == nil)
                cellLocationInfo = [[[NSBundle mainBundle] loadNibNamed:@"LocationInfoCell"
                                                                  owner:self
                                                                options:nil] objectAtIndex:0];
            NSDictionary *indexDict = [arrFetchedLocations objectAtIndex:indexPath.row - 1];
            [cellLocationInfo fillLocationInfoCellWithName:[indexDict objectForKey:@"name"]
                                                andAddress:[indexDict objectForKey:@"vicinity"]];
            cell = cellLocationInfo;
        }
        else {
            if (cellLocation == nil)
                cellLocation = [[[NSBundle mainBundle] loadNibNamed:@"LocationCell"
                                                              owner:self
                                                            options:nil] objectAtIndex:0];
            cell = cellLocation;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && repeatSelected) {
        valueSelectedToRepeat = (int)indexPath.row;
        NSArray *arrKeys = [dictReminderOptions allKeys];
        for (int i = 0; i < [arrKeys count]; i ++) {
            NSMutableDictionary *dictIndex = [dictReminderOptions objectForKey:[NSNumber numberWithInt:(int)indexPath.row]];
            
            int number = (i == indexPath.row) ? 1 : 0;
            [dictIndex setObject:[NSNumber numberWithInt:number] forKey:@"Selected"];
            
            //            NSMutableDictionary *mutDictAtIndex = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dictIndex objectForKey:@"Title"], @"Title", [NSNumber numberWithInt:1], @"Selected", nil];
            //            [dictReminderOptions removeObjectForKey:[NSNumber numberWithInt:valueSelectedToRepeat]];
            //            [dictReminderOptions setObject:mutDictAtIndex forKey:[NSNumber numberWithInt:valueSelectedToRepeat]];
            
        }
        [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
        NSLog(@"Dict : %@", dictReminderOptions.description);
    }
}

@end
