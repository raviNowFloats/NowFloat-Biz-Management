//
//  BizMessageViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 26/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BizMessageViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UITableView+ZGParallelView.h"
#import "UIColor+HexaString.h"
#import "MessageDetailsViewController.h"
#import "MasterController.h"    



@interface BizMessageViewController ()

@end


#define CELL_CONTENT_WIDTH 245.0f
#define CELL_CONTENT_MARGIN 10.0f
#define kBackGroudQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)


@implementation BizMessageViewController

@synthesize parallax,messageTableView,storeDetailDictionary,dealDescriptionArray,dealDateArray;

@synthesize dealDateString,dealDescriptionString,dealIdString;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self)
    {

    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userDetails=[NSUserDefaults standardUserDefaults];
    
    
        
    [messageTableView setScrollsToTop:YES];
    
    
    
    /*FP messages initialization*/
    
    dealDescriptionArray=[[NSMutableArray alloc]init];
    dealDateArray=[[NSMutableArray   alloc]init];
    dealId=[[NSMutableArray alloc]init];
    arrayToSkipMessage=[[NSMutableArray alloc]init];
    
    dealIdString=[[NSMutableString alloc]init];
    dealDescriptionString=[[NSMutableString alloc]init];
    dealDateString=[[NSMutableString alloc]init];
    
    
    

    /*Create an AppDelegate object*/
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [parallax setFrame:CGRectMake(0, 0, 320, 250)];

//    self.title=[NSString stringWithFormat:@"%@",[[appDelegate.storeDetailDictionary objectForKey:@"Tag"]lowercaseString ]];
    
    self.title=@"NowFloats";
    
    self.navigationController.navigationBarHidden=NO;
    
    SWRevealViewController *revealController = [self revealViewController];
        
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:revealController action:@selector(revealToggle:)];
    
    
     self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    /*Post Message Controller*/
    
    postMessageController=[[PostMessageViewController alloc]initWithNibName:@"PostMessageViewController" bundle:nil];
    
    /*SelectMessageController*/
    
    selectMsgTypeController=[[SelectMessageViewController alloc]initWithNibName:@"SelectMessageViewController" bundle:nil];
    
    
    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"plus.png"]
                        style:UIBarButtonItemStyleBordered
                        target:self
                        action:@selector(pushPostMessageController)];
    
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;

    [self.messageTableView addParallelViewWithUIView:self.parallax withDisplayRadio:0.7 cutOffAtMax:YES];
    
    fpMessageDictionary=[[NSMutableDictionary alloc]initWithDictionary:appDelegate.fpDetailDictionary];
    
    ismoreFloatsAvailable=[[fpMessageDictionary objectForKey:@"moreFloatsAvailable"] boolValue];
    

    /*set the array*/
    
    [dealDescriptionArray addObjectsFromArray:appDelegate.dealDescriptionArray];
    [dealDateArray addObjectsFromArray:appDelegate.dealDateArray];
    [dealId addObjectsFromArray:appDelegate.dealId];
    [arrayToSkipMessage addObjectsFromArray:appDelegate.arrayToSkipMessage];
    
    
        
    /*Set the initial skip by value here*/
    
    messageSkipCount=[arrayToSkipMessage count];

    [self setFooterForTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateView) name:@"updateMessages" object:nil];

    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    
    /*Set the downloadingSubview hidden*/
    
    [downloadingSubview setHidden:YES];
    
    
    
    /*Set the store tag*/
    
    [storeTagLabel setTextColor:[UIColor colorWithHexString:@"222222"]];
    
    [storeTagLabel setBackgroundColor:[UIColor colorWithHexString:@"FFC805"]];
    
    [storeTitleLabel setText:[NSString stringWithFormat:@"%@",appDelegate.businessName]];
    

}

- (void)updateView

{
    
    [downloadingSubview setHidden:YES];

    [messageTableView reloadData];
    
}

-(void)pushPostMessageController
{

    [self.navigationController pushViewController:postMessageController animated:YES];
    

}

#pragma UITableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return [dealDescriptionArray count ];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    static  NSString *identifier = @"TableViewCell";
    UILabel *label = nil;
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
        UIImageView *imageViewArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewArrow setTag:6];
        [imageViewArrow   setBackgroundColor:[UIColor clearColor] ];
        [cell addSubview:imageViewArrow];

        
        UILabel *imageViewBg = [[UILabel alloc] initWithFrame:CGRectZero];
        [imageViewBg setTag:2];
