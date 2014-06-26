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
#import "SA_OAuthTwitterEngine.h"
#import "SocialSettingsFBHelper.h"
#import "NFActivityView.h"
#import "Mixpanel.h"

#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

#define kOAuthConsumerKey	  @"h5lB3rvjU66qOXHgrZK41Q"
#define kOAuthConsumerSecret  @"L0Bo08aevt2U1fLjuuYAMtANSAzWWi8voGuvbrdtcY4"		

static NSString * const kGPPClientID =
@"984100786522-r42c18kqh1j0h3b56bj6psb13t310bi3.apps.googleusercontent.com";


@interface SettingsViewController ()
{
    NFActivityView *nfActivity;
    Mixpanel *mixPanel;
}
@end

@implementation SettingsViewController
@synthesize isGestureAvailable,delegate,fblabel,fbpagelabel,twitterlabel;


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
    
    isForFBPageAdmin=NO;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    nfActivity=[[NFActivityView alloc]init];
    
    nfActivity.activityTitle=@"Loading";

    version = [[UIDevice currentDevice] systemVersion];

    userFbAdminDetailsArray=[[NSMutableArray alloc]init];
        
    [titleBgLabel  setBackgroundColor:[UIColor colorWithHexString:@"3a589b"]];
    
    [fbPageOkBtn setBackgroundColor:[UIColor colorWithHexString:@"3a589b"]];
    
    [fbPageClose setBackgroundColor:[UIColor colorWithHexString:@"3a589b"]];
    
    [fbPageOkBtn.layer setCornerRadius:6.0];
    
    [fbPageClose.layer setCornerRadius:6.0];

    [fbAdminPageSubView.layer setCornerRadius:6.0];
    
    [bgLabel.layer setCornerRadius:6.0];
    
    fbAdminPageSubView.center=self.view.center;
    
    activityContainer.center=self.view.center;
    
    placeHolderBg.center=self.view.center;
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    
    mixPanel = [Mixpanel sharedInstance];
    
    mixPanel.showNotificationOnActive = NO;
    
    /*Create a custom Navigation Bar here*/
    
    
    if (version.floatValue<7.0)
    {

        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                                   CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 13,160, 20)];
        
        headerLabel.text=@"Social Sharing";
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textAlignment=NSTextAlignmentCenter;
        
        headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
        
        [navBar addSubview:headerLabel];
        

    }

    else
    {
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
        
        self.navigationController.navigationBar.translucent = NO;
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        self.navigationItem.title=@"Social Sharing";
        
        [self.navigationController.navigationBar addSubview:view];
        
        
        [facebookButton.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];

        [facebookAdminButton.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];

        [twitterButton.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
        
        [facebookButton.layer setBorderWidth:1.0];
        [facebookAdminButton.layer setBorderWidth:1.0];
        [twitterButton.layer setBorderWidth:1.0];

        [facebookButton.layer setCornerRadius:6.0];
        [facebookAdminButton.layer setCornerRadius:6.0];
        [twitterButton.layer setCornerRadius:6.0];
        
    }
    
    if (isGestureAvailable)
    {
        SWRevealViewController *revealController = [self revealViewController];
        
        revealController.delegate=self;
        
        //Set the RightRevealWidth 0
        revealController.rightViewRevealWidth=0;
        
        revealController.rightViewRevealOverdraw=0;
    
        [self.view addGestureRecognizer:revealController.panGestureRecognizer];
        
        if (version.floatValue<7.0)
        {
            UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
            
            [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
            
            [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            
            [navBar addSubview:leftCustomButton];

        }
        
        
        else
        {
            
            
            
            UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
            
            [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
            
            [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];

            UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftCustomButton];
            
            self.navigationItem.leftBarButtonItem = leftBtnItem;

        
        }
        
    }
    
    else
    {
        
       // UIImage *buttonCancelImage = [UIImage imageNamed:@"pre-btn.png"];
        
        UIButton  *customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [customCancelButton setFrame:CGRectMake(5,9,32,26)];
        
        [customCancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [customCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        
        [customCancelButton setShowsTouchWhenHighlighted:YES];

        if (version.floatValue<7.0)
        {
            [navBar addSubview:customCancelButton];            
        }
        
        else
        {
            UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:customCancelButton];
            
            self.navigationItem.leftBarButtonItem = leftBtnItem;
        }
        
        
    }

    
    if ([userDefaults objectForKey:@"NFManageFBUserId"] && [userDefaults objectForKey:@"NFManageFBAccessToken"])
    {
        fblabel.frame = CGRectMake(53, 28, 93, 20);
        [fbUserNameLabel setText:[userDefaults objectForKey:@"NFFacebookName"]];
        [disconnectFacebookButton setHidden:NO];
        [facebookButton setHidden:YES];
    }
    
    else
    {
        fblabel.frame = CGRectMake(53, 38, 93, 20);
        [disconnectFacebookButton setHidden:YES];
        [facebookButton setHidden:NO];
    }
    
    
    if (appDelegate.socialNetworkNameArray.count)
    {
        fbpagelabel.frame = CGRectMake(53, 73, 150, 20);
        [fbPageNameLabel setText:[appDelegate.socialNetworkNameArray objectAtIndex:0]];
        [disconnectFacebookAdmin setHidden:NO];
        [facebookAdminButton setHidden:YES];
    }
    
    
    else
    {
        fbpagelabel.frame = CGRectMake(53, 83, 150, 20);
        [disconnectFacebookAdmin setHidden:YES];
        [facebookAdminButton setHidden:NO];
    }
    
    
    if ([userDefaults objectForKey:@"authData"])
    {
         twitterlabel.frame = CGRectMake(53, 125, 93, 20);
        [disconnectTwitterButton setHidden:NO];
        [twitterButton setHidden:YES];
        [twitterUserNameLabel setText:[userDefaults objectForKey:@"NFManageTwitterUserName"]];
    }
    
    
    else
    {
        twitterlabel.frame = CGRectMake(53, 130, 93, 20);
        [twitterButton setHidden:NO];
        [disconnectTwitterButton setHidden:YES];
    }
    
    
    if ([FBSession activeSession].isOpen)
    {
        [[FBSession activeSession] closeAndClearTokenInformation];
    }

    
    
}

-(void)back
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    if ([delegate respondsToSelector:@selector(settingsViewUserDidComplete)])
    {
        [delegate performSelector:@selector(settingsViewUserDidComplete) withObject:nil];
    }

}

- (IBAction)facebookBtnClicked:(id)sender
{
    /*
    [[FBSession activeSession] closeAndClearTokenInformation];
    [self openSession:NO];
    [disconnectFacebookButton setHidden:NO];
    [facebookButton setHidden:YES];
     */
    
    [[SocialSettingsFBHelper sharedInstance]requestLoginAsAdmin:NO WithCompletionHandler:^(BOOL Success, NSDictionary *userDetails)
    {
        if (Success)
        {
            fblabel.frame = CGRectMake(53, 28, 93, 20);
            [disconnectFacebookButton setHidden:NO];
            [facebookButton setHidden:YES];
            [userDefaults setObject:[userDetails objectForKey:@"id"] forKey:@"NFManageFBUserId"];
            [userDefaults setObject:[userDetails objectForKey:@"name"] forKey:@"NFFacebookName"];
            [fbUserNameLabel setText:[userDetails objectForKey:@"name"]];
            [facebookButton setHidden:YES];
            [disconnectFacebookButton setHidden:NO];
            [userDefaults synchronize];
        }
        
        else
        {
            /*
            UIAlertView *failedFbAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Something went wrong connecting to facebook" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [failedFbAlert show];
            
            failedFbAlert=nil;
             */
        }
    }];
}

- (IBAction)fbAdminBtnClicked:(id)sender
{
    
    [nfActivity showCustomActivityView];
    
    [[SocialSettingsFBHelper sharedInstance]requestLoginAsAdmin:YES WithCompletionHandler:^(BOOL Success, NSDictionary *userDetails)
     {
         
         if (Success)
         {
             
             [nfActivity hideCustomActivityView];
             
             if ([[userDetails objectForKey:@"data"] count]>0)
             {
                 fbpagelabel.frame = CGRectMake(53, 73, 150, 20);
                 [appDelegate.socialNetworkNameArray removeAllObjects];
                 [appDelegate.fbUserAdminArray removeAllObjects];
                 [appDelegate.fbUserAdminIdArray removeAllObjects];
                 [appDelegate.fbUserAdminAccessTokenArray removeAllObjects];
                 
                 NSMutableArray *userAdminInfo=[[NSMutableArray alloc]init];
                 
                 [userAdminInfo addObjectsFromArray:[userDetails objectForKey:@"data"]];
                 
                 [self assignFbDetails:[userDetails objectForKey:@"data"]];
                 
                 for (int i=0; i<[userAdminInfo count]; i++)
                 {
                     [appDelegate.fbUserAdminArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"name" ] atIndex:i];
                     
                     [appDelegate.fbUserAdminAccessTokenArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"access_token" ] atIndex:i];
                     
                     [appDelegate.fbUserAdminIdArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"id" ] atIndex:i];
                 }
                 [self showFbPagesSubView];
             }

         }
         
         else
         {
             /*
             UIAlertView *failedFbAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Something went wrong connecting to facebook" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             
             [failedFbAlert show];
             
             failedFbAlert=nil;
             */
              [nfActivity hideCustomActivityView];
         }
     }];
}

