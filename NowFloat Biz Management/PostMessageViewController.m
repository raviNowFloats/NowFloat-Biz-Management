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
#import "PopUpView.h"
#import "CreatePictureDeal.h"
#import "NFActivityView.h"
#import "BizStoreDetailViewController.h"
#import "GetBizFloatDetails.h"
#import "SocialSettingsFBHelper.h"


#define kOAuthConsumerKey	  @"h5lB3rvjU66qOXHgrZK41Q"
#define kOAuthConsumerSecret  @"L0Bo08aevt2U1fLjuuYAMtANSAzWWi8voGuvbrdtcY4"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

static inline CGFloat degreesToRadians(CGFloat degrees)
{
    return M_PI * (degrees / 180.0);
}



static inline CGSize swapWidthAndHeight(CGSize size)
{
    CGFloat  swap = size.width;
    
    size.width  = size.height;
    
    size.height = swap;
    
    return size;
}

@interface PostMessageViewController()<updateDelegate,SettingsViewDelegate,PopUpDelegate,pictureDealDelegate,getFloatDetailsProtocol>
{
    double viewHeight;
    NFActivityView *nfActivity;
    NFActivityView *findPagesActivity;
}
@end

@implementation PostMessageViewController

@synthesize  postMessageTextView,delegate,isFromHomeView;
@synthesize testImage,chunkArray,request,dataObj,uniqueIdString,theConnection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
        
    [super viewWillAppear:animated];
        
    [[NSNotificationCenter defaultCenter]
                             addObserver:self
                             selector:@selector(updateView)
                             name:@"updateMessage" object:nil];

    if (isFirstMessage)
    {
        [nfActivity showCustomActivityView];
        [self performSelector:@selector(syncView) withObject:nil afterDelay:0.4];
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
    
    nfActivity=[[NFActivityView alloc]init];

    nfActivity.activityTitle=@"Uploading";
    
    chunkArray=[[NSMutableArray alloc]init];
    
    receivedData=[[NSMutableData alloc]init];

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
    
    fbPageSubView.center=self.view.center;
    
    [toolBarView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        
    [bgLabel.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    
    bgLabel.layer.borderWidth = 1.0;

    [characterCount setTextColor:[UIColor colorWithHexString:@"9c9b9b"]];
    
    [postMessageTextView setTextColor:[UIColor colorWithHexString:@"9c9b9b"]];
    
    [uploadPictureImgView.layer setCornerRadius:6.0];
    
    [uploadPictureImgView.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    CALayer * l = [uploadPictureImgView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:6.0];

    revealController = self.revealViewController;
    
    frontNavigationController = (id)revealController.frontViewController;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            viewHeight=480;
        }
        else
        {
            viewHeight=568;
        }
    }
    
    //Create NavBar here

    if (version.floatValue<7.0)
    {
        self.navigationController.navigationBarHidden=YES;

        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];

        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(100,13,160,20)];
        
        headerLabel.text=@"Create Message";
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textColor=[UIColor colorWithHexString:@"464646"];
        
        headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        [navBar addSubview:headerLabel];
        
        UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(13,11,25,25)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"cancelCross2.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:leftCustomButton];
        
        if (viewHeight==480) {

        [bgLabel setFrame:CGRectMake(bgLabel.frame.origin.x, navBar.frame.size.height+20, bgLabel.frame.size.width, bgLabel.frame.size.height-30)];
        
        [postMessageTextView setFrame:CGRectMake(postMessageTextView.frame.origin.x, navBar.frame.size.height+20, postMessageTextView.frame.size.width, postMessageTextView.frame.size.height-30)];
        
        [createMessageLabel setFrame:CGRectMake(createMessageLabel.frame.origin.x+5, navBar.frame.size.height+28, navBar.frame.size.width, createMessageLabel.frame.size.height)];

        [characterCount setFrame:CGRectMake(characterCount.frame.origin.x, createMessageLabel.frame.size.height+170, characterCount.frame.size.width, characterCount.frame.size.height)];

        [uploadPictureImgView setFrame:CGRectMake(uploadPictureImgView.frame.origin.x, uploadPictureImgView.frame.origin.y+55, uploadPictureImgView.frame.size.width, uploadPictureImgView.frame.size.height)];
        
        [addImageBtn setFrame:CGRectMake(addImageBtn.frame.origin.x, addImageBtn.frame.origin.y+55, addImageBtn.frame.size.width, addImageBtn.frame.size.height)];
            
        [addPhotoLbl setFrame:CGRectMake(addPhotoLbl.frame.origin.x, addPhotoLbl.frame.origin.y+55, addPhotoLbl.frame.size.width, addPhotoLbl.frame.size.height)];
        }
        
        else
        {
            [bgLabel setFrame:CGRectMake(bgLabel.frame.origin.x, navBar.frame.size.height+20, bgLabel.frame.size.width, bgLabel.frame.size.height)];
            
            [postMessageTextView setFrame:CGRectMake(postMessageTextView.frame.origin.x, navBar.frame.size.height+20, postMessageTextView.frame.size.width, postMessageTextView.frame.size.height)];
            
            [createMessageLabel setFrame:CGRectMake(createMessageLabel.frame.origin.x+5, navBar.frame.size.height+28, navBar.frame.size.width, createMessageLabel.frame.size.height)];
            
            [characterCount setFrame:CGRectMake(characterCount.frame.origin.x, createMessageLabel.frame.size.height+210, characterCount.frame.size.width, characterCount.frame.size.height)];
            
            [uploadPictureImgView setFrame:CGRectMake(uploadPictureImgView.frame.origin.x, uploadPictureImgView.frame.origin.y+55, uploadPictureImgView.frame.size.width, uploadPictureImgView.frame.size.height)];
            
            [addImageBtn setFrame:CGRectMake(addImageBtn.frame.origin.x, addImageBtn.frame.origin.y+55, addImageBtn.frame.size.width, addImageBtn.frame.size.height)];
        
            [addPhotoLbl setFrame:CGRectMake(addPhotoLbl.frame.origin.x, addPhotoLbl.frame.origin.y+55, addPhotoLbl.frame.size.width, addPhotoLbl.frame.size.height)];

        }
        
    }

    else
    {
        self.navigationController.navigationBarHidden=NO;
        self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];

        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(100,13,160,20)];
        
        headerLabel.text=@"Create Message";
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textColor=[UIColor colorWithHexString:@"464646"];
        
        headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        [view addSubview:headerLabel];

        [self.navigationController.navigationBar addSubview:view];

        
    
        UIImage *buttonImage = [UIImage imageNamed:@"cancelCross2.png"];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [backButton setImage:buttonImage forState:UIControlStateNormal];
        
        backButton.frame = CGRectMake(13,11,25,25);
        
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [self.navigationController.navigationBar addSubview:backButton];
        
        if (viewHeight==480) {

            [bgLabel setFrame:CGRectMake(bgLabel.frame.origin.x, bgLabel.frame.origin.y, bgLabel.frame.size.width, bgLabel.frame.size.height-30)];
            
            [postMessageTextView setFrame:CGRectMake(postMessageTextView.frame.origin.x, postMessageTextView.frame.origin.y, postMessageTextView.frame.size.width, postMessageTextView.frame.size.height-30)];
            
            [createMessageLabel setFrame:CGRectMake(createMessageLabel.frame.origin.x, navBar.frame.size.height, navBar.frame.size.width, createMessageLabel.frame.size.height)];
            
            [characterCount setFrame:CGRectMake(characterCount.frame.origin.x, bgLabel.frame.size.height+8, characterCount.frame.size.width, characterCount.frame.size.height)];
            
            [uploadPictureImgView setFrame:CGRectMake(uploadPictureImgView.frame.origin.x, uploadPictureImgView.frame.origin.y, uploadPictureImgView.frame.size.width, uploadPictureImgView.frame.size.height)];
            
            [addImageBtn setFrame:CGRectMake(addImageBtn.frame.origin.x, addImageBtn.frame.origin.y, addImageBtn.frame.size.width, addImageBtn.frame.size.height)];
            
        }
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
        [nfActivity showCustomActivityView];
        [postMessageTextView resignFirstResponder];
        

        
        [self performSelector:@selector(postNewMessage) withObject:nil afterDelay:0.1];
        
    }

}


