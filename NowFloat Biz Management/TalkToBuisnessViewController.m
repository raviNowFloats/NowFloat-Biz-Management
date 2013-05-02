//
//  TalkToBuisnessViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 25/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "TalkToBuisnessViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface TalkToBuisnessViewController ()

@end


#define CELL_CONTENT_WIDTH 245.0f
#define CELL_CONTENT_MARGIN 10.0f


@implementation TalkToBuisnessViewController
@synthesize talkToBuisnessTableView=table_ ;
@synthesize pullToRefreshManager = pullToRefreshManager_;
@synthesize reloads = reloads_;
@synthesize mailComposeDelegate;



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
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    userDetails=[NSUserDefaults standardUserDefaults];
    
    messageArray=[[NSMutableArray alloc]init];
    messageHeadingArray=[[NSMutableArray alloc]init];
    dateArray=[[NSMutableArray alloc]init];
    userMsgController=[[GetUserMessage alloc]init];

    

    
    self.title = NSLocalizedString(@"Inbox", nil);
    
    SWRevealViewController *revealController = [self revealViewController];

    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"detail-btn.png"]
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:revealController action:@selector(revealToggle:)];

    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;

    
    
    
    
    
   /*Design pull to refresh here*/
    
    pullToRefreshManager_ = [[MNMPullToRefreshManager alloc] initWithPullToRefreshViewHeight:50.0f
                                                tableView:table_
                                                withClient:self];

    
    
    if ([appDelegate.inboxArray count])
    {
        [loadingActivityView setHidden:YES];
        [messageArray addObjectsFromArray:appDelegate.userMessagesArray];
        [dateArray addObjectsFromArray:appDelegate.userMessageDateArray];
        [messageHeadingArray addObjectsFromArray:appDelegate.userMessageContactArray];
        [table_ reloadData];
    }
    
    
    else
    {
        
        NSString *urlString=[NSString stringWithFormat:@"%@/usermessages/%@",appDelegate.apiWithFloatsUri,[userDetails objectForKey:@"userFpId"]];
        
        NSURL *userMessageUrl=[NSURL URLWithString:urlString];
        
        [userMsgController fetchUserMessages:userMessageUrl];
        
        
    }
    
    
    [[NSNotificationCenter defaultCenter]
                                         addObserver:self
                                         selector:@selector(updateView)
                                         name:@"updateUserMessage" object:nil];

    
    [activitySubview setHidden:YES];
    

}