- (IBAction)disconnectFbPageAdminBtnClicked:(id)sender
{
    fbpagelabel.frame = CGRectMake(53, 83, 150, 20);
    fbAdminTableView=nil;
    [fbPageNameLabel setText:@""];
    [disconnectFacebookAdmin setHidden:YES];
    [facebookAdminButton setHidden:NO];
    [userDefaults removeObjectForKey:@"NFManageUserFBAdminDetails"];
    [userDefaults  synchronize];
    [appDelegate.fbUserAdminArray removeAllObjects];
    [appDelegate.fbUserAdminAccessTokenArray removeAllObjects];
    [appDelegate.fbUserAdminIdArray removeAllObjects];
    [appDelegate.fbPageAdminSelectedIndexArray removeAllObjects];
    [appDelegate.socialNetworkNameArray removeAllObjects];
    [appDelegate.socialNetworkAccessTokenArray removeAllObjects];
    [appDelegate.socialNetworkIdArray removeAllObjects];
    [appDelegate closeSession];

}

- (IBAction)disconnectFacebookBtnClicked:(id)sender
{
    fblabel.frame = CGRectMake(53, 38, 93, 20);
    [disconnectFacebookButton setHidden:YES];
    [facebookButton setHidden:NO];
    [fbUserNameLabel setText:@""];
    
    [appDelegate.fbUserAdminArray removeAllObjects];
    [appDelegate.fbUserAdminAccessTokenArray removeAllObjects];
    [appDelegate.fbUserAdminIdArray removeAllObjects];
    
    [appDelegate.socialNetworkNameArray removeAllObjects];
    [appDelegate.socialNetworkAccessTokenArray removeAllObjects];
    [appDelegate.socialNetworkIdArray removeAllObjects];
    
    [userDefaults removeObjectForKey:@"NFManageFBUserId"];
    [userDefaults removeObjectForKey:@"NFManageFBAccessToken"];
    [userDefaults synchronize];

}

