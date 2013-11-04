//
//  LeftViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 11/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "LeftViewController.h"
#import "BizMessageViewController.h"
#import "TalkToBuisnessViewController.h"
#import "StoreViewController.h"
#import "PrimaryImageViewController.h"
#import "SettingsViewController.h"
#import "AnalyticsViewController.h"
#import "BusinessDetailsViewController.h"
#import "BusinessAddressViewController.h"
#import "BusinessContactViewController.h"
#import "BusinessHoursViewController.h"
#import "TutorialViewController.h"



#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)


@interface LeftViewController ()

@end

@implementation LeftViewController

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
 
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];

    revealController = self.revealViewController;
    
    frontNavigationController = (id)revealController.frontViewController;
    
    widgetNameArray=[[NSArray alloc]initWithObjects:@"Home",@"Talk-To-Business",@"Biz Store",@"Social Options",@"Aanalytics",@"Feedback", nil];
    
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }

}


#pragma mark - Expanding

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    if (section==3 || section==6)
    {
        return YES;
    }
    
    return NO;
}



#pragma UITableView


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 9;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    NSString *sectionName;
    
    switch (section)
    {
        case 0:
            sectionName = [widgetNameArray objectAtIndex:0];
            break;
        case 1:
            sectionName = [widgetNameArray objectAtIndex:1];
            break;

        case 2:
            sectionName = [widgetNameArray objectAtIndex:2];
            break;

        case 4:
            sectionName = [widgetNameArray objectAtIndex:3];
            break;

        case 5:
            sectionName = [widgetNameArray objectAtIndex:4];
            break;
            
        case 7:
            sectionName = [widgetNameArray objectAtIndex:5];
            break;
            
        default:
            sectionName = @"";
            break;
    }
    
    return sectionName;


}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([expandedSections containsIndex:section] && section==3)
        {
            return 3; // return rows when expanded
        }
        
        if ([expandedSections containsIndex:section] && section==6)
        {
            return 5; // return rows when expanded
        }
        
        
        return 1; // only top row showing
    }
    
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    UIImageView *cellBgImgView=[[UIImageView alloc]initWithFrame:CGRectMake(10,4.5, 240, 46)];
    
    [cellBgImgView setBackgroundColor:[UIColor clearColor]];
    
    [cellBgImgView setImage:[UIImage imageNamed:@"menu-bg.png"]];
    
    [cell addSubview:cellBgImgView];


    UILabel *widgetNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(70,4.5,240,46)];
    
    [widgetNameLbl setBackgroundColor:[UIColor clearColor]];
    
    [widgetNameLbl setFont:[UIFont fontWithName:@"Helvetica-Neue" size:16.0]];
    
    [cell addSubview:widgetNameLbl];

    
    UIImageView *widgetImgView=[[UIImageView alloc]initWithFrame:CGRectMake(20,15, 26, 26)];
    
    [widgetImgView setBackgroundColor:[UIColor clearColor]];
    
    [cell addSubview:widgetImgView];
    
    
    arrowImageView=[[UIImageView alloc]initWithFrame:CGRectMake(220,20, 15, 15)];
    
    [arrowImageView setBackgroundColor:[UIColor clearColor]];
    
    [arrowImageView setImage:[UIImage imageNamed:@"down arrow_1.png"]];
    
    
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            
            if (indexPath.section==3)
            {
                widgetNameLbl.text = @"Image Gallery";
                widgetImgView.image=[UIImage imageNamed:@"image_1.png"];
                [cell addSubview:arrowImageView];
            }
            
            if (indexPath.section==6)
            {
                widgetNameLbl.text = @"Manage Website";
                widgetImgView.image=[UIImage imageNamed:@"manage_1.png"];
                [cell addSubview:arrowImageView];
            }
            
            
        }
        
        
        
        else
        {
            if (indexPath.section==3)
            {
                
                if ([indexPath row]==1 && indexPath.section==3)
                {

                    widgetNameLbl.text = @"    Featured Image";
                    widgetImgView.image=[UIImage imageNamed:@""];
                    cell.accessoryView = nil;

                }

                if ([indexPath row]==2 && indexPath.section==3)
                {
                    widgetNameLbl.text = @"    Gallery Image";
                    widgetImgView.image=[UIImage imageNamed:@""];
                    cell.accessoryView = nil;

                    
                }
    
            }
            
            if (indexPath.section==6)
            {
                
                if ([indexPath row]==1 && indexPath.section==6)
                {
                    widgetNameLbl.text = @"   Business Name";
                    widgetImgView.image=[UIImage imageNamed:@""];
                    cell.accessoryView = nil;

                }
                
                if ([indexPath row]==2 && indexPath.section==6)
                {
                    
                    widgetNameLbl.text = @"   Contact Numbers";
                    widgetImgView.image=[UIImage imageNamed:@""];
                    cell.accessoryView = nil;

                }
                
                if ([indexPath row]==3 && indexPath.section==6)
                {
                    
                    widgetNameLbl.text = @"   Business Address";
                    widgetImgView.image=[UIImage imageNamed:@""];
                    cell.accessoryView = nil;

                }
                
                if ([indexPath row]==4 && indexPath.section==6)
                {
                    widgetNameLbl.text = @"   Business Hours";
                    widgetImgView.image=[UIImage imageNamed:@""];
                    cell.accessoryView = nil;

                    
                }

            }

        }
    }
    else
    {
        
        if (indexPath.section==0)
        {
            widgetNameLbl.text=@"Home";
            widgetImgView.image=[UIImage imageNamed:@"home_1.png"];

        }

        if (indexPath.section==1)
        {
            widgetNameLbl.text=@"Talk-To-Business";
            widgetImgView.image=[UIImage imageNamed:@"inbox_1.png"];

        }

    
        if (indexPath.section==2)
        {
            widgetNameLbl.text=@"Biz Store";
            widgetImgView.image=[UIImage imageNamed:@"storeicon.png"];
            
        }
        

        if (indexPath.section==4)
        {
            widgetNameLbl.text=@"Social Options";
            widgetImgView.image=[UIImage imageNamed:@"settings_1.png"];
        }

        
        if (indexPath.section==5)
        {
            widgetNameLbl.text=@"Analytics";
            widgetImgView.image=[UIImage imageNamed:@"analytics_1.png"];
        }
        
        
        if (indexPath.section==7)
        {
            widgetNameLbl.text=@"Feedback";
            widgetImgView.image=[UIImage imageNamed:@"feedback_1.png"];
            
        }
        
        
        if (indexPath.section==8)
        {
            widgetNameLbl.text=@"Logout";
            widgetImgView.image=[UIImage imageNamed:@"logout_1.png"];
            
        }
        
        
    }
    
    
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            [leftPanelTableView beginUpdates];
            
            // only first row toggles exapand/collapse
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
                
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
//            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];

                NSLog(@"currentlyNotExpanded");

            }
            
            
            else
            {
        
                
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                            [UIView beginAnimations:nil context:NULL];
                
                
                NSLog(@"currentlyExpanded");
            }
            
            
            [leftPanelTableView endUpdates];
        }
    }

    
    
        if (indexPath.section==0)
        {
            
            if ([frontNavigationController.topViewController isKindOfClass:[BizMessageViewController class]] )
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
        
        
        if (indexPath.section==1)
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
    
    
        if (indexPath.section==2)
        {
            
            StoreViewController *storeController=[[StoreViewController alloc]initWithNibName:@"StoreViewController" bundle:Nil];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:storeController];
            
            navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            
            [self presentModalViewController:navigationController animated:YES];

        }
    
    
        if (indexPath.section==3)
        {


            
            if (indexPath.row==1) {

                if ( ![frontNavigationController.topViewController isKindOfClass:[PrimaryImageViewController class]] )
                {
                    PrimaryImageViewController *pImageViewController = [[PrimaryImageViewController alloc] init];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pImageViewController];
                    navigationController.navigationBar.tintColor=[UIColor blackColor];
                    
                    [revealController setFrontViewController:navigationController animated:YES];
                }
                
                else
                {
                    [revealController revealToggle:self];
                }

                
            }
            
            
            if (indexPath.row==2)
            {

                
                if ( ![frontNavigationController.topViewController isKindOfClass:[FGalleryViewController class]] )
                {
                    networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:networkGallery];
                    navigationController.navigationBar.tintColor=[UIColor blackColor];
                    
                    [revealController setFrontViewController:navigationController animated:YES];
                }
                
                else
                {
                    [revealController revealToggle:self];
                }
                

                
            }
            
            
            
        }
    
    
        if (indexPath.section==4)
        {

            if (![frontNavigationController.topViewController isKindOfClass:[SettingsViewController   class]] )
            {
                
                SettingsViewController *sController=[[SettingsViewController  alloc]initWithNibName:@"SettingsViewController" bundle:nil];
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:sController];
                navigationController.navigationBar.tintColor=[UIColor blackColor];
                
                [revealController setFrontViewController:navigationController animated:YES];
                
            }
            
            else
            {
                [revealController revealToggle:self];
            }

            
        }
    
    
        if (indexPath.section==5)
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
    
        if (indexPath.section==6)
        {

            
            
            if (indexPath.row==1)
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
            
            if (indexPath.row==2) {
                
                
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
            
            if (indexPath.row==3)
            {
                
                if (![frontNavigationController.topViewController isKindOfClass:[BusinessAddressViewController class]] )
                {
                    
                    BusinessAddressViewController *addressController=[[BusinessAddressViewController  alloc]initWithNibName:@"BusinessAddressViewController" bundle:nil];
                    
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addressController];
                    
                    navigationController.navigationBar.tintColor=[UIColor blackColor];
                    
                    [revealController setFrontViewController:navigationController animated:YES];
                    
                }
                
                else
                {
                    [revealController revealToggle:self];
                }
                
                
            }

            if (indexPath.row==4) {
                
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
            
            
        }
    
    
        if (indexPath.section==8)
        {
        
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag=1;
            [alert show];
            alert=nil;

        
        }
    
    
    
}


