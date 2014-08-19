//
//  PostUpdateViewController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 8/18/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "PostUpdateViewController.h"
#import "Mixpanel.h"
#import "SA_OAuthTwitterEngine.h"
#import <Social/Social.h>
#import "NFCameraOverlay.h"
#import "NFCropOverlay.h"
#import "FileManagerHelper.h"
#import "PopUpView.h"
#import "RIATips1Controller.h"
#import "NFActivityView.h"
#import "UIColor+HexaString.h"



#define kOAuthConsumerKey	  @"h5lB3rvjU66qOXHgrZK41Q"
#define kOAuthConsumerSecret  @"L0Bo08aevt2U1fLjuuYAMtANSAzWWi8voGuvbrdtcY4"
@interface PostUpdateViewController ()
{
    BOOL isPostPictureMessage;
    BOOL isFromCamera;
    BOOL isPictureMessage;
    BOOL isFacebookSelected;
    BOOL isFacebookPageSelected;
    BOOL isTwitterSelected;
    BOOL isSendToSubscribers;
    BOOL isGoingToStore;
    BOOL isGoingToEmailShare;
    BOOL isCancelPictureMessage;
    Mixpanel *mixpanel;
    SA_OAuthTwitterEngine *_engine;
    UIImageView *primaryImage;
    NFActivityView *nfActivity;
   
}

@property NFCameraOverlay *overlay;
@end

@implementation PostUpdateViewController
@synthesize uploadPictureImgView,createContentTextView,createMessageLbl,picker=_picker;
@synthesize overlay = _overlay;
@synthesize addImageBtn;
@synthesize postUpdateBtn;
@synthesize chunkArray,request,dataObj,uniqueIdString,theConnection;
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
    
     appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
     userDetails=[NSUserDefaults standardUserDefaults];
     
    mixpanel = [Mixpanel sharedInstance];

    nfActivity=[[NFActivityView alloc]init];
    nfActivity.activityTitle=@"Updating";
    
    [uploadPictureImgView  setContentMode:UIViewContentModeScaleAspectFill];
    
    [uploadPictureImgView.layer setCornerRadius:6.0];
    
    [uploadPictureImgView.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    
    CALayer * l = [uploadPictureImgView layer];
    
    [l setMasksToBounds:YES];
    
    [l setCornerRadius:6.0];
    
    l=nil;

    
    isPictureMessage=NO;
    isGoingToStore=NO;
    isGoingToEmailShare=NO;
    isPostPictureMessage = NO;
    isFromCamera = NO;
    isFacebookSelected=NO;
    isFacebookPageSelected=NO;
    isTwitterSelected=NO;
    isSendToSubscribers=YES;
    
    isCancelPictureMessage=NO;
    
    [selectedFacebookButton setHidden:YES];
    
    [selectedFacebookPageButton setHidden:YES];
    
    [selectedTwitterButton setHidden:YES];
    
    [sendToSubscribersOffButton setHidden:YES];
    
    [sendToSubscribersOnButton setHidden:NO];


    // Do any additional setup after loading the view from its nib.
    
    self.postUpdateView.frame = CGRectMake(10, 450, 300, 202);
    
    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        
         self.postUpdateView.frame = CGRectMake(10, 80, 300, 202);
        [createContentTextView becomeFirstResponder];
        
    }completion:^(BOOL finish)
     {
         
     }];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addImageBtnClicked:(id)sender
{
    isPostPictureMessage = YES;
    if(isFromCamera)
    {
        UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:@"Select from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery", nil];
        selectAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        selectAction.tag=3;
        [selectAction showInView:self.view];
        
    }
    else
    {
        if (uploadPictureImgView.image!=nil)
        {
            UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:@"Select from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery",@"Cancel Image",nil];
            selectAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            selectAction.tag=3;
           [selectAction showInView:self.view];
        }
        
        else
        {
            UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:@"Select from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery", nil];
            selectAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            selectAction.tag=3;
            [selectAction showInView:self.view];
        }
    }
    
    
}

- (IBAction)postUpdateBtnClicked:(id)sender
{
    [self createMessage];
}

