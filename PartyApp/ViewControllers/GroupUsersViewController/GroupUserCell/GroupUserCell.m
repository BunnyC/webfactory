//
//  GroupUserCell.m
//  PartyApp
//
//  Created by Gaganinder Singh on 30/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "GroupUserCell.h"

@implementation GroupUserCell

- (void)awakeFromNib
{
    // Initialization code
    img_GrpImage.layer.cornerRadius=img_GrpImage.frame.size.width/2;
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
        lbl_GrpName.text=[objCustom.fields objectForKey:@"GroupUserName"];
        NSInteger blobID=[[objCustom.fields objectForKey:@"GroupUserBlobId"] integerValue];
        activityIndicator .hidden=NO;
        [activityIndicator startAnimating];
        [QBContent TDownloadFileWithBlobID:blobID delegate:self];
        
    }
    else if([(QBUUser *)obj isKindOfClass:[QBUUser class]])
    {
        
        QBUUser *userObj=(QBUUser *)obj;
        lbl_GrpName.text=userObj.login;
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
            [img_GrpImage setImage:imageProfile];
            activityIndicator .hidden=YES;
            [activityIndicator stopAnimating];
            
            
            
        }
    }
}


@end
