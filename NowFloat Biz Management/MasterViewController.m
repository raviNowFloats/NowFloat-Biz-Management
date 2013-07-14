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
#import "PrimaryImageViewController.h"
#import "StoreGalleryViewController.h"
#import "SettingsController.h"
#import "SettingsViewController.h"
#import "NSString+CamelCase.h"
#import "UIColor+HexaString.h"
#import <QuartzCore/QuartzCore.h>
#import "Mixpanel.h"



#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

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

-(void)viewDidAppear:(BOOL)animated
{
    if (appDelegate.searchQueryArray.count >0)
    {
        [notificationImageView setHidden:NO];
        [notificationLabel setHidden:NO];
        [notificationLabel setText:[NSString stringWithFormat:@"%d",appDelegate.searchQueryArray.count]];
        
    }
    
    
    else
    {
        [notificationImageView  setHidden:YES];
        [notificationLabel setHidden:YES];
    }

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
        
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width,530);
    
    
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
    
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Home"];
    

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
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Manage Biz"];

    
    if (isImageGallerySubViewSet)
    {
        if (isManageBizSubViewSet)
        {
            [manageArrow   setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(360))];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.20];
            [imageGallerySubView  setFrame:CGRectMake(20,132,220,143)];
            [tertiarySubView setFrame:CGRectMake(20,283,220,269)];
            [manageBizSubView setFrame:CGRectMake(0,112,220,46)];
            [feedbackSubView setFrame:CGRectMake(0, 168, 220, 46)];
            [logoutSubView setFrame:CGRectMake(0, 224, 220, 46)];
            [UIView commitAnimations];
            isManageBizSubViewSet=NO;
            manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width,630);
        }
        
        else
        {            
            [manageArrow   setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180))];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.20];
            [imageGallerySubView  setFrame:CGRectMake(20,132, 220,143)];
            [tertiarySubView setFrame:CGRectMake(20,283,220,269+196)];
            [manageBizSubView setFrame:CGRectMake(0,112,220,242)];
            [feedbackSubView setFrame:CGRectMake(0, 364, 220, 46)];
            [logoutSubView setFrame:CGRectMake(0, 420, 220, 46)];
            [UIView commitAnimations];
            isManageBizSubViewSet=YES;
            manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width,780);
        }
        
    }
    
    else
    {
        if (isManageBizSubViewSet)
        {
            [manageArrow   setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(360))];

            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.20];
            [manageBizSubView setFrame:CGRectMake(0,112,220,46)];
            [imageGallerySubView  setFrame:CGRectMake(20,132, 220, 46)];
            [feedbackSubView setFrame:CGRectMake(0, 168, 220, 46)];
            [logoutSubView setFrame:CGRectMake(0, 224, 220, 46)];
            [tertiarySubView setFrame:CGRectMake(20,188,220,269)];
            [UIView commitAnimations];
            isManageBizSubViewSet=NO;
            manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 630);
            
        }
        
        else
        {
            [manageArrow setTransform:CGAffineTransformMakeRotation(-DEGREES_TO_RADIANS(180))];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.20];
            [manageBizSubView setFrame:CGRectMake(0,112,220,242)];
            [feedbackSubView setFrame:CGRectMake(0, 364, 220, 46)];
            [logoutSubView setFrame:CGRectMake(0, 420, 220, 46)];
            [imageGallerySubView  setFrame:CGRectMake(20,132, 220, 46)];
            [tertiarySubView setFrame:CGRectMake(20,188,220,269+196)];
            [UIView commitAnimations];
            isManageBizSubViewSet=YES;
            manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 630);
        }
        
    }
    
}

- (IBAction)imageGalleryButtonClicked:(id)sender
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Image Gallery"];
    
    if (isManageBizSubViewSet)
    {
        if (isImageGallerySubViewSet)
        {
            [galleryArrow   setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(360))];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.20];
            [imageGallerySubView  setFrame:CGRectMake(20, 132, 220, 46)];
            [tertiarySubView setFrame:CGRectMake(20,188,220,269+196)];
            [UIView commitAnimations];
            isImageGallerySubViewSet=NO;
            manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 630);
        }        
        else
        {
            [galleryArrow   setTransform:CGAffineTransformMakeRotation(-DEGREES_TO_RADIANS(180))];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.20];
            [imageGallerySubView  setFrame:CGRectMake(20,132, 220,143)];
            [tertiarySubView setFrame:CGRectMake(20,283,220,269+196)];
            [UIView commitAnimations];
            isImageGallerySubViewSet=YES;
            manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 780);
        }
    }    
    else
    {        
        if (isImageGallerySubViewSet)
        {
            [galleryArrow   setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(360))];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.20];
            [imageGallerySubView  setFrame:CGRectMake(20, 132, 220, 46)];
            [tertiarySubView setFrame:CGRectMake(20,188,220,269)];
            [UIView commitAnimations];            
            isImageGallerySubViewSet=NO;
            manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 630);
        }        
        else
        {
            [galleryArrow   setTransform:CGAffineTransformMakeRotation(-DEGREES_TO_RADIANS(180))];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.20];
            [imageGallerySubView  setFrame:CGRectMake(20,132, 220,143)];
            [tertiarySubView setFrame:CGRectMake(20,283,220,269)];
            [UIView commitAnimations];
            isImageGallerySubViewSet=YES;
            manageControllerScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 630);
        }
        
    }
}

- (IBAction)contactInformationButtonClicked:(id)sender
{
    
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Contact Information"];

    
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
    
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Business Hour"];

    
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
    
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Business Details"];

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
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Business Address"];

    
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
    
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Featured image"];

    
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
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Other Images"];

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
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Inbox"];

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
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Logout"];

    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag=1;
    [alert show];
    alert=nil;
    
    
}

- (IBAction)settingsButtonClicked:(id)sender
{
    
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Settings"];

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

- (IBAction)feedBackButtonClicked:(id)sender
{
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Feedback"];
    
    if ([MFMailComposeViewController canSendMail])
    {        
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        
        mail.mailComposeDelegate = self;
        
        
        NSArray *arrayRecipients=[NSArray arrayWithObject:@"hello@nowfloats.com"];
        
        [mail setToRecipients:arrayRecipients];
        
        [mail setSubject:[NSString stringWithFormat:@"Feedback from %@",[[appDelegate.businessName lowercaseString] stringByConvertingCamelCaseToCapitalizedWords]]];
                
        [self presentModalViewController:mail animated:YES];
        
    }
    
    else
    {
        UIAlertView *mailAlert=[[UIAlertView alloc]initWithTitle:@"Configure" message:@"Please configure email in settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [mailAlert show];
        
        mailAlert=nil;
        
    }
    
    
    
}





- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    
    [self dismissModalViewControllerAnimated:YES];
    
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
    homeSubview = nil;
    inboxSubView = nil;
    analyticsSubView = nil;
    settingsSubView = nil;
    feedbackSubView = nil;
    logoutSubView = nil;
    manageArrow = nil;
    galleryArrow = nil;
    notificationImageView = nil;
    notificationLabel = nil;
    [super viewDidUnload];
}

@end
