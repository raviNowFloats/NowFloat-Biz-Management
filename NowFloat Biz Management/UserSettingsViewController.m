//
//  UserSettingsViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 25/11/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "UserSettingsViewController.h"
#import "UIColor+HexaString.h"
#import "UAAppReviewManager.h"
#import "LogOutController.h"
#import "TutorialViewController.h"
#import "UserSettingsWebViewController.h"
#import "NSString+CamelCase.h"
#import "Mixpanel.h"
#import <sys/utsname.h>
#import "PopUpView.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

@interface APActivityProvider : UIActivityItemProvider

@end

@implementation APActivityProvider

- (id) activityViewController:(UIActivityViewController *)activityViewController
          itemForActivityType:(NSString *)activityType
{
    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] )
        return @"This is a #twitter post!";
    
    if ( [activityType isEqualToString:UIActivityTypePostToFacebook] )
        return @"This is a facebook post!";
    
    if ( [activityType isEqualToString:UIActivityTypeMessage] )
        return @"SMS message text";
    
    if ( [activityType isEqualToString:UIActivityTypeMail] )
        return @"Email text here!";
    
    if ( [activityType isEqualToString:@"it.albertopasca.myApp"] )
        return @"OpenMyapp custom text";
    
    return nil;
}
- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController { return @""; }
@end



@interface APActivityIcon : UIActivity
@end


@interface UserSettingsViewController ()<PopUpDelegate>
{
    float viewHeight;
}
@end

@implementation UserSettingsViewController

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
    
    version = [[UIDevice currentDevice] systemVersion];
    
    appDelegate=(AppDelegate *)[UIApplication  sharedApplication].delegate;

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
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    
    userSettingsArray=[[NSArray alloc]initWithObjects:@"Share your website",@"Like NowFloats",@"Follow NowFloats",@"Feedback",@"Rate on appstore",@"About Us",@"Logout", nil];
 
    
    revealController = [self revealViewController];
    
    revealController.delegate=self;
    
    frontNavigationController = (id)revealController.frontViewController;
    
    //Navigation Bar Here
    
    if (version.floatValue<7.0)
    {
        
        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 13, 120, 20)];
        
        headerLabel.text=@"Settings";
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textAlignment=NSTextAlignmentCenter;
        
        headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
        
        [navBar addSubview:headerLabel];
        
        leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:leftCustomButton];
        
    }

    
    else
    {
    
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        
        self.navigationController.navigationBar.translucent = NO;
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        self.navigationItem.title=@"Settings";
        
        leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftCustomButton];
        
        self.navigationItem.leftBarButtonItem = leftBtnItem;
    }
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    //Set the RightRevealWidth 0
    revealController.rightViewRevealWidth=0;
    revealController.rightViewRevealOverdraw=0;

    
    if (viewHeight==480)
    {
        if (version.floatValue<7.0)
        {
            [userSettingsTableView setFrame:CGRectMake(0, 54, userSettingsTableView.frame.size.width, 440)];
        }

        else
        {
            [userSettingsTableView setFrame:CGRectMake(0,-15, userSettingsTableView.frame.size.width, 510)];
        }
    }
    
    
    else
    {
        if (version.floatValue<7.0)
        {
            [userSettingsTableView setFrame:CGRectMake(0, 54, userSettingsTableView.frame.size.width, userSettingsTableView.frame.size.height)];
        }
        
        else
        {
            [userSettingsTableView setFrame:CGRectMake(0, -10, userSettingsTableView.frame.size.width, userSettingsTableView.frame.size.height)];
        }
    }
    
    
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }

}


#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{

    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    if (section==0)
    {
        return 1;
    }
    
    else if (section ==1)
    {
        return 2;
    }
    
    else if (section == 2)
    {
        return 4;
    }
    

    else if (section == 3)
    {
        return 1;
    }
    