//        [imageViewBg.layer setCornerRadius:6];
        [imageViewBg   setBackgroundColor:[UIColor clearColor] ];
        [cell addSubview:imageViewBg];

        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:UILineBreakModeWordWrap];
        [label setMinimumFontSize:14];
        [label setNumberOfLines:0];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
        [label setTag:1];
        [cell addSubview:label];
        
        UILabel *dealDateLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        [dealDateLabel setBackgroundColor:[UIColor clearColor]];
        [dealDateLabel setTag:4];
        [cell addSubview:dealDateLabel];
        
        UIImageView *dealImage=[[UIImageView alloc]initWithFrame:CGRectZero];
        [dealImage setTag:7];
        [cell addSubview:dealImage];


    }
        
    NSString *dateString=[dealDateArray objectAtIndex:[indexPath row] ];
    NSDate *date;
    
    
    if ([dateString hasPrefix:@"/Date("])
    {
        dateString=[dateString substringFromIndex:5];
        dateString=[dateString substringToIndex:[dateString length]-1];
        date=[self getDateFromJSON:dateString];
        
    }    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];    
    [dateFormatter setDateFormat:@"dd MMMM,yyyy"];
    
    NSString *dealDate=[dateFormatter stringFromDate:date];
    
    NSString *text = [dealDescriptionArray objectAtIndex:[indexPath row]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];

    
    label = (UILabel*)[cell viewWithTag:1];
    [label setText:text];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFrame:CGRectMake(66,18, (CELL_CONTENT_WIDTH+10) - (CELL_CONTENT_MARGIN * 2), MAX(size.height,44.0f))];//it was changed from 44


    UILabel *bgImageView=(UILabel *)[cell viewWithTag:2];
    [bgImageView setBackgroundColor:[UIColor whiteColor]];
    [bgImageView  setFrame:CGRectMake(53,CELL_CONTENT_MARGIN,255, MAX(size.height+40,80.0f))];

    
    UIImageView *bgArrowView=(UIImageView *)[cell viewWithTag:6];
    bgArrowView.image=[UIImage imageNamed:@"triangle.png"];
    [bgArrowView setFrame:CGRectMake(38,bgImageView.frame.size.height/2-7, 25, 25)];
    
    
    UILabel *dateLabel=(UILabel *)[cell viewWithTag:4];
    [dateLabel setText:dealDate];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setFrame:CGRectMake(66,label.frame.size.height+20,245,20)];
    [dateLabel setTextAlignment:NSTextAlignmentLeft];
    [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:10]];
    [dateLabel setAlpha:0.4];
    
    
    UIImageView *dealImageView=(UIImageView *)[cell viewWithTag:7];
    [dealImageView setImage:[UIImage imageNamed:@"qoutes.png"]];
    [dealImageView setFrame:CGRectMake(5,bgImageView.frame.size.height/2-10, 30,30)];
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
    
}



#pragma UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{

    MessageDetailsViewController *messageDetailsController=[[MessageDetailsViewController alloc]initWithNibName:@"MessageDetailsViewController" bundle:nil];
    
    
    NSString *dateString=[dealDateArray objectAtIndex:[indexPath row]];
    NSDate *date;
    
    
    if ([dateString hasPrefix:@"/Date("])
    {
        dateString=[dateString substringFromIndex:5];
        dateString=[dateString substringToIndex:[dateString length]-1];
        date=[self getDateFromJSON:dateString];
        
    }
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PST"]];
    [dateFormatter setDateFormat:@"dd MMMM,yyyy"];
    messageDetailsController.messageDate=[dateFormatter stringFromDate:date];
    
    messageDetailsController.messageDescription=[dealDescriptionArray objectAtIndex:[indexPath row]];
    
    
//    [self.navigationController pushViewController:messageDetailsController animated:YES];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *text = [dealDescriptionArray objectAtIndex:[indexPath row]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
    
    CGFloat height = MAX(size.height,44.0f);
    
    return height + (CELL_CONTENT_MARGIN+30 * 2);
    //Do not change ,,,,Change for entire cell height
    
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

-(void)setFooterForTableView
{
    
    if (ismoreFloatsAvailable)
    {
        
        [loadMoreButton setHidden:NO];
        
        loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        loadMoreButton.frame = CGRectMake(80,0, 200, 50);
        
        loadMoreButton.backgroundColor=[UIColor clearColor];
        
        [loadMoreButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
        
        [loadMoreButton setTitle:@"Tap Here For Older Message's" forState:UIControlStateNormal];
        
        [loadMoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        [footerView addSubview:loadMoreButton];
        
        messageTableView.tableFooterView=footerView;
        
        [loadMoreButton addTarget:self action:@selector(fetchMoreMessages) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    else
    {
        [loadMoreButton setHidden:YES];
    
    }
    
   
    
}


-(void)fetchMoreMessages
{
    [downloadingSubview setHidden:NO];

    [self performSelector:@selector(fetchMessages) withObject:nil afterDelay:1];
    
}



-(void)fetchMessages
{
    [loadMoreButton setHidden:YES];
    
    
    NSString *urlString=[NSString stringWithFormat:
                         @"https://api.withfloats.com/Discover/v1/floatingPoint/bizFloats?clientId=DB96EA35A6E44C0F8FB4A6BAA94DB017C0DFBE6F9944B14AA6C3C48641B3D70&skipBy=%d&fpId=%@",messageSkipCount,[userDetails objectForKey:@"userFpId"]];
    
    NSURL *url=[NSURL URLWithString:urlString];
    
    data = [NSData dataWithContentsOfURL: url];
    
    if (data==nil)
    {
        
        [self fetchMoreMessages];
    }
    
    
    else
    {
        
        [self performSelector:@selector(downloadMessages:) withObject:data];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMessages" object:nil];
        
    }


}



-(void)downloadMessages:(NSData *)responseData
{
    NSError* error;
    NSMutableDictionary* json = [NSJSONSerialization
                                 JSONObjectWithData:responseData //1
                                 options:kNilOptions
                                 error:&error];
    
    
    for (int i=0; i<[[json objectForKey:@"floats"] count]; i++)
    {
    
        [dealDescriptionArray addObject:[[[json objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"message" ]];

        [dealDateArray addObject:[[[json objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"createdOn" ]];
        
        [dealId addObject:[[[json objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"_id" ]];
        
        [arrayToSkipMessage addObject:[[[json objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"_id" ]];
        
    }
    

    
    messageSkipCount=arrayToSkipMessage.count;
    
    
    if ([[json objectForKey:@"moreFloatsAvailable"] boolValue]==1)
    {
        [loadMoreButton setHidden:NO];
    }
    
    
    else
    {
        [loadMoreButton setHidden:YES];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [self setParallax:nil];
    [self setMessageTableView:nil];
    downloadingSubview = nil;
    storeTagLabel = nil;
    storeTitleLabel = nil;
    [super viewDidUnload];
}




@end
