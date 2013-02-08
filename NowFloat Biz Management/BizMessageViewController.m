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


@implementation BizMessageViewController
@synthesize parallax,messageTableView,storeDetailDictionary;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        

        

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /*Create an AppDelegate object*/
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [parallax setFrame:CGRectMake(0, 0, 320, 250)];
    
    self.title = NSLocalizedString(@"NowFloats", nil);

    self.navigationController.navigationBarHidden=NO;
    
    SWRevealViewController *revealController = [self revealViewController];
        
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:revealController action:@selector(revealToggle:)];
    
    
     self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    /*Post Message Controller*/
    
    postMessageController=[[PostMessageViewController alloc]initWithNibName:@"PostMessageViewController" bundle:nil];
    
    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus.png"]
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self     action:@selector(pushPostMessageController)];
    
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;
    

    [self.messageTableView addParallelViewWithUIView:self.parallax withDisplayRadio:0.7 cutOffAtMax:YES];

    
    /*Deals Details HardCoded*/
    
    
    dealDateArray=[[NSMutableArray alloc]initWithObjects:@"/Date(1361320140000)/",@"/Date(1359829800000)/", @"/Date(1359354062847)/",@"/Date(1358249616884)/",@"/Date(1358243329249)/",@"/Date(1359829800000)/",@"/Date(1358249616884)/",@"/Date(1358249616884)/",@"/Date(1361320140000)/",@"/Date(1361320140000)/",@"/Date(1359829800000)/",@"/Date(1361320140000)/",@"/Date(1361320140000)/",nil];
    
    dealDescriptionArray =[[NSMutableArray alloc]initWithObjects:
                           @"Enjoy 15% off on pure veg alacarte and buffets above billing amount of Rs 500. Weekday buffets ",
                           @"Exclusive Free Deal - Buy 2 Tender Grilled Chicken at Rs 86 each (contains 3pc chicken + 1 Jeera Naan) and Get 2 desserts (strawberry/mango/vanilla or chocolate) worth Rs 40 Free.",
                           @"Enjoy flat 10% off on Alacarte and Buffets.",
                           @"Enjoy 15% off on Alacarte Food and Drinks above Rs 1000. Also valid on Home Deliveries, call 040 6454 4545/ 2354 2629 Daily coupon valid for Today. Offer valid on Dine-in and Deliveries within 3 km radius. Offer cannot be clubbed with any other offer. Other restaurant restrictions may apply.",
                           @"Get 20% off on alacarte and 15% off on buffets (above Rs 1000). Daily coupon valid for Today. Offer cannot be clubbed with any other offer. Other restaurant restrictions may apply.",
                           @"Enjoy 15% off on Alacarte Food and Drinks above Rs 1000. Also valid on Home Deliveries, call 040 6454 4545/ 2354 2629 Daily coupon valid for Today. Offer valid on Dine-in and Deliveries within 3 km radius. Offer cannot be clubbed with any other offer. Other restaurant restrictions may apply.",
                           @"Hello World",
                           @"Hii",@"The best ice-cream in town -Hazel",@"Enjoy 15% off on Alacarte Food and Drinks above Rs 1000. Also valid on Home Deliveries, call 040 6454 4545/ 2354 2629 Daily coupon valid for Today. Offer valid on Dine-in and Deliveries within 3 km radius. Offer cannot be clubbed with any other offer. Other restaurant restrictions may apply.",
                           @"The best ice-cream in town -Hazel",@"Enjoy 15% off.The best ice-cream in town -Hazel",@"Enjoy 15% off on Alacarte Food and Drinks above Rs 1000.",
                           nil];
    
    
    

    
    
    
    
    
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];


}


-(void)pushPostMessageController
{

    [self.navigationController pushViewController:postMessageController animated:YES];
    

}