/*
    else if ( section==2)
    {
        return 2;
    }
*/
    
    else
    {
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    NSString *identifier=@"String Identifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil)
    {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        
    }
    
    

    
    
    /*
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
    
        if (!indexPath.row)
        {
            if (indexPath.section==0)
            {
                nameLabel.text=@"Share your website";
                [settingImgView setImage:[UIImage imageNamed:@"UserSettingsShare.png"]];
            }

            if (indexPath.section==3)
            {
                
                nameLabel.text=@"About Us";
                [settingImgView setImage:[UIImage imageNamed:@"UserSettingsAbout.png"]];
            }
        }
        
        else
        {
            if (indexPath.section==0)
            {
                if ([indexPath row]==1 && indexPath.section==0)
                {
                    nameLabel.text=@"Facebook";
 
                }
                
                if ([indexPath row]==2 && indexPath.section==0)
                {
                    nameLabel.text=@"Twitter";
                }
            }
            
            
            if (indexPath.section==3)
            {
                
                if (indexPath.row==1 && indexPath.section==3)
                {
                    nameLabel.text=@"Terms & Conditions";
                }
                
                
                if (indexPath.row==2 && indexPath.section==3)
                {
                    
                    nameLabel.text=@"Privacy Policy";

                }
                
                if (indexPath.row==3 && indexPath.section==3)
                {
                    
                    nameLabel.text=@"About NowFloats";
                    
                }
            }
            
            
            
        }
    }
    */
    
    /*
        if (indexPath.section==1)
        {
            if (indexPath.row==0)
            {
                nameLabel.text=@"Like NowFloats";
                [settingImgView setImage:[UIImage imageNamed:@"UserSettingsLikeNF.png"]];
            }
            
            if (indexPath.row==1)
            {
                nameLabel.text=@"Follow NowFloats";
                [settingImgView setImage:[UIImage imageNamed:@"UserSettingsFollowNF.png"]];
            }
            
        }
*/
    
    /*
    else
    {
        if (indexPath.section==1)
        {
            if (indexPath.row==0 && indexPath.section==1)
            {
                nameLabel.text=@"Rate on AppStore";
                [settingImgView setImage:[UIImage imageNamed:@"UserSettingsRating.png"]];
            }
        }
        
        if (indexPath.section==2) {
            
            if (indexPath.row==0 && indexPath.section==2)
            {
                nameLabel.text=@"Like NowFloats";
                [settingImgView setImage:[UIImage imageNamed:@"UserSettingsLikeNF.png"]];
            }
            
        }
        if (indexPath.section==4) {
            
            if (indexPath.row==0 && indexPath.section==4)
            {
                nameLabel.text=@"Contact Us";
                
                [settingImgView setImage:[UIImage imageNamed:@"contactus.png"]];
            }
        }
        
        if (indexPath.section==5) {
            
            if (indexPath.row==0 && indexPath.section==5)
            {
                
                NSString *applicationVersion=[NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];

                nameLabel.text=applicationVersion;
                
                [settingImgView setImage:[UIImage imageNamed:@"NowFloats iPhone App Icon - 57x57.png"]];
            }
        }
        if(indexPath.section == 6){
            if(indexPath.row == 0 && indexPath.section == 6){
                nameLabel.text = @"Logout";
                [settingImgView setImage:[UIImage imageNamed:@"UserSettingsLogout.png"]];
            }
        }
    }
    */
    
    if ([indexPath section] == 0)
    {
        cell.textLabel.text= @"Share your website";
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    else if ([indexPath section]==1)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text=@"Send us your feedback";
        }
    
        else if (indexPath.row==1)
        {
            cell.textLabel.text=@"Rate us on the App Store";
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    }
    
    else if ([indexPath section] ==2)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text=@"Like us on Facebook";
        }
        
        else if (indexPath.row==1)
        {
            cell.textLabel.text=@"Follow us on twitter";
        }
        
        else if (indexPath.row == 2) {
            cell.textLabel.text=@"Terms of use";
        }
        
        else if (indexPath.row==3)
        {
            cell.textLabel.text=@"Privacy Policy";
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    }
    
    
    else if ([indexPath section] ==3)
    {
        cell.textLabel.text=@"Logout";
    }
    
    [tableView setSeparatorColor:[UIColor colorWithHexString:@"f0f0f0"]];

    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            [userSettingsTableView beginUpdates];
            
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
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
            }
                    
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
            }
            
            [userSettingsTableView endUpdates];            
        }
    }

    
    if (indexPath.section==0)
    {
        
        Mixpanel *mixPanel=[Mixpanel sharedInstance];
        
        [mixPanel track:@"Share website from settings"];
        
        if (version.floatValue<6.0)
        {
            UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:@"Select from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", nil];
            selectAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            selectAction.tag=1;
            [selectAction showInView:self.view];
        }
        
        else
        {
            NSString* shareText = [NSString stringWithFormat:@"Woohoo! We have a new website. Visit it at %@.nowfloats.com",[appDelegate.storeTag lowercaseString]];
            
            NSArray* dataToShare = @[shareText];
            
            UIActivityViewController* activityViewController =
            [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                              applicationActivities:nil];
            
            [self presentViewController:activityViewController animated:YES completion:nil];
        }
    }
    
    
    if (indexPath.section==1)
    {
        if (indexPath.row==0 && indexPath.section==1)
        {
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            
            [mixpanel track:@"Feedback"];
            
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
                
                mail.mailComposeDelegate = self;
                
                NSString *deviceOs=[[UIDevice currentDevice] systemVersion];
                
                NSString *applicationVersion=[NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
                
                applicationVersion=[applicationVersion stringByReplacingOccurrencesOfString:@"Version" withString:@""];
                
                NSArray *arrayRecipients=[NSArray arrayWithObject:@"hello@nowfloats.com"];
                
                [mail setToRecipients:arrayRecipients];
                
                [mail setMessageBody:[NSString stringWithFormat:@"\n\n\n\nDevice Type: %@\nDevice OS: %@\nApplication Version: %@",[self deviceName],deviceOs,applicationVersion] isHTML:NO];
                
                [self presentViewController:mail animated:YES completion:nil];
            }
            
            else
            {
                UIAlertView *mailAlert=[[UIAlertView alloc]initWithTitle:@"Configure" message:@"Please configure email in settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [mailAlert show];
                
                mailAlert=nil;
            }

        }
        
        else if (indexPath.row==1 && indexPath.section==1)
        {
            
            Mixpanel *mixPanel=[Mixpanel sharedInstance];
            
            [mixPanel track:@"Rate on appstore clicked"];
     
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/nowfloats-biz/id639599562?mt=8"]];

            
        }
    }
    
    if (indexPath.section==2)
    {
        
        Mixpanel *mixPanel=[Mixpanel sharedInstance];
        
        [mixPanel track:@"About us clicked"];
        
        
        UserSettingsWebViewController *webViewController=[[UserSettingsWebViewController alloc]initWithNibName:@"UserSettingsWebViewController" bundle:nil];
        
        UINavigationController *navController=[[UINavigationController   alloc]initWithRootViewController:webViewController];

        if (indexPath.row==0 && indexPath.section==2)
        {
            NSURL *url = [NSURL URLWithString:@"fb://profile/582834458454343"];
            [[UIApplication sharedApplication] openURL:url];
        }
        
        else if (indexPath.row==1 && indexPath.section==2)
        {
            //[self followTwitter];
            webViewController.displayParameter=@"Follow Us";
            
            [self presentViewController:navController animated:YES completion:nil];
            
            webViewController=nil;

        }


        else if (indexPath.row==2 && indexPath.section==2)
        {
            webViewController.displayParameter=@"Terms & Conditions";
            
            [self presentViewController:navController animated:YES completion:nil];
            
            webViewController=nil;

            
        }

        else if (indexPath.row==3 && indexPath.section==2)
        {
            webViewController.displayParameter=@"Privacy Policy";
            
            [self presentViewController:navController animated:YES completion:nil];
            
            webViewController=nil;

        }
    }
    
    
    
    
    if(indexPath.section == 3)
    {
        if(indexPath.row == 0 && indexPath.section == 3)
        {
            //Log out section
            PopUpView *visitorsPopUp=[[PopUpView alloc]init];
            visitorsPopUp.delegate=self;
            visitorsPopUp.descriptionText=@"We hate to see you go.";
            visitorsPopUp.titleText=@"Are you sure?";
            visitorsPopUp.tag=205;
            visitorsPopUp.popUpImage=[UIImage imageNamed:@"cancelregister.png"];
            visitorsPopUp.successBtnText=@"GOT TO GO";
            visitorsPopUp.cancelBtnText=@"Cancel";
            [visitorsPopUp showPopUpView];
        }
    }
}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1)
    {
        if(buttonIndex == 0)
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                NSString* shareText = [NSString stringWithFormat:@"Take a look at my website.\n %@.nowfloats.com",[appDelegate.storeTag lowercaseString]];
                
                [fbSheet setInitialText:shareText];
                
                [self presentViewController:fbSheet animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Sorry"
                                          message:@"You can't post a feed right now, make sure your device has an internet connection and you have at least one Facebook account setup."
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                
                [alertView show];
            }
        }
        
        
        if (buttonIndex==1)
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                NSString* shareText = [NSString stringWithFormat:@"Take a look at my website.\n %@.nowfloats.com",[appDelegate.storeTag lowercaseString]];
                [tweetSheet setInitialText:shareText];
                [self presentViewController:tweetSheet animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Sorry"
                                          message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup."
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                
                [alertView show];
            }
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    
    if (section==0 || section==3)
    {
        return YES;
    }
    
    return NO;
}

