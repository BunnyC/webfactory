//
//  RearTableViewCell.m
//  PartyApp
//
//  Created by Gaganinder Singh on 16/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "RearTableViewCell.h"

@implementation RearTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnMenuClicked:(id)sender {
    
    
    if([_delegate respondsToSelector:_callBackViewController])
        {
            [_delegate performSelectorInBackground:_callBackViewController withObject:[NSNumber numberWithInteger:[sender tag]]];
        }
    
  
}
@end
