//
//  MasterController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "MasterController.h"
#import "UIExpandableTableView.h"
#import "GHCollapsingAndSpinningTableViewCell.h"
#import "SWRevealViewController.h"
#import "TalkToBuisnessViewController.h"
#import "SelectImageViewController.h"
#import "BizMessageViewController.h"
#import "BusinessDetailsViewController.h"
#import "BusinessAddressViewController.h"
#import "BusinessContactViewController.h"
#import "BusinessHoursViewController.h"
#import "AnalyticsViewController.h"


@interface MasterController ()

@end



#define kUITableExpandableSection 1

@implementation MasterController
@synthesize tileImageurl ;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView = [[UIExpandableTableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f) style:UITableViewStylePlain];
    
    manageStoreDetails =[[NSMutableArray alloc]initWithObjects:@"\t\t\t\t\t\t\t\t\t\t\t\tContact Information",@"\t\t\t\t\t\t\t\t\t\t\t\tBusiness Hours",@"\t\t\t\t\t\t\t\t\t\t\t\tBusiness Details",@"\t\t\t\t\t\t\t\t\t\t\t\tBusiness Address" ,nil];
    dataArray=[[NSMutableArray alloc]initWithObjects:@"HOME",@"MANAGE MY STORE",@"IMAGE GALLERY",@"INBOX",@"ANALYTICS", nil];
        
}




#pragma mark - UIExpandableTableViewDatasource

- (BOOL)tableView:(UIExpandableTableView *)tableView canExpandSection:(NSInteger)section
{
    // return YES, if the section should be expandable
    return section == kUITableExpandableSection;
}

