//
//  AppDelegate.m
//  NowFloat Biz Management
//
//  Created by Sumanta Roy on 25/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.


#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "BizMessageViewController.h"
#import "LoginViewController.h"
#import "TutorialViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SettingsViewController.h"
#import "UIColor+HexaString.h"
#import "SearchQueryController.h"
#import "BizStoreIAPHelper.h"
#import "Mixpanel.h"
#import "LeftViewController.h"
#import "FileManagerHelper.h"
#import "RegisterChannel.h"
#import "UserSettingsViewController.h"
#import "BizStoreViewController.h"
#import "BizStoreDetailViewController.h"
#import "TalkToBuisnessViewController.h"
#import "AnalyticsViewController.h"
#import "SearchQueryViewController.h"
#import "BusinessDetailsViewController.h"
#import "BusinessContactViewController.h"
#import "BusinessAddressViewController.h"
#import "BusinessHoursViewController.h"
#import "BusinessLogoUploadViewController.h"

#import <FacebookSDK/FBSessionTokenCachingStrategy.h>


#define GOOGLE_API_KEY @"AIzaSyAz5qKM3-qM2cRHccJWRXI5sqQ_qGzWSmY"

#if BOOST_PLUS
#define MIXPANEL_TOKEN @"78860f1e5c7e3bc55a2574f42d5efd30" //Boost Plus
#else
#define MIXPANEL_TOKEN @"be4edc1ffc2eb228f1583bd396787c9a" //Boost Lite
#endif

NSString *const bundleUrl = @"com.biz.nowfloats";
NSString *const updateLink = @"update";
NSString *const buySeo = @"nfstoreseo";
NSString *const buyTtb = @"nfstorettb";
NSString *const buyFeatureImage = @"nfstoreimage";
NSString *const analyticsUrl = @"analytics";
NSString *const storeUrl = @"nfstore";
NSString *const ttbUrl = @"ttb";
NSString *const searchQueriesUrl = @"searchqueries";
NSString *const socialSharingUrl = @"socialoptions";
NSString *const settingsUrl = @"settings";
NSString *const businessNameUrl = @"name";
NSString *const contactUrl = @"contact";
NSString *const addressUrl = @"address";
NSString *const timingUrl = @"timings";
NSString *const logoUrl = @"logo";



//MIXPANEL_TOKEN_DEV @"5922188e4ed1daff8609d2d03b0a2b9f"
//Distribution mixpanel be4edc1ffc2eb228f1583bd396787c9a
//ravi mixpanel @"59912051c6d0d2dab02aa12813ea022a"

@interface AppDelegate()<RegisterChannelDelegate>{
    SWRevealViewController *revealController;
    NSDictionary *pushPayloadInApp;
}


@end



@implementation AppDelegate
@synthesize storeDetailDictionary,msgArray,fpDetailDictionary,clientId;

@synthesize businessDescription,businessName;
@synthesize dealDescriptionArray,dealDateArray,dealId,arrayToSkipMessage;
@synthesize userMessagesArray,userMessageContactArray,userMessageDateArray,inboxArray,storeTimingsArray,storeContactArray,storeTag,storeEmail,storeFacebook,storeWebsite,storeVisitorGraphArray,storeAnalyticsArray,apiWithFloatsUri,apiUri,secondaryImageArray,dealImageArray,localImageUri,primaryImageUploadUrl,primaryImageUri,fbUserAdminArray,fbUserAdminAccessTokenArray,fbUserAdminIdArray,socialNetworkNameArray,fbPageAdminSelectedIndexArray,socialNetworkAccessTokenArray,socialNetworkIdArray,multiStoreArray,addedFloatsArray,deletedFloatsArray,searchQueryArray,isNotified,storeCategoryName,storeWidgetArray,storeRootAliasUri,storeLogoURI,deviceTokenData;

