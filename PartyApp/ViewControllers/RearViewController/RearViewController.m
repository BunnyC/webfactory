//
//  RearViewController.m
//  PartyApp
//
//  Created by Gaganinder Singh on 16/08/14.
//  Copyright (c) 2014 WebFactory. All rights reserved.
//

#import "RearViewController.h"
#import "RearTableViewCell.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "FriendsViewController.h"
#import "AddToGroupViewController.h"
#import "AddReminderViewController.h"
@interface RearViewController ()
{
    NSInteger _presentedRow;
}
@end

@implementation RearViewController

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
    [self setup];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setup
{
    commFunc = [CommonFunctions sharedObject];
    self.navigationItem.title=@"Menu";
    arrMenus=[[NSArray alloc]initWithObjects:@"My Profile",@"Friends",@"Groups",@"Reminders",@"First Aid",@"Durgs Info",@"Settings", nil];
//    cell=[[RearTableViewCell alloc]init];
//    cell.delegate=self;
//    cell.callBackViewController=@selector(btnMenuTextClicked:);
    //cell.delegate=self;
    //tblViewRear registerNib:<#(UINib *)#> forCellReuseIdentifier:<#(NSString *)#>
}

#pragma mark - TableView Delegate Method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMenus.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    
   RearTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   
    if(!cell)
    {
        NSArray *nib;
        nib=[[NSBundle mainBundle]loadNibNamed:@"RearTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.delegate=self;
        cell.callBackViewController=@selector(btnMenuTextClicked:);
    }

    cell.btnMenuText.tag=indexPath.row;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.imgVwCell setImage:[UIImage imageNamed:[NSString stringWithFormat:@"side%d",indexPath.row+1]]];
    [cell.btnMenuText setTitle:[arrMenus objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    
    // selecting row
    NSInteger row = indexPath.row;
    
    // if we are trying to push the same row or perform an operation that does not imply frontViewController replacement
    // we'll just set position and return
    
    if ( row == _presentedRow )
    {
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }
//    else if (row == 2)
//    {
//        [revealController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
//        return;
//    }
//     else
//    {
//        [commFunc showUnderDevelopmentAlert];
//        return;
//    }
    
    // otherwise we'll create a new frontViewController and push it with animation
    
    UIViewController *newFrontController = nil;
    
    if (row == 0)
    {
        if([commFunc isDeviceiPhone5])
        {
        newFrontController = [[ProfileViewController alloc] init];
        }
        else
        {
            newFrontController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController4" bundle:nil];
        }
    }
    
    else if (row == 1)
    {
        newFrontController = [[FriendsViewController alloc] init];
    }
    else if(row==2)
    {
        AddToGroupViewController *obj=[[AddToGroupViewController alloc]initWithNibName:@"AddToGroupViewController" bundle:nil];
        obj.objUser=[commFunc getQBUserObjectFromUserDefaults];
        obj.isShowNavigationBarButton=YES;
        newFrontController=obj;
        
    }
    else if(row==3)
    {
        NSString *xibName = [commFunc isDeviceiPhone5] ? @"AddReminderViewController" : @"AddReminderViewController4";
        AddReminderViewController *objAddReminderView = [[AddReminderViewController alloc] initWithNibName:xibName bundle:nil];
       // [self.navigationController pushViewController:objAddReminderView animated:YES];
        objAddReminderView.isShowNavigationBarButton=TRUE;
        newFrontController=objAddReminderView;
    }
    else
    {
        [commFunc showUnderDevelopmentAlert];
        return;
    }

    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];

    [navigationController.navigationBar setTranslucent:FALSE];

    
    //[navigationController pushViewController:newFrontController animated:YES];
    [revealController pushFrontViewController:navigationController animated:YES];
    
    _presentedRow = row;  // <- store the presented row
}


#pragma mark - ButtonMenu Clicked

-(void)btnMenuTextClicked:(id)sender
{
    NSNumber *numTag=(NSNumber *)sender;
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    UINavigationController *tempNavigationController=delegate.navController;
    NSArray *arrViewController=[tempNavigationController viewControllers];
    switch ([numTag integerValue])
    {
        case 0:
        {
            for (id obj  in arrViewController)
            {
                RearViewController *objRear=(RearViewController *)obj;
                if([objRear isKindOfClass:[RearViewController class]])
                {
                    [delegate.navController pushViewController:objRear animated:YES];
                }
            }
        }
            break;
            
        default:
            break;
    }
    //NSLog(@"%@",self.navigationController.topViewController);
}


@end
