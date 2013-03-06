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


@interface MessageDetailsViewController ()

@end

@implementation MessageDetailsViewController
@synthesize messageDate,messageDescription,messageTextView,messageId;
@synthesize dateLabel,bgLabel;
@synthesize selectItemCallback = _selectItemCallback;


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
    //[self.view setBackgroundColor:[UIColor colorWithHexString:@"CCCCCC"]];

    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    postToSocialSiteSubview.hidden=YES;
    
    activityIndicatorSubView.hidden=YES;
    
    postToFBTimelineButton.hidden=NO;

    self.navigationController.navigationBarHidden=NO;
    
    messageTextView.text=messageDescription;//set message description
    fbTextMessage.text=messageDescription;//set message description on facebookSubview
    
    /*Set the textview height based on the content height*/
    
    CGRect frame1 = messageTextView.frame;
    frame1.size.height = messageTextView.contentSize.height;
    messageTextView.frame = frame1;
    
    [dateLabel setFrame:CGRectMake(60, messageTextView.frame.size.height+18, 250,37)];
    
    CGRect frame2 = fbTextMessage.frame;
    frame2.size.height = fbTextMessage.contentSize.height;
    fbTextMessage.frame = frame2;
    
    [messageTextView.layer setCornerRadius:6];
    [fbTextMessage.layer setCornerRadius:6];
    [dateLabel.layer setCornerRadius:6];

    //Set datelabel
    [dateLabel setText:messageDate];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionStateChanged:)
                                                 name:SCSessionStateChangedNotification
                                               object:nil];
    

}

- (void)sessionStateChanged:(NSNotification*)notification
{
    
    postToSocialSiteSubview.hidden=NO;
    
}

-(void)updateMessage
{
    NSLog(@"update message");
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
    [appDelegate openSession];
}

- (IBAction)postToFBTimeLine:(id)sender
{
    activityIndicatorSubView.hidden=NO;
    postToFBTimelineButton.hidden=YES;

    if ([FBSession.activeSession.permissions indexOfObject:@"publish_stream"] ==
        NSNotFound)
    {
        
        
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_stream"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error)
         {
             if (!error)
             {
                 // re-call assuming we now have the permission
                 NSLog(@"RECALL");
                 [self postToFBTimeLine:sender];
             }
             
         }];
        
    }
    
    
    else
    {
        
        [self postOpenGraphAction];
    }

    
    
}

- (void)postOpenGraphAction
{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:fbTextMessage.text forKey:@"message"];
    
    [FBRequestConnection startForPostWithGraphPath:@"me/feed"
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
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated
{

}
@end
