//
//  AddToGroupCellTableViewCell.m
//  PartyApp
//
//  Created by Gaganinder Singh on 20/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "AddToGroupCellTableViewCell.h"

@implementation AddToGroupCellTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCellValues:(id)obj
{
    if([(QBCOCustomObject *)obj isKindOfClass:[QBCOCustomObject class]])
    {
        QBCOCustomObject *objCustom=(QBCOCustomObject *)obj;
        lbl_GroupName.text=[objCustom.fields objectForKey:@"FR_Name"];
        
    }
    
}
@end
