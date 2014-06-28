//
//  PATextField.m
//  PartyApp
//
//  Created by Varun on 29/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "PATextField.h"

@implementation PATextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect textRect = CGRectMake(bounds.origin.x + 5,
                                 bounds.origin.y,
                                 bounds.size.width - 10,
                                 bounds.size.height);
    return textRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect editingTextRect = CGRectMake(bounds.origin.x + 5,
                                        bounds.origin.y,
                                        bounds.size.width - 10,
                                        bounds.size.height);
    return editingTextRect;
}

@end
