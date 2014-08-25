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
#import "PrimaryImageViewController.h"
#import "SettingsViewController.h"
#import "AnalyticsViewController.h"
#import "BusinessDetailsViewController.h"
#import "BusinessAddressViewController.h"
#import "BusinessContactViewController.h"
#import "BusinessHoursViewController.h"
#import "TutorialViewController.h"
#import "BusinessLogoUploadViewController.h"
#import "SearchQueryViewController.h"
#import "UserSettingsViewController.h"
#import "LogOutController.h"
#import "PopUpView.h"
#import "UIColor+HexaString.h"
#import "Mixpanel.h"
#import "BizStoreViewController.h"
#import <sys/utsname.h>
#import "BizStoreDetailViewController.h"
#import "NFInstaPurchase.h"
#import "LeftTableCell.h"
#import "BusinessProfileController.h"
#import "ImageGallery.h"
#import "InternationalProPack.h"

#define BusinessTimingsTag 1006
#define ImageGalleryTag 1004
#define AutoSeoTag 1008
#define TalkToBusinessTag 1002


#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)


@interface SelectionButton : UIButton
@property (nonatomic,strong) NSIndexPath *index;
@end

@implementation SelectionButton
@synthesize index;
@end



@interface LeftViewController ()<PopUpDelegate,NFInstaPurchaseDelegate>
{
    float viewHeight;
    UILabel *notificationLabel;
    UIImageView *notificationImageView;
    NSString *version;
    NFInstaPurchase *popUpView;
}
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

-(void)viewDidAppear:(BOOL)animated
{
    [leftPanelTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];

    version = [[UIDevice currentDevice] systemVersion];

    [leftPanelTableView setScrollsToTop:YES];
    leftPanelTableView.bounces = NO;
    
    leftPanelTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    leftPanelTableView.scrollEnabled = NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            viewHeight=480;
        }
        
        else
        {
            viewHeight=568;
        }
    }

    if (version.floatValue<7.0)
    {
        if (viewHeight==480)
        {
            [leftPanelTableView setFrame:CGRectMake(leftPanelTableView.frame.origin.x, leftPanelTableView.frame.origin.y+10, leftPanelTableView.frame.size.width, 440)];
        }
        
        else
        {
            [leftPanelTableView setFrame:CGRectMake(leftPanelTableView.frame.origin.x, leftPanelTableView.frame.origin.y+10, leftPanelTableView.frame.size.width, leftPanelTableView.frame.size.height-40)];
   
        }
    }
    
    
    if (version.floatValue>=7.0)
    {
        if (viewHeight==568 )
        {
            [leftPanelTableView setFrame:CGRectMake(leftPanelTableView.frame.origin.x, leftPanelTableView.frame.origin.y+20, leftPanelTableView.frame.size.width, leftPanelTableView.frame.size.height-20)];
        }
        
        else
        {
            [leftPanelTableView setFrame:CGRectMake(leftPanelTableView.frame.origin.x, leftPanelTableView.frame.origin.y+20, leftPanelTableView.frame.size.width, 440)];

        }
        
    }
    
    leftPanelTableView.backgroundColor = [UIColor colorFromHexCode:@"#545454"];

    
    self.view.backgroundColor = [UIColor colorFromHexCode:@"#545454"];
    
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    mixPanel.showNotificationOnActive = NO;
    
    revealController = self.revealViewController;
    
    frontNavigationController = (id)revealController.frontViewController;
    
   // widgetNameArray=[[NSArray alloc]initWithObjects:@"Home",@"Talk-To-Business",@"Search Queries",@"NowFloats Store",@"Social Sharing",@"Analytics",@"Settings", nil];
    
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }

}


