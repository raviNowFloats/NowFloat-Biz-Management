//
//  AppDelegate.m
//  NowFloat Biz Management
//
//  Created by Sumanta Roy on 25/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "BizMessageViewController.h"
#import "MasterController.h"
#import "LoginViewController.h"



@implementation AppDelegate
@synthesize storeDetailDictionary,msgArray,fpDetailDictionary,clientId;

@synthesize businessDescription,businessName;
@synthesize dealDescriptionArray,dealDateArray,dealId,arrayToSkipMessage;
@synthesize userMessagesArray,userMessageContactArray,userMessageDateArray,inboxArray,storeTimingsArray,storeContactArray,storeTag,storeEmail,storeFacebook,storeWebsite;





- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(@"Application did finish launching with options");
    
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
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window = window;
    
    LoginViewController *loginController=[[LoginViewController alloc]init];
    
    MasterController *rearViewController=[[MasterController  alloc]init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
	
    navigationController.navigationBar.tintColor=[UIColor blackColor];
    
	SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:navigationController];
    
    revealController.delegate = self;
    
	self.viewController = revealController;
	
	self.window.rootViewController = self.viewController;
    
	[self.window makeKeyAndVisible];
    
	return YES;

    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{    
//    [msgArray removeAllObjects];
//    [storeDetailDictionary removeAllObjects];
//    [fpDetailDictionary removeAllObjects];
//
//        
//    [dealDateArray removeAllObjects];
//    [dealDescriptionArray removeAllObjects];
//    [dealId removeAllObjects];
//    [arrayToSkipMessage removeAllObjects];
//    
//    [inboxArray removeAllObjects];
//    [userMessagesArray removeAllObjects];
//    [userMessageDateArray removeAllObjects];
//    [userMessageContactArray removeAllObjects];
//    
//    [storeTimingsArray removeAllObjects];
//    [storeContactArray removeAllObjects];
    
    

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
//    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//	self.window = window;
//    
//    LoginViewController *loginController=[[LoginViewController alloc]init];
//    
//    MasterController *rearViewController=[[MasterController  alloc]init];
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
//	
//    navigationController.navigationBar.tintColor=[UIColor blackColor];
//    
//	SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:navigationController];
//    
//    revealController.delegate = self;
//    
//	self.viewController = revealController;
//	
//	self.window.rootViewController = self.viewController;
//    
//	[self.window makeKeyAndVisible];
    
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
