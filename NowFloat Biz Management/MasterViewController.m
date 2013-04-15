//
//  MasterViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 09/03/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "MasterViewController.h"
#import "TalkToBuisnessViewController.h"
#import "SelectImageViewController.h"
#import "BizMessageViewController.h"
#import "BusinessDetailsViewController.h"
#import "BusinessAddressViewController.h"
#import "BusinessContactViewController.h"
#import "BusinessHoursViewController.h"
#import "AnalyticsViewController.h"
#import "LoginViewController.h"
#import "SettingsViewController.h"
#import "PrimaryImageViewController.h"
#import "StoreGalleryViewController.h"



@interface MasterViewController ()

@end

@implementation MasterViewController


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

    isImageGallerySubViewSet=NO;
    
    isManageBizSubViewSet=NO;
    
    revealController = self.revealViewController;
    
    frontNavigationController = (id)revealController.frontViewController;    
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

- (IBAction)homeButtonClicked:(id)sender
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

- (IBAction)manageMyBizButtonClicked:(id)sender
{
    
    if (isImageGallerySubViewSet)
    {
        if (isManageBizSubViewSet)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.20];
            [manageBizSubView setFrame:CGRectMake(0,45,320,45)];
            [imageGallerySubView  setFrame:CGRectMake(0, 90, 320,135)];
            [tertiarySubView setFrame:CGRectMake(0,225,320,178)];
            [UIView commitAnimations];
            isManageBizSubViewSet=NO;
            manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 572);
        }
        
        else
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.20];
            [manageBizSubView setFrame:CGRectMake(0,45,320,220)];
            [imageGallerySubView  setFrame:CGRectMake(0, 265, 320,135)];
            [tertiarySubView setFrame:CGRectMake(0,400,320,178)];
            [UIView commitAnimations];
            isManageBizSubViewSet=YES;
            manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 572);
        }

    }
    
    else
    {
    
        if (isManageBizSubViewSet)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.20];
            [manageBizSubView setFrame:CGRectMake(0,45,320,45)];
            [imageGallerySubView  setFrame:CGRectMake(0, 90, 320, 45)];
            [tertiarySubView setFrame:CGRectMake(0,135,320,178)];
            [UIView commitAnimations];
            isManageBizSubViewSet=NO;
            manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 572);

        }
    
        else
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.20];
            [manageBizSubView setFrame:CGRectMake(0,45,320,220)];
            [imageGallerySubView  setFrame:CGRectMake(0, 265, 320, 45)];
            [tertiarySubView setFrame:CGRectMake(0,310,320,178)];
            [UIView commitAnimations];
            isManageBizSubViewSet=YES;
            manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 572);
        }
        
    }
    
}

- (IBAction)imageGalleryButtonClicked:(id)sender
{
    if (isManageBizSubViewSet)
    {
        if (isImageGallerySubViewSet)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.20];
            [manageBizSubView setFrame:CGRectMake(0,45,320,220)];
            [imageGallerySubView  setFrame:CGRectMake(0,265,320, 45)];
            [tertiarySubView setFrame:CGRectMake(0,310,320,178)];
            [UIView commitAnimations];

            isImageGallerySubViewSet=NO;
            manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 572);

        }
        
        else
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.20];
            [manageBizSubView setFrame:CGRectMake(0,45,320,220)];
            [imageGallerySubView  setFrame:CGRectMake(0,265, 320, 135)];
            [tertiarySubView setFrame:CGRectMake(0,400,320,178)];
            [UIView commitAnimations];

            isImageGallerySubViewSet=YES;
            manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 572);

        }

        
    }
    
    else
    {
    
    if (isImageGallerySubViewSet)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.20];
        [manageBizSubView setFrame:CGRectMake(0,45,320,45)];
        [imageGallerySubView  setFrame:CGRectMake(0, 90, 320, 45)];
        [tertiarySubView setFrame:CGRectMake(0,135,320,178)];
        [UIView commitAnimations];

        isImageGallerySubViewSet=NO;
        manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 572);
    }
    
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.20];
        [manageBizSubView setFrame:CGRectMake(0,45,320,45)];
        [imageGallerySubView  setFrame:CGRectMake(0,90, 320, 135)];
        [tertiarySubView setFrame:CGRectMake(0,222,320,178)];
        [UIView commitAnimations];
        isImageGallerySubViewSet=YES;
        manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 572);

    }

    }
}

- (IBAction)contactInformationButtonClicked:(id)sender
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

- (IBAction)bizHoursButtonClicked:(id)sender
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

- (IBAction)bizDetailsButtonClicked:(id)sender
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

- (IBAction)bizAddressButtonClicked:(id)sender
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

- (IBAction)primaryImageButtonClicked:(id)sender
{
    
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

- (IBAction)secondaryImageButtonClicked:(id)sender
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

- (IBAction)inboxButtonClicked:(id)sender
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

- (IBAction)analyticsButtonClicked:(id)sender
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

- (IBAction)logOutButtonClicked:(id)sender
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Logout" message:@"Are you sure to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag=1;
    [alert show];
    alert=nil;
    

}

- (IBAction)settingsButtonClicked:(id)sender
{
    if (![frontNavigationController.topViewController isKindOfClass:[SettingsViewController   class]] )
    {
        
        SettingsViewController *analyticsController=[[SettingsViewController  alloc]initWithNibName:@"SettingsViewController" bundle:nil];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:analyticsController];
        navigationController.navigationBar.tintColor=[UIColor blackColor];
        
        [revealController setFrontViewController:navigationController animated:YES];
        
    }
    
    else
    {
        [revealController revealToggle:self];
    }
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    
    if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
            
            NSUserDefaults *userDetails=[NSUserDefaults standardUserDefaults];
            
            [userDetails removeObjectForKey:@"userFpId"];
            
            [userDetails removeObjectForKey:@"NFManageFBAccessToken"];
            
            [userDetails removeObjectForKey:@"NFManageFBUserId"];
            
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
            
            if (![frontNavigationController.topViewController isKindOfClass:[LoginViewController  class]] )
            {
                
                LoginViewController *loginController=[[LoginViewController  alloc]initWithNibName:@"LoginViewController" bundle:nil];
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
                navigationController.navigationBar.tintColor=[UIColor blackColor];
                
                [revealController setFrontViewController:navigationController animated:YES];
                
                
            }
            
            else
            {
                [revealController revealToggle:self];
            }
            
        }
        
        
    }
    
    
    else if (alertView.tag==2)
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
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    manageControllerScrollView = nil;
    manageBizSubView = nil;
    imageGallerySubView = nil;
    tertiarySubView = nil;
    [super viewDidUnload];
}

@end
