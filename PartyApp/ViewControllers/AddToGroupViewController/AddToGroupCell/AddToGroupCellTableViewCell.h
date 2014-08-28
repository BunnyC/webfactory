//
//  AddToGroupCellTableViewCell.h
//  PartyApp
//
//  Created by Gaganinder Singh on 20/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddToGroupCellTableViewCell : UITableViewCell
{
    
    __weak IBOutlet UILabel *lbl_NumberOfGroup;
    __weak IBOutlet UILabel *lbl_GroupName;
}

-(void)setCellValues:(id)obj;

@end
