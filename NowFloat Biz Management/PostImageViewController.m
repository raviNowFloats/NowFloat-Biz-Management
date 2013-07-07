//
//  PostImageViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 12/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "PostImageViewController.h"
#import "UIColor+HexaString.h"  
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "CreatePictureDeal.h"
#import "BizMessageViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SA_OAuthTwitterEngine.h"
#import "Mixpanel.h"

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

@interface PostImageViewController ()<FBLoginViewDelegate,pictureDealDelegate>

@end

@implementation PostImageViewController
@synthesize request,dataObj,uniqueIdString,chunkArray,theConnection,fbSession;
@synthesize postImageView,testImage,imageOrinetationString;


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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadPicture) name:@"postPicture" object:nil ];

    
    [self performSelector:@selector(showKeyBoard) withObject:nil afterDelay:0.4];
}


-(void)showKeyBoard
{
    
    [imageDescriptionTextView  becomeFirstResponder];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.        
    
    self.navigationController.navigationBarHidden=YES;
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    userDetails=[NSUserDefaults standardUserDefaults];
    
    chunkArray=[[NSMutableArray alloc]init];
    
    receivedData=[[NSMutableData alloc]init];
    
    isFacebookAdmin=NO;
    
    [fbPageSubView setHidden:YES];
        
    successCode=0;
    
    [imageDescriptionTextView.layer setCornerRadius:6.0];
    [imageDescriptionTextView.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    [imageDescriptionTextView.layer setBorderWidth:1.0];
    CALayer * l = [postImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:6.0];
    
    [activitySubView setHidden:YES];
    
    NSData *imageData=UIImageJPEGRepresentation(testImage, 0.1);
    
    UIImage *img=[UIImage imageWithData:imageData];
    
    [postImageView setImage:img];
    
    //[postImageView setImage:[self rotate:UIImageOrientationDown]];
    
    if ([imageOrinetationString isEqualToString:@"left"])
    {
        [postImageView setImage:[self rotate:UIImageOrientationRight]];
        
    }

    
    if ([imageOrinetationString isEqualToString:@"right"])
    {
            [postImageView setImage:[self rotate:UIImageOrientationLeft]];
        
    }
    
    
    if ([imageOrinetationString isEqualToString:@"up"])
    {
            [postImageView setImage:[self rotate:UIImageOrientationDown]];
        

    }
    
    
    if ([imageOrinetationString isEqualToString:@"normal"])
    {
            //[postImageView setImage:[self rotate:UIImageOrientationDown]];
    
        
    }



    
    [postImageView setContentMode:UIViewContentModeScaleAspectFit];

    [self writeImageToDocuments];//Write the Image 

    
    //Create NavBar here
    
    CGFloat width = self.view.frame.size.width;
    
    navBar = [[UINavigationBar alloc] initWithFrame:
                               CGRectMake(0,0,width,44)];
    
    [self.view addSubview:navBar];
    
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(140,13,160,20)];
    
    headerLabel.text=@"Picture";
    
    headerLabel.backgroundColor=[UIColor clearColor];
    
    headerLabel.textColor=[UIColor colorWithHexString:@"464646"];
    
    headerLabel.font=[UIFont fontWithName:@"Helevetica" size:18.0];
    
    [navBar addSubview:headerLabel];
    
    
    //Create the custom back bar button here....
    
    UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    
    backButton.frame = CGRectMake(5,0,50,44);
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:backButton];

    
    /*Notification to post a picture*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadPicture) name:@"postPicture" object:nil ];
  
    
    /*Notification to post the failed view*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetView) name:@"FailedImageDeal" object:nil ];
    
    
    [selectedFacebookPageButton setHidden:YES];
    [selectedFacebookButton setHidden:YES];
    [selectedTwitterButton setHidden:YES];

    
    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40) ];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    
    
    UIBarButtonItem *cancelleftBarButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonClicked:)];
    NSArray *array = [NSArray arrayWithObjects:cancelleftBarButton, nil];
    [toolbar setItems:array];
    
    imageDescriptionTextView.inputAccessoryView = toolBarView;

    isSendToSubscibers=YES;
    
    [sendToSubscribersOffButton setHidden:YES];
    
    [sendToSubscribersOnButton setHidden:NO];

    
}



-(void)back
{
//    BizMessageViewController *bizController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
//    
//    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
//    [viewControllers removeLastObject];
//    [viewControllers addObject:bizController];
//    [[self navigationController] setViewControllers:viewControllers animated:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0,5);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
    
    NSString *imageName=[NSString stringWithFormat:@"%@.jpg",uuid];
    
    [postImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    postImageView.image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData* imageData = UIImageJPEGRepresentation(postImageView.image, 0.1);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    appDelegate.localImageUri=[NSMutableString stringWithFormat:@"local%@",fullPathToFile];
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    [picker1 dismissModalViewControllerAnimated:YES];    
    
}


-(void)startUpload
{
    if ([imageDescriptionTextView.text length])
    {
        
        
        [activitySubView setHidden:NO];

        [self performSelector:@selector(postImage) withObject:nil afterDelay:0.1];
    }
    
    else
    {
        [activitySubView setHidden:YES];

        UIAlertView *uploadAlertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Please fill a description about the image view" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [uploadAlertView show];
        
        uploadAlertView=nil;
        
    }
    

}


-(void)postImage
{

    if ([imageDescriptionTextView.text length])
    {
        
        [imageDescriptionTextView resignFirstResponder];
        
        if (isFacebookSelected)
        {
            [self postPhotoToFb];
            
        }
        
        
        if (isFacebookPageSelected)
        {
            [self postPhotoToFbPage];
        }
        
        
        CreatePictureDeal *createDeal=[[CreatePictureDeal alloc]init];
        
        createDeal.dealUploadDelegate=self;
        
        NSMutableDictionary *uploadDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
           imageDescriptionTextView.text,@"message",
           [NSNumber numberWithBool:isSendToSubscibers],@"sendToSubscribers",[appDelegate.storeDetailDictionary  objectForKey:@"_id"],@"merchantId",appDelegate.clientId,@"clientId",nil];
        
        createDeal.offerDetailDictionary=[[NSMutableDictionary alloc]init];
        
        [createDeal createDeal:uploadDictionary postToTwitter:isTwitterSelected ];
                
    }
    
    else
    {
        UIAlertView *emptyAlert=[[UIAlertView alloc]initWithTitle:@"Uh-oh" message:@"Enter a description for the picture" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        emptyAlert.tag=1;
        [emptyAlert show];
        emptyAlert=nil;     
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
    
    
    NSArray *a1=[NSArray arrayWithObject:[appDelegate.fbUserAdminArray objectAtIndex:[indexPath  row]]];
    
    NSArray *a2=[NSArray arrayWithObject:[appDelegate.fbUserAdminAccessTokenArray objectAtIndex:[indexPath row]]];
    
    NSArray *a3=[NSArray arrayWithObject:[appDelegate.fbUserAdminIdArray objectAtIndex:[indexPath row]]];
    
    [appDelegate.socialNetworkNameArray addObjectsFromArray:a1];
    [appDelegate.socialNetworkAccessTokenArray addObjectsFromArray:a2];
    [appDelegate.socialNetworkIdArray addObjectsFromArray:a3];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [fbPageSubView setHidden:YES];
    
    isFacebookPageSelected=YES;
    
    [facebookPageButton setHidden:YES];
    
    [selectedFacebookPageButton setHidden:NO];
    
    [self showKeyBoard];
    
}


- (void)openSession:(BOOL)isAdmin

{    
    isFacebookAdmin=isAdmin;
    
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
            //[self postPhotoToFb];
            
            
            NSArray *permissions =  [NSArray arrayWithObjects:
                                     @"publish_stream",
                                     @"manage_pages",@"publish_actions"
                                     ,nil];
            
            if ([FBSession.activeSession.permissions
                 indexOfObject:@"publish_actions"] == NSNotFound)
            {
                
                [[FBSession activeSession] reauthorizeWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error)
                 {
                     
                        if (!isFacebookAdmin)
                        {
                            
                            if ([userDetails objectForKey:@"NFManageFBAccessToken"] && [userDetails objectForKey:@"NFManageFBUserId"])
                            {
                                isFacebookSelected=YES;
                                [facebookButton setHidden:YES];
                                [selectedFacebookButton setHidden:NO];
                            }
                            
                            else
                            {
                                [self populateUserDetails];                    
                            }
                            
                        }
                     
                        else
                        {
                            if (!appDelegate.socialNetworkNameArray.count)
                            {
                                [activitySubView setHidden:NO];
                                
                                [self connectAsFbPageAdmin];
                            }
                            
                            else
                            {
                                [activitySubView setHidden:YES];
                                isFacebookPageSelected=YES;
                                [selectedFacebookPageButton setHidden:NO];
                                [facebookPageButton setHidden:YES];        
                            }
                                                        
                        }
                     
                 }];
            }
            

        }
            break;
            
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            break;
        default:
            break;
    }
}


-(void)postPhotoToFb
{
    UIImage *img = postImageView.image;

    [FBRequestConnection startWithGraphPath:@"me/photos" parameters:[NSDictionary dictionaryWithObjectsAndKeys:img,@"source",imageDescriptionTextView.text,@"message" ,nil] HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         NSLog(@"Success");         
     }
     
     ];
    
    
    if (!isFacebookPageSelected )
    {
        [FBSession.activeSession closeAndClearTokenInformation];
    }



}


-(void)postPhotoToFbPage
{
    
    UIImage *img = postImageView.image;
    
    [FBRequestConnection startWithGraphPath:[NSString  stringWithFormat:@"%@/photos",[appDelegate.socialNetworkIdArray objectAtIndex:0]] parameters:[NSDictionary dictionaryWithObjectsAndKeys:img,@"source",imageDescriptionTextView.text,@"message" ,nil] HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         NSLog(@"Success");
     }
     
     ];
    
    
    if (!isFacebookSelected)
    {
        
    [FBSession.activeSession closeAndClearTokenInformation];
        
    }
    
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
    
    UIImage *img =postImageView.image;
    
    dataObj=UIImageJPEGRepresentation(img,0.1);
    
    NSUInteger length = [dataObj length];
    
//    NSLog(@"Dataobject Length:%d",length);
    
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
    
    [appDelegate.dealImageArray insertObject:appDelegate.localImageUri atIndex:0];
    
    [self updateView];
    
    NSLog(@"receivedString:%@",receivedString);
    
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
                //NSLog(@"SuccessCode:%d",code);

            }
        
    }
}


- (void) keyboardWillShow: (NSNotification*) aNotification
{
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = [[self view] frame];
    
    rect.origin.y -= 215;
    
    [[self view] setFrame: rect];
    
    [UIView commitAnimations];
    
}


- (void) keyboardWillHide: (NSNotification*) aNotification
{
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = [[self view] frame];
    
    rect.origin.y += 215;
    
    [[self view] setFrame: rect];
    
    [UIView commitAnimations];
    
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    
    saySomthingLabel.hidden=YES;

    return YES;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
        replacementText:(NSString *)text
{
    //TO LIMIT NUMBER OF CHARACTERS TO 160
    if (textView.text.length > 160 && range.length == 0)
    {
        return NO;
    }
        
    return YES;
}


-(void)textViewDidChange:(UITextView *)textView
{
    NSString *substring = [NSString stringWithString:textView.text];
    
    saySomthingLabel.hidden=YES;
    
    substring = [substring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([textView.text length]!=0) {
        
        UIButton *customButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [customButton addTarget:self action:@selector(startUpload) forControlEvents:UIControlEventTouchUpInside];
        
        [customButton setFrame:CGRectMake(280,5, 30, 30)];
        
        [customButton setBackgroundImage:[UIImage imageNamed:@"checkmark.png"]  forState:UIControlStateNormal];
        
        [customButton setShowsTouchWhenHighlighted:YES];
        
        [navBar addSubview:customButton];
        
        /*
        UIBarButtonItem *postMessageButtonItem = [[UIBarButtonItem alloc]initWithCustomView:customButton];
        
        self.navigationItem.rightBarButtonItem=postMessageButtonItem;
        */
    }
    
}


