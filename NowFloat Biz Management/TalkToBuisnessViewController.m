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
#import "UIColor+HexaString.h"
#import "GetUserMessage.h"
#import "NSString+CamelCase.h"


@interface TalkToBuisnessViewController ()<updateInboxDelegate>
{

    GetUserMessage *userMsgController;

}
@end


#define FONT_SIZE 12.0f
#define CELL_CONTENT_WIDTH 290.0f
#define CELL_CONTENT_MARGIN 20.0f


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
    
    userMsgController.delegate=self;
    
    /*Design a custom navigation bar here*/
    
    self.navigationController.navigationBarHidden=YES;
    
    CGFloat width = self.view.frame.size.width;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:
                               CGRectMake(0,0,width,44)];
    
    [self.view addSubview:navBar];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(113, 13, 90, 20)];
    
    headerLabel.text=@"Inbox";
    
    headerLabel.backgroundColor=[UIColor clearColor];
    
    headerLabel.textAlignment=NSTextAlignmentCenter;
    
    headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
    
    headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
    
    [navBar addSubview:headerLabel];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;
    
    UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
    
    [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
    
    [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:leftCustomButton];
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];

    //Set the RightRevealWidth 0
    revealController.rightViewRevealWidth=0;
    revealController.rightViewRevealOverdraw=0;

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
        
        NSString *urlString=[NSString stringWithFormat:@"%@/usermessages/%@?clientId=%@",appDelegate.apiWithFloatsUri,[userDetails objectForKey:@"userFpId"],appDelegate.clientId];
        
        NSURL *userMessageUrl=[NSURL URLWithString:urlString];
        
        [userMsgController fetchUserMessages:userMessageUrl];
        
        
        
    }
    
    
    [[NSNotificationCenter defaultCenter]
                                         addObserver:self
                                         selector:@selector(updateView)
                                         name:@"updateUserMessage" object:nil];

    
    [activitySubview setHidden:YES];
    

}


