//
//  SearchFriendsTableViewCell.m
//  PartyApp
//
//  Created by Gaganinder Singh on 17/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "SearchFriendsTableViewCell.h"

@implementation SearchFriendsTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    img_FRImage.layer.cornerRadius=img_FRImage.frame.size.width/2;
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
    lbl_FRName.text=[objCustom.fields objectForKey:@"FR_Name"];
        NSInteger blobID=[[objCustom.fields objectForKey:@"FR_BlobID"] integerValue];
    activityIndicator .hidden=NO;
    [activityIndicator startAnimating];
    [QBContent TDownloadFileWithBlobID:blobID delegate:self];
        
    }
    else if([(QBUUser *)obj isKindOfClass:[QBUUser class]])
    {
        
      QBUUser *userObj=(QBUUser *)obj;
      lbl_FRName.text=userObj.login;
        activityIndicator .hidden=NO;
        [activityIndicator startAnimating];
       [QBContent TDownloadFileWithBlobID:userObj.blobID delegate:self];

        
    }
    
}

-(void)completedWithResult:(Result *)result{
    // Download file result
    
    if ([result isKindOfClass:[QBCFileDownloadTaskResult class]]){
    
        if(result.success){
            QBCFileDownloadTaskResult *res = (QBCFileDownloadTaskResult *)result;
            NSData *fileData = res.file;
            
            UIImage *imageProfile = [UIImage imageWithData:fileData];
            [img_FRImage setImage:imageProfile];
            activityIndicator .hidden=YES;
            [activityIndicator stopAnimating];

            
           
        }
    }
}


@end
