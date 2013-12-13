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
#import "FileManagerHelper.h"
#import "StoreViewController.h"
#import "PopUpView.h"


#define kOAuthConsumerKey	  @"h5lB3rvjU66qOXHgrZK41Q"
#define kOAuthConsumerSecret  @"L0Bo08aevt2U1fLjuuYAMtANSAzWWi8voGuvbrdtcY4"


@interface PostMessageViewController()<updateDelegate,SettingsViewDelegate,PopUpDelegate>



@end

@implementation PostMessageViewController

@synthesize  postMessageTextView,delegate;

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

    if (isFirstMessage)
    {
        [self performSelector:@selector(syncView) withObject:nil afterDelay:1.0];
    }
    


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
    
    version = [[UIDevice currentDevice] systemVersion];
    
    isFacebookSelected=NO;

    isFacebookPageSelected=NO;
    
    isTwitterSelected=NO;
    
    isSendToSubscribers=YES;
    
    isFirstMessage=NO;
    
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
    
    if (version.floatValue<7.0)
    {
        self.navigationController.navigationBarHidden=YES;

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
        
        UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [backButton setImage:buttonImage forState:UIControlStateNormal];
        
        backButton.frame = CGRectMake(5,0,50,44);
        
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:backButton];
        
        [bgLabel setFrame:CGRectMake(bgLabel.frame.origin.x, navBar.frame.size.height+20, bgLabel.frame.size.width, bgLabel.frame.size.height)];
        
        [postMessageTextView setFrame:CGRectMake(postMessageTextView.frame.origin.x, navBar.frame.size.height+20, postMessageTextView.frame.size.width, postMessageTextView.frame.size.height)];
        
        [createMessageLabel setFrame:CGRectMake(createMessageLabel.frame.origin.x, navBar.frame.size.height+28, navBar.frame.size.width, createMessageLabel.frame.size.height)];

        [characterCount setFrame:CGRectMake(characterCount.frame.origin.x, createMessageLabel.frame.size.height+170, characterCount.frame.size.width, characterCount.frame.size.height)];
        
    }
    
    
    
    else
    {
    
        
        self.navigationController.navigationBarHidden=NO;
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];

        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(128,13,160,20)];
        
        headerLabel.text=@"Message";
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textColor=[UIColor colorWithHexString:@"464646"];
        
        headerLabel.font=[UIFont fontWithName:@"Helevetica" size:18.0];
        
        [view addSubview:headerLabel];

        [self.navigationController.navigationBar addSubview:view];

        
    
        UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [backButton setImage:buttonImage forState:UIControlStateNormal];
        
        backButton.frame = CGRectMake(0,0,50,44);
        
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        self.navigationItem.leftBarButtonItem=leftBtnItem;

        
        
    }
    
    //Create the right bar button here
    customRightBarButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customRightBarButton addTarget:self action:@selector(postMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [customRightBarButton setBackgroundImage:[UIImage imageNamed:@"checkmark.png"]  forState:UIControlStateNormal];
    
    [customRightBarButton setShowsTouchWhenHighlighted:YES];

    [navBar addSubview:customRightBarButton];

    [customRightBarButton setHidden:YES];
    
    
    

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
    

    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40) ];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    
    
    UIBarButtonItem *cancelleftBarButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClicked:)];
    NSArray *array = [NSArray arrayWithObjects:cancelleftBarButton, nil];
    [toolbar setItems:array];
    
    postMessageTextView.inputAccessoryView = toolBarView;
    
    [connectingFacebookSubView setHidden:YES];
    
    
    FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
    
    fHelper.userFpTag=appDelegate.storeTag;
    
    NSMutableDictionary *userSetting=[[NSMutableDictionary alloc]init];
    
    if ([fHelper openUserSettings] != NULL)
    {
        [userSetting addEntriesFromDictionary:[fHelper openUserSettings]];
        
        if ([userSetting objectForKey:@"updateMsgtutorial"]!=nil)
        {
            [self isTutorialView:[[userSetting objectForKey:@"updateMsgtutorial"] boolValue]];            
        }
        
        else
        {
            [self isTutorialView:NO];
            
        }
    }
    
}