-(void)postNewMessage
{
    if (isPictureMessage)
    {
        CreatePictureDeal *createDeal=[[CreatePictureDeal alloc]init];
        
        createDeal.dealUploadDelegate=self;
        
        NSMutableDictionary *uploadDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
       postMessageTextView.text,@"message",
       [NSNumber numberWithBool:isSendToSubscribers],@"sendToSubscribers",
       [appDelegate.storeDetailDictionary  objectForKey:@"_id"],@"merchantId",
                                           appDelegate.clientId,@"clientId",nil];
        
        createDeal.offerDetailDictionary=[[NSMutableDictionary alloc]init];
        
        [createDeal createDeal:uploadDictionary postToTwitter:isTwitterSelected postToFB:isFacebookSelected postToFbPage:isFacebookPageSelected];
    }
    
    else
    {
        
    CreateStoreDeal *createStrDeal=[[CreateStoreDeal alloc]init];
    
    createStrDeal.delegate=self;
        
    NSMutableDictionary *uploadDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
        [postMessageTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@"message",
        [NSNumber numberWithBool:isSendToSubscribers],@"sendToSubscribers",[appDelegate.storeDetailDictionary  objectForKey:@"_id"],@"merchantId",appDelegate.clientId,@"clientId",nil];
    
    createStrDeal.offerDetailDictionary=[[NSMutableDictionary alloc]init];
    
    [createStrDeal createDeal:uploadDictionary isFbShare:isFacebookSelected isFbPageShare:isFacebookPageSelected isTwitterShare:isTwitterSelected];
    }
        
}