@synthesize mixpanel,startTime,bgTask;
@synthesize settingsController=_settingsController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    isForFBPageAdmin=NO;
    
    msgArray=[[NSMutableArray alloc]init];
    storeDetailDictionary=[[NSMutableDictionary alloc]init];
    fpDetailDictionary=[[NSMutableDictionary alloc]init];
    clientId=@"DB96EA35A6E44C0F8FB4A6BAA94DB017C0DFBE6F9944B14AA6C3C48641B3D70";
    
    
    businessName=[[NSMutableString alloc]init];
    businessDescription=[[NSMutableString alloc]init];
    
    dealDateArray=[[NSMutableArray alloc]init];
    dealDescriptionArray=[[NSMutableArray alloc]init];
    dealId=[[NSMutableArray alloc]init];
    arrayToSkipMessage=[[NSMutableArray alloc]init];
    
    inboxArray=[[NSMutableArray alloc]init];
    userMessagesArray=[[NSMutableArray alloc]init];
    userMessageDateArray=[[NSMutableArray alloc]init];
    userMessageContactArray=[[NSMutableArray alloc]init];
    
    storeTimingsArray=[[NSMutableArray alloc]init];
    storeContactArray=[[NSMutableArray alloc]init];
    
    storeTag=[[NSString alloc]init];
    storeTag = @"";
    storeWebsite=[[NSString alloc]init];
    storeFacebook=[[NSString alloc]init];
    storeEmail=[[NSString alloc]init];    
    
    storeVisitorGraphArray=[[NSMutableArray alloc]init];
    storeAnalyticsArray=[[NSMutableArray alloc]init];
    
    apiWithFloatsUri=@"https://api.withfloats.com/Discover/v1/floatingPoint";
    apiUri=@"https://api.withfloats.com";

//    apiWithFloatsUri=@"http://api.nowfloatsdev.com/Discover/v1/floatingPoint";
//    apiUri=@"http://api.nowfloatsdev.com";
    
    
    secondaryImageArray=[[NSMutableArray alloc]init];
    dealImageArray=[[NSMutableArray alloc]init];
    localImageUri=[[NSMutableString alloc]init];
    primaryImageUploadUrl=[[NSMutableString alloc]init];
    primaryImageUri=[[NSMutableString alloc]init];

    
    fbUserAdminArray=[[NSMutableArray alloc]init];
    fbUserAdminIdArray=[[NSMutableArray alloc]init];
    fbUserAdminAccessTokenArray=[[NSMutableArray alloc]init];
    socialNetworkNameArray =[[NSMutableArray alloc]init];
    socialNetworkIdArray=[[NSMutableArray alloc]init];
    socialNetworkAccessTokenArray=[[NSMutableArray alloc]init];
    fbPageAdminSelectedIndexArray=[[NSMutableArray alloc]init];
    multiStoreArray=[[NSMutableArray alloc]init];
    addedFloatsArray=[[NSMutableArray alloc]init];
    deletedFloatsArray=[[NSMutableArray alloc]init];
    searchQueryArray=[[NSMutableArray alloc]init];
    storeCategoryName=[[NSMutableString alloc]init];
    storeWidgetArray=[[NSMutableArray alloc]init];
    storeRootAliasUri=[[NSMutableString alloc]init];
    storeLogoURI=[[NSMutableString alloc]init];
    
    deviceTokenData=[[NSMutableData alloc]init];
    
    
    isNotified=NO;
    isFBPageAdminDeSelected=NO;
    isFBDeSelected=NO;
    
    [GMSServices provideAPIKey:GOOGLE_API_KEY];
    
    
    userDefaults=[NSUserDefaults standardUserDefaults];

    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	self.window = window;
    
    self.mixpanel = [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    
   // self.mixpanel.showNotificationOnActive = NO;
    
    self.mixpanel.flushInterval = 1; // defaults to 60 seconds
    
    LoginViewController *loginController=[[LoginViewController alloc]init];
    
    TutorialViewController *tutorialController=[[TutorialViewController alloc]init];
    
    LeftViewController *rearViewController=[[LeftViewController  alloc]init];
    
    UINavigationController *navigationController ;
    
        if ([userDefaults objectForKey:@"userFpId"])
        {
            navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
        }
        
        else
        {
            navigationController = [[UINavigationController alloc] initWithRootViewController:tutorialController];
        }
        

    
    

    NSString *version = [[UIDevice currentDevice] systemVersion];
 
    if ([version intValue] < 7)
    {
     
     UIImage *navBackgroundImage = [UIImage imageNamed:@"header-bg.png"];
     
     [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
        
     [[UINavigationBar appearance] setTitleTextAttributes:
     @{
       UITextAttributeTextColor: [UIColor colorWithHexString:@"464646"],
       UITextAttributeTextShadowColor: [UIColor colorWithHexString:@"464646"],
       UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero],
       UITextAttributeFont: [UIFont fontWithName:@"Helvetica" size:18.0f]
       }];
        
    UIImage *barButtonImage = [[UIImage imageNamed:@"btn bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,6,0,6)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"btn bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,6, 0, 6)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
    }

    else
    {
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"ffb900"]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:
         @{
           UITextAttributeTextColor: [UIColor colorWithHexString:@"464646"],
           UITextAttributeTextShadowColor: [UIColor colorWithHexString:@"464646"],
           UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero],
           UITextAttributeFont: [UIFont fontWithName:@"Helvetica" size:18.0f]
           }];
    }
    
	revealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:navigationController];
    
    revealController.delegate = self;
    
	self.viewController = revealController;
	
	self.window.rootViewController = self.viewController;
    
	[self.window makeKeyAndVisible];
    
    
    if ([userDefaults objectForKey:@"NFManageUserFBAdminDetails"])
    {
        NSMutableArray *userAdminInfo=[[NSMutableArray alloc]init];
        
        [userAdminInfo addObjectsFromArray:[userDefaults objectForKey:@"NFManageUserFBAdminDetails"]];
                
        for (int i=0; i<[userAdminInfo count]; i++)
        {
                        
            [fbUserAdminArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"name" ] atIndex:i];
            
            [fbUserAdminAccessTokenArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"access_token" ] atIndex:i];
            
            [fbUserAdminIdArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"id" ] atIndex:i];
        }
        
    }
    
    
    [BizStoreIAPHelper sharedInstance];
    
    self.startTime = [NSDate date];

    
    NSNumber *seconds = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:self.startTime]];
    
    [self.mixpanel track:@"Session"
                          properties:[NSDictionary dictionaryWithObject:seconds forKey:@"Length"]];
    
    [userDefaults setObject:self.startTime forKey:@"appStartDate"];
    
    if(launchOptions != nil)
    {
        frntNavigationController = (id)revealController.frontViewController;
        
        if([launchOptions objectForKey:UIApplicationLaunchOptionsURLKey])
        {
            
        }
        else
        {
            if([frntNavigationController.topViewController isKindOfClass:[LoginViewController class]])
            {
                [storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isFromNotification"];
                
                NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
                
                [storeDetailDictionary setObject:remoteNotif forKey:@"pushPayLoad"];
                
                [loginController enterBtnClicked:nil];
            }
        }
    }
    
    
	return YES;
}



