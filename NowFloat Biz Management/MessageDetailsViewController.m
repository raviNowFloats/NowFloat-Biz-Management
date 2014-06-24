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


#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 25.0f

@implementation MessageDetailsViewController
@synthesize messageDate,messageDescription,messageTextView,messageId;
@synthesize dateLabel;
@synthesize selectItemCallback = _selectItemCallback;
@synthesize dealImageUri;
@synthesize currentRow;
@synthesize delegate;
@synthesize rawMessageDate;
@synthesize bgLabel=_bgLabel;
@synthesize messageTextLbl=_messageTextLbl;

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
    
    version = [[UIDevice currentDevice] systemVersion];

    
    //Create NavBar here

    if (version.floatValue<7.0)
    {
               
        UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [backButton setImage:buttonImage forState:UIControlStateNormal];
        
        backButton.frame = CGRectMake(5,0,50,44);
        
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        self.navigationItem.leftBarButtonItem = leftBtnItem;
        
        
        customDeleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [customDeleteButton addTarget:self action:@selector(deleteFloat) forControlEvents:UIControlEventTouchUpInside];
        
        [customDeleteButton setFrame:CGRectMake(275,7,30,30)];
        
        [customDeleteButton setBackgroundImage:[UIImage imageNamed:@"trashcan.png"]  forState:UIControlStateNormal];
        
        [customDeleteButton setShowsTouchWhenHighlighted:YES];
        
        UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:customDeleteButton];
        
        //[self.navigationController.navigationBar addSubview:customDeleteButton];
        
        self.navigationItem.rightBarButtonItem= rightBarBtnItem;
    }
    
    else
    {
        customDeleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [customDeleteButton addTarget:self action:@selector(deleteFloat) forControlEvents:UIControlEventTouchUpInside];
        
        [customDeleteButton setFrame:CGRectMake(240,7,80,30)];
        
        //[customDeleteButton setBackgroundImage:[UIImage imageNamed:@"trashcan.png"]  forState:UIControlStateNormal];
        
        [customDeleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        
        [customDeleteButton setShowsTouchWhenHighlighted:YES];
        
        [self.navigationController.navigationBar addSubview:customDeleteButton];
    }
        
    fbTextMessage.text=messageDescription;//set message description on facebookSubview
/*
    [messageTextView.layer setBorderWidth:1.0];
    
    [messageTextView.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    
    [messageTextView setScrollEnabled:NO];
*/
    
    //Create the deal Image space here check for local images or URI from response
    
    NSString *_imageUriString=dealImageUri;
    
    NSString *imageUriSubString=[_imageUriString  substringToIndex:5];
   
    NSString *stringData;

    if ([dealImageUri isEqualToString:@"/Deals/Tile/deal.png"] )
    {

        stringData = [NSString stringWithFormat:@"%@",messageDescription];

    }
    
    else if ( [dealImageUri isEqualToString:@"/BizImages/Tile/.jpg" ])
    {
        stringData = [NSString stringWithFormat:@"%@",messageDescription];
    }
    
    else if ([imageUriSubString isEqualToString:@"local"])
    {
        stringData = [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@",messageDescription];
        
        UIImageView *dealImageView=[[UIImageView alloc]initWithFrame:CGRectMake(11, _bgLabel.frame.origin.y-5, 260, 260)];
        
        NSString *imageStringUrl=[NSString stringWithFormat:@"%@",[dealImageUri substringFromIndex:5]];
        
        [dealImageView setBackgroundColor:[UIColor clearColor]];
        
        [dealImageView setImage:[UIImage imageWithContentsOfFile:imageStringUrl]];
        
        [dealImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [_bgLabel addSubview:dealImageView];
    }
    
    else
    {
        stringData = [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@",messageDescription];
        
        UIImageView *dealImageView=[[UIImageView alloc]initWithFrame:CGRectMake(11, _bgLabel.frame.origin.y-5, 260, 260)];
        
        NSString *imageStringUrl=[NSString stringWithFormat:@"%@%@",appDelegate.apiUri,dealImageUri];
        
        [dealImageView setImageWithURL:[NSURL URLWithString:imageStringUrl]];
        
        [dealImageView setBackgroundColor:[UIColor clearColor]];
        
        [dealImageView setContentMode:UIViewContentModeScaleAspectFit];

        [_bgLabel addSubview:dealImageView];
    }
    
    
    
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]  constrainedToSize:constraint lineBreakMode:nil];
    
    [_messageTextLbl setNumberOfLines:0];
    
    [_messageTextLbl setText:stringData];
    
    if (version.floatValue<7.0)
    {
        [_messageTextLbl setFrame:CGRectMake(30,20,262, MAX(size.height, 44.0f)+5)];
    }

    else{
        [_messageTextLbl setFrame:CGRectMake(30,20,262, MAX(size.height, 44.0f)+5)];
    }
    
    _messageTextLbl.textColor=[UIColor colorWithHexString:@"3c3c3c"];

    [_bgLabel setFrame:CGRectMake(20,10,282, MAX(size.height,20.0f)+130)];
        
    [_bgLabel.layer setCornerRadius:6.0 ];
    
    [_bgLabel.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    
    [_bgLabel.layer setBorderWidth:1.0];
    
    [dateLabel setFrame:CGRectMake(30,_messageTextLbl.frame.size.height+20, 262, 30)];

    
    NSDate *messageDay = rawMessageDate;
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"EEEE"]; // day, like "Saturday"
    NSString *dayOfWeek = [myFormatter stringFromDate:messageDay];
    
    
    NSDate *timingMsg=rawMessageDate;
    NSDateFormatter *timingFormatter=[[NSDateFormatter alloc]init];
    [timingFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *timeOfUpdate=[timingFormatter stringFromDate:timingMsg];

    [dateLabel setText:[NSString stringWithFormat:@"%@  |  %@  |  %@",dayOfWeek,messageDate,timeOfUpdate]];
    
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *applineImageView;

    applineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,_messageTextLbl.frame.size.height+45, 282, 11)];

    [applineImageView setImage:[UIImage imageNamed:@"appline.png"]];
    
    [_bgLabel addSubview:applineImageView];
    
    
    tagLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,_messageTextLbl.frame.size.height+56, 262,50)];
    
    [tagLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    
    [tagLabel setNumberOfLines:0];
    
    [tagLabel setTextColor:[UIColor colorWithHexString:@"3c3c3c"]];
    
    [tagLabel setBackgroundColor:[UIColor clearColor]];
    
    [_bgLabel addSubview:tagLabel];

    av =[[UIActivityIndicatorView alloc]
         initWithFrame:CGRectMake(130,_messageTextLbl.frame.size.height+90, 20.0f, 20.0f)];
    
    [av setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    [av startAnimating];
    
    [av setHidesWhenStopped:YES];
    
    [_bgLabel addSubview:av];
    
    
    
    //Get Float Keywords ...
    
    GetBizFloatDetails *getDetails=[[GetBizFloatDetails  alloc]init];
    
    getDetails.delegate=self;
    
    [getDetails getBizfloatDetails:messageId];
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            if (_bgLabel.frame.size.height>=300)//ios7
            {
                messageDescriptionScrollView.contentSize=CGSizeMake(self.view.frame.size.width,_bgLabel.frame.size.height+_bgLabel.frame.size.height/4);
            }

        }
        
        
        else
        {
            if (_bgLabel.frame.size.height>=480)//ios7
            {
                messageDescriptionScrollView.contentSize=CGSizeMake(self.view.frame.size.width,_bgLabel.frame.size.height+_bgLabel.frame.size.height/15);
            }
        }

    }
    