-(void)postPhotoToFbPage
{
    
    UIImage *img =uploadPictureImgView.image;
    
    [FBRequestConnection startWithGraphPath:
                                [NSString  stringWithFormat:@"%@/photos",[appDelegate.socialNetworkIdArray objectAtIndex:0]]
                                 parameters:[NSDictionary dictionaryWithObjectsAndKeys:img,@"source",postMessageTextView.text,@"message" ,nil]
                                 HTTPMethod:@"POST"
                                 completionHandler:^
         (FBRequestConnection *connection, id result, NSError *error)
         {
             if (!error)
             {
                 NSLog(@"result:%@",result);
             }
             
             else
             {
                 NSLog(@"error:%@",error.localizedDescription);
             }
         }
     ];
    
    
    if (!isFacebookSelected)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    
}


-(void)postPhotoToFb
{
    /*
    UIImage *img = uploadPictureImgView.image;
    
    [FBRequestConnection startWithGraphPath:@"me/photos"
                 parameters:[NSDictionary dictionaryWithObjectsAndKeys:img,@"source",postMessageTextView.text,@"message" ,nil]
                                 HTTPMethod:@"POST"
      completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (!error)
         {
             NSLog(@"result:%@",result);
         }
         
         else
         {
             NSLog(@"error:%@",error.localizedDescription);
         }
     }
     ];
    
    if (!isFacebookPageSelected )
    {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    */
    
}


-(void)updateMessageSucceed
{
    [self updateView];
}


-(void)updateMessageFailed
{
    [nfActivity hideCustomActivityView];
    
    if (isFromHomeView)
    {

        [self dismissViewControllerAnimated:YES completion:nil];
        
        [delegate performSelector:@selector(messageUpdateFailed)];
        
    }
    
}


-(void)updateView
{
    FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
    
    fHelper.userFpTag=appDelegate.storeTag;
    
    NSMutableDictionary *userSetting=[[NSMutableDictionary alloc]init];
    
    if (![appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"] && ![appDelegate.storeWidgetArray containsObject:@"TIMINGS"] && ![appDelegate.storeWidgetArray containsObject:@"TOB"] && ![appDelegate.storeWidgetArray containsObject:@"SITESENSE"])
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
    
    else if (![appDelegate.storeWidgetArray containsObject:@"SITESENSE"] && appDelegate.dealDescriptionArray.count>=1)
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
    [nfActivity hideCustomActivityView];

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
    [nfActivity hideCustomActivityView];

    PopUpView *customPopUp=[[PopUpView alloc]init];
    customPopUp.delegate=self;
    customPopUp.titleText=@"Buy Auto-SEO!";
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
    [nfActivity hideCustomActivityView];
    
    if (isFromHomeView) {

        [self dismissViewControllerAnimated:YES completion:nil];
        
        [delegate performSelector:@selector(messageUpdatedSuccessFully)];
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"First User Message Posted"];
        
    }
    
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [delegate performSelector:@selector(messageUpdatedSuccessFully)];
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Post Message"];
    }
}


