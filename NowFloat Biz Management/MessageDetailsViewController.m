//
//  MessageDetailsViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 30/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "MessageDetailsViewController.h"
#import "UIColor+HexaString.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import "Accounts/Accounts.h"
#import "SWRevealViewController.h"
#import "BizMessageViewController.h"
#import "SBJson.h"
#import "SBJsonWriter.h"
#import "UpdateFaceBook.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GetBizFloatDetails.h"
#import "DeleteFloatController.h"
#import "Mixpanel.h"

@interface MessageDetailsViewController ()<getFloatDetailsProtocol,updateBizMessage>

@end

@implementation MessageDetailsViewController
@synthesize messageDate,messageDescription,messageTextView,messageId;
@synthesize dateLabel,bgLabel;
@synthesize selectItemCallback = _selectItemCallback;
@synthesize dealImageUri;
@synthesize currentRow;
@synthesize delegate;
@synthesize rawMessageDate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    postToSocialSiteSubview.hidden=YES;
    
    activityIndicatorSubView.hidden=YES;
    
    postToFBTimelineButton.hidden=NO;
    
    self.navigationController.navigationBarHidden=YES;
    
    fbTextMessage.text=messageDescription;//set message description on facebookSubview
    
    [messageTextView.layer setBorderWidth:1.0];
    
    [messageTextView.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    
    [messageTextView setScrollEnabled:NO];

    
    //Create the deal Image space here check for local images or URI from response
    
    NSString *_imageUriString=dealImageUri;
    
    NSString *imageUriSubString=[_imageUriString  substringToIndex:5];
    

    if ([dealImageUri isEqualToString:@"/Deals/Tile/deal.png"] )
    {
        messageTextView.text=messageDescription;//set message description
    }
    
    
    else if ( [dealImageUri isEqualToString:@"/BizImages/Tile/.jpg" ])
        
    {
        messageTextView.text=messageDescription;//set message description

    }
    
    else if ([imageUriSubString isEqualToString:@"local"])
    {
        
        NSString *version=[[UIDevice currentDevice] systemVersion];
        
        
        if ([version floatValue]<7.0)
        {
            
            
            messageTextView.text=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@",messageDescription];//set message description

        }

        else
        {
            messageTextView.text=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@",messageDescription];//set message description

        
        }
        
        
    }
    
    else
    {
        NSString *version=[[UIDevice currentDevice] systemVersion];

        if ([version floatValue]<7.0)
        {
            
            
            messageTextView.text=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@",messageDescription];//set message description
            
        }
        
        else
        {
            messageTextView.text=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@",messageDescription];//set message description
            
            
        }
        
        
    }

        
    
    /*Set the messageTextView height based on the content height*/
    
    
    messageTextView.textColor=[UIColor colorWithHexString:@"3c3c3c"];
    
    
    NSString *version=[[UIDevice currentDevice] systemVersion];
    
    
    if ([version floatValue]<7.0) {

    
    
    CGRect frame1 = messageTextView.frame;

    NSLog(@"contentSize:%f",messageTextView.contentSize.height);
    
    frame1.size.height = messageTextView.contentSize.height+170;
    
    messageTextView.frame = frame1;

    }
    
    
    
    
    
    else
    {
    
    UIFont *font = [messageTextView font];
    
    int width1 = messageTextView.frame.size.width;
    
    int height1 = messageTextView.frame.size.height;
    
    messageTextView.contentInset = UIEdgeInsetsMake(0,5,0, 5);
    
    NSMutableDictionary *atts = [[NSMutableDictionary alloc] init];
    [atts setObject:font forKey:NSFontAttributeName];
    
    CGRect rect = [messageTextView.text boundingRectWithSize:CGSizeMake(width1, height1)
             options:NSStringDrawingUsesLineFragmentOrigin
          attributes:atts
             context:nil];
    
    
    CGRect frame = messageTextView.frame;
    frame.size.height = rect.size.height + 170;
        
    messageTextView.frame = frame;
    
    }
    
    messageTextView.text=@"";
    
    if ([dealImageUri isEqualToString:@"/Deals/Tile/deal.png"] )
    {

        [messageTitleLabel setFrame:CGRectMake(8, messageTextView.frame.origin.y-10, 250, 21)];
        messageTextView.text=[NSString stringWithFormat:@"\n\n%@\n\n\n",messageDescription];
    
    }
    
    
    else if ( [dealImageUri isEqualToString:@"/BizImages/Tile/.jpg" ])
        
    {
        [messageTitleLabel setFrame:CGRectMake(8, messageTextView.frame.origin.y-10, 250, 21)];
        messageTextView.text=[NSString stringWithFormat:@"\n\n%@\n\n\n",messageDescription];

    }
    
    else if ([imageUriSubString isEqualToString:@"local"])
    {
        
        [messageTitleLabel setFrame:CGRectMake(8, messageTextView.frame.origin.y+265, 250, 21)];
        
        UIImageView *dealImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, messageTextView.frame.origin.y-5, 252, 250)];
        
        NSString *imageStringUrl=[NSString stringWithFormat:@"%@",[dealImageUri substringFromIndex:5]];
        
        [dealImageView setBackgroundColor:[UIColor clearColor]];
        
        [dealImageView setImage:[UIImage imageWithContentsOfFile:imageStringUrl]];
        
        dealImageView.contentMode=UIViewContentModeScaleToFill;
        
        [messageTextView addSubview:dealImageView];
        
        messageTextView.text=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@\n\n\n",messageDescription];

    }
    
    else
    {
        [messageTitleLabel setFrame:CGRectMake(8, messageTextView.frame.origin.y+265, 250, 21)];        
        
        UIImageView *dealImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, messageTextView.frame.origin.y-5, 252, 250)];
        
        NSString *imageStringUrl=[NSString stringWithFormat:@"%@%@",appDelegate.apiUri,dealImageUri];
        
        [dealImageView setImageWithURL:[NSURL URLWithString:imageStringUrl]];
        
        dealImageView.contentMode=UIViewContentModeScaleToFill;
        
        [dealImageView setBackgroundColor:[UIColor clearColor]];
        
        [messageTextView addSubview:dealImageView];
        
        if ([version floatValue]<7.0)
        {

            messageTextView.text=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@\n\n\n",messageDescription];
            
            
        }
        
        else
        {
        messageTextView.text=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@\n\n\n",messageDescription];
        }
    }
    
    [messageTitleLabel setBackgroundColor:[UIColor clearColor]];
    
    [messageTextView addSubview:messageTitleLabel];
    
    UIImageView *applineImageView;
    UILabel *tagHeadingLabel;
    UILabel *messageDescriptionLabel;
    
    
    if ([version floatValue]<7.0) {

        [dateLabel setFrame:CGRectMake(30, messageTextView.frame.size.height-120,282,28)];
        applineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(-5,  messageTextView.frame.size.height-110, 282, 11)];
        tagHeadingLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, messageTextView.frame.size.height-90, 282, 28)];

        tagTextView=[[UITextView alloc]initWithFrame:CGRectMake(messageTextView.frame.origin.x-20, messageTextView.frame.size.height-65, 272,60)];

    }
    
    else
    {    
        [dateLabel setFrame:CGRectMake(30, messageTextView.frame.size.height-110,282,28)];
        applineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(-5,  messageTextView.frame.size.height-100, 282, 11)];

        tagHeadingLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, messageTextView.frame.size.height-80, 282, 28)];
        
        tagTextView=[[UITextView alloc]initWithFrame:CGRectMake(messageTextView.frame.origin.x-20, messageTextView.frame.size.height-55, 272,60)];

    }
    
    [messageTextView addSubview:messageDescriptionLabel];
    
    [applineImageView setImage:[UIImage imageNamed:@"appline.png"]];
    
    [messageTextView addSubview:applineImageView];
    
    
    
    [tagHeadingLabel setBackgroundColor:[UIColor clearColor]];
    
    [tagHeadingLabel setText:@"Tags"];
    
    [tagHeadingLabel setTextColor:[UIColor colorWithHexString:@"9c9b9b"]];
    
    [tagHeadingLabel  setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
    
    [messageTextView addSubview:tagHeadingLabel];

    
    [tagTextView setTextColor:[UIColor colorWithHexString:@"3c3c3c"]];
    
    [tagTextView setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    
    [tagTextView setBackgroundColor:[UIColor clearColor]];
    
    [tagTextView setEditable:NO];
    
    [tagTextView setUserInteractionEnabled:NO];
    
    [messageTextView addSubview:tagTextView];
    
    av =[[UIActivityIndicatorView alloc]
         initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    
    [av setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    av.center=tagTextView.center;
    
    [av startAnimating];
    
    [av setHidesWhenStopped:YES];
    
    [messageTextView addSubview:av];
                                            
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            if (messageTextView.frame.size.height>300)
            {
                messageDescriptionScrollView.contentSize=CGSizeMake(self.view.frame.size.width,messageTextView.frame.size.height+150);
            }            
        }
        if(result.height == 568)
        {
            // iPhone 5

            if (messageTextView.frame.size.height>420)
            {
                messageDescriptionScrollView.contentSize=CGSizeMake(self.view.frame.size.width,messageTextView.frame.size.height+150);
            }
        }
    }
    
    CGRect frame2 = fbTextMessage.frame;
    frame2.size.height = fbTextMessage.contentSize.height;
    fbTextMessage.frame = frame2;
    
    [messageTextView.layer setCornerRadius:6];
    [fbTextMessage.layer setCornerRadius:6];
    [dateLabel.layer setCornerRadius:6];
    
    
    NSDate *messageDay = rawMessageDate;
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"EEEE"]; // day, like "Saturday"
    NSString *dayOfWeek = [myFormatter stringFromDate:messageDay];
    
    
    NSDate *timingMsg=rawMessageDate;
    NSDateFormatter *timingFormatter=[[NSDateFormatter alloc]init];
    [timingFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *timeOfUpdate=[timingFormatter stringFromDate:timingMsg];
    
    
    //Set datelabel
    [dateLabel setText:[NSString stringWithFormat:@"%@  |  %@  |  %@",dayOfWeek,messageDate,timeOfUpdate]];
    
    //Create NavBar here
    
    CGFloat width = self.view.frame.size.width;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:
                               CGRectMake(0,0,width,44)];
    
    [self.view addSubview:navBar];

    //Create the custom back bar button here....
    
    UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    
    backButton.frame = CGRectMake(5,0,50,44);
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:backButton];
    
    
    //Create Custom Delete button
    
    UIButton *customButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customButton addTarget:self action:@selector(deleteFloat) forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setFrame:CGRectMake(280,7, 30, 30)];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"trashcan.png"]  forState:UIControlStateNormal];
    
    [customButton setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customButton];
    
    //Get Float Keywords ...
    
    GetBizFloatDetails *getDetails=[[GetBizFloatDetails  alloc]init];
    
    getDetails.delegate=self;
    
    [getDetails getBizfloatDetails:messageId];
        
}