- (IBAction)twitterBtnClicked:(id)sender
{
    // Twitter Initialization / Login Code Goes Here
    
    if(!_engine)
    {
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        _engine.consumerKey    = kOAuthConsumerKey;
        _engine.consumerSecret = kOAuthConsumerSecret;
    }
    
	 if(![_engine isAuthorized])
     {
	    UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];
	    if (controller)
        {
            [self presentViewController:controller animated:YES completion:nil];
	    }
     }

    
    [twitterButton setHidden:YES];
    [disconnectTwitterButton setHidden:NO];

    
}

- (IBAction)disconnectTwitterBtnClicked:(id)sender
{
    
    [_engine clearAccessToken];
     twitterlabel.frame = CGRectMake(53, 130, 93, 20);
    [userDefaults removeObjectForKey:@"authData"];
    [userDefaults removeObjectForKey:@"NFManageTwitterUserName"];
    [userDefaults synchronize];
    
    [twitterButton setHidden:NO];
    [disconnectTwitterButton setHidden:YES];
    twitterUserNameLabel.text=@"";
}



#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}


- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username
{
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier
{
	NSLog(@"Request %@ succeeded", requestIdentifier);
}
- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}



#pragma SA_OAuthTwitterControllerDelegate

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller
{
    [twitterButton setHidden:NO];
    [disconnectTwitterButton setHidden:YES];
}

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username
{

    twitterUserNameLabel.text=username;
    
    [userDefaults setObject:username forKey:@"NFManageTwitterUserName"];
    
    [userDefaults synchronize];
    twitterlabel.frame = CGRectMake(53, 125, 93, 20);

}