-(void)createMessage
{
    if (isPictureMessage)
    {
        CreatePictureDeal *createDeal=[[CreatePictureDeal alloc]init];
        
        createDeal.dealUploadDelegate=self;
        
        NSMutableDictionary *uploadDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                               createContentTextView.text,@"message",
                                               [NSNumber numberWithBool:isSendToSubscribers],@"sendToSubscribers",
                                               [appDelegate.storeDetailDictionary  objectForKey:@"_id"],@"merchantId",
                                               appDelegate.clientId,@"clientId",
                                               uploadPictureImgView.image,@"pictureMessage",
                                               nil];
        
        createDeal.offerDetailDictionary=[[NSMutableDictionary alloc]init];
        
        [createDeal createDeal:uploadDictionary postToTwitter:isTwitterSelected postToFB:isFacebookSelected postToFbPage:isFacebookPageSelected ];
    }
    
    else
    {
        CreateStoreDeal *createStrDeal=[[CreateStoreDeal alloc]init];
        
        createStrDeal.delegate=self;
        
        NSMutableDictionary *uploadDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:                                               [createContentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@"message",
                                               [NSNumber numberWithBool:isSendToSubscribers],@"sendToSubscribers",[appDelegate.storeDetailDictionary  objectForKey:@"_id"],@"merchantId",appDelegate.clientId,@"clientId",nil];
        
        createStrDeal.offerDetailDictionary=[[NSMutableDictionary alloc]init];
        
        [createStrDeal createDeal:uploadDictionary isFbShare:isFacebookSelected isFbPageShare:isFacebookPageSelected isTwitterShare:isTwitterSelected];
    }
}


- (IBAction)createContentCloseBtnClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma pictureDealDelegate
-(void)successOnDealUpload
{
    [self uploadPictureMessage];
}

-(void)uploadPictureMessage
{
    chunkArray=[[NSMutableArray alloc]init];
    
    receivedData=[[NSMutableData alloc]init];
    
    totalImageDataChunks=0;
    
    successCode = 0;
    
    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0, 36);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
    
    uniqueIdString=[[NSString alloc]initWithString:uuid];
    
    UIImage *img =uploadPictureImgView.image;
    
    dataObj=UIImageJPEGRepresentation(img,0.4);
    
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
                [nfActivity hideCustomActivityView];
            }
        }
        
        else
        {
            [nfActivity hideCustomActivityView];
            
            UIAlertView *failedPictureTextMsg=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Failed to upload the message. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [failedPictureTextMsg show];
            
            failedPictureTextMsg= nil;
        }
    
}

-(void)finishUpload
{
    [appDelegate.dealImageArray insertObject:appDelegate.localImageUri atIndex:0];
    
    if (isFacebookPageSelected)
    {
        [self performSelector:@selector(uploadPictureToFaceBookPage) withObject:Nil afterDelay:2.0];
    }
    
    if (isPictureMessage)
    {
        [self performSelector:@selector(uploadPictureToFaceBookPage) withObject:Nil afterDelay:2.0];
    }
    
    [self closeContentCreateSubview];
    
    [self updateViewController];
}


