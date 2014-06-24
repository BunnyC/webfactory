//
//  LogNightViewController.h
//  PartyApp
//
//  Created by Varun on 20/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "BaseViewController.h"

@interface LogNightViewController : BaseViewController{
    
    __weak IBOutlet UIView *viewRatings;
    __weak IBOutlet UITextView *txtViewNotes;
    __weak IBOutlet UIView *viewSharingOptions;
    __weak IBOutlet UITableView *tableViewOptions;
}

@end
