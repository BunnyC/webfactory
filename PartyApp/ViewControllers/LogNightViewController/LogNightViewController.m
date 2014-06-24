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
}

#pragma mark - UITableView Delegates & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    NSString *imageName = [self.arrImages objectAtIndex:indexPath.row];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    [cell.imageView setImage:image];
    
    [cell.textLabel setText:[self.arrOptions objectAtIndex:indexPath.row]];
    return cell;
}

@end
