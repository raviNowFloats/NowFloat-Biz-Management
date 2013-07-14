//
//  PostMessageViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 27/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "PostMessageViewController.h"
#import <QuartzCore/CoreAnimation.h>
#import "UIColor+HexaString.h"
#import "CreateStoreDeal.h"
#import "BizMessageViewController.h"
#import "UpdateFaceBook.h"
#import "SettingsViewController.h"
#import "UIColor+HexaString.h"
#import "UpdateFaceBookPage.h"  
#import "SA_OAuthTwitterEngine.h"
#import "UpdateTwitter.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "Mixpanel.h"    




#define kOAuthConsumerKey	  @"h5lB3rvjU66qOXHgrZK41Q"
#define kOAuthConsumerSecret  @"L0Bo08aevt2U1fLjuuYAMtANSAzWWi8voGuvbrdtcY4"


@interface PostMessageViewController  ()<updateDelegate>



@end

@implementation PostMessageViewController

@synthesize  postMessageTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) viewWillAppear:(BOOL)animated
{
        
    [super viewWillAppear:animated];
        
    [[NSNotificationCenter defaultCenter]
                             addObserver:self
                             selector:@selector(updateView)
                             name:@"updateMessage" object:nil];

    
    [self performSelector:@selector(showKeyBoard) withObject:nil afterDelay:0.4];
}


-(void)showKeyBoard
{

    [postMessageTextView becomeFirstResponder];


}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden=YES;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    isFacebookSelected=NO;

    isFacebookPageSelected=NO;
    
    isTwitterSelected=NO;
    
    isSendToSubscribers=YES;
    
    [selectedFacebookButton setHidden:YES];
    
    [selectedFacebookPageButton setHidden:YES];
    
    [selectedTwitterButton setHidden:YES];
    
    [sendToSubscribersOffButton setHidden:YES];
    
    [sendToSubscribersOnButton setHidden:NO];
        
    [bgLabel.layer setCornerRadius:6.0];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    
    [toolBarView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        
    [bgLabel.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    
    bgLabel.layer.borderWidth = 1.0;

    [characterCount setTextColor:[UIColor colorWithHexString:@"9c9b9b"]];
    
    [postMessageTextView setTextColor:[UIColor colorWithHexString:@"9c9b9b"]];
    
    revealController = self.revealViewController;
    
    frontNavigationController = (id)revealController.frontViewController;
    
    //Create NavBar here
    
    CGFloat width = self.view.frame.size.width;
    
    navBar = [[UINavigationBar alloc] initWithFrame:
              CGRectMake(0,0,width,44)];
    
    [self.view addSubview:navBar];

    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(128,13,160,20)];
    
    headerLabel.text=@"Message";
    
    headerLabel.backgroundColor=[UIColor clearColor];
    
    headerLabel.textColor=[UIColor colorWithHexString:@"464646"];
    
    headerLabel.font=[UIFont fontWithName:@"Helevetica" size:18.0];
    
    [navBar addSubview:headerLabel];

    

    [[NSNotificationCenter defaultCenter]
                         addObserver:self
                         selector:@selector(updateView)
                         name:@"updateMessage" object:nil];
    
    [[NSNotificationCenter defaultCenter]
                         addObserver:self
                         selector:@selector(showFbPagesSubView)
                         name:@"showAccountList" object:nil];

    
    
    [downloadSubview setHidden:YES];
    
    [fbPageSubView setHidden:YES];
        

    
    //Create the custom back bar button here....
    
    UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    
    backButton.frame = CGRectMake(5,0,50,44);
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:backButton];

    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40) ];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    
    
    UIBarButtonItem *cancelleftBarButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonClicked:)];
    NSArray *array = [NSArray arrayWithObjects:cancelleftBarButton, nil];
    [toolbar setItems:array];
    
    postMessageTextView.inputAccessoryView = toolBarView;
    
}


-(void)back
{    
    BizMessageViewController *bizController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:bizController];
    [[self navigationController] setViewControllers:viewControllers animated:YES];    
}


-(void)textViewDidChange:(UITextView *)textView
{
    NSString *substring = [NSString stringWithString:textView.text];
    
    createMessageLabel.hidden=YES;
    
    substring = [substring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (substring.length > 0)
    {
        characterCount.hidden = NO;
        
        characterCount.text = [NSString stringWithFormat:@"%d", substring.length];
        
        UIButton *customButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [customButton addTarget:self action:@selector(postMessage) forControlEvents:UIControlEventTouchUpInside];
        
        [customButton setFrame:CGRectMake(280,5, 30, 30)];
        
        [customButton setBackgroundImage:[UIImage imageNamed:@"checkmark.png"]  forState:UIControlStateNormal];
        
        [customButton setShowsTouchWhenHighlighted:YES];
        
        [navBar addSubview:customButton];

    }
    
    
    if (substring.length == 0)
    {
        characterCount.hidden = YES;
        createMessageLabel.hidden=NO;
        self.navigationItem.rightBarButtonItem=nil;

    }
    
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView;
{


}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL flag = NO;
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            flag = YES;
            return YES;
        }
        
        else
        {
            return NO;
        }
    }
    else if([[textView text] length] > 249)
    {
        return NO;
    }
    
    return YES;
}


