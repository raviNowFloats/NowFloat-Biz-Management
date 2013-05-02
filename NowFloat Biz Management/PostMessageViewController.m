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


@interface PostMessageViewController ()

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
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    isFacebookSelected=NO;

    isFacebookPageSelected=NO;
    
    [selectedFacebookButton setHidden:YES];
    
    [selectedFacebookPageButton setHidden:YES];

    [postMessageTextView.layer setCornerRadius:6];
    
    [selectPageBgLabel setBackgroundColor:[UIColor colorWithHexString:@"3a589b"]];
        
    revealController = self.revealViewController;
    
    frontNavigationController = (id)revealController.frontViewController;

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
        
        [customButton setFrame:CGRectMake(0, 0, 55, 30)];
        
        [customButton addTarget:self action:@selector(postMessage) forControlEvents:UIControlEventTouchUpInside];
        
        [customButton setBackgroundImage:[UIImage imageNamed:@"update.png"]  forState:UIControlStateNormal];
        
        UIBarButtonItem *postMessageButtonItem = [[UIBarButtonItem alloc]initWithCustomView:customButton];
        
        self.navigationItem.rightBarButtonItem=postMessageButtonItem;

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
    
    NSMutableDictionary *uploadDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           @"0",@"DiscountPercent",
                                           postMessageTextView.text,@"Description",
                                           postMessageTextView.text,@"Title",nil];
    
    createStrDeal.offerDetailDictionary=[[NSMutableDictionary alloc]init];
    
    [createStrDeal createDeal:uploadDictionary isFbShare:isFacebookSelected isFbPageShare:isFacebookPageSelected];    
}


-(void)updateView
{
    BizMessageViewController *bizController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];

    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:bizController];
    [[self navigationController] setViewControllers:viewControllers animated:YES];    
}


- (IBAction)facebookButtonClicked:(id)sender
{

    if ([userDefaults objectForKey:@"NFManageFBAccessToken"] && [userDefaults objectForKey:@"NFManageFBUserId"])
    {
        isFacebookSelected=YES;
        [facebookButton setHidden:YES];
        [selectedFacebookButton setHidden:NO];
    }
    
    else
    {
        [downloadSubview setHidden:NO];
        [self openSession:NO];

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
    if (!appDelegate.socialNetworkNameArray.count)
    {
        [postMessageTextView resignFirstResponder];
        [downloadSubview setHidden:NO];
        [self openSession:YES];
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
    selectPageBgLabel = nil;
    [super viewDidUnload];
}



@end