-(void)dismissKeyboard
{
    if ([imageDescriptionTextView.text length]==0)
    {
        saySomthingLabel.hidden=NO;   
    }
    [imageDescriptionTextView resignFirstResponder];
}


- (IBAction)facebookButtonClicked:(id)sender
{
    [self openSession:NO];    
}


- (IBAction)selectedFacebookButtonClicked:(id)sender
{
    
    isFacebookSelected=NO;    
    [facebookButton setHidden:NO];
    [selectedFacebookButton setHidden:YES];
    
    
}


- (IBAction)facebookPageButton:(id)sender
{

    [imageDescriptionTextView resignFirstResponder];
    
    [self openSession:YES];
}


- (IBAction)selectedFacebookPageButtonClicked:(id)sender
{
    isFacebookPageSelected=NO;
    [facebookPageButton setHidden:NO];
    [selectedFacebookPageButton setHidden:YES];
    
}


- (IBAction)twitterButtonClicked:(id)sender
{
    
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Twitter Sharing"];

    if (![userDetails objectForKey:@"authData"])
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


- (IBAction)selectedTwitterButtonCicked:(id)sender
{
    isTwitterSelected=NO;
    [twitterButton setHidden:NO];
    [selectedTwitterButton setHidden:YES];
}

- (IBAction)sendToSubscribersOnClicked:(id)sender
{
    UIAlertView *sendToSubscribersAlert=[[UIAlertView alloc]initWithTitle:@"Confirm" message:@"Are you sure you don't want your subscribers to receive this message?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    sendToSubscribersAlert.tag=3;
    
    [sendToSubscribersAlert show];
    
    sendToSubscribersAlert=nil;

}

- (IBAction)sendToSubscribersOffButtonClicked:(id)sender
{
    
    [sendToSubscribersOnButton setHidden:NO];
    
    [sendToSubscribersOffButton setHidden:YES];
    
    isSendToSubscibers=YES;
    
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
    
    [userDetails setObject:username forKey:@"NFManageTwitterUserName"];
    
    [userDetails synchronize];
    
}


-(void)populateUserDetails
{
    NSString * accessToken = [[FBSession activeSession] accessToken];
    
    [userDetails setObject:accessToken forKey:@"NFManageFBAccessToken"];
    
    [userDetails synchronize];
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
     {
         if (!error)
         {
             [userDetails setObject:[user objectForKey:@"id"] forKey:@"NFManageFBUserId"];
             [userDetails setObject:[user objectForKey:@"name"] forKey:@"NFFacebookName"];
             [userDetails synchronize];
             
             isFacebookSelected=YES;
             [facebookButton setHidden:YES];
             [selectedFacebookButton setHidden:NO];
             [activitySubView setHidden:YES];
             
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
                 
                 [activitySubView setHidden:YES];
             }
             
             //[FBSession.activeSession closeAndClearTokenInformation];
             
         }
         else
         {
             [self openSession:YES];
         }
     }
     ];
    
}


