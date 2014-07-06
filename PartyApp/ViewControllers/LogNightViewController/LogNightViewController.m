//
//  LogNightViewController.m
//  PartyApp
//
//  Created by Varun on 20/06/2014.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "LogNightViewController.h"

@interface LogNightViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *arrOptions;
@property (strong, nonatomic) NSArray *arrImages;
@property (strong, nonatomic) NSMutableDictionary *dictOptions;

@end

@implementation LogNightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDefaults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Defaults

- (void)initDefaults {
    self.arrOptions = [NSArray arrayWithObjects:@"Allow Location", @"Notify Friends", @"Post on Facebook", nil];
    self.arrImages = [NSArray arrayWithObjects:@"location", @"commentIcon", @"facebookIcon", nil];
    
    NSNumber *numberValue = [NSNumber numberWithInt:0];
    
    NSMutableDictionary *dictLocation = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"location", @"SelImage",
                                         @"unselLocation", @"UnSelImage",
                                         numberValue, @"Selected", nil];
    
    NSMutableDictionary *dictNotify = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"selCommentIcon", @"SelImage",
                                       @"commentIcon", @"UnSelImage",
                                       numberValue, @"Selected", nil];
    
    NSMutableDictionary *dictFacebook = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"selFacebookIcon", @"SelImage",
                                         @"facebookIcon", @"UnSelImage",
                                         numberValue, @"Selected", nil];
    
    self.dictOptions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                        dictLocation, @"Allow Location",
                        dictNotify, @"Notify Friends",
                        dictFacebook, @"Post on Facebook", nil];
}

#pragma mark - UITableView Delegates & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dictOptions allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    CommonFunctions *commFunc = [CommonFunctions sharedObject];
    
    NSArray *arrOptions = [self.dictOptions allKeys];
    
    int selected = [[[arrOptions objectAtIndex:indexPath.row] objectForKey:@"Selected"] intValue];
    
    if (selected) {
        UIImageView *imgViewAcc = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 13)];
        [imgViewAcc setContentMode:UIViewContentModeCenter];
        
        UIImage *imageAcc = [commFunc imageWithName:@"tick" andType:_pPNGType];
        
        [imgViewAcc setImage:imageAcc];
        
    }
    
    NSString *keyName = selected ? @"UnSelImage" : @"SelImage";
    NSString *imageName = [[arrOptions objectAtIndex:indexPath.row] objectForKey:keyName];
    UIImage *imageMain = [commFunc imageWithName:imageName andType:_pPNGType];
    [cell.imageView setImage:imageMain];
    
    [cell.textLabel setText:[[self.dictOptions allKeys] objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
