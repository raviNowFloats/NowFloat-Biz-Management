//
//  SettingsController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 25/04/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "SettingsController.h"
#import <Social/Social.h>
#import "Accounts/Accounts.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIColor+HexaString.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialViewController.h"
#import "SelectFbPageViewController.h"

@interface SettingsController ()

@end

@implementation SettingsController

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
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    listOfItems=[[NSMutableArray alloc]init];
        
    socialNetworksArray=[[NSMutableArray alloc]initWithObjects:@"Facebook",@"Facebook Pages", nil];
    
    manageArray=[[NSMutableArray alloc]initWithObjects:@"Manage accounts", nil];
    
    socialNetworkImageArray=[[NSMutableArray alloc]initWithObjects:@"facebookoriginal.png",@"facebookoriginal.png",nil];
    
    
    NSDictionary *s1=[NSDictionary dictionaryWithObject:socialNetworksArray forKey:@"SocialNetworks"];
    
    NSDictionary *s2=[NSDictionary dictionaryWithObject:manageArray forKey:@"SocialNetworks"];
    
    
    [listOfItems addObject:s1];
    [listOfItems addObject:s2];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"detail-btn.png"]
             style:UIBarButtonItemStyleBordered
            target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    
//    [userDefaults removeObjectForKey:@"NFManageUserFBAdminDetails"];
//    [userDefaults   synchronize];
    
    
//    [userDefaults removeObjectForKey:@"NFManageFBAccessToken"];
//    [userDefaults removeObjectForKey:@"NFManageFBUserId"];
//    [userDefaults   synchronize];

    
}


#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;// Default is 1 if not implemented
{
    
    return [listOfItems count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSDictionary *dictionary = [listOfItems objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"SocialNetworks"];
    return [array count];

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"SocialNetworks"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:14.0];

    
    if ([indexPath section]==0)
    {
        
        cell.imageView.image=[UIImage imageNamed:[socialNetworkImageArray objectAtIndex:[indexPath row]]];
    }
    
    
    else
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    
    return cell;
}






#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    /*
    NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"SocialNetworks"];
    NSString *selectedType = [array objectAtIndex:indexPath.row];
    */
    
    if ([indexPath section]==0)
    {
        if (indexPath.row==0)
        {
            [self populateUserDetails];
        }
        
        else if (indexPath.row==1)
        {
            
            [self connectAsFbPageAdmin];
        }
    }
    
    
    
    else if ([indexPath section]==1)
    {
        SocialViewController *sController=[[SocialViewController alloc]initWithNibName:@"SocialViewController" bundle:nil];
        
        [self.navigationController pushViewController:sController animated:YES];
        
        sController=nil;
    }
    
    


    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
             [userDefaults setObject:[user objectForKey:@"name"] forKey:@"NFFacebookName"];
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
         if ([[user objectForKey:@"data"] count]>0)
         {
             [appDelegate.socialNetworkNameArray removeAllObjects];
             [appDelegate.fbUserAdminArray removeAllObjects];
             [appDelegate.fbUserAdminIdArray removeAllObjects];
             [appDelegate.fbUserAdminAccessTokenArray removeAllObjects];
             
             NSMutableArray *userAdminInfo=[[NSMutableArray alloc]init];
             
             [userAdminInfo addObjectsFromArray:[user objectForKey:@"data"]];
             
                 [self assignFbDetails:[user objectForKey:@"data"]];
    
                 for (int i=0; i<[userAdminInfo count]; i++)
                 {
                     [appDelegate.fbUserAdminArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"name" ] atIndex:i];
                     
                     [appDelegate.fbUserAdminAccessTokenArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"access_token" ] atIndex:i];
                     
                     [appDelegate.fbUserAdminIdArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"id" ] atIndex:i];

                 }
                                  
                 [self pushSelectFBPageController];
             
        }
         
         else
         {
             UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"You do not have pages to manage" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
             
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


-(void)assignFbDetails:(NSArray*)sender
{
    
    [userDefaults setObject:sender forKey:@"NFManageUserFBAdminDetails"];
    
    [userDefaults synchronize];
    
}


-(void)pushSelectFBPageController
{
    
    
    SelectFbPageViewController *selectController=[[SelectFbPageViewController alloc]initWithNibName:@"SelectFbPageViewController" bundle:nil];
    
    [self.navigationController  pushViewController:selectController animated:YES];
    
    selectController=nil;




}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