-(void)uploadPictureToFaceBookPage
{
    
    UIImage *img =uploadPictureImgView.image;
    
    [FBRequestConnection startWithGraphPath:
     [NSString  stringWithFormat:@"%@/photos",[appDelegate.socialNetworkIdArray objectAtIndex:0]]
                                 parameters:[NSDictionary dictionaryWithObjectsAndKeys:img,@"source",createContentTextView.text,@"message" ,nil]
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

-(void)updateViewController
{
    FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
    
    fHelper.userFpTag=appDelegate.storeTag;
    
    NSMutableDictionary *userSetting=[[NSMutableDictionary alloc]init];
    
    if (![appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"] && ![appDelegate.storeWidgetArray containsObject:@"TIMINGS"] && ![appDelegate.storeWidgetArray containsObject:@"TOB"] && ![appDelegate.storeWidgetArray containsObject:@"SITESENSE"])
    {
        [nfActivity hideCustomActivityView];
        
        if ([fHelper openUserSettings] != NULL)
        {
            [userSetting addEntriesFromDictionary:[fHelper openUserSettings]];
            
            if ([userSetting objectForKey:@"userFirstMessage"]!=nil)
            {
                if ([[userSetting objectForKey:@"userFirstMessage"] boolValue])
                {
                    if (![appDelegate.storeWidgetArray containsObject:@"SITESENSE"] && appDelegate.dealDescriptionArray.count>=1)
                    {
                        [self showBuyAutoSeoPlugin];
                    }
                    
                    else
                    {
                        [self syncView];
                    }
                }
                
                else
                {
                    [fHelper updateUserSettingWithValue:[NSNumber numberWithBool:YES] forKey:@"userFirstMessage"];
                    [self showPostFirstUserMessage];
                }
            }
            
            else
            {
                [fHelper updateUserSettingWithValue:[NSNumber numberWithBool:YES] forKey:@"userFirstMessage"];
                [self showPostFirstUserMessage];//PopUp Tag is 1 or 2.
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
    
    
    RIATips1Controller *ria = [[RIATips1Controller alloc]initWithNibName:@"RIATips1Controller" bundle:nil];
    [self presentViewController:ria animated:YES completion:nil];
}

-(void)syncView
{
    [nfActivity hideCustomActivityView];//Do not delete.
    
    if (isPictureMessage)
    {
        [mixpanel track:@"Post Image Deal"];
        
        isPictureMessage= NO;
        
        isCancelPictureMessage=NO;
        
        //uploadPictureImgView.image=[UIImage imageNamed:@""];
        
        [addImageBtn setBackgroundImage:[UIImage imageNamed:@"addimageplaceholder.png"] forState:UIControlStateNormal];
        
        [addImageBtn setBackgroundImage:[UIImage imageNamed:@"addimagepostupdateonclick.png"] forState:UIControlStateHighlighted];
        
        if (addPhotoLbl.isHidden)
        {
            [addPhotoLbl setHidden:NO];
        }
        
        
        if (createMessageLbl.isHidden)
        {
            [createMessageLbl setHidden:NO];
        }
    }
    
    else
    {
        
        [mixpanel track:@"Post Message"];
    }
    
    [createContentTextView setText:@""];
    
    [postUpdateBtn setEnabled:NO];
    
    
    if (isFacebookPageSelected)
    {
        [selectedFacebookPageButton setHidden:YES];
        
        if (isFacebookPageSelected)
        {
            [facebookPageButton setHidden:NO];
        }
        
        isFacebookPageSelected = NO;
    }
    
    
    if (isFacebookSelected)
    {
        isFacebookSelected = NO;
        
        if (facebookPageButton.isHidden)
        {
            [facebookPageButton setHidden:NO];
        }
        
        [selectedFacebookButton setHidden:YES];
    }
    
    
    if (isTwitterSelected)
    {
        isTwitterSelected = NO;
        
        if (twitterButton.isHidden)
        {
            [twitterButton setHidden:NO];
        }
        
        [selectedTwitterButton setHidden:YES];
    }
    
    
    if (!isSendToSubscribers) {
        
        if (sendToSubscribersOnButton.isHidden)
        {
            [sendToSubscribersOnButton setHidden:NO];
            [sendToSubscribersOffButton setHidden:YES];
        }
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)showBuyAutoSeoPlugin
{
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
}


#pragma PopUpViewDelegate

-(void)successBtnClicked:(id)sender
{
    [nfActivity hideCustomActivityView];
    
}



-(void)cancelBtnClicked:(id)sender
{
    
}

#pragma SocialOptionsMethods

- (IBAction)facebookBtnClicked:(id)sender
{
    [mixpanel track:@"Facebook Sharing"];
    
    NSLog(@"access : %@",[userDetails objectForKey:@"NFManageFBAccessToken"]);
    NSLog(@"FBUSER ID : %@",[userDetails objectForKey:@"NFManageFBUserId"]);
    
    
    if ([userDetails objectForKey:@"NFManageFBAccessToken"] && [userDetails objectForKey:@"NFManageFBUserId"])
    {
        isFacebookSelected=YES;
        [facebookButton setHidden:YES];
        [selectedFacebookButton setHidden:NO];
    }
    
    else
    {
        UIAlertView *fbAlert=[[UIAlertView alloc]initWithTitle:@"Facebook" message:@"To connect to Facebook,\n please sign in." delegate:self    cancelButtonTitle:@"Cancel" otherButtonTitles:@"Connect", nil];
        [fbAlert setTag:2001];
        [fbAlert show];
        fbAlert=nil;
    }
}

#pragma UITextViewDelegate


-(void)textViewDidChange:(UITextView *)textView
{
    NSString *substring = [NSString stringWithString:textView.text];
    
    createMessageLbl.hidden=YES;
    
    substring = [substring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (substring.length > 0)
    {
        [postUpdateBtn setEnabled:YES];
         postUpdateBtn.alpha = 1.0;
    }
    
    
    if (substring.length == 0)
    {
        createMessageLbl.hidden=NO;
        [postUpdateBtn setEnabled:NO];
        postUpdateBtn.alpha = 0.5;
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



- (IBAction)selectedFaceBookClicked:(id)sender
{
    isFacebookSelected=NO;
    [selectedFacebookButton setHidden:YES];
    [facebookButton setHidden:NO];
}


- (IBAction)facebookPageBtnClicked:(id)sender
{
    [mixpanel track:@"Facebook page sharing"];
    
    if (!appDelegate.socialNetworkNameArray.count)
    {
        UIAlertView *fbPageAlert=[[UIAlertView alloc]initWithTitle:@"Facebook Page" message:@"To connect to Facebook Page,\n Please sign in." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Connect ", nil];
        
        fbPageAlert.tag=2002;
        
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
    
}


- (IBAction)twitterBtnClicked:(id)sender
{
    [mixpanel track:@"Twitter sharing"];
    
    if (![userDetails objectForKey:@"authData"])
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
    
    sendToSubscribersAlert.tag=2;
    
    [sendToSubscribersAlert show];
    
    sendToSubscribersAlert=nil;
}




- (IBAction)sendToSubscribersOffClicked:(id)sender
{
    
    [sendToSubscribersOnButton setHidden:NO];
    [sendToSubscribersOffButton setHidden:YES];
    isSendToSubscribers=YES;
    
}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag==1)
    {
        
        if(buttonIndex == 0)
        {
            _picker = [[UIImagePickerController alloc] init];
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _picker.delegate = self;
            _picker.allowsEditing=YES;
            _picker.navigationBar.barStyle=UIBarStyleBlackOpaque;
            [self presentViewController:_picker animated:NO completion:nil];
            _picker=nil;
            [_picker setDelegate:nil];
        }
        
        
        if (buttonIndex==1)
        {
            _picker=[[UIImagePickerController alloc] init];
            _picker.allowsEditing=YES;
            [_picker setDelegate:self];
            //          [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            _picker.navigationBar.barStyle=UIBarStyleBlackOpaque;
            [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:_picker animated:YES completion:NULL];
            _picker=nil;
            [_picker setDelegate:nil];
            
        }
        
    }
    
    else if (actionSheet.tag==2)
    {
        if(buttonIndex == 0)
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                NSString* shareText = [NSString stringWithFormat:@"Take a look at my website.\n %@.nowfloats.com",[appDelegate.storeTag lowercaseString]];
                
                [fbSheet setInitialText:shareText];
                
                [self presentViewController:fbSheet animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Sorry"
                                          message:@"You can't post a feed right now, make sure your device has an internet connection and you have at least one Facebook account setup."
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                
                [alertView show];
            }
            
            
            
        }
        
        
        if (buttonIndex==1)
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                NSString* shareText = [NSString stringWithFormat:@"Take a look at my website.\n %@.nowfloats.com",[appDelegate.storeTag lowercaseString]];
                [tweetSheet setInitialText:shareText];
                [self presentViewController:tweetSheet animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Sorry"
                                          message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup."
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                
                [alertView show];
            }
        }
    }
    
    else if (actionSheet.tag == 3)
    {
        
        if(buttonIndex == 0)
        {
            if(isFromCamera)
            {
               
            }
            [self closeContentCreateSubview];
            isFromCamera = NO;
            _overlay = [[NFCameraOverlay alloc] initWithNibName:@"NFCameraOverlay" bundle:nil];
            
            _picker = [[UIImagePickerController alloc] init];
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //  _picker.delegate=self;
            _picker.navigationBar.barStyle = UIBarStyleBlackOpaque;
            
            _picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            _picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            _picker.cameraFlashMode= UIImagePickerControllerCameraFlashModeAuto;
            _picker.showsCameraControls = NO;
            //_picker.navigationBarHidden = YES;
            _picker.wantsFullScreenLayout = YES;
            _overlay.pickerReference = _picker;
            _picker.delegate = _overlay;
            _overlay.delegate= self;
            _picker.cameraOverlayView = _overlay.view;
            _picker.cameraViewTransform = CGAffineTransformMakeScale(1.5, 1.5);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelay:2.2f];
            _overlay.bottomBarSubView.alpha = 1.0f;
            [UIView commitAnimations];
            [self presentViewController:_picker animated:NO completion:nil];
        }
        
        
        else if (buttonIndex==1)
        {
            if(isFromCamera)
            {
                
            }
            isFromCamera = NO;
            [self closeContentCreateSubview];
            _picker=[[UIImagePickerController alloc] init];
            [_picker setDelegate:self];
            _picker.navigationBar.contentMode = UIViewContentModeScaleAspectFit;
            [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:_picker animated:NO completion:nil];
            _picker=nil;
            [_picker setDelegate:nil];
            
        }
        
        
        else if (buttonIndex == 2)
        {
           // uploadPictureImgView.image=nil;
            
            isPictureMessage = NO;
            
            isPostPictureMessage = NO;
            
            isFromCamera = NO;
            
            [addImageBtn setBackgroundImage:[UIImage imageNamed:@"addimageplaceholder.png"] forState:UIControlStateNormal];
            
            [addImageBtn setBackgroundImage:[UIImage imageNamed:@"addimagepostupdateonclick.png"] forState:UIControlStateHighlighted];
            
            [addPhotoLbl setHidden:NO];
            
        }
    }
    
}

-(void)closeContentCreateSubview
{
     //[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma NFCameraOverlayDelegate

-(void)NFOverlayDidFinishPickingMediaWithInfo:(NSDictionary *)info
{
   
        
        
        [self writeImageToDocuments];//Write the Image
        
        [addImageBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        [addImageBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        
        isPictureMessage=YES;
        
        [addPhotoLbl setHidden:YES];
        
        [_picker dismissViewControllerAnimated:NO completion:^{
        isPostPictureMessage = NO;
            
        }];
    
    
}


-(void)NFOverlayDidCancelPickingMedia
{
    [_picker dismissViewControllerAnimated:NO completion:nil];
    
}

-(void)NFOverlayDidFinishCroppingWithImage:(UIImage *)croppedImage
{
    [uploadPictureImgView setImage:croppedImage];
    [self NFOverlayDidFinishPickingMediaWithInfo:nil];
}

-(void)NFCropOverlayDidFinishCroppingWithImage:(UIImage *)croppedImage
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [uploadPictureImgView setImage:croppedImage];
    [self NFOverlayDidFinishPickingMediaWithInfo:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if (isPostPictureMessage)
    {
        
        isPostPictureMessage = YES;
        
        NSMutableDictionary *imageInfo = [[NSMutableDictionary alloc]initWithDictionary:info];
        
        NFCropOverlay *cropController = [[NFCropOverlay alloc]initWithNibName:@"NFCropOverlay" bundle:nil];
        
        cropController.delegate = self;
        
        cropController.imageInfo = imageInfo;
        
        [picker1 presentViewController:cropController animated:YES completion:nil];
        
        [addImageBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        [addImageBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        
        isPictureMessage=YES;
        
        [addPhotoLbl setHidden:YES];
        
    }
    
    else{
        
        primaryImage.image =  [info objectForKey:UIImagePickerControllerEditedImage];
        NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
        
        NSRange range = NSMakeRange (0,5);
        
        uuid=[uuid substringWithRange:range];
        
        NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
        
        uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
        
        NSString *imageName=[NSString stringWithFormat:@"%@.jpg",uuid];
        
        NSData* imageData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage], 0.1);
        
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString* documentsDirectory = [paths objectAtIndex:0];
        
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
        
        NSString *localImageUri=[NSMutableString stringWithFormat:@"local%@",fullPathToFile];
        appDelegate.primaryImageUploadUrl = [NSMutableString stringWithFormat:@"%@",localImageUri];
        
        [imageData writeToFile:fullPathToFile atomically:NO];
        
        [picker1 dismissViewControllerAnimated:YES completion:nil];
        
        [self performSelector:@selector(displayPrimaryImageModalView:) withObject:localImageUri afterDelay:1.0];
    }
}


#pragma mark SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) strData forUsername: (NSString *) username
{
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:strData forKey: @"authData"];
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
    
    [userDetails setObject:username forKey:@"NFManageTwitterUserName"];
    [userDetails synchronize];
    isTwitterSelected=YES;
    [twitterButton setHidden:YES];
    [selectedTwitterButton setHidden:NO];
    
}

-(void)check
{
    isTwitterSelected=NO;
    [twitterButton setHidden:NO];
    [selectedTwitterButton setHidden:YES];
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


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    if (isPostPictureMessage)
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
     
    }
    
    else{
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)updateMessageFailed
{
    [nfActivity hideCustomActivityView];
    
}

-(void)updateMessageSucceed
{
   
    [self updateViewController];
}

-(void)failedOnDealUpload:(NSString *)dealid
{
    [nfActivity hideCustomActivityView];
    
    UIAlertView *failedPictureTextMsg=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Failed to upload the message. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [failedPictureTextMsg show];
    
    failedPictureTextMsg= nil;
    
    DeleteFloatController *delController=[[DeleteFloatController alloc]init];
    delController.DeleteBizFloatdelegate=self;
    [delController deletefloat:dealid];
    delController=nil;
    
}

-(void)updateBizMessage
{
    
    
}
@end
