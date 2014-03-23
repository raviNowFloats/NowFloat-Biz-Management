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


@interface UserSettingsViewController ()
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

    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([expandedSections containsIndex:section] && section==3)
        {
            return 4;
        }
    }
    
    if (section==1)
    {
        return 1;
    }
    
    
    
    
/*
    else if ( section==2)
    {
        return 2;
    }
*/
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    NSString *identifier=@"String Identifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil)
    {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *nameLbl=[[UILabel alloc]initWithFrame:CGRectMake(55,0,240,44)];
        
        [nameLbl setTag:1];
        
        [nameLbl setBackgroundColor:[UIColor clearColor]];
        
        [nameLbl setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
        
        [nameLbl setTextColor:[UIColor colorWithHexString:@"454545"]];
        
        [cell addSubview:nameLbl];
        
        
        UIImageView *nameImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15,8, 28, 28)];
        
        [nameImgView setTag:2];
        
        [nameImgView setAlpha:0.60];
        
        [nameImgView setBackgroundColor:[UIColor clearColor]];
        
        [cell addSubview:nameImgView];
    }
    
    
    UILabel *nameLabel=(UILabel *)[cell viewWithTag:1];
    
    UIImageView *settingImgView=(UIImageView *)[cell viewWithTag:2];
    
    
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
                
                NSString *applicationVersion=[NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];

                nameLabel.text=applicationVersion;
                
                [settingImgView setImage:[UIImage imageNamed:@"NowFloats iPhone App Icon - 57x57.png"]];
            }
        }
    }
    
    
    [tableView setSeparatorColor:[UIColor colorWithHexString:@"f0f0f0"]];

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
        /*
        if (indexPath.row==1 && indexPath.section==1)
        {
            [self resetAppReviewManager];
            
            // The AppID is the only required setup
            [UAAppReviewManager setAppID:@"364709193"]; // iBooks
            
            // Debug means that it will popup on the next available change
            [UAAppReviewManager setDebug:YES];
            
            // This overrides the default value, read from your localized bundle plist
            [UAAppReviewManager setAppName:@"Pong"];
            
            // This overrides the default value, read from the UAAppReviewManager bundle plist
            [UAAppReviewManager setReviewTitle:@"Rate This Shiz"];
            
            // This overrides the default value, read from the UAAppReviewManager bundle plist
            [UAAppReviewManager setReviewMessage:@"Yo! I werked rly hard on this shiz yo, hit me up wit some good ratings yo!"];
            
            // This overrides the default value, read from the UAAppReviewManager bundle plist
            [UAAppReviewManager setCancelButtonTitle:@"Nah, fool"];
            
            // This overrides the default value, read from the UAAppReviewManager bundle plist
            [UAAppReviewManager setRateButtonTitle:@"Hell yeah!"];
            
            // This overrides the default value, read from the UAAppReviewManager bundle plist
            [UAAppReviewManager setRemindButtonTitle:@"Hit me up later..."];
            
            // This overrides the default value of 30, but it doesn't matter here because of Debug mode enabled
            [UAAppReviewManager setDaysUntilPrompt:28];
            
            // This overrides the default value of 1, but it doesn't matter here because of Debug mode enabled
            [UAAppReviewManager setDaysBeforeReminding:13];
            
            // This means that the popup won't show if you have already rated any version of the app, but it doesn't matter here because of Debug mode enabled
            [UAAppReviewManager setShouldPromptIfRated:NO];
            
            // This overrides the default value of 20, but it doesn't matter here because of Debug mode enabled
            [UAAppReviewManager setSignificantEventsUntilPrompt:99];
            
            // This means that UAAppReviewManager won't track this version if it hasn't already, but it doesn't matter here because of Debug mode enabled
            [UAAppReviewManager setTracksNewVersions:NO];
            
            // UAAppReviewManager comes with standard translations for 27 Languages. If you want o provide your own translations instead,
            //  or you change the default title, message or button titles, set this to YES.
            [UAAppReviewManager setUseMainAppBundleForLocalizations:YES];
            
            // This overrides the default of NO and is iOS 6+. Instead of going to the review page in the App Store App,
            //  the user goes to the main page of the app, in side of this app. Downsides are that it doesn't go directly to
            //  reviews and doesn't take affiliate codes
            [UAAppReviewManager setOpensInStoreKit:YES];
            
            // If you are opening in StoreKit, you can change whether or not to animated the push of the View Controller
            [UAAppReviewManager setUsesAnimation:YES];
            
            // This sets the Affiliate code you want to use, but is not required.
            // If you don't set it, it will use my affiliate code as a reward for creating UAAppReviewManager
            [UAAppReviewManager setAffiliateCode:@"11l7j9"];
            
            // This sets the Affiliate campaign code for tracking, but is not required.
            // If you leave it blank, it will use my affiliate code as a reward for creating UAAppReviewManager
            [UAAppReviewManager setAffiliateCampaignCode:@"UAAppReviewManager-ExampleApp"];
            
            
            // UAAppReviewManager is block based, so setup some blocks on events
            [UAAppReviewManager setOnDeclineToRate:^() {
                NSLog(@"The user just declined to rate");
            }];
            [UAAppReviewManager setOnDidDisplayAlert:^() {
                NSLog(@"We just displayed the rating prompt");
            }];
            [UAAppReviewManager setOnDidOptToRate:^() {
                NSLog(@"The user just opted to rate");
            }];
            [UAAppReviewManager setOnDidOptToRemindLater:^() {
                NSLog(@"The user just opted to remind later");
            }];
            [UAAppReviewManager setOnWillPresentModalView:^(BOOL animated) {
                NSLog(@"About to present the modal view: %@animated", (animated?@"":@"not "));
            }];
            [UAAppReviewManager setOnDidDismissModalView:^(BOOL animated) {
                NSLog(@"Just dismissed the modal view: %@animated", (animated?@"":@"not "));
            }];
            
            // UAAppReviewManager has sensible defaults for the NSUserDefault keys it uses, but you can customize that here
            [UAAppReviewManager setKey:@"kSettingsSignificantEventTally" forUAAppReviewManagerKeyType:UAAppReviewManagerKeySignificantEventCount];
            
            // YES here means it is ok to show, but it doesn't matter because we have debug on.
            [UAAppReviewManager userDidSignificantEvent:YES];
            
            // You can also call it with a block to circumvent any of UAAppReviewManager's should rate logic.
            [UAAppReviewManager userDidSignificantEventWithShouldPromptBlock:^BOOL(NSDictionary *trackingInfo) {
                //the tracking info dictionary has all the keys/value UAAppReviewManager uses to determine whether or not to show a prompt
                return NO;
            }];
            
            // Or you can set a global one to get one last chance to stop the prompt, or do your own logic
            [UAAppReviewManager setShouldPromptBlock:^BOOL(NSDictionary *trackingInfo) {
                // This will be called once all other rating conditions have been met, but before the prompt.
                // if a local UAAppReviewManagerShouldPromptBlock is called using the local methods, this will not be called.
                // Return YES to allow the prompt, NO to stop the presentation.
                return YES;
            }];

            
        }
        */
        /*
        if (indexPath.row==0 && indexPath.section==1) {

            
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
                
                [self presentModalViewController:mail animated:YES];
            }
            
            else
            {
                UIAlertView *mailAlert=[[UIAlertView alloc]initWithTitle:@"Configure" message:@"Please configure email in settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [mailAlert show];
                
                mailAlert=nil;
                
            }
        }
        */
        
        if (indexPath.row==0 && indexPath.section==1)
        {
            
            Mixpanel *mixPanel=[Mixpanel sharedInstance];
            
            [mixPanel track:@"Rate on appstore clicked"];

            /*
            [UAAppReviewManager setAppID:@"639599562"];
            
            [UAAppReviewManager setDebug:YES];

            [UAAppReviewManager setSignificantEventsUntilPrompt:0];
            */
            
            if (version.floatValue<7.0) {


            }

            else
            {
            
            
                
            }
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/nowfloats-biz/id639599562?mt=8"]];

            
        }
        
        
        
    }
    
    if (indexPath.section==2) {

        if (indexPath.row==0 && indexPath.section==2)
        {
            NSURL *url = [NSURL URLWithString:@"fb://profile/277931445614143"];
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }
    
    
    
    if (indexPath.section==3)
    {

        Mixpanel *mixPanel=[Mixpanel sharedInstance];
        
        [mixPanel track:@"About us clicked"];

        
        UserSettingsWebViewController *webViewController=[[UserSettingsWebViewController alloc]initWithNibName:@"UserSettingsWebViewController" bundle:nil];

        UINavigationController *navController=[[UINavigationController   alloc]initWithRootViewController:webViewController];
        

        if (indexPath.row==1 && indexPath.section==3) {
            
            webViewController.displayParameter=@"Terms & Conditions";
            
            [self presentModalViewController:navController animated:YES];
            
            webViewController=nil;
            
        }
        
        
        if (indexPath.row==2 && indexPath.section==3) {

            
            webViewController.displayParameter=@"Privacy Policy";
            
            
            [self presentModalViewController:navController animated:YES];
            
            webViewController=nil;

            
        }
        
        
        if (indexPath.row==3 && indexPath.section==3)
        {
            webViewController.displayParameter=@"About Us";
            
            [self presentModalViewController:navController animated:YES];
            
            webViewController=nil;
            
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
    [self dismissModalViewControllerAnimated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
