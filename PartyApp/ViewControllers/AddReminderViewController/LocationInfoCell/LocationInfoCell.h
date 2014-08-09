//
//  LocationInfoCell.h
//  PartyApp
//
//  Created by Varun on 10/08/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationInfoCell : UITableViewCell {
    
    __weak IBOutlet UILabel *labelName;
    __weak IBOutlet UILabel *labelAddress;
}

- (void)fillLocationInfoCellWithName:(NSString *)name
                          andAddress:(NSString *)address;

@end