#pragma UITableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return dealDateArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    static  NSString *identifier = @"TableViewCell";
    UILabel *label = nil;
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        
//        UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(5,0,310, 100)];
//        [imageViewBg setTag:1];
//        [imageViewBg   setBackgroundColor:[UIColor clearColor] ];
//        [cell addSubview:imageViewBg];
        
        
//        UIImageView *messageTypeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5,10, 30, 30)];
//        [messageTypeImageView setTag:2];
//        [messageTypeImageView setBackgroundColor:[UIColor clearColor]];
//        [cell   addSubview:messageTypeImageView];
//                
//        
//        UILabel *dealDescription=[[UILabel alloc]initWithFrame:CGRectMake(60,7,243,60)];
//        [dealDescription setBackgroundColor:[UIColor clearColor]];
//        [dealDescription setNumberOfLines:2];
//        [dealDescription setTag:3];
//        [cell addSubview:dealDescription];
//        
//        
        
        
        UIImageView *imageViewArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewArrow setTag:6];
        [imageViewArrow   setBackgroundColor:[UIColor clearColor] ];
        [cell addSubview:imageViewArrow];

        
        UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewBg setTag:2];
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
    
    
//    UIImageView *bgImageView=(UIImageView *)[cell viewWithTag:1];
//    bgImageView.image=[UIImage imageNamed:@"msg_bg.png"];
//
//    UIImageView *typeImageView=(UIImageView *)[cell viewWithTag:2];
//    typeImageView.image=[UIImage imageNamed:@"qoutes.png"];
//    
//    
//    
//    UILabel *messageLabel=(UILabel *)[cell viewWithTag:3];
//    [messageLabel setText:[dealDescriptionArray objectAtIndex:[indexPath row]]];
//    [messageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
//    
//
//    UILabel *dateLabel=(UILabel *)[cell viewWithTag:4];
//    [dateLabel setText:dealDate];
//    [dateLabel setTextAlignment:NSTextAlignmentLeft];
//    [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:10]];
    
    
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
    [dateFormatter setDateFormat:@"dd-MMMM yyyy"];
    NSString *dealDate=[dateFormatter stringFromDate:date];


    
    NSString *text = [dealDescriptionArray objectAtIndex:[indexPath row]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];

    
    label = (UILabel*)[cell viewWithTag:1];
    [label setText:text];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFrame:CGRectMake(66,18, (CELL_CONTENT_WIDTH+10) - (CELL_CONTENT_MARGIN * 2), MAX(size.height,44.0f))];//it was changed from 44

    
    UIImageView *bgImageView=(UIImageView *)[cell viewWithTag:2];
    bgImageView.image=[UIImage imageNamed:@"box.png"];
    [bgImageView  setFrame:CGRectMake(53,CELL_CONTENT_MARGIN,255, MAX(size.height+40,80.0f))];
    
    
    
    UIImageView *bgArrowView=(UIImageView *)[cell viewWithTag:6];
    bgArrowView.image=[UIImage imageNamed:@"triangle.png"];
//    [bgArrowView setFrame:CGRectMake(38, CELL_CONTENT_MARGIN+12, 25, 25)];
    [bgArrowView setFrame:CGRectMake(38,bgImageView.frame.size.height/2, 25, 25)];
    
    
    UILabel *dateLabel=(UILabel *)[cell viewWithTag:4];
    [dateLabel setText:dealDate];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setFrame:CGRectMake(66,label.frame.size.height+20,245,20)];
    [dateLabel setTextAlignment:NSTextAlignmentLeft];
    [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:10]];
    [dateLabel setAlpha:0.4];
    
    
    UIImageView *dealImageView=(UIImageView *)[cell viewWithTag:7];
    [dealImageView setImage:[UIImage imageNamed:@"qoutes.png"]];
    [dealImageView setFrame:CGRectMake(5,bgImageView.frame.size.height/2-3, 30,30)];
    
    
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
    [dateFormatter setDateFormat:@"dd-MMMM yyyy"];
    messageDetailsController.messageDate=[dateFormatter stringFromDate:date];
    
    messageDetailsController.messageDescription=[dealDescriptionArray objectAtIndex:[indexPath row]];
    
    
    [self.navigationController pushViewController:messageDetailsController animated:YES];
    

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *text = [dealDescriptionArray objectAtIndex:[indexPath row]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
    
    CGFloat height = MAX(size.height,44.0f);
    
    return height + (CELL_CONTENT_MARGIN+20 * 2);
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [self setParallax:nil];
    [self setMessageTableView:nil];
    [super viewDidUnload];
}




@end