-(void)assignFbDetails:(NSArray*)sender
{
    
    [userDetails setObject:sender forKey:@"NFManageUserFBAdminDetails"];
    
    [userDetails synchronize];
    
}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1)
    {
        if(buttonIndex == 0)
        {
            picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing=YES;
            [self presentModalViewController:picker animated:NO];                    
            picker=nil;
            [picker setDelegate:nil];
        }
        
        
        if (buttonIndex==1)
        {
            picker=[[UIImagePickerController alloc] init];
            picker.allowsEditing=YES;
            [picker setDelegate:self];
            [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            [self presentViewController:picker animated:YES completion:NULL];
            picker=nil;
            [picker setDelegate:nil];
            
        }
        
    }
    
}


-(void)updateView
{
    [activitySubView setHidden:YES];

    BizMessageViewController *bizController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers removeLastObject];
    [viewControllers addObject:bizController];
    [[self navigationController] setViewControllers:viewControllers animated:NO];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Post Image"];

    
}


-(void)resetView
{
    
    [activitySubView setHidden:YES];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag==1)
    {
        
        if (buttonIndex==1)
        {
            [activitySubView setHidden:NO];
            [self openSession:NO];
        }
        
        
    }
    
    
    if (alertView.tag==2)
    {
        if (buttonIndex==1)
        {
            [activitySubView setHidden:NO];
            [self openSession:YES];
        }
        
    }
    
    
    if (alertView.tag==3) {
        
        
        if (buttonIndex==1) {
            
            [sendToSubscribersOnButton setHidden:YES];
            [sendToSubscribersOffButton setHidden:NO];
            isSendToSubscibers=NO;
        }

        
    }
    
    
}


