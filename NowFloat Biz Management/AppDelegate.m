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
#import "MasterViewController.h"
#import "SettingsViewController.h"
#import "UIColor+HexaString.h"
#import "RightViewController.h"
#import "SearchQueryController.h"
#import "BizStoreIAPHelper.h"
#import "Mixpanel.h"
#import "LeftViewController.h"
#import "FileManagerHelper.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>

//ae49e4d9b8aed0e4f9de3a25c734d929

#define MIXPANEL_TOKEN @"be4edc1ffc2eb228f1583bd396787c9a"

@implementation AppDelegate
@synthesize storeDetailDictionary,msgArray,fpDetailDictionary,clientId;

@synthesize businessDescription,businessName;
@synthesize dealDescriptionArray,dealDateArray,dealId,arrayToSkipMessage;
@synthesize userMessagesArray,userMessageContactArray,userMessageDateArray,inboxArray,storeTimingsArray,storeContactArray,storeTag,storeEmail,storeFacebook,storeWebsite,storeVisitorGraphArray,storeAnalyticsArray,apiWithFloatsUri,apiUri,secondaryImageArray,dealImageArray,localImageUri,primaryImageUploadUrl,primaryImageUri,fbUserAdminArray,fbUserAdminAccessTokenArray,fbUserAdminIdArray,socialNetworkNameArray,fbPageAdminSelectedIndexArray,socialNetworkAccessTokenArray,socialNetworkIdArray,multiStoreArray,addedFloatsArray,deletedFloatsArray,searchQueryArray,isNotified,storeCategoryName,storeWidgetArray,storeRootAliasUri,storeLogoURI,deviceTokenData;

@synthesize mixpanel,startTime,bgTask;
@synthesize settingsController=_settingsController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Let the device know we want to receive push notifications
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
    storeWebsite=[[NSString alloc]init];
    storeFacebook=[[NSString alloc]init];
    storeEmail=[[NSString alloc]init];
    
    
    storeVisitorGraphArray=[[NSMutableArray alloc]init];
    storeAnalyticsArray=[[NSMutableArray alloc]init];
    
    apiWithFloatsUri=@"https://api.withfloats.com/Discover/v1/floatingPoint";
    apiUri=@"https://api.withfloats.com";
    
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
    
    
    userDefaults=[NSUserDefaults standardUserDefaults];

    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	self.window = window;
    
    self.mixpanel = [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    
    self.mixpanel.flushInterval = 1; // defaults to 60 seconds

    
    LoginViewController *loginController=[[LoginViewController alloc]init];
    
    TutorialViewController *tutorialController=[[TutorialViewController alloc]init];
    
    //MasterViewController *rearViewController=[[MasterViewController  alloc]init];
    
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
            
    //navigationController.navigationBar.tintColor=[UIColor clearColor];
    
    //RightViewController *rightController=[[RightViewController alloc]init];

    NSString *version = [[UIDevice currentDevice] systemVersion];
 
    if ([version intValue] < 7)
    {
     
     UIImage *navBackgroundImage = [UIImage imageNamed:@"header-bg.png"];
     
     [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
     
     [[UINavigationBar appearance] setTitleTextAttributes:
      @{
        UITextAttributeTextColor: [UIColor whiteColor],
        UITextAttributeTextShadowColor: [UIColor clearColor],
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
        
    
        [[UINavigationBar appearance] setTitleTextAttributes:
         @{
           UITextAttributeTextColor: [UIColor colorWithHexString:@"464646"],
           UITextAttributeTextShadowColor: [UIColor colorWithHexString:@"464646"],
           UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero],
           UITextAttributeFont: [UIFont fontWithName:@"Helvetica" size:18.0f]
           }];

    }
    
    
    
/*
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
    
    if ([version intValue] < 7)
    {
        UIImage *barButtonImage = [[UIImage imageNamed:@"btn bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,6,0,6)];
        
        [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        UIImage *backButtonImage = [[UIImage imageNamed:@"btn bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,6, 0, 6)];
        
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
*/

    
    
    
	SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:navigationController];
    
    revealController.delegate = self;
    
    //revealController.rightViewController=rightController;
    
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
    
    NSNumber *seconds = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:self.startTime]];
    [[Mixpanel sharedInstance] track:@"Session" properties:[NSDictionary dictionaryWithObject:seconds forKey:@"Length"]];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
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
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    self.startTime = [NSDate date];

    FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
    
    if (storeTag!=NULL || storeTag.length!=0)
    {
        fHelper.userFpTag=storeTag;
        
        [fHelper updateUserSettingWithValue:self.startTime forKey:@"appStartDate"];
    }
    
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
    
    NSLog(@"applicationWillTerminate");
    
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
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    
    [deviceTokenData setData:deviceToken];
    
    
    if ([userDefaults objectForKey:@"apnsTokenNFBoost"]!=nil)
    {
        if (![token isEqualToString:[userDefaults objectForKey:@"apnsTokenNFBoost"]])
        {
            
            [userDefaults setObject:token forKey:@"apnsTokenNFBoost"];
        }
    }
    
    else
    {
        [userDefaults setObject:token forKey:@"apnsTokenNFBoost"];
    }
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

@end