-(void)isTutorialView:(BOOL)available
{
    
    if (!available)
    {
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
                [[[[UIApplication sharedApplication] delegate] window] addSubview:tutorialOverLayiPhone4View ];
            }
            
            else
            {
                [[[[UIApplication sharedApplication] delegate] window] addSubview:tutorialOverLayView ];
            }
        }

        
        FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
        
        fHelper.userFpTag=appDelegate.storeTag;
        
        [fHelper updateUserSettingWithValue:[NSNumber numberWithBool:YES] forKey:@"updateMsgtutorial"];
        
    }
    
    else
    {
        [self performSelector:@selector(showKeyBoard) withObject:nil afterDelay:0.4];
    }
    
}


-(void)back
{
    [self dismissModalViewControllerAnimated:YES];    
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
        

        if (version.floatValue<7.0)
        {
            [customRightBarButton setFrame:CGRectMake(280,5, 30, 30)];
            
            [customRightBarButton setHidden:NO];
        }
        
        else
        {
            [customRightBarButton setFrame:CGRectMake(275,5, 30, 30)];
    
            [customRightBarButton setHidden:NO];

            UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithCustomView:customRightBarButton ];
            
            self.navigationItem.rightBarButtonItem=rightBarBtn;
            
        }
        
        
    }
    
    
    if (substring.length == 0)
    {
        characterCount.hidden = YES;
        createMessageLabel.hidden=NO;
        
        if (version.floatValue<7.0)
        {
            [customRightBarButton setHidden:YES];
        }
        
        else
        {
            [customRightBarButton setHidden:YES];

            self.navigationItem.rightBarButtonItem=nil;
    
        }
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
           [postMessageTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@"message",
           [NSNumber numberWithBool:isSendToSubscribers],@"sendToSubscribers",[appDelegate.storeDetailDictionary  objectForKey:@"_id"],@"merchantId",appDelegate.clientId,@"clientId",nil];
    
    createStrDeal.offerDetailDictionary=[[NSMutableDictionary alloc]init];
    
    [createStrDeal createDeal:uploadDictionary isFbShare:isFacebookSelected isFbPageShare:isFacebookPageSelected isTwitterShare:isTwitterSelected];

    
/*
        UpdateTwitter *twitterUpdate=[[UpdateTwitter alloc]init];

        [twitterUpdate postToTwitter:@"51e4e0ec4ec0a45b084d3617" messageString:postMessageTextView.text];
*/
    
}


-(void)updateMessageSucceed
{
    [self updateView];
}


-(void)updateMessageFailed
{
    [downloadSubview setHidden:YES];
}


-(void)updateView
{
    /*
    BizMessageViewController *bizController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];

    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:bizController];
    [[self navigationController] setViewControllers:viewControllers animated:NO];
    */
    /*
    FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
    
    NSMutableDictionary *userSetting=[[NSMutableDictionary alloc]init];
    
    if (![appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"] && ![appDelegate.storeWidgetArray containsObject:@"TIMINGS"] && ![appDelegate.storeWidgetArray containsObject:@"TOB"])
    {
        if ([fHelper openUserSettings] != NULL)
        {
            [userSetting addEntriesFromDictionary:[fHelper openUserSettings]];
            
            if ([userSetting objectForKey:@"userFirstMessage"]!=nil)
            {
                if ([[userSetting objectForKey:@"userFirstMessage"] boolValue])
                {
                    [self syncView];
                    
                }
                
                else
                {
                    //VisitStoreSubView code goes here
                    [fHelper updateUserSettingWithValue:[NSNumber numberWithBool:YES] forKey:@"userFirstMessage"];
                    isFirstMessage=YES;
                    [self showPostFirstUserMessage];
                }
            }
            
            else
            {
                //VisitStoreSubView code goes here
                [fHelper updateUserSettingWithValue:[NSNumber numberWithBool:YES] forKey:@"userFirstMessage"];
                isFirstMessage=YES;
                [self showPostFirstUserMessage];
            }
        }
    }
    
    else
    {
        [self syncView];
    }
    */
    
    if (appDelegate.dealDescriptionArray.count==1 && ![appDelegate.storeWidgetArray containsObject:@"SITESENSE"])
    {
        [self showPostFirstUserMessage];
    }
    
    else if (![appDelegate.storeWidgetArray containsObject:@"SITESENSE"] && appDelegate.dealDescriptionArray.count>1)
    {
        [self showBuyAutoSeoPlugin];
    }
    
    else
    {
        [self syncView];
    }
    
}


-(void)showPostFirstUserMessage
{
    PopUpView *customPopUp=[[PopUpView alloc]init];
    customPopUp.delegate=self;
    customPopUp.titleText=@"Good Start!";
    customPopUp.descriptionText=@"Websites which are updated regularly rank better in search! Plenty more features to help your business are available on the biz store!";
    customPopUp.popUpImage=[UIImage imageNamed:@"thumbsup.png"];
    customPopUp.successBtnText=@"Go To Store";
    customPopUp.cancelBtnText=@"Later";
    customPopUp.tag=1;
    [customPopUp showPopUpView];
    isFirstMessage=YES;
}


