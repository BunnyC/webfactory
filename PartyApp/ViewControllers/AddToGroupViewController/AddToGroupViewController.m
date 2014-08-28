//
//  AddToGroupViewController.m
//  PartyApp
//
//  Created by Gaganinder Singh on 20/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "AddToGroupViewController.h"
#import "AddToGroupCellTableViewCell.h"
@interface AddToGroupViewController ()

@end

@implementation AddToGroupViewController

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
    
    arrOfGroups=[[NSMutableArray alloc]initWithObjects:@"Dane Group",@"Fan Group", nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)btnAddGroupAction:(id)sender {
}

#pragma mark -TableView Delegate Method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrOfGroups.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierCell=@"cell";
    AddToGroupCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierCell];
    if(!cell)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AddToGroupCellTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id obj=[arrOfGroups objectAtIndex:indexPath.row];
    [cell setCellValues:obj];
    
    
    return cell;
}

@end