#pragma UITableView
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 9;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LeftTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftTableCell"];
    
    leftPanelTableView.separatorColor = [UIColor colorFromHexCode:@"#767676"];
   
    
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LeftTableCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor colorFromHexCode:@"#545454"];

    
     cell.headTextLabel.textColor = [UIColor colorFromHexCode:@"#e9e9e9"];
     cell.lineView.backgroundColor = [UIColor colorFromHexCode:@"#767676"];
    
    if(indexPath.row == 0)
    {
        cell.iconView.image = [UIImage imageNamed:@"Circle.png"];
        cell.headTextLabel.text = @"Home";
        cell.arrowView.image = [UIImage imageNamed:@"Arrow.png"];
       
    }
    else if (indexPath.row==1)
    {
        cell.iconView.image = [UIImage imageNamed:@"BusinessProfile.png"];
        cell.headTextLabel.text = @"Business Profile";
        cell.arrowView.image = [UIImage imageNamed:@"Arrow.png"];
    }
    else if (indexPath.row==2)
    {
        cell.iconView.image = [UIImage imageNamed:@"Stats.png"];
        cell.headTextLabel.text = @"Analytics";
        cell.arrowView.image = [UIImage imageNamed:@"Arrow.png"];
    }
    else if (indexPath.row==3)
    {
        cell.iconView.image = [UIImage imageNamed:@"NFStore.png"];
        cell.headTextLabel.text = @"NowFloats Store";
        cell.arrowView.image = [UIImage imageNamed:@"Arrow.png"];
    }
    else if (indexPath.row==4)
    {
        cell.iconView.image = [UIImage imageNamed:@"TOB.png"];
        cell.headTextLabel.text = @"Business Enquiries";
        if (![appDelegate.storeWidgetArray containsObject:@"TOB"])
        {
            cell.arrowView.frame = CGRectMake(cell.arrowView.frame.origin.x-5, cell.arrowView.frame.origin.y-5, 20, 20);
            cell.arrowView.image = [UIImage imageNamed:@"newLock.png"];
        }
        else
        {
            cell.arrowView.image = [UIImage imageNamed:@"Arrow.png"];
        }
        
    }
    else if (indexPath.row==5)
    {
        cell.iconView.image = [UIImage imageNamed:@"Gal.png"];
        cell.headTextLabel.text = @"Image Gallery";
//        if (![appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
//        {
//            cell.arrowView.frame = CGRectMake(cell.arrowView.frame.origin.x-5, cell.arrowView.frame.origin.y-5, 20, 20);
//            cell.arrowView.image = [UIImage imageNamed:@"newLock.png"];
//        }
//        else
//        {
            cell.arrowView.image = [UIImage imageNamed:@"Arrow.png"];
        
    }
   
    else
    {
        cell.iconView.image = [UIImage imageNamed:@"Set.png"];
        cell.headTextLabel.text = @"Settings";
        cell.arrowView.image = [UIImage imageNamed:@"Arrow.png"];
        UIView *lineViewCell = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 260, 2)];
        lineView.backgroundColor = [UIColor colorFromHexCode:@"#767676"];
        [lineViewCell addSubview:lineView];
        [cell.contentView addSubview:lineViewCell];
    }
    

    
    
  
    UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = [UIColor colorFromHexCode:@"474747"];
    cell.selectedBackgroundView =customColorView;
    
    return cell;
}


