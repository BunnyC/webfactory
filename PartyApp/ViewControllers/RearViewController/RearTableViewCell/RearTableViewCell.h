//
//  RearTableViewCell.h
//  PartyApp
//
//  Created by Gaganinder Singh on 16/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RearTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnMenuText;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwCell;

@property (nonatomic,assign)id delegate;
@property(nonatomic,assign)SEL callBackViewController;

- (IBAction)btnMenuClicked:(id)sender;


@end