-(void)downloadFinished
{

    [self updateView];
    
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
    
        UIImageView *backgroundLabel=[[UIImageView alloc]initWithFrame:CGRectZero];
        backgroundLabel.tag=1;
        [cell addSubview:backgroundLabel];
        
    
        UIImageView *inboxMarkerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(38,30, 10, 10)];
        inboxMarkerImageView.image=[UIImage imageNamed:@"markerinbox.png"];
        [cell addSubview:inboxMarkerImageView];

        
        UIImageView *leftImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        [leftImageView setTag:10];
        [cell addSubview:leftImageView];
        
        
        
        UIImageView *centerImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        [centerImageView setTag:11];
        [cell addSubview:centerImageView];
        
        
        
        UIImageView *rightImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        [rightImageView setImage:[UIImage imageNamed:@"userBgright.png"]];
        [rightImageView setTag:12];
        [cell addSubview:rightImageView];
        
        
        UILabel *messageLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        messageLabel.tag=2;
        [messageLabel setLineBreakMode:UILineBreakModeWordWrap];
        [messageLabel setNumberOfLines:0];
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:messageLabel];
        
        UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,80+20, 259, 25)];
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

        UIImageView *msgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(33,12, 13,13)];
        [msgImageView setImage:[UIImage imageNamed:@"user.png"]];
        [cell   addSubview:msgImageView];
        
        
        
        UILabel *messageHeaderLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        [messageHeaderLabel setTag:4];
        [messageHeaderLabel setTextAlignment:NSTextAlignmentCenter];
        [messageHeaderLabel setTextColor:[UIColor whiteColor]];
        [messageHeaderLabel setBackgroundColor:[UIColor clearColor ]];
        [cell addSubview:messageHeaderLabel];
        
        
        
                
    }
    
    
    
    
    NSString *text = [messageArray objectAtIndex:[indexPath row]];
    
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
    
    [dateFormatter setDateFormat:@"dd MMMM, yyyy"];
    
    NSString *dealDate=[dateFormatter stringFromDate:date];
    
    
    NSString *contentString=[NSString stringWithFormat:@"%@\n%@",dealDate,text];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [contentString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];


   

    UIImageView *topImgView=(UIImageView *)[cell viewWithTag:8];
    [topImgView setImage:[UIImage imageNamed:@"top_cell.png"]];
    [topImgView setFrame:CGRectMake(20,40,280,5)];
    
    
    UIImageView *bgLabel=(UIImageView *)[cell viewWithTag:1];
    [bgLabel setImage:[UIImage imageNamed:@"middle_cell.png"]];
    [bgLabel  setFrame:CGRectMake(20,45,280, MAX(size.height+40,80.0f))];
    
    
    UIImageView *bottomImgView=(UIImageView *)[cell viewWithTag:9];
    [bottomImgView setImage:[UIImage imageNamed:@"bottom_cell.png"]];
    [bottomImgView setFrame:CGRectMake(20,bgLabel.frame.size.height+45, 280,5)];

    UILabel *msgLabel=(UILabel *)[cell viewWithTag:2];
    msgLabel.text=[messageArray objectAtIndex:[indexPath row]];
    msgLabel.textColor=[UIColor colorWithHexString:@"5b5b5b"];
    [msgLabel setFrame:CGRectMake(35,bgLabel.frame.origin.y, (CELL_CONTENT_WIDTH) - (CELL_CONTENT_MARGIN * 2), MAX(size.height,44.0f))];
    [msgLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    
    UILabel *dateLbl=(UILabel *)[cell viewWithTag:3];
    dateLbl.text=dealDate;
    [dateLbl setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [dateLbl setTextColor:[UIColor colorWithHexString:@"9c9b9b"]];
    [dateLbl setFrame:CGRectMake(35,msgLabel.frame.size.height+60,245,20)];
    [dateLbl setTextAlignment:NSTextAlignmentLeft];
    
        
    NSString *contact=[appDelegate.userMessageContactArray objectAtIndex:[indexPath row]];
    
    
    if ([self seeIfString:contact ContainsThis:@"@"])
    {
        UIImageView *userlBg=(UIImageView *)[cell viewWithTag:10];
        [userlBg setFrame:CGRectMake(20,10,2,20)];
        userlBg.image=[UIImage imageNamed:@"userBgleft.png"];
        
        
        UIImageView *userCBg=(UIImageView *)[cell viewWithTag:11];
        [userCBg setFrame:CGRectMake(22, 10,180, 20)];
        userCBg.image=[UIImage imageNamed:@"userbgmiddle.png"];
        
        UIImageView *userRbg=(UIImageView *)[cell viewWithTag:12];
        [userRbg setFrame: CGRectMake(202, 10, 2, 20)];
        userRbg.image=[UIImage imageNamed:@"userBgright"];
        

        UILabel *msgHeadingLbl=(UILabel *)[cell viewWithTag:4];
        msgHeadingLbl.text=[messageHeadingArray objectAtIndex:[indexPath row]];
        [msgHeadingLbl setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [msgHeadingLbl setFrame:CGRectMake(24,7,200, 25)];

    }
    
    else
    {
        UILabel *msgHeadingLbl=(UILabel *)[cell viewWithTag:4];
        msgHeadingLbl.text=[messageHeadingArray objectAtIndex:[indexPath row]];
        [msgHeadingLbl setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [msgHeadingLbl setFrame:CGRectMake(15,7,170, 25)];
        
        UIImageView *userlBg=(UIImageView *)[cell viewWithTag:10];
        [userlBg setFrame:CGRectMake(20,10,2,20)];
        userlBg.image=[UIImage imageNamed:@"userBgleft.png"];
        
        
        UIImageView *userCBg=(UIImageView *)[cell viewWithTag:11];
        [userCBg setFrame:CGRectMake(22, 10, 150, 20)];
        userCBg.image=[UIImage imageNamed:@"userbgmiddle.png"];
        
        UIImageView *userRbg=(UIImageView *)[cell viewWithTag:12];
        [userRbg setFrame: CGRectMake(172, 10, 2, 20)];
        userRbg.image=[UIImage imageNamed:@"userBgright"];
    
    }
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *text = [messageArray objectAtIndex:[indexPath row]];
        
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
    
    
    NSString *contentString=[NSString stringWithFormat:@"\n\n%@\n\n\n%@",dealDate,text];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [contentString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);

    
}



#pragma UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{

    
    NSString *contact=[appDelegate.userMessageContactArray objectAtIndex:[indexPath row]];
    
    if ([self seeIfString:contact ContainsThis:@"@"])
    {
        
        UIAlertView *emailAlert=[[UIAlertView alloc]initWithTitle:nil message:@"Would you like to reply to this message ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        emailAlert.tag=1;
        
        contactEmail=[appDelegate.userMessageContactArray objectAtIndex:[indexPath row]];
        
        [emailAlert show];
        
        emailAlert=nil;
            
    }
    
    
    else
    {
    
        UIAlertView *callAlert=[[UIAlertView alloc]initWithTitle:nil message:@"Phone" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call",@"SMS", nil];
        
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
            [mail setSubject:[NSString stringWithFormat:@"From %@",[[appDelegate.businessName lowercaseString] stringByConvertingCamelCaseToCapitalizedWords]]];
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
    
    NSString *urlString=[NSString stringWithFormat:@"%@/usermessages/%@?clientId=%@",appDelegate.apiWithFloatsUri,[userDetails objectForKey:@"userFpId"],appDelegate.clientId];

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

#pragma SWRevealViewControllerDelegate


- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position
{
    NSString *str = nil;
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    else if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    else if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    else if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    
    else if ( position == FrontViewPositionLeftSide ) str = @"FrontViewPositionLeftSide";
    
    else if ( position == FrontViewPositionLeftSideMostRemoved ) str = @"FrontViewPositionLeftSideMostRemoved";
    
    return str;
}


- (IBAction)revealFrontController:(id)sender
{
    
    SWRevealViewController *revealController = [self revealViewController];
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeftSide"]) {
        
        [revealController performSelector:@selector(rightRevealToggle:)];
        
    }
    
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"]) {
        
        [revealController performSelector:@selector(revealToggle:)];
        
    }
    
}



- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position;
{
    
    frontViewPosition=[self stringFromFrontViewPosition:position];
    
    //FrontViewPositionLeft
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeftSide"])
    {
        
        [revealFrontControllerButton setHidden:NO];
        
    }
    
    //FrontViewPositionCenter
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeft"]) {
        
        [revealFrontControllerButton setHidden:YES];
        
    }
    
    //FrontViewPositionRight
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"]) {
        
        [revealFrontControllerButton setHidden:NO];
        
    }
    
    
    
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


-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}
@end
