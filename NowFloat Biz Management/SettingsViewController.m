//
//  SettingsViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 11/03/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "SettingsViewController.h"
#import <Social/Social.h>
#import "Accounts/Accounts.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIColor+HexaString.h"        
#import <QuartzCore/QuartzCore.h>


@interface SettingsViewController ()

@end

@implementation SettingsViewController



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
    
    [fbAdminPageSubView setHidden:YES];
    
    [activitySubView setHidden:YES];
    
    isForFBPageAdmin=NO;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    userFbAdminDetailsArray=[[NSMutableArray alloc]init];
        
    [titleBgLabel  setBackgroundColor:[UIColor colorWithHexString:@"3a589b"]];
    
    [fbPageOkBtn setBackgroundColor:[UIColor colorWithHexString:@"3a589b"]];
    
    [fbPageClose setBackgroundColor:[UIColor colorWithHexString:@"3a589b"]];
    
    [fbPageOkBtn.layer setCornerRadius:6.0];
    
    [fbPageClose.layer setCornerRadius:6.0];

    [fbAdminPageSubView.layer setCornerRadius:6.0];
                
    SWRevealViewController *revealController = [self revealViewController];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"detail-btn.png"]
                     style:UIBarButtonItemStyleBordered
                    target:revealController action:@selector(revealToggle:)];
    
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    
    if ([userDefaults objectForKey:@"NFManageFBUserId"] && [userDefaults objectForKey:@"NFManageFBAccessToken"])
    {
        [disconnectFacebookButton setHidden:NO];
        [facebookButton setHidden:YES];
    }
    
    else
    {
        [disconnectFacebookButton setHidden:YES];
        [facebookButton setHidden:NO];    
    }
    
    
    if ([userDefaults objectForKey:@"NFManageUserFBAdminDetails"])
    {        
        [disconnectFacebookAdmin setHidden:NO];
        [facebookAdminButton setHidden:YES];
    }
    
    
    else
    {
        [disconnectFacebookAdmin setHidden:YES];
        [facebookAdminButton setHidden:NO];    
    }
    
    
    NSLog(@"User Defaults:%@",[userDefaults dictionaryRepresentation]);
    
}


#pragma UITableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return appDelegate.fbUserAdminIdArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static  NSString *identifier = @"TableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=[appDelegate.fbUserAdminArray objectAtIndex:[indexPath row]];
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    
    return cell;    
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([selectedCell accessoryType] == UITableViewCellAccessoryNone)
    {
        [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [appDelegate.fbPageAdminSelectedIndexArray addObject:[NSNumber numberWithInt:indexPath.row]];        
    }
    else
    {
        [selectedCell setAccessoryType:UITableViewCellAccessoryNone];
        [appDelegate.fbPageAdminSelectedIndexArray removeObject:[NSNumber numberWithInt:indexPath.row]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}


- (IBAction)facebookButtonClicked:(id)sender
{
    [self openSession:NO];
    [disconnectFacebookButton setHidden:NO];
    [facebookButton setHidden:YES];
}


- (IBAction)fbAdminButtonClicked:(id)sender
{
    [activitySubView setHidden:NO];

    [self openSession:YES];
}


- (IBAction)disconnectFbPageAdminButtonClicked:(id)sender
{
    fbAdminTableView=nil;
    [disconnectFacebookAdmin setHidden:YES];
    [facebookAdminButton setHidden:NO];
    [userDefaults removeObjectForKey:@"NFManageUserFBAdminDetails"];
    [userDefaults  synchronize];
    [appDelegate.fbUserAdminArray removeAllObjects];
    [appDelegate.fbUserAdminAccessTokenArray removeAllObjects];
    [appDelegate.fbUserAdminIdArray removeAllObjects];
    [appDelegate.fbPageAdminSelectedIndexArray removeAllObjects];
    [appDelegate closeSession];
    
}


- (IBAction)disconnectFacebookButtonClicked:(id)sender
{
    
    [disconnectFacebookButton setHidden:YES];
    [facebookButton setHidden:NO];
    [userDefaults removeObjectForKey:@"NFManageFBUserId"];
    [userDefaults removeObjectForKey:@"NFManageFBAccessToken"];
    [appDelegate closeSession];
    [userDefaults synchronize];

}


- (IBAction)twitterButtonClicked:(id)sender
{

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateView
{
    
    NSLog(@"updateView");
    
    [fbAdminTableView reloadData];
    
    [activitySubView setHidden:YES];

    [fbAdminPageSubView setHidden:NO];
//    
//    [facebookAdminButton setHidden:YES];
//    
//    [disconnectFacebookAdmin setHidden:NO];
    
}


- (IBAction)closeFbAdminPageSubView:(id)sender
{
    [fbAdminPageSubView setHidden:YES];
    
    [disconnectFacebookAdmin setHidden:YES];
    
    [facebookAdminButton setHidden:NO];
    
    [userDefaults removeObjectForKey:@"NFManageUserFBAdminDetails"];
    
    [userDefaults  synchronize];
    
    [appDelegate.fbUserAdminArray removeAllObjects];
    
    [appDelegate.fbUserAdminAccessTokenArray removeAllObjects];
    
    [appDelegate.fbUserAdminIdArray removeAllObjects];
    
    [appDelegate.fbPageAdminSelectedIndexArray removeAllObjects];
    
    [appDelegate closeSession];
    
}

- (IBAction)selectFbPages:(id)sender
{
    
    if ([appDelegate.fbPageAdminSelectedIndexArray count]>0)
    {        
        [fbAdminPageSubView setHidden:YES];

        [facebookAdminButton setHidden:YES];
        
        [disconnectFacebookAdmin setHidden:NO];
    }
    
    
    else
    {
        
        UIAlertView *selectionAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Please select a page from the list" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [selectionAlert show];
        selectionAlert=nil;
    
    }
    
}


- (void)viewDidUnload
{
    facebookButton = nil;
    disconnectFacebookButton = nil;
    disconnectFacebookAdmin = nil;
    facebookAdminButton = nil;
    fbAdminPageSubView = nil;
    activitySubView = nil;
    fbAdminTableView = nil;
    titleBgLabel = nil;
    fbPageOkBtn = nil;
    fbPageClose = nil;
    [super viewDidUnload];
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
                 NSMutableArray *userAdminInfo=[[NSMutableArray alloc]init];
                 
                 [userAdminInfo addObjectsFromArray:[user objectForKey:@"data"]];
                 
                 [self assignFbDetails:[user objectForKey:@"data"]];
                 
                 for (int i=0; i<[userAdminInfo count]; i++)
                 {
                     
                     [appDelegate.fbUserAdminArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"name" ] atIndex:i];
                     
                     [appDelegate.fbUserAdminAccessTokenArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"access_token" ] atIndex:i];
                     
                     [appDelegate.fbUserAdminIdArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"id" ] atIndex:i];
                 }
                 
                
                 [self updateView];
             }
             
             else
             {
                 
                 UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"You donot have pages to manage" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                 
                 [alerView show];
                 
                 alerView=nil;
                 
                 [activitySubView setHidden:YES];
                 
                 [disconnectFacebookAdmin setHidden:YES];
                 
                 [facebookAdminButton setHidden:NO];
                 
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


@end