-(void)postMessage
{

    if ([postMessageTextView.text length]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]
                                        initWithTitle:@"Ooops"
                                        message:@"Please fill a message"
                                        delegate:self
                                        cancelButtonTitle:@"Okay"
                                        otherButtonTitles:nil, nil];
        [alert  show];
        alert=nil;        
    }

    else
    {        
        [downloadSubview setHidden:NO];
        [postMessageTextView resignFirstResponder];
        

        
        [self performSelector:@selector(postNewMessage) withObject:nil afterDelay:0.1];
        
    }

}


-(void)postNewMessage
{

    
    
    CreateStoreDeal *createStrDeal=[[CreateStoreDeal alloc]init];
    
    createStrDeal.delegate=self;
        
    NSMutableDictionary *uploadDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
           postMessageTextView.text,@"message",
           [NSNumber numberWithBool:isSendToSubscribers],@"sendToSubscribers",[appDelegate.storeDetailDictionary  objectForKey:@"_id"],@"merchantId",appDelegate.clientId,@"clientId",nil];
    
    createStrDeal.offerDetailDictionary=[[NSMutableDictionary alloc]init];
    
    [createStrDeal createDeal:uploadDictionary isFbShare:isFacebookSelected isFbPageShare:isFacebookPageSelected isTwitterShare:isTwitterSelected];
    
}


-(void)downloadFinished
{
    [self updateView];
}


-(void)updateView
{
    BizMessageViewController *bizController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];

    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:bizController];
    [[self navigationController] setViewControllers:viewControllers animated:NO];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];    
    [mixpanel track:@"Post Message"];

}