#pragma PopUpDelegate
-(void)successBtnClicked:(id)sender
{
    BizStoreDetailViewController *storeController=[[BizStoreDetailViewController alloc]initWithNibName:@"BizStoreDetailViewController" bundle:Nil];
    
    storeController.isFromOtherViews=YES;
    storeController.selectedWidget=1008;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:storeController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
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
        UIAlertView *fbAlert=[[UIAlertView alloc]initWithTitle:@"Facebook" message:@"To connect to Facebook,\n please sign in." delegate:self    cancelButtonTitle:@"Cancel" otherButtonTitles:@"Connect", nil];
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
        UIAlertView *fbPageAlert=[[UIAlertView alloc]initWithTitle:@"Facebook Page" message:@"To connect to Facebook Page,\n Please sign in." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Connect ", nil];
        
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
        UIAlertView *twitterAlert=[[UIAlertView alloc]initWithTitle:@"Twitter" message:@"To connect to Twitter,\n Please sign in." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Connect", nil];
        
        twitterAlert.tag=4;
        
        [twitterAlert show];

        twitterAlert=nil;
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
    
    isTwitterSelected=YES;
    [twitterButton setHidden:YES];
    [selectedTwitterButton setHidden:NO];

}



-(IBAction)dismissKeyboardOnTap:(id)sender
{
    [[self view] endEditing:YES];
}


- (IBAction)cancelFaceBookPages:(id)sender
{
    [findPagesActivity  hideCustomActivityView];
    [connectingFacebookSubView setHidden:YES];
    [fbPageSubView setHidden:YES];
    [self performSelector:@selector(showKeyBoard) withObject:nil afterDelay:0.1];
}


-(void)showFbPagesSubView
{
    [fbPageSubView setHidden:NO];
    [self reloadFBpagesTableView];
    [findPagesActivity hideCustomActivityView];    
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
    
    //UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSArray *a1=[NSArray arrayWithObject:[appDelegate.fbUserAdminArray objectAtIndex:[indexPath  row]]];
    
    NSArray *a2=[NSArray arrayWithObject:[appDelegate.fbUserAdminAccessTokenArray objectAtIndex:[indexPath row]]];
    
    NSArray *a3=[NSArray arrayWithObject:[appDelegate.fbUserAdminIdArray objectAtIndex:[indexPath row]]];
    
    [appDelegate.socialNetworkNameArray addObjectsFromArray:a1];
    [appDelegate.socialNetworkAccessTokenArray addObjectsFromArray:a2];
    [appDelegate.socialNetworkIdArray addObjectsFromArray:a3];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [fbPageSubView setHidden:YES];

    [selectedFacebookPageButton setHidden:NO];
    [facebookPageButton setHidden:YES];

    [self performSelector:@selector(showKeyBoard) withObject:nil afterDelay:0.1];

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
                 [findPagesActivity hideCustomActivityView];

                 UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"You do not have pages to manage" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                 
                 [alerView show];
                 
                 alerView=nil;
             }
             
             [FBSession.activeSession closeAndClearTokenInformation];
             
         }
         else
         {
             [findPagesActivity hideCustomActivityView];
             /*
             UIAlertView *fbPageFailAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong while connecting to facebook. Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
             
             [fbPageFailAlert show];
             
             fbPageFailAlert=nil;
              */
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
            [postMessageTextView resignFirstResponder];
            
            [[SocialSettingsFBHelper sharedInstance]requestLoginAsAdmin:NO WithCompletionHandler:^(BOOL Success, NSDictionary *userDetails)
             {
                 if (Success)
                 {
                     [self showKeyBoard];
                     [facebookButton setHidden:YES];
                     [selectedFacebookButton setHidden:NO];
                     [userDefaults setObject:[userDetails objectForKey:@"id"] forKey:@"NFManageFBUserId"];
                     [userDefaults setObject:[userDetails objectForKey:@"name"] forKey:@"NFFacebookName"];
                     [userDefaults synchronize];
                 }
                 
                 else
                 {
                     /*
                     UIAlertView *failedFbAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Something went wrong connecting to facebook" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     
                     [failedFbAlert show];
                     
                     failedFbAlert=nil;
                      */
                     [self showKeyBoard];

                 }
             }];

        }
    }
    
   else if (alertView.tag==2)
    {
        if (buttonIndex==1)
        {
            findPagesActivity=[[NFActivityView alloc]init];
            
            findPagesActivity.activityTitle=@"searching";
            
            [findPagesActivity  showCustomActivityView];
            
            [postMessageTextView resignFirstResponder];
            
            [[SocialSettingsFBHelper sharedInstance]requestLoginAsAdmin:YES WithCompletionHandler:^(BOOL Success, NSDictionary *userDetails)
             {
                 if (Success)
                 {
                     if ([[userDetails objectForKey:@"data"] count]>0)
                     {
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
                     [findPagesActivity  hideCustomActivityView];
                     [self showKeyBoard];
                 }
             }];
        }
    }
    
   else if (alertView.tag==3)
    {
        if (buttonIndex==1)
        {
            [sendToSubscribersOnButton setHidden:YES];
            [sendToSubscribersOffButton setHidden:NO];
            isSendToSubscribers=NO;
        }
    }
    
    else if(alertView.tag==4)
    {
        if (buttonIndex==1)
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
            
        }
    }
}




