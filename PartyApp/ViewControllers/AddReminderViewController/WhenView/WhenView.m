//
//  WhenView.m
//  PartyApp
//
//  Created by Varun on 17/08/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "WhenView.h"

@interface WhenView () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate> {
    
    __weak IBOutlet UIDatePicker *datePicker;
    __weak IBOutlet UITableView *tableViewReminder;
    __weak IBOutlet UIImageView *imgViewWhenWhere;
    
    UITextView *cellTextView;
    UIImageView *imageViewCellBack;
    
    NSString *strAddedNote;
    NSArray *arrReminderOptions;
    NSMutableDictionary *dictReminderOptions;
    
    int repeatValueSelectedForTimer;
    int sectionToExpand;
    BOOL expandSection1;
    BOOL expandSection2;
}

@end

@implementation WhenView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [self initVariablesForWhenView];
}

#pragma mark - Init Defaults

- (void)initVariablesForWhenView {
    
    CommonFunctions *commFunc = [CommonFunctions sharedObject];
    UIImage *imageWhenWhereBack = [commFunc imageWithName:@"whenNWhere" andType:_pPNGType];
    UIImage *resizableImage = [imageWhenWhereBack resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2) resizingMode:UIImageResizingModeStretch];
    [imgViewWhenWhere setImage:resizableImage];
    
    repeatValueSelectedForTimer = -1;
    sectionToExpand = -1;
    
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
}

#pragma mark - Section Button Action

- (void)sectionButtonTouched:(UIButton *)sender {
    
    if (cellTextView) {
        [cellTextView setHidden:![sender tag]];
        [imageViewCellBack setHidden:![sender tag]];
    }
    
    int heightIncrement = 120;
    
    if ([sender tag] == 0) {
        expandSection1 = YES;
        expandSection2 = NO;
        [tableViewReminder setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }
    else {
        expandSection1 = NO;
        expandSection2 = YES;
        [tableViewReminder setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        if (repeatValueSelectedForTimer >= 0)
            heightIncrement += 30;
    }
    
    CGRect frameTable = tableViewReminder.frame;
    frameTable.size.height = 80 + heightIncrement;
    [tableViewReminder setFrame:frameTable];
    
    CGRect frameSelf = self.frame;
    frameSelf.size.height = CGRectGetMaxY(frameTable);
    [self setFrame:frameSelf];
    
    if ([_delegate respondsToSelector:@selector(resizeTheViewWithViewType:)])
        [_delegate resizeTheViewWithViewType:1];
    
    [tableViewReminder reloadData];
}

#pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([[textView text] isEqualToString:@"Write your note here..."])
        [textView setText:@""];
    
    if ([_delegate respondsToSelector:@selector(resizeScrollViewForEditing:)])
        [_delegate resizeScrollViewForEditing:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    strAddedNote = textView.text;
    [self sendValuesBackToMainView];
    if ([_delegate respondsToSelector:@selector(resizeScrollViewForEditing:)])
        [_delegate resizeScrollViewForEditing:NO];
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? 30 : 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger noOfRows = 0;
    switch (section) {
        case 0:
            if (expandSection1)
                noOfRows = [[dictReminderOptions allKeys] count];
            else if (repeatValueSelectedForTimer >= 0)
                noOfRows = 1;
            break;
        case 1:
            noOfRows = expandSection2 ? 1 : 0;
            break;
        default:
            break;
    }
    return noOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
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
    
    [button setSelected:section == 0 ? expandSection1 : expandSection2];
    
    [viewSection addSubview:button];
    
    return viewSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    [cell.textLabel setFont:[UIFont fontWithName:_pFontArialRoundedMT size:12]];
    NSString *textCell = nil;
    
    for (UITextView *textView in cell.subviews)
        if ([textView isKindOfClass:[UITextView class]])
            [textView removeFromSuperview];
    
    if (indexPath.section == 0) {
        
        int indexValue = (int)indexPath.row;
        
        NSDictionary *dictIndex = [dictReminderOptions objectForKey:[NSNumber numberWithInt:indexValue]];
        textCell = [dictIndex objectForKey:@"Title"];
        
        if (expandSection1) {
            if (repeatValueSelectedForTimer >= 0) {
                if (indexValue == repeatValueSelectedForTimer)
                    [cell.textLabel setTextColor:[UIColor colorWithRed:234/255.0f green:178/255.0f blue:23/255.0f alpha:1.0f]];
                else
                    [cell.textLabel setTextColor:[UIColor whiteColor]];
            }
        }
        else {
            if (repeatValueSelectedForTimer >= 0) {
                [cell.textLabel setTextColor:[UIColor colorWithRed:234/255.0f green:178/255.0f blue:23/255.0f alpha:1.0f]];
                textCell = [[dictReminderOptions objectForKey:[NSNumber numberWithInt:repeatValueSelectedForTimer]] objectForKey:@"Title"];
            }
        }
    }
    else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        textCell = @"";
        
        if (!cellTextView) {
            UIImage *imageBack = [[CommonFunctions sharedObject] imageWithName:@"whenNWhere"
                                                                       andType:_pPNGType];
            
            UIImage *resizableImage = [imageBack resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2) resizingMode:UIImageResizingModeStretch];
            
            UIImageView *imageViewTextBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 292, 120)];
            [imageViewTextBack setImage:resizableImage];
            
            UITextView *textViewCell = [[UITextView alloc] initWithFrame:CGRectMake(2, 2, 288, 116)];
            [textViewCell setBackgroundColor:[UIColor clearColor]];
            [textViewCell setTag:100];
            [textViewCell setTextColor:[UIColor whiteColor]];
            [textViewCell setDelegate:self];
            
            if ([strAddedNote length])
                [textViewCell setText:strAddedNote];
            else
                [textViewCell setText:@"Write your note here..."];
            
            cellTextView = textViewCell;
            imageViewCellBack = imageViewTextBack;
        }
        [cell.contentView addSubview:imageViewCellBack];
        [cell.contentView addSubview:cellTextView];
    }
    
    [cell.textLabel setText:textCell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        repeatValueSelectedForTimer = (int)indexPath.row;
        [self sendValuesBackToMainView];
    }
    [tableView performSelector:@selector(reloadData)
                    withObject:nil afterDelay:0.2f];
}

#pragma mark - Send Values to Main View

- (void)sendValuesBackToMainView {
    if ([_delegate respondsToSelector:@selector(selectedValuesInWhenView:)]) {
        
        NSNumber *selectedRepeat = [NSNumber numberWithInt:(repeatValueSelectedForTimer + 1)];
        NSString *strNote = !strAddedNote.length ? @"" : strAddedNote;
        
        NSDictionary *dictValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                    datePicker.date, @"SelectedDate",
                                    strNote, @"SelectedNote",
                                    selectedRepeat, @"SelectedRepeat", nil];
        [_delegate selectedValuesInWhenView:dictValues];
    }
}

#pragma mark - Touch Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UIView *viewTouched = [[touches anyObject] view];
    if (![viewTouched isKindOfClass:[UITextView class]]) {
        
        if (![[cellTextView text] isEqualToString:@"Write your note here..."])
            strAddedNote = @"";

        [cellTextView resignFirstResponder];
        [self sendValuesBackToMainView];
    }
}

@end
