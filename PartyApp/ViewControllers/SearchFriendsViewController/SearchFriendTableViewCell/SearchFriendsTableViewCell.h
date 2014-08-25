//
//  SearchFriendsTableViewCell.h
//  PartyApp
//
//  Created by Gaganinder Singh on 17/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFriendsTableViewCell : UITableViewCell<QBActionStatusDelegate>
{
    
    __weak IBOutlet UILabel *lbl_FRName;
    __weak IBOutlet UIImageView *img_FRImage;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    
}

-(void)setCellValues:(id)obj;
@end