- (void)openSession:(BOOL)isAdmin
{
    isForFBPageAdmin=isAdmin;
    
    NSArray *permissions =  [NSArray arrayWithObjects:
                             @"publish_stream",
                             @"manage_pages"
                             ,nil];

    [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
     {
        //[self sessionStateChanged:session state:state error:error];

    }];
    
}


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
{    switch (state)
    {
        case FBSessionStateOpen:
        {
            if (isForFBPageAdmin)
            {
                [self connectAsFbPageAdmin];
            }
            
            else
            {
                [self populateUserDetails];
            }
        }
            
        break;
            
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
        {
            if (isForFBPageAdmin)
            {
                isFBPageAdminDeSelected=YES;
            }
            
            else
            {
                isFBDeSelected=YES;            
            }
            [FBSession.activeSession closeAndClearTokenInformation];            
        }
        break;
        default:
        break;
    }
}


-(void)populateUserDetails
{
    NSString * accessToken = [[FBSession activeSession] accessTokenData].accessToken;
    
    [userDefaults setObject:accessToken forKey:@"NFManageFBAccessToken"];
    
    [userDefaults synchronize];

    [[FBRequest requestForMe] startWithCompletionHandler:
    ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
        {
         if (!error)
         {
             [userDefaults setObject:[user objectForKey:@"id"] forKey:@"NFManageFBUserId"];
             [userDefaults synchronize];
             [FBSession.activeSession closeAndClearTokenInformation];
         }
         else
         {
             [self openSession:NO];
         }
        }
     ];
}


