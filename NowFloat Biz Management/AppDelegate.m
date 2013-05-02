//
//  AppDelegate.m
//  NowFloat Biz Management
//
//  Created by Sumanta Roy on 25/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//fb193559690753525

#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "BizMessageViewController.h"
#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MasterViewController.h"
#import "SettingsViewController.h"



@implementation AppDelegate
@synthesize storeDetailDictionary,msgArray,fpDetailDictionary,clientId;

@synthesize businessDescription,businessName;
@synthesize dealDescriptionArray,dealDateArray,dealId,arrayToSkipMessage;
@synthesize userMessagesArray,userMessageContactArray,userMessageDateArray,inboxArray,storeTimingsArray,storeContactArray,storeTag,storeEmail,storeFacebook,storeWebsite,storeVisitorGraphArray,storeAnalyticsArray,apiWithFloatsUri,apiUri,secondaryImageArray,dealImageArray,localImageUri,primaryImageUploadUrl,primaryImageUri,fbUserAdminArray,fbUserAdminAccessTokenArray,fbUserAdminIdArray,socialNetworkNameArray,fbPageAdminSelectedIndexArray,socialNetworkAccessTokenArray,socialNetworkIdArray;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
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
    
    isFBPageAdminDeSelected=NO;
    isFBDeSelected=NO;
    
    
    userDefaults=[NSUserDefaults standardUserDefaults];

    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window = window;
    
    LoginViewController *loginController=[[LoginViewController alloc]init];
    
    MasterViewController *rearViewController=[[MasterViewController  alloc]init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
	
    navigationController.navigationBar.tintColor=[UIColor clearColor];

    

    /*
    UIImage *navBackgroundImage = [UIImage imageNamed:@"header-bg.png"];
    
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    
    UIImage *barButtonImage = [[UIImage imageNamed:@"header-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    */
    

    
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                UITextAttributeTextColor: [UIColor whiteColor],
                          UITextAttributeTextShadowColor: [UIColor clearColor],
                         UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero],
                                     UITextAttributeFont: [UIFont fontWithName:@"Helvetica" size:22.0f]
     }];
    

    
    
    
    
	SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:navigationController];
    
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
            
            //[socialNetworkArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"name" ] atIndex:i];
            
            [fbUserAdminArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"name" ] atIndex:i];
            
            [fbUserAdminAccessTokenArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"access_token" ] atIndex:i];
            
            [fbUserAdminIdArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"id" ] atIndex:i];
        }
        
    }
    
	return YES;
    

}


//"photo_upload", "user_photos","publish_stream", "read_stream", "offline_access"


- (void)openSession:(BOOL)isAdmin

{
    isForFBPageAdmin=isAdmin;
    
    NSArray *permissions =  [NSArray arrayWithObjects:
                             @"publish_stream",
                             @"manage_pages"
                             ,nil];

    [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
     {
        [self sessionStateChanged:session state:state error:error];

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
    NSString * accessToken = [[FBSession activeSession] accessToken];
    
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
    return [FBSession.activeSession handleOpenURL:url];
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
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];
    
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
    
    [FBSession.activeSession closeAndClearTokenInformation];
    
    
}
@end