-(void)showFbPagesSubView
{
    
    [activitySubView setHidden:YES];
    [fbPageSubView setHidden:NO];
    [self reloadFBpagesTableView];
    
}


-(void)reloadFBpagesTableView
{    
    [fbPageTableView reloadData];
}


-(UIImage*)rotate:(UIImageOrientation)orient
{
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGRect             rect = CGRectZero;
    CGAffineTransform  tran = CGAffineTransformIdentity;
    
    bnds.size = postImageView.image.size;
    rect.size = postImageView.image.size;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            return postImageView.image;
            
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
    CGContextDrawImage(ctxt, rect, self.postImageView.image.CGImage);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{

    postImageView = nil;
    imageDescriptionTextView = nil;
    saySomthingLabel = nil;
    activitySubView = nil;
    toolBarView = nil;
    facebookButton = nil;
    selectedFacebookButton = nil;
    facebookPageButton = nil;
    selectedFacebookButton = nil;
    selectedFacebookPageButton = nil;
    fbPageSubView = nil;
    fbPageTableView = nil;
    twitterButton = nil;
    selectedTwitterButton = nil;
    [self setPostImageView:nil];
    sendToSubscribersOffButton = nil;
    sendToSubscribersOnButton = nil;
    [super viewDidUnload];
}


-(void)viewDidDisappear:(BOOL)animated
{

    if ([imageDescriptionTextView.text length]==0)
    {
        saySomthingLabel.hidden=NO;
    }

    [imageDescriptionTextView resignFirstResponder];

}


-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [self.fbSession handleOpenURL:url];
}


-(void)writeImageToDocuments
{


    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0,5);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
    
    NSString *imageName=[NSString stringWithFormat:@"%@.jpg",uuid];
    
    NSData* imageData = UIImageJPEGRepresentation(postImageView.image, 0.1);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    appDelegate.localImageUri=[NSMutableString stringWithFormat:@"local%@",fullPathToFile];
    
    [imageData writeToFile:fullPathToFile atomically:NO];

}



@end