#pragma SettingsViewDelegate

-(void)settingsViewUserDidComplete
{
    [self performSelector:@selector(showKeyBoard) withObject:nil afterDelay:0.50];
}


- (IBAction)addImageBtnClicked:(id)sender
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Post Image Deal"];
}


-(UIImage*)rotate:(UIImageOrientation)orient
{
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGRect             rect = CGRectZero;
    CGAffineTransform  tran = CGAffineTransformIdentity;
    
    bnds.size = uploadPictureImgView.image.size;
    rect.size = uploadPictureImgView.image.size;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            return uploadPictureImgView.image;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, degreesToRadians(180.0));
            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds.size = swapWidthAndHeight(bnds.size);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, degreesToRadians(-90.0));
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds.size = swapWidthAndHeight(bnds.size);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, degreesToRadians(-90.0));
            break;
            
        case UIImageOrientationRight:
            bnds.size = swapWidthAndHeight(bnds.size);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, degreesToRadians(90.0));
            break;
            
        case UIImageOrientationRightMirrored:
            bnds.size = swapWidthAndHeight(bnds.size);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, degreesToRadians(90.0));
            break;
            
        default:
            // orientation value supplied is invalid
            assert(false);
            return nil;
    }
    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(ctxt, rect, uploadPictureImgView.image.CGImage);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}


-(void)writeImageToDocuments
{
        
    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0,5);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
    
    NSString *imageName=[NSString stringWithFormat:@"%@.jpg",uuid];
    
    NSData* imageData = UIImageJPEGRepresentation(uploadPictureImgView.image, 0.1);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    appDelegate.localImageUri=[NSMutableString stringWithFormat:@"local%@",fullPathToFile];
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
}

#pragma CreatePictureDealDelegate

-(void)successOnDealUpload
{
    
    [self uploadPicture];
    
}


-(void)failedOnDealUpload
{
    
    
    [self resetView];
    
}



