//
//  LocationInfoCell.m
//  PartyApp
//
//  Created by Varun on 10/08/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "LocationInfoCell.h"

@implementation LocationInfoCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillLocationInfoCellWithName:(NSString *)name
                          andAddress:(NSString *)address {
    
    [labelName setText:name];
    [labelAddress setText:address];
}

@end