-(void)connectAsFbPageAdmin
{
    [[FBRequest requestForGraphPath:@"me/accounts"]
     startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
     {
         if (!error)
         {
             //NSLog(@"user:%d",[[user objectForKey:@"data"] count]);

             if ([[user objectForKey:@"data"] count]>0)
             {                 
                 NSMutableArray *userAdminInfo=[[NSMutableArray alloc]init];
                 
                 [userAdminInfo addObjectsFromArray:[user objectForKey:@"data"]];
                 
                 [self assignFbDetails:[user objectForKey:@"data"]];
                 
                 for (int i=0; i<[userAdminInfo count]; i++)
                 {
                     
                     [fbUserAdminArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"name" ] atIndex:i];
                     
                     [fbUserAdminAccessTokenArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"access_token" ] atIndex:i];
                     
                     [fbUserAdminIdArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"id" ] atIndex:i];                                          
                 }
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"showAccountList" object:nil];                 
             }
             
             else
             {
             
                 UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"You donot have pages to manage" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                 
                 [alerView show];
             
                 alerView=nil;
             
             }
             
             [FBSession.activeSession closeAndClearTokenInformation];
             
         }
         else
         {
             [self openSession:YES];
         }
     }
     ];
    
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //return [FBSession.activeSession handleOpenURL:url];
    if([url isEqual:[NSURL URLWithString:@"com.biz.nowfloats://"]])
    {
    
        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"com.biz.nowfloats://"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"com.biz.nowfloats://"]];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/in/app/nowfloats-boost/id639599562"]];
        }
        
        return true;
    }
    
    else
    {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call)
    {
        
        if (call.accessTokenData)
        {
            if ([FBSession activeSession].isOpen)
            {
                NSLog(@"INFO: Ignoring app link because current session is open.");
            }
            
            else
                
            {
                [self handleAppLink:call.accessTokenData];
            }
        }
        
    }];
    }
    
}

