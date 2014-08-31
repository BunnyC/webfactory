//
//  GroupUserCell.h
//  PartyApp
//
//  Created by Gaganinder Singh on 30/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupUserCell : UITableViewCell<QBActionStatusDelegate>
{
    
    __weak IBOutlet UILabel *lbl_GrpName;
    __weak IBOutlet UIImageView *img_GrpImage;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    
}

-(void)setCellValues:(id)obj;
@end