-(void)showBuyAutoSeoPlugin
{
    PopUpView *customPopUp=[[PopUpView alloc]init];
    customPopUp.delegate=self;
    customPopUp.titleText=@"Good Start!";
    customPopUp.descriptionText=@"Websites which are updated regularly rank better in search! Buy the Auto-SEO Plugin absolutely FREE";
    customPopUp.popUpImage=[UIImage imageNamed:@"thumbsup.png"];
    customPopUp.badgeImage=[UIImage imageNamed:@"FreeBadge.png"];
    customPopUp.successBtnText=@"Go To Store";
    customPopUp.cancelBtnText=@"Later";
    customPopUp.tag=2;
    [customPopUp showPopUpView];
    isFirstMessage=YES;
}


-(void)syncView
{
    [self dismissModalViewControllerAnimated:YES];
    
    [delegate performSelector:@selector(messageUpdatedSuccessFully)];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Post Message"];
}


#pragma PopUpDelegate
-(void)successBtnClicked:(id)sender
{
    StoreViewController *storeController=[[StoreViewController alloc]initWithNibName:@"StoreViewController" bundle:Nil];
    
    storeController.currentScrollPage=4;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:storeController];
    
    navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    [self presentModalViewController:navigationController animated:YES];
}


-(void)cancelBtnClicked:(id)sender
{
    [self performSelector:@selector(syncView) withObject:Nil afterDelay:1.0];
}


- (IBAction)facebookBtnClicked:(id)sender
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


- (IBAction)facebookPageBtnClicked:(id)sender
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


- (IBAction)selectedFbPageBtnClicked:(id)sender
{
    isFacebookPageSelected=NO;
    [facebookPageButton setHidden:NO];
    [selectedFacebookPageButton setHidden:YES];
}


- (IBAction)fbPageSubViewCloseBtnClicked:(id)sender
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


- (IBAction)twitterBtnClicked:(id)sender
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


- (IBAction)selectedTwitterBtnClicked:(id)sender
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


- (IBAction)dismissTutotialOverlayBtnClicked:(id)sender
{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            
            [tutorialOverLayiPhone4View removeFromSuperview];
            
        }
        
        else
        {
            [tutorialOverLayView removeFromSuperview];
        }
    }
    
    [self showKeyBoard];
    
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


- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username
{
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


- (IBAction)cancelFaceBookPages:(id)sender
{
        [connectingFacebookSubView setHidden:YES];
    [fbPageSubView setHidden:YES];
    
}


-(void)showFbPagesSubView
{

    [connectingFacebookSubView setHidden:YES];
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
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:12.0];
    
    
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
            [connectingFacebookSubView setHidden:YES];
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
             [connectingFacebookSubView setHidden:YES];

             [FBSession.activeSession closeAndClearTokenInformation];
         }
         else
         {
             [connectingFacebookSubView setHidden:NO];

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
            /*
            [connectingFacebookSubView setHidden:NO];
            [self openSession:NO];
             */
            [postMessageTextView resignFirstResponder];
            
            SettingsViewController *settingController=[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:Nil];
            
            settingController.delegate=self;
            
            settingController.isGestureAvailable=NO;
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingController];
            
            // And now you want to present the view in a modal fashion
            [self presentModalViewController:navigationController animated:YES];
            
        }
        
        
    }
    
    
    if (alertView.tag==2)
    {
        if (buttonIndex==1)
        {
            /*
            [connectingFacebookSubView setHidden:NO];
            [self openSession:YES];
             */
            [postMessageTextView resignFirstResponder];
            
            SettingsViewController *settingController=[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:Nil];
            
            settingController.delegate=self;

            settingController.isGestureAvailable=NO;
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingController];
            
            // You can even set the style of stuff before you show it
            navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            
            // And now you want to present the view in a modal fashion
            [self presentModalViewController:navigationController animated:YES];
            

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

#pragma SettingsViewDelegate

-(void)settingsViewUserDidComplete
{
    [self performSelector:@selector(showKeyBoard) withObject:nil afterDelay:0.50];
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
    connectingFacebookSubView = nil;
    [super viewDidUnload];
}


-(void)viewWillDisappear:(BOOL)animated
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