-(void)DeepLinkUrl:(NSURL *) url
{
   
    
    UIViewController *DeepLinkController = [[UIViewController alloc] init];
    
    BOOL isGoingToStore;
    
    BOOL isDetailView;
    
    if([url isEqual:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",bundleUrl,storeUrl]]])
    {
        isGoingToStore = YES;
        isDetailView = NO;
        
        BizStoreViewController *BAddress = [[BizStoreViewController alloc] initWithNibName:@"BizStoreViewController" bundle:nil];
        
        DeepLinkController = BAddress;
        [storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isStoreScreen"];
        
    }
    else if([url isEqual:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",bundleUrl,buySeo]]])
    {
        BizStoreDetailViewController *BAddress = [[BizStoreDetailViewController alloc] initWithNibName:@"BizStoreDetailViewController" bundle:nil];
        
        
        BAddress.selectedWidget=1008;
        
        isGoingToStore = YES;
        isDetailView = YES;
        [storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isFromDeeplink"];
        DeepLinkController = BAddress;
        
        
    }
    else if([url isEqual:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",bundleUrl,buyTtb]]])
    {
        BizStoreDetailViewController *BAddress = [[BizStoreDetailViewController alloc] initWithNibName:@"BizStoreDetailViewController" bundle:nil];
        
        
        BAddress.selectedWidget=1002;
        
        isGoingToStore = YES;
        isDetailView = YES;
        [storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isFromDeeplink"];
        
        DeepLinkController = BAddress;
        
    }
    else if([url isEqual:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",bundleUrl,buyFeatureImage]]])
    {
        BizStoreDetailViewController *BAddress = [[BizStoreDetailViewController alloc] initWithNibName:@"BizStoreDetailViewController" bundle:nil];
        
        
        BAddress.selectedWidget=1004;
        
        isGoingToStore = YES;
        isDetailView = YES;
        [storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isFromDeeplink"];
        
        DeepLinkController = BAddress;
        
    }
    else if([url isEqual:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",bundleUrl,ttbUrl]]])
    {
        TalkToBuisnessViewController *BAddress = [[TalkToBuisnessViewController alloc] initWithNibName:@"TalkToBuisnessViewController" bundle:nil];
        
        DeepLinkController = BAddress;
        
        isDetailView = NO;
        
    }
    else if([url isEqual:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",bundleUrl,analyticsUrl]]])
    {
        AnalyticsViewController *BAddress = [[AnalyticsViewController alloc] initWithNibName:@"AnalyticsViewController" bundle:nil];
        
        DeepLinkController = BAddress;
        
        isDetailView = NO;
        
        [storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isAnalyticsScreen"];
        
    }
    else if([url isEqual:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",bundleUrl,searchQueriesUrl]]])
    {
        
        SearchQueryViewController  *BAddress=[[SearchQueryViewController alloc]initWithNibName:@"SearchQueryViewController" bundle:nil];
        
        DeepLinkController = BAddress;
        
        isDetailView = NO;
        
        [storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isSearchScreen"];
        
    }
    else if([url isEqual:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",bundleUrl,socialSharingUrl]]])
    {
        
        SettingsViewController *BAddress = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        
        BAddress.isGestureAvailable =YES;
        
        DeepLinkController = BAddress;
        
        isDetailView = NO;
        
        [storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isSocialScreen"];
        
    }
    else if([url isEqual:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",bundleUrl,settingsUrl]]])
    {
        
        UserSettingsViewController *BAddress = [[UserSettingsViewController alloc] initWithNibName:@"UserSettingsViewController" bundle:nil];
        
        DeepLinkController = BAddress;
        
        
        
        isDetailView = NO;
        
        [storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isSettingScreen"];
        
    }
    else if([url isEqual:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",bundleUrl,businessNameUrl]]])
    {
        BusinessDetailsViewController *BAddress = [[BusinessDetailsViewController alloc] initWithNibName:@"BusinessDetailsViewController" bundle:nil];
        
        isDetailView = NO;
        
        DeepLinkController = BAddress;
        
    }
    else if([url isEqual:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",bundleUrl,contactUrl]]])
    {
        BusinessContactViewController *BAddress = [[BusinessContactViewController alloc] initWithNibName:@"BusinessContactViewController" bundle:nil];
        
        DeepLinkController = BAddress;
        
        isDetailView = NO;
        
        [storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isContactScreen"];
        
    }
    else if([url isEqual:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",bundleUrl,addressUrl]]])
    {
        BusinessAddressViewController *BAddress = [[BusinessAddressViewController alloc] initWithNibName:@"BusinessAddressViewController" bundle:nil];
        
        DeepLinkController = BAddress;
        
        isDetailView = NO;
        
        [storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isAddressScreen"];
        
    }
    else if([url isEqual:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",bundleUrl,timingUrl]]])
    {
        BusinessHoursViewController *BAddress = [[BusinessHoursViewController alloc] initWithNibName:@"BusinessHoursViewController" bundle:nil];
        
        DeepLinkController = BAddress;
        
        isDetailView = NO;
        
        [storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isTimingScreen"];
        
    }
    else if([url isEqual:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",bundleUrl,logoUrl]]])
    {
        BusinessLogoUploadViewController *BAddress = [[BusinessLogoUploadViewController alloc] initWithNibName:@"BusinessLogoUploadViewController" bundle:nil];
        
        DeepLinkController = BAddress;
        
        isDetailView = NO;
        
        [storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isLogoScreen"];
        
    }
    else if([url isEqual:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",bundleUrl,updateLink]]])
    {
        BizMessageViewController *BAddress = [[BizMessageViewController alloc] initWithNibName:@"BizMessageViewController" bundle:nil];
        
        DeepLinkController = BAddress;
        
        [storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isUpdateNotification"];
        
        isDetailView = NO;
        
    }
    else
    {
        isDetailView = NO;
    }
    
    BizStoreViewController *storeView = [[BizStoreViewController alloc] initWithNibName:@"BizStoreViewController" bundle:nil];
    
    frntNavigationController =  (id)revealController.frontViewController;
    
    if(isDetailView)
    {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:storeView];
        [navController pushViewController:DeepLinkController animated:NO];
        [revealController setFrontViewController:navController animated:NO];
        
    }
    else
    {
        if([frntNavigationController.topViewController  isKindOfClass:[DeepLinkController class]])
        {
            if( [frntNavigationController.topViewController respondsToSelector:@selector(viewDidAppear:)])
            {
                [frntNavigationController.topViewController performSelector:@selector(viewDidAppear:) withObject:[NSNumber numberWithBool:YES]];
            }
        }
        else
        {
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:DeepLinkController];
            [revealController setFrontViewController:navController animated:NO];
        }
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101)
        
    {
        
        NSDictionary *aps = (NSDictionary *)[pushPayloadInApp objectForKey:@"aps"];
        
        NSInteger badge = [aps objectForKey:@"badge"];
        
        if(buttonIndex == 0)
            
        {
            
            if(badge != 0)
                
            {
                
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                
            }
            
        }
        
        else if( buttonIndex == 1)
            
        {
            
            NSString *urlString = [aps objectForKey:@"url"];
            
            if(badge != 0)
                
            {
                
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                
            }
            
            
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            if(url != NULL)
                
            {
                
                [self DeepLinkUrl:url];
                
            }
            
        }
        
    }
}

// Helper method to wrap logic for handling app links.
- (void)handleAppLink:(FBAccessTokenData *)appLinkToken
{
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil
                                                     permissions:nil
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
    
    [FBSession setActiveSession:appLinkSession];

    // ... and open it from the App Link's Token.
    [appLinkSession openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
     {
         if (error)
         {
             [_settingsController loginView:nil handleError:error];
         }
     }];
}


-(void)closeSession
{

    [FBSession.activeSession closeAndClearTokenInformation];

}


-(void)assignFbDetails:(NSArray*)sender
{
    
    [userDefaults setObject:sender forKey:@"NFManageUserFBAdminDetails"];
    
    [userDefaults synchronize];
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSDate *appCloseDate = [NSDate date];
    
    NSMutableDictionary *userSetting=[[NSMutableDictionary alloc]init];
    
   // NSMutableDictionary *storeCache = [[NSMutableDictionary alloc] init];
    
    FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
    
    if (storeTag!=NULL || storeTag.length!=0)
    {
        fHelper.userFpTag=storeTag;
        
        [userSetting addEntriesFromDictionary:[fHelper openUserSettings]];
        
        if (userSetting!=NULL && userSetting!=nil)
        {
            if ([userSetting objectForKey:@"1st Login"]!=nil)
            {
                if ([[userSetting objectForKey:@"1st Login"] boolValue])
                {
                    [fHelper updateUserSettingWithValue:appCloseDate forKey:@"1stLoginCloseDate"];
                }
            }
            
            if ([userSetting objectForKey:@"2nd Login"]!=nil)
            {
                if ([[userSetting objectForKey:@"2nd Login"] boolValue])
                {
                    [fHelper removeUserSettingforKey:@"1stLoginCloseDate"];
                    
                    [fHelper updateUserSettingWithValue:appCloseDate forKey:@"2ndLoginCloseDate"];
                }
            }
        }
        
//        [fHelper createCacheDictionary];
//        
//        [fHelper updateCacheDictionaryWithValue:storeDetailDictionary];
//        
//        [storeCache addEntriesFromDictionary:[fHelper openCacheDictionary]];
//        
//        NSLog(@"%@",storeCache);
        
    }

    /*
    NSMutableDictionary *userSetting=[[NSMutableDictionary alloc]init];
    
    [userSetting addEntriesFromDictionary:[fHelper openUserSettings]];

    if ([userSetting objectForKey:@"2nd Login"]!=nil)
    {
        if ([[userSetting objectForKey:@"2nd Login"] boolValue])
        {
            if ([[userSetting allKeys] containsObject:@"SecondLoginTimeStamp"])
            {
                [fHelper updateUserSettingWithValue:appCloseDate forKey:@"SecondLogOutTimeStamp"];
            }
        }
    }
    */
    
    [self.window endEditing:YES];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    
//    if([storeDetailDictionary objectForKey:@"isUpdateNotification"] != nil)
//    {
//        if([storeDetailDictionary objectForKey:@"isUpdateNotification"] == [NSNumber numberWithBool:YES])
//        {
//            frntNavigationController =  (id)revealController.frontViewController;
//            
//            if([frntNavigationController.topViewController  isKindOfClass:[BizMessageViewController class]])
//            {
//                if( [frntNavigationController.topViewController respondsToSelector:@selector(viewDidAppear:)])
//                {
//                    [frntNavigationController.topViewController performSelector:@selector(viewDidAppear:) withObject:[NSNumber numberWithBool:YES]];
//                }
//            }
//            
//        }
//    }
//    
    
   
    //[FBSession.activeSession handleDidBecomeActive];
    
    [FBAppEvents activateApp];

    // Facebook SDK * login flow *
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActive];

}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    [msgArray removeAllObjects];
    [storeDetailDictionary removeAllObjects];
    [fpDetailDictionary removeAllObjects];
    
    
    [dealDateArray removeAllObjects];
    [dealDescriptionArray removeAllObjects];
    [dealId removeAllObjects];
    [arrayToSkipMessage removeAllObjects];
    
    [inboxArray removeAllObjects];
    [userMessagesArray removeAllObjects];
    [userMessageDateArray removeAllObjects];
    [userMessageContactArray removeAllObjects];
    
    
    [storeTimingsArray removeAllObjects];
    [storeContactArray removeAllObjects];
    
    [storeVisitorGraphArray removeAllObjects];
    [storeAnalyticsArray removeAllObjects];

    [secondaryImageArray removeAllObjects];
    [dealImageArray removeAllObjects];
    

    
    NSDate *appCloseDate = [NSDate date];
    
    NSMutableDictionary *userSetting=[[NSMutableDictionary alloc]init];
    
    FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
    
    if (storeTag!=NULL || storeTag.length!=0)
    {
        fHelper.userFpTag=storeTag;
        
        [userSetting addEntriesFromDictionary:[fHelper openUserSettings]];
        
        if (userSetting!=NULL && userSetting!=nil)
        {
            if ([userSetting objectForKey:@"1st Login"]!=nil)
            {
                if ([[userSetting objectForKey:@"1st Login"] boolValue])
                {
                    [fHelper updateUserSettingWithValue:appCloseDate forKey:@"1stLoginCloseDate"];
                }
            }
            
            if ([userSetting objectForKey:@"2nd Login"]!=nil)
            {
                if ([[userSetting objectForKey:@"2nd Login"] boolValue])
                {
                    [fHelper removeUserSettingforKey:@"1stLoginCloseDate"];
                    
                    [fHelper updateUserSettingWithValue:appCloseDate forKey:@"2ndLoginCloseDate"];
                }
            }
        }
    }
    
    
    

    
    [FBSession.activeSession closeAndClearTokenInformation];
    
    
}



- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [deviceTokenData setData:deviceToken];
    
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
        
    [userDefaults setObject:token forKey:@"apnsTokenNFBoost"];
    
    @try
    {
        if (storeTag!=NULL && ![storeTag isEqual:@""])
        {
            mixpanel = [Mixpanel sharedInstance];
            [mixpanel identify:storeTag];
            [mixpanel.people addPushDeviceToken:deviceTokenData];
        }
     }
    
    @catch (NSException *e)
    {
        NSLog(@"Execpetion at app delegate register channel :%@",e);
    }
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error.localizedDescription);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ( application.applicationState == UIApplicationStateActive)
    {
        if([storeDetailDictionary objectForKey:@"isFromNotification"] == [NSNumber numberWithBool:YES])
        {
            NSDictionary *aps = (NSDictionary *)[userInfo objectForKey:@"aps"];
            NSString *urlString = [aps objectForKey:@"url"];
            NSInteger badge = [aps objectForKey:@"badge"];
            
            if(badge != 0)
            {
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            }
            
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            if(url != NULL)
            {
                [self DeepLinkUrl:url];
            }
            
        }
        else
        {
            pushPayloadInApp = [[NSDictionary alloc] init];
            pushPayloadInApp = userInfo;
            NSString *cancelTitle = @"Close";
            
            NSString *showTitle = @"Open";
            
            NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Push notification"message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:showTitle, nil];
            
            alertView.tag = 101;
            
            [alertView show];
            

            
        }
        
    }
    else
    {
        
        
        NSDictionary *aps = (NSDictionary *)[userInfo objectForKey:@"aps"];
        NSString *urlString = [aps objectForKey:@"url"];
        NSInteger badge = [aps objectForKey:@"badge"];
        
        if(badge != 0)
        {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
        
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        if(url != NULL)
        {
            
            [self DeepLinkUrl:url];
        }
        
    }
   
}


#pragma RegisterChannel

-(void)setRegisterChannel
{
    RegisterChannel *regChannel=[[RegisterChannel alloc]init];
    
    regChannel.delegate=self;
    
    [regChannel registerNotificationChannel];
}

#pragma RegisterChannelDelegate

-(void)channelDidRegisterSuccessfully
{
    //    NSLog(@"channelDidRegisterSuccessfully");
}

-(void)channelFailedToRegister
{
    //    NSLog(@"channelFailedToRegister");
}



@end