#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    
    if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
            
            NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
            
            [navigationArray removeAllObjects];
            
            self.navigationController.viewControllers = navigationArray;
            
            NSUserDefaults *userDetails=[NSUserDefaults standardUserDefaults];
            
            [userDetails removeObjectForKey:@"userFpId"];
            
            [userDetails removeObjectForKey:@"NFManageFBAccessToken"];
            
            [userDetails removeObjectForKey:@"NFManageFBUserId"];
            
            [userDetails removeObjectForKey:@"NFFacebookName"];
            
            [userDetails removeObjectForKey:@"NFManageUserFBAdminDetails"];
            
            [userDetails synchronize];
            
            [appDelegate.storeDetailDictionary removeAllObjects];
            [appDelegate.msgArray removeAllObjects];
            [appDelegate.fpDetailDictionary removeAllObjects];
            [appDelegate.dealDateArray removeAllObjects];
            [appDelegate.dealDescriptionArray removeAllObjects];
            [appDelegate.dealId removeAllObjects];
            [appDelegate.arrayToSkipMessage removeAllObjects];
            [appDelegate.inboxArray removeAllObjects];
            [appDelegate.userMessagesArray removeAllObjects];
            [appDelegate.userMessageDateArray removeAllObjects];
            [appDelegate.userMessageContactArray removeAllObjects];
            [appDelegate.storeTimingsArray removeAllObjects];
            [appDelegate.storeContactArray removeAllObjects];
            [appDelegate.storeAnalyticsArray removeAllObjects];
            [appDelegate.storeVisitorGraphArray removeAllObjects];
            [appDelegate.secondaryImageArray removeAllObjects];
            [appDelegate.dealImageArray removeAllObjects];
            [appDelegate.fbUserAdminArray removeAllObjects];
            [appDelegate.fbUserAdminIdArray removeAllObjects];
            [appDelegate.fbUserAdminAccessTokenArray removeAllObjects];
            [appDelegate.socialNetworkNameArray removeAllObjects];
            [appDelegate.socialNetworkIdArray removeAllObjects];
            [appDelegate.socialNetworkAccessTokenArray removeAllObjects];
            [appDelegate.multiStoreArray removeAllObjects];
            [appDelegate.searchQueryArray removeAllObjects];
            appDelegate.storeEmail=@"No Description";
            [appDelegate.storeWidgetArray removeAllObjects];
            appDelegate.storeRootAliasUri=[NSMutableString stringWithFormat:@""];
            appDelegate.storeCategoryName=[NSMutableString stringWithFormat:@""];
            [appDelegate.deletedFloatsArray removeAllObjects];
            
            /*
             if (![frontNavigationController.topViewController isKindOfClass:[LoginViewController  class]] )
             {
             
             LoginViewController *loginController=[[LoginViewController  alloc]initWithNibName:@"LoginViewController" bundle:nil];
             
             UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
             navigationController.navigationBar.tintColor=[UIColor blackColor];
             
             [revealController setFrontViewController:navigationController animated:YES];
             
             
             }
             */
            
            if (![frontNavigationController.topViewController isKindOfClass:[TutorialViewController class]] )
            {
                
                TutorialViewController *tutorialController=[[TutorialViewController  alloc]initWithNibName:@"TutorialViewController" bundle:nil];
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tutorialController];
                navigationController.navigationBar.tintColor=[UIColor blackColor];
                
                [revealController setFrontViewController:navigationController animated:YES];
                
                
            }
            
            
            else
            {
                [revealController revealToggle:self];
            }
            
        }
        
        
    }
    
    
    if (alertView.tag==2)
    {
        if (buttonIndex==1)
        {
            
            UIDevice *device = [UIDevice currentDevice];
            
            if ([[device model] isEqualToString:@"iPhone"] )
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:09160004303"]]];
            }
            
            else
            {
                UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [notPermitted show];
                
            }
            
        }
        
    }
    
    if (alertView.tag==1001) {
        
        if (buttonIndex==1)
        {
            StoreViewController *storeController=[[StoreViewController alloc]initWithNibName:@"StoreViewController" bundle:Nil];
            
            storeController.currentScrollPage=1;
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:storeController];
            
            // You can even set the style of stuff before you show it
            navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            
            // And now you want to present the view in a modal fashion
            [self presentModalViewController:navigationController animated:YES];
            
        }
        
    }
    
    
    
    if (alertView.tag==1002)
    {
        
        if (buttonIndex==1)
        {
            StoreViewController *storeController=[[StoreViewController alloc]initWithNibName:@"StoreViewController" bundle:Nil];
            
            
            storeController.currentScrollPage=2;
            
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:storeController];
            
            // You can even set the style of stuff before you show it
            navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            
            // And now you want to present the view in a modal fashion
            [self presentModalViewController:navigationController animated:YES];
            
        }
        
        
        
    }
    
    
    
}



#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    num = [appDelegate.secondaryImageArray count];
	return num;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    
    return FGalleryPhotoSourceTypeNetwork;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    return [appDelegate.secondaryImageArray objectAtIndex:index];
}

- (void)handleTrashButtonTouch:(id)sender
{
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
    
}

- (void)handleEditCaptionButtonTouch:(id)sender
{
    // here we could implement some code to change the caption for a stored image
}

-(void)showGallery
{
    
    networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    [self.navigationController pushViewController:networkGallery animated:YES];
    networkGallery=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