-(void)back
{
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Back from view details"];
    

    [self.navigationController popViewControllerAnimated:YES];
}


-(void)getKeyWords:(NSDictionary *)responseDictionary
{
    
    if ([[responseDictionary objectForKey:@"targetFloat"] objectForKey:@"_keywords"]==[NSNull null])
    {
        tagTextView.text=@"+";
        [av stopAnimating];
    }
    
    else
    {
    
    NSMutableArray *floatDetailArray=[[NSMutableArray alloc]initWithArray:[[responseDictionary objectForKey:@"targetFloat"] objectForKey:@"_keywords"]];
    
    if ([floatDetailArray count])
    {
        
        NSMutableArray *tempArray=[[NSMutableArray alloc]initWithArray:floatDetailArray];

        
        if ([floatDetailArray count]>3)
        {
            
            for (int i=0; i<[floatDetailArray count]; i++)
            {
                
                if (i>3)
                {
                    [tempArray removeLastObject];
                }
                
            }
            
        }
        
        NSMutableString *keywordMutableString=[[NSMutableString alloc]init];
        
        for (int i=0; i<[tempArray count]; i++)
        {
            
            if (i==tempArray.count-1)
            {
                
                [keywordMutableString appendString:[NSString stringWithFormat:@" %@",[floatDetailArray objectAtIndex:i]]];
            }
            
            else
            {
                
                [keywordMutableString appendString:[NSString stringWithFormat:@" %@ |",[floatDetailArray objectAtIndex:i]]];
                
            }
            
            
        }
        
        [av stopAnimating];
        
        tagTextView.text=keywordMutableString;

    }
    
 
    else
    {
    
        [av stopAnimating];
        
        tagTextView.text=@"+";
    
    }
    
    }
}