- (IBAction)facebookButtonClicked:(id)sender
{

    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Facebook Sharing"];

    if ([userDefaults objectForKey:@"NFManageFBAccessToken"] && [userDefaults objectForKey:@"NFManageFBUserId"])
    {
        isFacebookSelected=YES;
        [facebookButton setHidden:YES];
        [selectedFacebookButton setHidden:NO];
    }
    
    else
    {

        
        
        UIAlertView *fbAlert=[[UIAlertView alloc]initWithTitle:@"Login" message:@"You need to be logged into Facebook" delegate:self    cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        [fbAlert setTag:1];
        [fbAlert show];
        fbAlert=nil;
        
        

    }

}


- (IBAction)selectedFaceBookClicked:(id)sender
{
    isFacebookSelected=NO;
    [selectedFacebookButton setHidden:YES];
    [facebookButton setHidden:NO];
    
}


- (IBAction)facebookPageButtonClicked:(id)sender
{
    
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Facebook page sharing"];

    if (!appDelegate.socialNetworkNameArray.count)
    {

        
        UIAlertView *fbPageAlert=[[UIAlertView alloc]initWithTitle:@"Login" message:@"You need to be logged into Facebook" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login ", nil];
        
        fbPageAlert.tag=2;
        
        [fbPageAlert show];
        
        fbPageAlert=nil;
        
        
    }
    
    else if (appDelegate.socialNetworkNameArray.count)
    {
        isFacebookPageSelected=YES;
        [selectedFacebookPageButton setHidden:NO];
        [facebookPageButton setHidden:YES];        
    }

}


- (IBAction)selectedFbPageButtonClicked:(id)sender
{
    isFacebookPageSelected=NO;
    [facebookPageButton setHidden:NO];
    [selectedFacebookPageButton setHidden:YES];
}


- (IBAction)fbPageSubViewCloseButtonClicked:(id)sender
{
    
    [fbPageSubView setHidden:YES];
    
    if ([appDelegate.socialNetworkNameArray count])
    {
        isFacebookPageSelected=YES;
        [selectedFacebookPageButton setHidden:NO];
        [facebookPageButton setHidden:YES];        
    }
    
    [self performSelector:@selector(showKeyBoard) withObject:nil afterDelay:0.1];
    
}


- (IBAction)twitterButtonClicked:(id)sender
{

    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Twitter sharing"];

    
    if (![userDefaults objectForKey:@"authData"])
    {
        
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
        
        isTwitterSelected=YES;
        [twitterButton setHidden:YES];
        [selectedTwitterButton setHidden:NO];
        
        
    }
    
    
    else
    {
    
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        _engine.consumerKey    = kOAuthConsumerKey;
        _engine.consumerSecret = kOAuthConsumerSecret;

        [_engine isAuthorized];
        
        isTwitterSelected=YES;
        [twitterButton setHidden:YES];
        [selectedTwitterButton setHidden:NO];
        
    }
    
    
}


- (IBAction)selectedTwitterButtonClicked:(id)sender
{
    
    isTwitterSelected=NO;
    [twitterButton setHidden:NO];
    [selectedTwitterButton setHidden:YES];
}

- (IBAction)sendToSubscibersOnClicked:(id)sender
{
    
    UIAlertView *sendToSubscribersAlert=[[UIAlertView alloc]initWithTitle:@"Confirm" message:@"Are you sure you don't want your subscribers to receive this message?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    sendToSubscribersAlert.tag=3;
    
    [sendToSubscribersAlert show];
    
    sendToSubscribersAlert=nil;
    
}


- (IBAction)sendToSubscribersOffClicked:(id)sender
{
    
    [sendToSubscribersOnButton setHidden:NO];
    [sendToSubscribersOffButton setHidden:YES];
    isSendToSubscribers=YES;
    
}






-(void)check
{
        isTwitterSelected=NO;
        [twitterButton setHidden:NO];
        [selectedTwitterButton setHidden:YES];

}



#pragma mark SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username
{
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}


- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}


#pragma SA_OAuthTwitterControllerDelegate

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller
{
    [self check];

}


- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username
{
      
    [userDefaults setObject:username forKey:@"NFManageTwitterUserName"];
    
    [userDefaults synchronize];
    
}



-(IBAction)dismissKeyboardOnTap:(id)sender
{
    [[self view] endEditing:YES];
}


-(void)showFbPagesSubView
{

    [downloadSubview setHidden:YES];
    [fbPageSubView setHidden:NO];
    [self reloadFBpagesTableView];
    
}


-(void)reloadFBpagesTableView
{

    [fbPageTableView reloadData];

}


#pragma UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return appDelegate.fbUserAdminIdArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static  NSString *identifier = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text=[appDelegate.fbUserAdminArray objectAtIndex:[indexPath row]];
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([selectedCell accessoryType] == UITableViewCellAccessoryNone)
    {
        [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        NSArray *a1=[NSArray arrayWithObject:[appDelegate.fbUserAdminArray objectAtIndex:[indexPath  row]]];
        
        NSArray *a2=[NSArray arrayWithObject:[appDelegate.fbUserAdminAccessTokenArray objectAtIndex:[indexPath row]]];
        
        NSArray *a3=[NSArray arrayWithObject:[appDelegate.fbUserAdminIdArray objectAtIndex:[indexPath row]]];
        
        [appDelegate.socialNetworkNameArray addObjectsFromArray:a1];
        [appDelegate.socialNetworkAccessTokenArray addObjectsFromArray:a2];
        [appDelegate.socialNetworkIdArray addObjectsFromArray:a3];
    }
    
    else
    {
        [selectedCell setAccessoryType:UITableViewCellAccessoryNone];
        [appDelegate.socialNetworkNameArray removeObject:[appDelegate.fbUserAdminArray   objectAtIndex:[indexPath row ]]];
        [appDelegate.socialNetworkIdArray removeObject:[appDelegate.fbUserAdminIdArray objectAtIndex:[indexPath row]]];
        [appDelegate.socialNetworkAccessTokenArray removeObject:[appDelegate.fbUserAdminAccessTokenArray objectAtIndex:[indexPath row] ]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


- (void)openSession:(BOOL)isAdmin
{
    
    isForFBPageAdmin=isAdmin;
    
    [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
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
            
            NSArray *permissions =  [NSArray arrayWithObjects:
                                     @"publish_stream",
                                     @"manage_pages",@"publish_actions"
                                     ,nil];

            if ([FBSession.activeSession.permissions
                 indexOfObject:@"publish_actions"] == NSNotFound)
            {
                
                [[FBSession activeSession] reauthorizeWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error)
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
        }
            
            break;
            
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
        {
            [downloadSubview setHidden:YES];
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
             
             isFacebookSelected=YES;
             [facebookButton setHidden:YES];
             [selectedFacebookButton setHidden:NO];
             [downloadSubview setHidden:YES];

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
                 
                 [self showFbPagesSubView];
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{


    if (alertView.tag==1)
    {
        
        if (buttonIndex==1)
        {
            [downloadSubview setHidden:NO];
            [self openSession:NO];            
        }
        
        
    }
    
    
    if (alertView.tag==2)
    {
        if (buttonIndex==1)
        {
            [postMessageTextView resignFirstResponder];
            [downloadSubview setHidden:NO];
            [self openSession:YES];
        }
                    
    }
    
    
    if (alertView.tag==3) {
        
        
        if (buttonIndex==1) {
            
            [sendToSubscribersOnButton setHidden:YES];
            [sendToSubscribersOffButton setHidden:NO];
            isSendToSubscribers=NO;
        }
        
        
    }
    


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [self setPostMessageTextView:nil];
    characterCount = nil;
    downloadSubview = nil;
    createMessageLabel = nil;
    facebookButton = nil;
    selectedFacebookButton = nil;
    facebookPageButton = nil;
    selectedFacebookPageButton = nil;
    fbPageTableView = nil;
    fbPageSubView = nil;
    bgLabel = nil;
    toolBarView = nil;
    twitterButton = nil;
    selectedTwitterButton = nil;
    sendToSubscribersOnButton = nil;
    sendToSubscribersOffButton = nil;
    [super viewDidUnload];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