-(void)updateView
{
    
    [fbAdminTableView reloadData];
    
    [nfActivity hideCustomActivityView];
    
    [fbAdminPageSubView setHidden:NO];

}


- (IBAction)closeFbAdminPageSubView:(id)sender
{
    
    
    [fbAdminPageSubView setHidden:YES];
    
    if ([appDelegate.socialNetworkNameArray count])
    {
        [fbPageNameLabel setText:[appDelegate.socialNetworkNameArray objectAtIndex:0]];
        [disconnectFacebookAdmin setHidden:NO];
        [facebookAdminButton setHidden:YES];
    }
    
    else
    {    
        [disconnectFacebookAdmin setHidden:YES];
        [facebookAdminButton setHidden:NO];
    }
    
    
    
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
    
    NSArray *a1=[NSArray arrayWithObject:[appDelegate.fbUserAdminArray objectAtIndex:[indexPath  row]]];
    
    NSArray *a2=[NSArray arrayWithObject:[appDelegate.fbUserAdminAccessTokenArray objectAtIndex:[indexPath row]]];
    
    NSArray *a3=[NSArray arrayWithObject:[appDelegate.fbUserAdminIdArray objectAtIndex:[indexPath row]]];
    
    [appDelegate.socialNetworkNameArray addObjectsFromArray:a1];
    [appDelegate.socialNetworkAccessTokenArray addObjectsFromArray:a2];
    [appDelegate.socialNetworkIdArray addObjectsFromArray:a3];
    
    
    [userDefaults setObject:a1 forKey:@"FBUserPageAdminName"];
    [userDefaults setObject:a2 forKey:@"FBUserPageAdminAccessToken"];
    [userDefaults setObject:a3 forKey:@"FBUserPageAdminId"];
    
    [userDefaults synchronize];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [fbAdminPageSubView setHidden:YES];
    
    if ([appDelegate.socialNetworkNameArray count])
    {
        [fbPageNameLabel setText:[appDelegate.socialNetworkNameArray objectAtIndex:0]];
        [disconnectFacebookAdmin setHidden:NO];
        [facebookAdminButton setHidden:YES];
    }

}