#pragma UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{

    return messageArray.count;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *staticIdentifier=@"Identifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:staticIdentifier];
    
    if (cell==nil)
    
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:staticIdentifier];
    
        UIImageView *backgroundLabel=[[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 280, 100)];
        
        backgroundLabel.tag=1;
        [cell addSubview:backgroundLabel];
        [backgroundLabel.layer setCornerRadius:5.0 ];
        
        UILabel *underLine=[[UILabel alloc]initWithFrame:CGRectMake(30,30,259, 1)];
        [underLine setBackgroundColor:[UIColor blackColor]];
        [cell addSubview:underLine];
        
        UILabel *messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,31, 259,49)];
        messageLabel.tag=2;
        [messageLabel setLineBreakMode:UILineBreakModeWordWrap];
        [messageLabel setNumberOfLines:0];
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:messageLabel];
        
        UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,80, 259, 25)];
        dateLabel.tag=3;
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:dateLabel];
    
        UIImageView *topRoundedCorner=[[UIImageView alloc]initWithFrame:CGRectZero];
        topRoundedCorner.tag=8;
        [topRoundedCorner setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:topRoundedCorner];
        
        UIImageView *bottomRoundedCorner=[[UIImageView alloc]initWithFrame:CGRectZero];
        [bottomRoundedCorner setTag:9];
        [bottomRoundedCorner setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:bottomRoundedCorner];

        UIImageView *msgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(30,13, 15, 15)];
        
        [msgImageView setImage:[UIImage imageNamed:@"user.png"]];
        [cell   addSubview:msgImageView];
        
        
        UILabel *messageHeaderLabel=[[UILabel alloc]initWithFrame:CGRectMake(50,8, 234, 25)];
        [messageHeaderLabel setTag:4];
        [messageHeaderLabel setBackgroundColor:[UIColor clearColor ]];
        [cell addSubview:messageHeaderLabel];
                
    }
    
    
    
    
    NSString *dateString=[dateArray objectAtIndex:[indexPath row]];
    NSDate *date;
    
    
    if ([dateString hasPrefix:@"/Date("])
    {
        dateString=[dateString substringFromIndex:5];
        dateString=[dateString substringToIndex:[dateString length]-1];
        date=[self getDateFromJSON:dateString];
        
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PST"]];
    [dateFormatter setDateFormat:@"dd-MMMM, yyyy"];
    NSString *dealDate=[dateFormatter stringFromDate:date];
    
    
    
    NSString *text = [messageArray objectAtIndex:[indexPath row]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];

    UIImageView *bgLabel=(UIImageView *)[cell viewWithTag:1];
    [bgLabel setImage:[UIImage imageNamed:@"middle_cell.png"]];
    [bgLabel  setFrame:CGRectMake(20,15,280, MAX(size.height+40,80.0f))];

    UIImageView *topImgView=(UIImageView *)[cell viewWithTag:8];
    [topImgView setImage:[UIImage imageNamed:@"top_cell.png"]];
    [topImgView setFrame:CGRectMake(20,8,280,9)];
    
    UIImageView *bottomImgView=(UIImageView *)[cell viewWithTag:9];
    [bottomImgView setImage:[UIImage imageNamed:@"bottom_cell.png"]];
    [bottomImgView setFrame:CGRectMake(20,bgLabel.frame.size.height+15, 280,9)];

    UILabel *msgLabel=(UILabel *)[cell viewWithTag:2];
    msgLabel.text=[messageArray objectAtIndex:[indexPath row]];
    [msgLabel setFrame:CGRectMake(30,31, (CELL_CONTENT_WIDTH+35) - (CELL_CONTENT_MARGIN * 2), MAX(size.height,44.0f))];
    [msgLabel setBackgroundColor:[UIColor clearColor]];
    [msgLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    
    UILabel *dateLbl=(UILabel *)[cell viewWithTag:3];
    dateLbl.text=dealDate;
    [dateLbl setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [dateLbl setFrame:CGRectMake(40,msgLabel.frame.size.height+20,245,20)];
    [dateLbl setTextAlignment:NSTextAlignmentRight];
    
    UILabel *msgHeadingLbl=(UILabel *)[cell viewWithTag:4];
    msgHeadingLbl.text=[messageHeadingArray objectAtIndex:[indexPath row]];
    [msgHeadingLbl setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *text = [messageArray objectAtIndex:[indexPath row]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
    
    CGFloat height = MAX(size.height,44.0f);
    
    return height + (CELL_CONTENT_MARGIN+40 * 2);
    //Do not change ,,,,Change for entire cell height
    
}



#pragma UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{

    
    NSString *contact=[appDelegate.userMessageContactArray objectAtIndex:[indexPath row]];
    
    if ([self seeIfString:contact ContainsThis:@"@"])
    {
        
        UIAlertView *emailAlert=[[UIAlertView alloc]initWithTitle:@"Email" message:@"Are you sure to email this contact ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Email", nil];
        emailAlert.tag=1;
        contactEmail=[appDelegate.userMessageContactArray objectAtIndex:[indexPath row]];
        [emailAlert show];
        
        emailAlert=nil;
        
        
    }
    
    
    else
    {
    
        UIAlertView *callAlert=[[UIAlertView alloc]initWithTitle:@"Call" message:@"Are you sure to call this contact ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call",@"SMS", nil];
        
        contactPhoneNumber=[appDelegate.userMessageContactArray objectAtIndex:[indexPath row]];
        
        callAlert.tag=2;
        [callAlert show];
        callAlert=nil;
        
    }
    

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{

    if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
            
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            
            [mail setToRecipients:[NSArray arrayWithObject:contactEmail]];
            [mail setMessageBody:[NSString stringWithFormat:@"\n\n\n\nFrom\n%@.nowfloats.com",[[appDelegate.storeDetailDictionary objectForKey:@"Tag"] lowercaseString]] isHTML:NO];
            [self presentModalViewController:mail animated:YES];
            
        }
        
    }

    
    
    if (alertView.tag==2)
    {
        if (buttonIndex==1)
        {
            UIDevice *device = [UIDevice currentDevice];
            
            if ([[device model] isEqualToString:@"iPhone"] )
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",contactPhoneNumber]]];
            }
            
            else
            {
                UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [notPermitted show];
                
            }

        }
        
        
        
        
        if (buttonIndex==2) {
            
            MFMessageComposeViewController *pickerSMS = [[MFMessageComposeViewController alloc] init];
            
            pickerSMS.messageComposeDelegate = self;
            
            pickerSMS.recipients=[NSArray arrayWithObject:contactPhoneNumber];
            
            pickerSMS.body = [NSString stringWithFormat:@"From\n%@.nowfloats.com",[[appDelegate.storeDetailDictionary objectForKey:@"Tag"] lowercaseString]];
            
            [self presentModalViewController:pickerSMS animated:YES];

                        
        }
        
        
        
    }

}


-(BOOL)seeIfString:(NSString*)thisString ContainsThis:(NSString*)containsThis
{
    NSRange textRange = [[thisString lowercaseString] rangeOfString:[containsThis lowercaseString]];
    
    if(textRange.location != NSNotFound)
        return YES;
    
    return NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [pullToRefreshManager_ tableViewScrolled];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    [pullToRefreshManager_ tableViewReleased];
    
    
}


- (void)pullToRefreshTriggered:(MNMPullToRefreshManager *)manager
{
    reloads_++;

    [activitySubview setHidden:NO];
    
    NSString *urlString=[NSString stringWithFormat:@"%@/usermessages/%@",appDelegate.apiWithFloatsUri,[userDetails objectForKey:@"userFpId"]];

    NSURL *userMessageUrl=[NSURL URLWithString:urlString];
    
    [userMsgController fetchUserMessages:userMessageUrl];

    [self performSelector:@selector(loadTable) withObject:nil afterDelay:0.5f];
    
    
}


- (void)loadTable
{

    [table_ reloadData];
    [pullToRefreshManager_ tableViewReloadFinishedAnimated:YES];
    [loadingActivityView setHidden:YES];
    [activitySubview setHidden:YES];
}


- (NSDate*) getDateFromJSON:(NSString *)dateString
{
    // Expect date in this format "/Date(1268123281843)/"
    int startPos = [dateString rangeOfString:@"("].location+1;
    int endPos = [dateString rangeOfString:@")"].location;
    NSRange range = NSMakeRange(startPos,endPos-startPos);
    unsigned long long milliseconds = [[dateString substringWithRange:range] longLongValue];
    NSTimeInterval interval = milliseconds/1000;
    return [NSDate dateWithTimeIntervalSince1970:interval];
}


-(void)updateView
{
    [loadingActivityView setHidden:YES];

    [messageArray removeAllObjects];
    [dateArray removeAllObjects];
    [messageHeadingArray removeAllObjects];
    
    
    [messageArray addObjectsFromArray:appDelegate.userMessagesArray];
    [dateArray addObjectsFromArray:appDelegate.userMessageDateArray];
    [messageHeadingArray addObjectsFromArray:appDelegate.userMessageContactArray];

    [table_ reloadData];
    [pullToRefreshManager_ tableViewReloadFinishedAnimated:YES];

}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [self dismissModalViewControllerAnimated:YES];
    
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{


    [self dismissModalViewControllerAnimated:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [self setTalkToBuisnessTableView:nil];
    loadingActivityView = nil;
    activitySubview = nil;
    [super viewDidUnload];
}
@end