- (BOOL)tableView:(UIExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section {
    // return YES, if you need to download data to expand this section. tableView will call tableView:downloadDataForExpandableSection: for this section
    return !_didDownloadData;
}

- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(UIExpandableTableView *)tableView expandingCellForSection:(NSInteger)section
{
    NSString *CellIdientifier = @"GHCollapsingAndSpinningTableViewCell";
    
    GHCollapsingAndSpinningTableViewCell *cell = (GHCollapsingAndSpinningTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdientifier];
    
    if (cell == nil)
    {
        cell = [[GHCollapsingAndSpinningTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdientifier];
    }
    
    if (section == 1)
    {
        cell.textLabel.text = @"   MANAGE MY STORE";
        cell.imageView.image=[UIImage imageNamed:@"manage.png"];
    }
    
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:12];

    return cell;
}

#pragma mark - UIExpandableTableViewDelegate

- (void)tableView:(UIExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
{
    // download your data here
            
    double delayInSeconds =0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {

        _didDownloadData = YES;
        [tableView expandSection:section animated:YES];
    });
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 1)
    {
        return manageStoreDetails.count + 1;
        // return +1 here, because this section can be expanded

    }
    
        
    else if (section == 0 || section ==2 || section==3 || section==4)
    {
        return 1;
    }
    
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSInteger row = indexPath.section;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundView = backgroundView;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    // Configure the cell...
    
    if (indexPath.section == 1)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = [manageStoreDetails objectAtIndex:indexPath.row - 1];
        // use -1 here, because the expanding cell is always at row 0
        cell.selectionStyle=UITableViewCellSelectionStyleNone;        
        
    }
    
    
    else{
        
        if (row==0) {
            cell.textLabel.text = @"HOME";
            cell.imageView.image=[UIImage imageNamed:@"home.png"];

        }
        
        else if (row ==2)
        {
            cell.textLabel.text = @"IMAGE GALLERY";
            
            cell.imageView.image=[UIImage imageNamed:@"gallery.png"];
            
        }
        
        
        else if(row==3)
        {
        
            cell.textLabel.text = @"INBOX";
            cell.imageView.image=[UIImage imageNamed:@"inbox.png"];

        
        }
        
        
        else if(row==4)
            
        {
        
            cell.textLabel.text = @"ANALYTICS";
            cell.imageView.image=[UIImage imageNamed:@"analytics.png"];

        
        }
        
    
    }
    
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:12];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = self.revealViewController;
    
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;

    

    
    NSInteger row=[indexPath section];
    
    if (indexPath.section == 1)
    {
        
        if (indexPath.row==1)
        {
            if ( ![frontNavigationController.topViewController isKindOfClass:[BusinessContactViewController class]] )
            {
                BusinessContactViewController *frontViewController = [[BusinessContactViewController alloc] init];
                            
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                navigationController.navigationBar.tintColor=[UIColor blackColor];
                
                [revealController setFrontViewController:navigationController animated:YES];
            }
            
            else
            {
                [revealController revealToggle:self];
            }

        }
        
        
        else if(indexPath.row==2)
            
        {
            
            if ( ![frontNavigationController.topViewController isKindOfClass:[BusinessHoursViewController class]] )
            {
                BusinessHoursViewController *frontViewController = [[BusinessHoursViewController alloc] init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                navigationController.navigationBar.tintColor=[UIColor blackColor];
                
                [revealController setFrontViewController:navigationController animated:YES];
            }
            
            else
            {
                [revealController revealToggle:self];
            }
            

            
        
        }
        

        
        
        else if(indexPath.row==3)
        {
        
            
            if ( ![frontNavigationController.topViewController isKindOfClass:[BusinessDetailsViewController class]] )
            {
                BusinessDetailsViewController *frontViewController = [[BusinessDetailsViewController alloc] init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                navigationController.navigationBar.tintColor=[UIColor blackColor];
                
                [revealController setFrontViewController:navigationController animated:YES];
            }
            
            else
            {
                [revealController revealToggle:self];
            }
            
            

        }
        
        
        
        
        
        else if(indexPath.row==4)
        {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Uh-Oh" message:@"Please call our customer care no +919160004303 to change your address" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            
            [alert show];
            alert=nil;
            
        }
        
    }
    
    else
    {


        if (row == 0)
        {
            if ( ![frontNavigationController.topViewController isKindOfClass:[BizMessageViewController class]] )
            {
                BizMessageViewController *frontViewController = [[BizMessageViewController alloc] init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                navigationController.navigationBar.tintColor=[UIColor blackColor];
                
                [revealController setFrontViewController:navigationController animated:YES];
            }
            
            else
            {
                [revealController revealToggle:self];
            }
        }
        
        
        else if(row ==2)
        {
        
        
            if (![frontNavigationController.topViewController isKindOfClass:[SelectImageViewController    class]] )
            {
                
                SelectImageViewController *selectGallery=[[SelectImageViewController      alloc]initWithNibName:@"SelectImageViewController" bundle:nil];
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:selectGallery];
                navigationController.navigationBar.tintColor=[UIColor blackColor];
                
                [revealController setFrontViewController:navigationController animated:YES];
                
            }
            
            else
            {
                [revealController revealToggle:self];
            }
            

        
        }
        
        
        else if (row == 3)
        {
            if (![frontNavigationController.topViewController isKindOfClass:[TalkToBuisnessViewController class]] )
            {
                
                TalkToBuisnessViewController *talkController=[[TalkToBuisnessViewController  alloc]initWithNibName:@"TalkToBuisnessViewController" bundle:nil];
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:talkController];
                navigationController.navigationBar.tintColor=[UIColor blackColor];
                
                [revealController setFrontViewController:navigationController animated:YES];
                
            }
            
            else
            {
                [revealController revealToggle:self];
            }
            
        
        
        
        
        
        }


        
        else if (row == 4)
        {
            if (![frontNavigationController.topViewController isKindOfClass:[AnalyticsViewController   class]] )
            {
                
                AnalyticsViewController *analyticsController=[[AnalyticsViewController  alloc]initWithNibName:@"AnalyticsViewController" bundle:nil];
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:analyticsController];
                navigationController.navigationBar.tintColor=[UIColor blackColor];
                
                [revealController setFrontViewController:navigationController animated:YES];
                
            }
            
            else
            {
                [revealController revealToggle:self];
            }
            
            
            
            
            
            
        }

        
    }
}


- (void)viewDidUnload {
    masterTableView = nil;
    [super viewDidUnload];
}
@end