-(void)successBtnClicked:(id)sender
{
    if ([[sender objectForKey:@"tag"] intValue] == 205)
    {
        Mixpanel *mixPanel=[Mixpanel sharedInstance];
        
        [mixPanel track:@"logout"];
        
        LogOutController *logOut=[[LogOutController alloc]init];
        
        [logOut clearFloatingPointDetails];
        
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
        
        [navigationArray removeAllObjects];
        
        self.navigationController.viewControllers = navigationArray;
        
        if (![frontNavigationController.topViewController isKindOfClass:[TutorialViewController class]] ){
            
            TutorialViewController *tutorialController=[[TutorialViewController  alloc]initWithNibName:@"TutorialViewController" bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tutorialController];
            navigationController.navigationBar.tintColor=[UIColor blackColor];
            
            [revealController setFrontViewController:navigationController animated:YES];
        }
        else {
            [revealController revealToggle:self];
        }
    }
}

-(void)cancelBtnClicked:(id)sender
{
    
}

- (void)resetAppReviewManager
{
	// This is just to clean up after the customized one above before showing the standard one.
	[UAAppReviewManager setAppID:@"12345678"];
	[UAAppReviewManager setDebug:YES];
	[UAAppReviewManager setAppName:nil];
	[UAAppReviewManager setReviewTitle:nil];
	[UAAppReviewManager setReviewMessage:nil];
	[UAAppReviewManager setCancelButtonTitle:nil];
	[UAAppReviewManager setRateButtonTitle:nil];
	[UAAppReviewManager setRemindButtonTitle:nil];
	[UAAppReviewManager setDaysUntilPrompt:0];
	[UAAppReviewManager setDaysBeforeReminding:0];
	[UAAppReviewManager setShouldPromptIfRated:YES];
	[UAAppReviewManager setSignificantEventsUntilPrompt:0];
	[UAAppReviewManager setTracksNewVersions:YES];
	[UAAppReviewManager setUseMainAppBundleForLocalizations:NO];
	[UAAppReviewManager setOpensInStoreKit:NO];
	[UAAppReviewManager setUsesAnimation:YES];
	[UAAppReviewManager setAffiliateCode:@"11l7j9"];
	[UAAppReviewManager setAffiliateCampaignCode:@"UAAppReviewManager"];
	[UAAppReviewManager setOnDeclineToRate:nil];
	[UAAppReviewManager setOnDidDisplayAlert:nil];
	[UAAppReviewManager setOnDidOptToRate:nil];
	[UAAppReviewManager setOnDidOptToRemindLater:nil];
	[UAAppReviewManager setOnWillPresentModalView:nil];
	[UAAppReviewManager setOnDidDismissModalView:nil];
	[UAAppReviewManager setKey:@"UAAppReviewManagerKeySignificantEventCount" forUAAppReviewManagerKeyType:UAAppReviewManagerKeySignificantEventCount];
}



- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma SWRevealViewControllerDelegate


- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position
{
    NSString *str = nil;
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    else if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    else if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    else if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    
    else if ( position == FrontViewPositionLeftSide ) str = @"FrontViewPositionLeftSide";
    
    else if ( position == FrontViewPositionLeftSideMostRemoved ) str = @"FrontViewPositionLeftSideMostRemoved";
    
    return str;
}


- (IBAction)revealFrontController:(id)sender
{
    
    revealController = [self revealViewController];
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeftSide"])
    {
        [revealController performSelector:@selector(rightRevealToggle:)];
    }
    
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"]) {
        
        [revealController performSelector:@selector(revealToggle:)];
        
    }
    
}


- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position;
{
    
    frontViewPosition=[self stringFromFrontViewPosition:position];
    
    //FrontViewPositionLeft
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeftSide"])
    {
        
        [revealFrontControllerButton setHidden:NO];
        
    }
    
    //FrontViewPositionCenter
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeft"]) {
        
        [revealFrontControllerButton setHidden:YES];
        
    }
    
    //FrontViewPositionRight
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"])
    {
        [revealFrontControllerButton setHidden:NO];
    }
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

-(void)followTwitter{

    ACAccountStore *account = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted==YES)
         {
             NSArray *accountsArray = [account accountsWithAccountType:accountType];
             
             
             if ([accountsArray count] > 0)
             {
                 ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                 NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                 [tempDict setValue:@"NowFloatsBoost" forKey:@"screen_name"];
                 [tempDict setValue:@"true" forKey:@"follow"];
                 
             SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST
                           URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/friendships/create.json"]
                    parameters:[NSDictionary dictionaryWithDictionary:tempDict]];
             
                 [request setAccount:twitterAccount];
                 
                 [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                 {
                     
                     NSString *output = [NSString stringWithFormat:@"HTTP response status: %i Error %d", [urlResponse statusCode],error.code];
                     NSLog(@"%@error %@", output,error.description);
                     
                     
                     if(responseData)
                     {
                         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
                         if(responseDictionary)
                         {
                             //NSLog(@"responseDictionary:%@",responseDictionary);
                         }
                     }
                     
                     else
                     {
                         // responseDictionary is nil
                         NSLog(@"Failed");
                     }
                 }];
                 
        
             }
         }
         
         else
         {
             NSLog(@"Error:%@",error.localizedDescription);
         }
         
     }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