- (void)openSession:(BOOL)isAdmin
{

    isForFBPageAdmin=isAdmin;
    
    version = [[UIDevice currentDevice] systemVersion];
    
    if ([version floatValue]<7.0)
    {

        [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
         {
         [self sessionStateChanged:session state:state error:error];
         
         }];
    }
    
    
    else
    {
        NSArray *permissions =  [NSArray arrayWithObjects:
                                 @"publish_stream",
                                 @"manage_pages",@"publish_actions"
                                 ,nil];
        
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             [self sessionStateChanged:session state:status error:error];
         }];
    }
    

}


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
{    switch (state)
    {
        case FBSessionStateOpen:
        {
            
            NSArray *permissions =  [NSArray arrayWithObjects:
                                     @"publish_stream",
                                     @"manage_pages",@"publish_actions"
                                     ,nil];
            
            if ([FBSession.activeSession.permissions
                 indexOfObject:@"publish_actions"] == NSNotFound)
            {
                            
                [[FBSession activeSession] requestNewPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error)
                 {
                     
                     if (isForFBPageAdmin)
                     {
                         [self connectAsFbPageAdmin];
                     }
                     
                     else
                     {
                         [self populateUserDetails];
                     }
                     
                     
                 }];
            }
            
            else
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

        }
            
            break;
            
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
        {
            
            if (isForFBPageAdmin)
            {
                
                 [nfActivity hideCustomActivityView];
                
            }
            
            
            else{
        
                [disconnectFacebookButton setHidden:YES];
                [facebookButton setHidden:NO];
            
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
    NSString * accessToken =  [[FBSession activeSession] accessTokenData].accessToken;

    [userDefaults setObject:accessToken forKey:@"NFManageFBAccessToken"];
    
    NSLog(@"accessToken:%@",accessToken);
    
    [userDefaults synchronize];
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
     {
         if (!error)
         {            
             [userDefaults setObject:[user objectForKey:@"id"] forKey:@"NFManageFBUserId"];
             [userDefaults setObject:[user objectForKey:@"name"] forKey:@"NFFacebookName"];
             [fbUserNameLabel setText:[user objectForKey:@"name"]];             
             [facebookButton setHidden:YES];
             [disconnectFacebookButton setHidden:NO];
             [userDefaults synchronize];
         }
         
         
            else
                
            {            
                UIAlertView *fbFailedAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
                
                [fbFailedAlert show];
                
                fbFailedAlert=nil;
            }
     }
     ];
    

    [FBSession.activeSession closeAndClearTokenInformation];

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
                 [self showFbPagesSubView];
             }
             
             else
             {
                 UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"You do not have pages to manage" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                 
                 [alerView show];
                 
                 alerView=nil;
                 
                 [FBSession.activeSession closeAndClearTokenInformation];

                 
             }
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


-(void)fbResync
{
    ACAccountStore *accountStore;
    ACAccountType *accountTypeFB;
    if ((accountStore = [[ACAccountStore alloc] init]) && (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook] ) ){
        
        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
        id account;
        if (fbAccounts && [fbAccounts count] > 0 && (account = [fbAccounts objectAtIndex:0])){
            
            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                //we don't actually need to inspect renewResult or error.
                if (error){
                    
                    NSLog(@"error in resync:%@",[error localizedDescription]);
                }
            }];
        }
        
        
    }
}


-(void)assignFbDetails:(NSArray*)sender
{
    
    [userDefaults setObject:sender forKey:@"NFManageUserFBAdminDetails"];
    
    [userDefaults synchronize];
    
}


-(void)showFbPagesSubView
{
    [nfActivity hideCustomActivityView];
    [fbAdminPageSubView setHidden:NO];
    [fbAdminTableView reloadData];
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
    
    SWRevealViewController *revealController = [self revealViewController];
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeftSide"]) {
        
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
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"]) {
        
        [revealFrontControllerButton setHidden:NO];
        
    }
    
    
    
}


- (void)viewDidUnload
{
    facebookButton = nil;
    disconnectFacebookButton = nil;
    disconnectFacebookAdmin = nil;
    facebookAdminButton = nil;
    fbAdminPageSubView = nil;
    fbAdminTableView = nil;
    titleBgLabel = nil;
    fbPageOkBtn = nil;
    fbPageClose = nil;
    bgLabel = nil;
    fbUserNameLabel = nil;
    fbPageNameLabel = nil;
    disconnectTwitterButton = nil;
    twitterButton = nil;
    twitterUserNameLabel = nil;
    revealFrontControllerButton = nil;
    [super viewDidUnload];
}


#pragma mark - FBLoginView delegate


- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    if ([FBSession activeSession].isOpen)
    {
        [self populateUserDetails];
    }
    
}


- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    
    if (error.fberrorShouldNotifyUser)
    {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Something Went Wrong";
        alertMessage = error.fberrorUserMessage;
    }
    
    else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession)
    {
        // It is important to handle session closures as mentioned. You can inspect
        // the error for more context but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    }
    
    else if (error.fberrorCategory == FBErrorCategoryUserCancelled)
    {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
    }
    
    else
    {
        // For simplicity, this sample treats other errors blindly, but you should
        // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage)
    {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }

}


- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    
}

@end