- (void)sessionStateChanged:(NSNotification*)notification
{
    
    postToSocialSiteSubview.hidden=NO;
    
}


-(void)updateMessage
{
    NSLog(@"update message");
}


-(void)deleteFloat
{
    
    
    UIAlertView *deleteAlert=[[UIAlertView alloc]initWithTitle:@"Confirm" message:@"Are you sure to delete ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    [deleteAlert show];
    
    deleteAlert=nil;
    
    
    
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [activityIndicatorSubView setHidden:NO];
        DeleteFloatController *delController=[[DeleteFloatController alloc]init];
        delController.DeleteBizFloatdelegate=self;
        [delController deletefloat:messageId];
        delController=nil;

    }

}


-(void)updateBizMessage
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Delete Float"];
    [activityIndicatorSubView setHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [appDelegate.deletedFloatsArray insertObject:messageId atIndex:0];
    [delegate performSelector:@selector(removeObjectFromTableView:) withObject:currentRow];

}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (IBAction)postToTwitter:(id)sender
{
    
    [activityIndicatorSubView   setHidden:NO];
    
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
    
    recievedData=[[NSMutableData alloc]init];
    
    NSString *urlString=@"https://www.googleapis.com/urlshortener/v1/url";
    
    NSURL *postUrl=[NSURL URLWithString:urlString];
    
    NSString *messageUrl=[NSString stringWithFormat:@"http://%@.nowfloats.com/bizfloat/%@",[[appDelegate.storeDetailDictionary objectForKey:@"Tag"] lowercaseString],messageId];
    
    NSDictionary *uploadDictionary=@{@"longUrl":messageUrl};
    
    NSString *updateString=[jsonWriter stringWithObject:uploadDictionary];
    
    NSData *postData = [updateString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:postUrl];
    
    [uploadRequest setHTTPMethod:@"POST"];
    
    [uploadRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [uploadRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [uploadRequest setHTTPBody:postData];
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:uploadRequest delegate:self];
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    NSLog(@"response for urlshortner:%d",code);
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    
    if (data1==nil)
    {
        UIAlertView *alertForConnection=[[UIAlertView alloc]initWithTitle:@"Request Failed" message:@"Request failure with URL shortner" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil,nil];
        [alertForConnection show];
        alertForConnection=nil;
        [activityIndicatorSubView setHidden:YES];
    }
    
    else
    {
        
        [recievedData appendData:data1];
        
    }
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError* error;
    
    NSMutableDictionary* json = [NSJSONSerialization
                                 JSONObjectWithData:recievedData
                                 options:kNilOptions
                                 error:&error];
    
    if (error)
    {
        
        UIAlertView *urlShortnerAlert=[[UIAlertView alloc]initWithTitle:@"URLShortner" message:error.localizedDescription delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [urlShortnerAlert show];
        [activityIndicatorSubView setHidden:YES];
        
    }
    
    
    else
    {
        [activityIndicatorSubView setHidden:YES];
        
        SLComposeViewController *tweetSheet = [SLComposeViewController                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheet setInitialText:[NSString stringWithFormat:@"Look what i found on NowFloats %@",[json  objectForKey:@"id"]]];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    
    [activityIndicatorSubView setHidden:YES];
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
}


- (IBAction)smsButtonClicked:(id)sender
{
    MFMessageComposeViewController *pickerSMS = [[MFMessageComposeViewController alloc] init];
    
    pickerSMS.messageComposeDelegate = self;
    
    pickerSMS.body = [NSString stringWithFormat:@"%@\n\nFrom\n%@.nowfloats.com",messageDescription,[[appDelegate.storeDetailDictionary objectForKey:@"Tag"] lowercaseString]];
    
    [self presentModalViewController:pickerSMS animated:YES];
    
}


- (IBAction)mailButtonClicked:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        
        mail.mailComposeDelegate = self;
        
        [mail setMessageBody:[NSString stringWithFormat:@"%@\n\n\n\nFrom\n%@.nowfloats.com",messageDescription,[[appDelegate.storeDetailDictionary objectForKey:@"Tag"] lowercaseString]] isHTML:NO];
        
        [self presentModalViewController:mail animated:YES];
        
    }
    
    else
    {
        UIAlertView *mailAlert=[[UIAlertView alloc]initWithTitle:@"Configure" message:@"Please configure email in settings" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [mailAlert show];
        
        mailAlert=nil;
        
    }
    
    
}


- (IBAction)postToFacebook:(id)sender
{
//    [appDelegate openSession];
//    
//    NSString * accessToken = [[FBSession activeSession] accessToken];
//
//    NSLog(@"accessToken :%@",accessToken);
    
    

    if ([userDefaults objectForKey:@"NFManageFBAccessToken"] && [userDefaults objectForKey:@"NFManageFBUserId"])
    {
        
//        UpdateFaceBook *postToFb=[[UpdateFaceBook alloc]init];
//
//        [postToFb postToFaceBook:messageTextView.text ];
//
//        postToFb=nil;
        
        [postToSocialSiteSubview setHidden:NO];
        
    }
    
    else
    {
        
//        [self openSession:NO];
        
    }

}


- (IBAction)postToFBTimeLine:(id)sender
{
//    activityIndicatorSubView.hidden=NO;
//    postToFBTimelineButton.hidden=YES;
//    
//    if ([FBSession.activeSession.permissions indexOfObject:@"publish_stream"] ==
//        NSNotFound)
//    {
//        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_stream"]
//                        defaultAudience:FBSessionDefaultAudienceFriends
//                        completionHandler:^(FBSession *session, NSError *error)
//         {
//             if (!error)
//             {
//                 // re-call assuming we now have the permission
//                 NSLog(@"RECALL");
//                 [self postToFBTimeLine:sender];
//             }
//             
//         }];
//        
//    }
//    
//    
//    else
//    {
//        
//        [self postOpenGraphAction];
//    }
//
    
    
        UpdateFaceBook *postToFb=[[UpdateFaceBook alloc]init];

        [postToFb postToFaceBook:messageTextView.text ];

        postToFb=nil;

    
}


- (void)postOpenGraphAction
{
    /*
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:fbTextMessage.text forKey:@"message"];
    
    [FBRequestConnection  startForPostWithGraphPath:@"me/feed"
                                       graphObject:[NSDictionary dictionaryWithDictionary:params]
                                 completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (!error)
         {
             [[[UIAlertView alloc] initWithTitle:@"Result"
                                         message:@"Your update has been posted to Facebook!"
                                        delegate:self
                               cancelButtonTitle:@"Sweet!"
                               otherButtonTitles:nil] show];
             
             postToSocialSiteSubview.hidden=YES;
             activityIndicatorSubView.hidden=YES;
         }
         
         else
         {
             postToFBTimelineButton.hidden=NO;
             [[[UIAlertView alloc] initWithTitle:@"Error"
                                         message:@"Yikes! Facebook had an error.  Please try again!"
                                        delegate:nil
                               cancelButtonTitle:@"Ok"
                               otherButtonTitles:nil] show];
             
             activityIndicatorSubView.hidden=YES;
             NSLog(@"code:%d",error.code);
         }
     }
     ];
     */
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [self dismissModalViewControllerAnimated:YES];
    
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    
    [self dismissModalViewControllerAnimated:YES];
    
}


- (IBAction)returnKeyBoard:(id)sender
{
    
    [[self view] endEditing:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [self setMessageTextView:nil];
    [self setMessageDate:nil];
    [self setDateLabel:nil];
    [self setBgLabel:nil];
    postToSocialSiteSubview = nil;
    fbTextMessage = nil;
    activityIndicatorSubView = nil;
    postToFBTimelineButton = nil;
    messageDescriptionScrollView = nil;
    messageTitleLabel = nil;
    [super viewDidUnload];
}


-(void)viewDidDisappear:(BOOL)animated
{
    
}

@end