-(void)uploadPicture
{
    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0, 36);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
    
    uniqueIdString=[[NSString alloc]initWithString:uuid];
    
    UIImage *img =uploadPictureImgView.image;
    
    dataObj=UIImageJPEGRepresentation(img,0.7);
    
    NSUInteger length = [dataObj length];
    
    NSUInteger chunkSize = 3000*10;
    
    NSUInteger offset = 0;
    
    int numberOfChunks=0;
    
    do
    {
        NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
        
        NSData* chunk = [NSData dataWithBytesNoCopy:(char *)[dataObj bytes] + offset
                                             length:thisChunkSize
                                       freeWhenDone:NO];
        offset += thisChunkSize;
        
        [chunkArray insertObject:chunk atIndex:numberOfChunks];
        
        numberOfChunks++;
        
    }
    
    while (offset < length);
    
    totalImageDataChunks=[chunkArray count];
    
    request=[[NSMutableURLRequest alloc] init];
    
    NSString *imageDealString= [appDelegate.dealId objectAtIndex:0];
    
    for (int i=0; i<[chunkArray count]; i++)
    {
        
        NSString *urlString=[NSString stringWithFormat:@"%@/createBizImage?clientId=%@&bizMessageId=%@&requestType=parallel&requestId=%@&totalChunks=%d&currentChunkNumber=%d",appDelegate.apiWithFloatsUri,appDelegate.clientId,imageDealString,uniqueIdString,[chunkArray count],i];
        
        NSString *postLength=[NSString stringWithFormat:@"%ld",(unsigned long)[[chunkArray objectAtIndex:i] length]];
        
        urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *uploadUrl=[NSURL URLWithString:urlString];
        
        NSMutableData *tempData =[[NSMutableData alloc]initWithData:[chunkArray objectAtIndex:i]] ;
        
        [request setURL:uploadUrl];
        [request setTimeoutInterval:30000];
        [request setHTTPMethod:@"PUT"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"binary/octet-stream" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:tempData];
        [request setCachePolicy:NSURLCacheStorageAllowed];
        
        theConnection=[[NSURLConnection  alloc]initWithRequest:request delegate:self startImmediately:YES];
    }
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [receivedData appendData:data1];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableString *receivedString=[[NSMutableString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSString *idString = [receivedString
                          stringByReplacingOccurrencesOfString:@"\"" withString:@""];

    NSLog(@"idString:%@",idString);
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
     NSLog(@"code:%d",code);
    
    if (code==200)
    {
        
        successCode++;
        
        if (successCode==totalImageDataChunks)
        {
            
            [self finishUpload];
            
        }
    }
    
    else
    {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    
}


-(void)finishUpload
{
    [appDelegate.dealImageArray insertObject:appDelegate.localImageUri atIndex:0];
    
    if (isPictureMessage && isFacebookPageSelected)
    {
        [self performSelector:@selector(uploadPictureToFaceBookPage) withObject:Nil afterDelay:2.0];
    }
    
    if (isPictureMessage && isFacebookSelected)
    {
        [self performSelector:@selector(uploadPictureToFaceBook) withObject:Nil afterDelay:2.0];
    }
    
    [self updateView];
}



-(void)uploadPictureToFaceBook
{
    
    NSString *messageId= [appDelegate.dealId objectAtIndex:0];
    
    GetBizFloatDetails *getDetails=[[GetBizFloatDetails  alloc]init];
    
    getDetails.delegate=self;
    
    [getDetails getBizfloatDetails:messageId];

}

-(void)uploadPictureToFaceBookPage
{
    NSString *messageId= [appDelegate.dealId objectAtIndex:0];

    GetBizFloatDetails *getDetails=[[GetBizFloatDetails  alloc]init];
    
    getDetails.delegate=self;
    
    [getDetails getBizfloatDetails:messageId];

}

#pragma getFloatDetailsProtocol

-(void)getActualImageUri:(NSDictionary *)responseDictionary;
{
    NSString *uploadImageUriString=[[responseDictionary objectForKey:@"targetFloat"] objectForKey:@"ActualImageUri"];

    NSMutableDictionary *uploadDic;
    
    if (![uploadImageUriString isEqualToString:@"https://api.withfloats.com/Deals/Tile/deal.png"])
    {
        if (isFacebookPageSelected)
        {
            if (isPictureMessage)
            {
                uploadDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:postMessageTextView.text,@"dealDescription",[NSNumber numberWithBool:isPictureMessage],@"isPictureDeal",uploadImageUriString,@"imageUri",nil];
                
                UpdateFaceBookPage *updateFB=[[UpdateFaceBookPage alloc]init];
                
                [updateFB postToFaceBookPage:uploadDic];
            }
            
            else
            {
                uploadDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:postMessageTextView.text,@"dealDescription",[NSNumber numberWithBool:isPictureMessage],@"isPictureDeal",nil];
                
                UpdateFaceBookPage *updateFB=[[UpdateFaceBookPage alloc]init];
                
                [updateFB postToFaceBookPage:uploadDic];
            }
        }
        
        if (isFacebookSelected)
        {
            if (isPictureMessage)
            {
                uploadDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:postMessageTextView.text,@"dealDescription",[NSNumber numberWithBool:isPictureMessage],@"isPictureDeal",uploadImageUriString,@"imageUri",nil];
                
                UpdateFaceBook *updateFB=[[UpdateFaceBook alloc]init];
                
                [updateFB postToFaceBook:uploadDic];
            }
            
            else
            {
                uploadDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:postMessageTextView.text,@"dealDescription",[NSNumber numberWithBool:isPictureMessage],@"isPictureDeal",nil];
                
                UpdateFaceBook *updateFB=[[UpdateFaceBook alloc]init];
                
                [updateFB postToFaceBook:uploadDic];
            }
        }
    }
}


-(void)getFloatDetailFailed
{


}

-(void)resetView
{
    [nfActivity hideCustomActivityView];
    
    UIAlertView *imgUploadFailedErr=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Image upload failed." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
    
    [imgUploadFailedErr show];
    
    imgUploadFailedErr=nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