-(void)tableViewBtnClicked:(SelectionButton*)button
{
    UITableView *table = leftPanelTableView;
    
    NSIndexPath *indexPath = button.index;
    
    [[table delegate] tableView:table didSelectRowAtIndexPath:indexPath];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    
    if(indexPath.row == 0)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Home"];
        
        if([appDelegate.storeDetailDictionary objectForKey:@"isFromNotification"] == [NSNumber numberWithBool:YES])
        {
            [appDelegate.storeDetailDictionary removeObjectForKey:@"isFromNotification"];
            BizMessageViewController *deepLinkView = [[BizMessageViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:deepLinkView];
            
            [revealController setFrontViewController:navController animated:YES];
        }
        else
        {
            BizMessageViewController *frontViewController = [[BizMessageViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
            navigationController.navigationBar.tintColor=[UIColor blackColor];
            
            [revealController setFrontViewController:navigationController animated:YES];
        }
    }
    else if(indexPath.row == 1)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Business Profile"];
        
       
        
        if (![frontNavigationController.topViewController isKindOfClass:[AnalyticsViewController   class]] )
        {
            
            BusinessProfileController *businessProfile=[[BusinessProfileController alloc]initWithNibName:@"BusinessProfileController" bundle:Nil];
            
            
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:businessProfile];
            navigationController.navigationBar.tintColor=[UIColor blackColor];
            
            [revealController setFrontViewController:navigationController animated:YES];
            
        }
        
        else
        {
            [revealController revealToggle:self];
        }
        
    }
    else if(indexPath.row == 2)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Analytics button clicked"];
        
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
    else if(indexPath.row == 3)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"NowFloats Store button clicked"];
        
        if ( ![frontNavigationController.topViewController isKindOfClass:[BizStoreViewController class]] )
        {
            BizStoreViewController *storeController=[[BizStoreViewController alloc]initWithNibName:@"BizStoreViewController" bundle:Nil];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:storeController];
            
            navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            
            [revealController setFrontViewController:navigationController animated:YES];
        }
        
        else
        {
            [revealController revealToggle:self];
        }
    }
    else if(indexPath.row == 4)
    {
        if (![appDelegate.storeWidgetArray containsObject:@"TOB"])
        {
            /*
             PopUpView *ttbPopUp=[[PopUpView alloc]init];
             ttbPopUp.delegate=self;
             ttbPopUp.descriptionText=@"Get Talk To Business feature to let your website visitors contact you directly from the site.";
             ttbPopUp.titleText=@"Buy in store";
             ttbPopUp.tag=1001;
             ttbPopUp.popUpImage=[UIImage imageNamed:@"storedetailttb.png"];
             ttbPopUp.successBtnText=@"Buy";
             ttbPopUp.cancelBtnText=@"Cancel";
             [ttbPopUp showPopUpView];
             */
            
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            
            [mixpanel track:@"buy_ttbclicked"];
            
            if(![[appDelegate.storeDetailDictionary objectForKey:@"CountryPhoneCode"]  isEqual: @"91"])
            {
                popUpView=[[NFInstaPurchase alloc]init];
                
                popUpView.delegate=self;
                
                popUpView.selectedWidget=TalkToBusinessTag;
                
                [popUpView showInstantBuyPopUpView];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"It's Upgrade Time!" message:@"Check NowFloats Store for more information on upgrade plans" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Go To Store", nil];
                
                alertView.tag = 1897;
                
                [alertView show];
                
                alertView = nil;
            }
            
            
        }
        
        else
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
    }
    else if(indexPath.row == 5)
    {
        if ( ![frontNavigationController.topViewController isKindOfClass:[FGalleryViewController class]] )
        {
            //networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
          //  ImageGallery *netorkGallery = [[ImageGallery alloc] init];
            InternationalProPack *netorkGallery = [[InternationalProPack alloc] initWithNibName:@"InternationalProPack" bundle:nil];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:netorkGallery];
            navigationController.navigationBar.tintColor=[UIColor blackColor];
            
            [revealController setFrontViewController:navigationController animated:YES];

        }
        
        else
        {
            [revealController revealToggle:self];
        }
    }
    else
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"User settings button clicked"];
        
        if (![frontNavigationController.topViewController isKindOfClass:[UserSettingsViewController class]] )
        {
            
            UserSettingsViewController *userSettingsController=[[UserSettingsViewController  alloc]initWithNibName:@"UserSettingsViewController" bundle:nil];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userSettingsController];
            
            navigationController.navigationBar.tintColor=[UIColor blackColor];
            
            [revealController setFrontViewController:navigationController animated:YES];
            
        }
        
        else
        {
            [revealController revealToggle:self];
        }
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
    
    if(alertView.tag == 1897)
    {
        if(buttonIndex == 1)
        {
        
            BizStoreViewController *storeController=[[BizStoreViewController alloc]initWithNibName:@"BizStoreViewController" bundle:Nil];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:storeController];
            
            navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            
            [revealController setFrontViewController:navigationController animated:NO];
            
            [revealController revealToggle:self];
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

-(void)buyBtnClicked:(id)sender
{

    NSInteger i=[sender tag];
    
    NSLog(@"sender:%d",i);

}

#pragma PopUpDelegate

-(void)successBtnClicked:(id)sender
{
    
    BizStoreDetailViewController *storeController=[[BizStoreDetailViewController alloc]initWithNibName:@"BizStoreDetailViewController" bundle:Nil];
    
    storeController.isFromOtherViews=YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:storeController];
    


    if ([[sender objectForKey:@"tag"] intValue]==1001) {

        storeController.selectedWidget=1002;
        
    }
    
    
    if ([[sender objectForKey:@"tag"] intValue]==1002)
    {
        storeController.selectedWidget=1004;
    }
    
    
    
    if ([[sender objectForKey:@"tag"] intValue] == 1003)
    {
        storeController.selectedWidget=1006;
        
    }
    
    
    [self presentViewController:navigationController animated:YES completion:nil];


}

-(void)cancelBtnClicked:(id)sender
{

    if ([[sender objectForKey:@"tag"] intValue]==1001) {
        
        
        
    }
    
    
    if ([[sender objectForKey:@"tag"] intValue]==1002) {
        
        
        
    }


}

#pragma NFInstaPurchaseDelegate

-(void)instaPurchaseViewDidClose
{
    [popUpView removeFromSuperview];
    [leftPanelTableView reloadData];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSString*) deviceName
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode =
        @{
          @"i386"      :@"Simulator",
          @"iPod1,1"   :@"iPod Touch",      // (Original)
          @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
          @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
          @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
          @"iPhone1,1" :@"iPhone",          // (Original)
          @"iPhone1,2" :@"iPhone",          // (3G)
          @"iPhone2,1" :@"iPhone",          // (3GS)
          @"iPad1,1"   :@"iPad",            // (Original)
          @"iPad2,1"   :@"iPad 2",          //
          @"iPad3,1"   :@"iPad",            // (3rd Generation)
          @"iPhone3,1" :@"iPhone 4",        //
          @"iPhone4,1" :@"iPhone 4S",       //
          @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
          @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
          @"iPad3,4"   :@"iPad",            // (4th Generation)
          @"iPad2,5"   :@"iPad Mini",       // (Original)
          @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
          @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
          @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
          @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
          @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
          @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
          @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
          @"iPad4,5"   :@"iPad Mini"        // (2nd Generation iPad Mini - Cellular)
          };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([deviceName rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([deviceName rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([deviceName rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
    }
    
    return deviceName;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