/*
    if ([dealImageUri isEqualToString:@"/Deals/Tile/deal.png"] )
    {

        messageTextView.text=messageDescription;//set message description

        [messageTextView sizeToFit];
        
        [messageTextView layoutIfNeeded];
    }
    
    
    else if ( [dealImageUri isEqualToString:@"/BizImages/Tile/.jpg" ])
        
    {
        messageTextView.text=messageDescription;//set message description

        [messageTextView sizeToFit];
        
        [messageTextView layoutIfNeeded];

    }
    
    else if ([imageUriSubString isEqualToString:@"local"])
    {
        
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


        if ([version floatValue]<7.0)
        {
            
            
            messageTextView.text=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@",messageDescription];//set message description
            
        }
        
        else
        {
            messageTextView.text=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@",messageDescription];//set message description
        }
        
        
    }

        
    
    //Set the messageTextView height based on the content height
    
    
    messageTextView.textColor=[UIColor colorWithHexString:@"3c3c3c"];
    
    
    if ([version floatValue]<7.0)
    {

    CGRect frame1 = messageTextView.frame;
    
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
    
    CGRect rect=[messageTextView.text
                 boundingRectWithSize:CGSizeMake(width1,height1)
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
        
        [dealImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [messageTextView addSubview:dealImageView];
        
        messageTextView.text=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@\n\n\n",messageDescription];

        
    }
    
    else
    {
        [messageTitleLabel setFrame:CGRectMake(8, messageTextView.frame.origin.y+265, 250, 21)];        
        
        UIImageView *dealImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, messageTextView.frame.origin.y-5, 252, 250)];
        
        NSString *imageStringUrl=[NSString stringWithFormat:@"%@%@",appDelegate.apiUri,dealImageUri];
        
        [dealImageView setImageWithURL:[NSURL URLWithString:imageStringUrl]];
        
        [dealImageView setBackgroundColor:[UIColor clearColor]];
        
        [dealImageView setContentMode:UIViewContentModeScaleAspectFit];
        
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
            if (messageTextView.frame.size.height>300)
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
    
    
    //Get Float Keywords ...
    
    GetBizFloatDetails *getDetails=[[GetBizFloatDetails  alloc]init];
    
    getDetails.delegate=self;
    
    [getDetails getBizfloatDetails:messageId];
    */
    

}


-(void)back
{
    if ([customDeleteButton isDescendantOfView:
         self.navigationController.navigationBar])
    {
        [customDeleteButton removeFromSuperview];
    }
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Back from view details"];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)getKeyWords:(NSDictionary *)responseDictionary
{
    
    if ([[responseDictionary objectForKey:@"targetFloat"] objectForKey:@"_keywords"]==[NSNull null])
    {
        tagLabel.text=@"";
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

        if (keywordMutableString.length>80) {
            
            [tagLabel setFont:[UIFont fontWithName:@"Helvetica" size:9.0]];
        }
        
        tagLabel.text=keywordMutableString;

        
    }
    
 
    else
    {
    
        [av stopAnimating];
        
        tagLabel.text=@"";
    
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
    if ([customDeleteButton isDescendantOfView:
         self.navigationController.navigationBar])
    {
        [customDeleteButton removeFromSuperview];
    }
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


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
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


-(void)connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    
    [activityIndicatorSubView setHidden:YES];
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
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
    
}


- (void)postOpenGraphAction
{

}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
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


-(void)viewWillDisappear:(BOOL)animated
{
    [customDeleteButton setHidden:YES];
}

@end
