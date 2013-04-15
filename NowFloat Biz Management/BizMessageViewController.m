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
#import "NSString+CamelCase.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "KGModal.h"




#define TIME_FOR_SHRINKING 0.61f
#define TIME_FOR_EXPANDING 0.60f
#define SCALED_DOWN_AMOUNT 0.01



@interface BizMessageViewController ()

@end

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 25.0f
#define kBackGroudQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)


@implementation BizMessageViewController

@synthesize parallax,messageTableView,storeDetailDictionary,dealDescriptionArray,dealDateArray,dealImageArray;

@synthesize dealDateString,dealDescriptionString,dealIdString;

@synthesize isLoadedFirstTime;

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

    /*FP messages initialization*/
    
    dealDescriptionArray=[[NSMutableArray alloc]init];
    dealDateArray=[[NSMutableArray   alloc]init];
    dealId=[[NSMutableArray alloc]init];
    dealImageArray=[[NSMutableArray alloc]init];
    arrayToSkipMessage=[[NSMutableArray alloc]init];
    
    dealIdString=[[NSMutableString alloc]init];
    dealDescriptionString=[[NSMutableString alloc]init];
    dealDateString=[[NSMutableString alloc]init];
    
    /*Create an AppDelegate object*/
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [parallax setFrame:CGRectMake(0, 0, 320, 250)];
    
    self.title=@"NowFloats";
    
    self.navigationController.navigationBarHidden=NO;
    
    SWRevealViewController *revealController = [self revealViewController];
        
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                    style:UIBarButtonItemStyleBordered
                    target:revealController action:@selector(revealToggle:)];
    
    
     self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    /*Post Message Controller*/
    
    postMessageController=[[PostMessageViewController alloc]initWithNibName:@"PostMessageViewController" bundle:nil];
    
    /*PostImageViewController*/
    
    postImageViewController=[[PostImageViewController alloc]initWithNibName:@"PostImageViewController" bundle:nil];
    
    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"plus.png"]
                        style:UIBarButtonItemStyleBordered
                        target:self
                        action:@selector(chooseMessageType)];
    
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;

    [self.messageTableView addParallelViewWithUIView:self.parallax withDisplayRadio:0.7 cutOffAtMax:YES];
    
    [self.messageTableView setScrollsToTop:YES];
    
    fpMessageDictionary=[[NSMutableDictionary alloc]initWithDictionary:appDelegate.fpDetailDictionary];
    
    ismoreFloatsAvailable=[[fpMessageDictionary objectForKey:@"moreFloatsAvailable"] boolValue];
    

    
//    if (isLoadedFirstTime)
    {
        /*set the array*/
        
        [dealDescriptionArray addObjectsFromArray:appDelegate.dealDescriptionArray];
        [dealDateArray addObjectsFromArray:appDelegate.dealDateArray];
        [dealId addObjectsFromArray:appDelegate.dealId];
        [dealImageArray addObjectsFromArray:appDelegate.dealImageArray];
        [arrayToSkipMessage addObjectsFromArray:appDelegate.arrayToSkipMessage];
        /*Set the initial skip by value here*/
        messageSkipCount=[arrayToSkipMessage count];
    }
    

    [self setFooterForTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateView) name:@"updateMessages" object:nil];

    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    
    /*Set the downloadingSubview hidden*/
    
    [downloadingSubview setHidden:YES];
        
    
    /*Set the store tag*/
    
    [storeTagLabel setTextColor:[UIColor colorWithHexString:@"222222"]];
    
    [storeTagLabel setBackgroundColor:[UIColor colorWithHexString:@"FFC805"]];
    
    [storeTitleLabel setText:[[[NSString stringWithFormat:@"%@",appDelegate.businessName] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords]];    
    
    [self.messageTableView setSeparatorColor:[UIColor colorWithHexString:@"ffb900"]];

    
}



-(void)chooseMessageType
{
    UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Post a message",@"Upload a picture", nil];
    selectAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    selectAction.tag=1;
    [selectAction showInView:self.view];

    
}



-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1)
    {
        if(buttonIndex == 0)
        {
            [self pushPostMessageController];
        }
        
        
        if (buttonIndex==1)
        {
            [self pushPostImageViewController];
        }
        
    }
    
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


-(void)pushPostImageViewController
{

    [self.navigationController pushViewController:postImageViewController animated:YES];
    
}






    





#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
            [self pushPostMessageController];
        }
        
        
        if (buttonIndex==2)
        {
            [self pushPostImageViewController];
        }
    }
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
    
    if (!cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        
        UIImageView *imageViewArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewArrow setTag:6];
        [imageViewArrow   setBackgroundColor:[UIColor clearColor] ];
        [cell addSubview:imageViewArrow];
         
        UIImageView *dealImage=[[UIImageView alloc]initWithFrame:CGRectZero];
        [dealImage setTag:7];
        [cell addSubview:dealImage];

        
        UILabel *dealDateLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        [dealDateLabel setBackgroundColor:[UIColor whiteColor]];
        [dealDateLabel setTag:4];
        [cell addSubview:dealDateLabel];
            
        UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewBg setTag:2];
        [imageViewBg   setBackgroundColor:[UIColor clearColor] ];
        [[cell contentView] addSubview:imageViewBg];

        UIImageView *topRoundedCorner=[[UIImageView alloc]initWithFrame:CGRectZero];
        [topRoundedCorner setTag:8];
        [topRoundedCorner setBackgroundColor:[UIColor clearColor]];
        [[cell contentView] addSubview:topRoundedCorner];
        
        
        UIImageView *bottomRoundedCorner=[[UIImageView alloc]initWithFrame:CGRectZero];
        [bottomRoundedCorner    setTag:9];
        [bottomRoundedCorner setBackgroundColor:[UIColor clearColor]];
        [[cell contentView] addSubview:bottomRoundedCorner];
        
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setMinimumFontSize:FONT_SIZE];
        [label setNumberOfLines:0];
        [label setFont:[UIFont fontWithName:@"Helvetica" size:FONT_SIZE]];
        [label setTag:1];
        [[cell contentView] addSubview:label];
        
        
        UIImageView *dealImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        [dealImageView setTag:3];
        [dealImageView setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:dealImageView];
        
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
    [dateFormatter setDateFormat:@"dd MMMM, yyyy"];
    
    NSString *dealDate=[dateFormatter stringFromDate:date];
    
    NSString *text = [dealDescriptionArray objectAtIndex:[indexPath row]];
    
    NSString *stringData;

    if ([[dealImageArray objectAtIndex:[indexPath row]] isEqualToString:@"/Deals/Tile/deal.png"])
    {
        stringData=[NSString stringWithFormat:@"%@\n\n%@\n",text,dealDate];
    }
    
    
    else if ( [[dealImageArray objectAtIndex:[indexPath row]]isEqualToString:@"/BizImages/Tile/.jpg" ])
    {
    
        stringData=[NSString stringWithFormat:@"%@\n\n%@\n",text,dealDate];

    }
    
    else
    {
        
    stringData=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n%@\n\n%@\n",text,dealDate];   
    }
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]  constrainedToSize:constraint lineBreakMode:nil];

    UIImageView *storeDealImageView=(UIImageView *)[cell viewWithTag:3];

    
    NSString *_imageUriString=[dealImageArray  objectAtIndex:[indexPath row]];
    
    NSString *imageUriSubString=[_imageUriString  substringToIndex:5];
    
    if ([[dealImageArray objectAtIndex:[indexPath row]] isEqualToString:@"/Deals/Tile/deal.png"] )
    {
        [storeDealImageView setFrame:CGRectMake(50,20,254,0)];
        [storeDealImageView setBackgroundColor:[UIColor redColor]];

    }
    
    
    else if ( [[dealImageArray objectAtIndex:[indexPath row]]isEqualToString:@"/BizImages/Tile/.jpg" ])
        
    {
    
        [storeDealImageView setFrame:CGRectMake(50,20,254,0)];
        [storeDealImageView setBackgroundColor:[UIColor redColor]];
            
    }
    
    else if ([imageUriSubString isEqualToString:@"local"])
    {

        NSString *imageStringUrl=[NSString stringWithFormat:@"%@",[appDelegate.localImageUri substringFromIndex:5]];
        [storeDealImageView setFrame:CGRectMake(50,24,254,196)];
        [storeDealImageView setBackgroundColor:[UIColor clearColor]];
        storeDealImageView.image=[UIImage imageWithContentsOfFile:imageStringUrl];
        
    }
    
    else
    {
        NSString *imageStringUrl=[NSString stringWithFormat:@"%@%@",appDelegate.apiUri,[dealImageArray objectAtIndex:[indexPath row]]];
        [storeDealImageView setFrame:CGRectMake(50,24,254,196)];
        [storeDealImageView setBackgroundColor:[UIColor clearColor]];
        [storeDealImageView setImageWithURL:[NSURL URLWithString:imageStringUrl]];
    }
    
    
    

    
    
    if (!label)
    label = (UILabel*)[cell viewWithTag:1];
    UIImageView *topImage=(UIImageView *)[cell viewWithTag:8];
    UIImageView *bottomImage=(UIImageView *)[cell viewWithTag:9];
    UIImageView *bgImage=(UIImageView *)[cell viewWithTag:2];
    UILabel *dateLabel=(UILabel *)[cell viewWithTag:4];
    UIImageView *dealImageView=(UIImageView *)[cell viewWithTag:7];
    UIImageView *bgArrowView=(UIImageView *)[cell viewWithTag:6];    
    


    [label setText:stringData];
    [label setFrame:CGRectMake(50,CELL_CONTENT_MARGIN,254, MAX(size.height, 44.0f))];
    [label setBackgroundColor:[UIColor clearColor]];

    [dateLabel setText:dealDate];
    [dateLabel setBackgroundColor:[UIColor whiteColor]];
    [dateLabel setFrame:CGRectMake(50,label.frame.size.height,245,30)];
    [dateLabel setTextAlignment:NSTextAlignmentLeft];
    [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:10]];
    [dateLabel setAlpha:1];
    
    [topImage setFrame:CGRectMake(42,CELL_CONTENT_MARGIN-10, 269,10)];
    [topImage setImage:[UIImage imageNamed:@"top_cell.png"]];
    
    [bottomImage setFrame:CGRectMake(42, MAX(size.height, 44.0f)+20, 269, 10)];
    [bottomImage setImage:[UIImage imageNamed:@"bottom_cell.png"]];
    
    [bgImage setFrame:CGRectMake(42,CELL_CONTENT_MARGIN,269, MAX(size.height, 44.0f))];
    [bgImage setImage:[UIImage imageNamed:@"middle_cell.png"]];
    
    [dealImageView setImage:[UIImage imageNamed:@"qoutes.png"]];
    [dealImageView setFrame:CGRectMake(5,bgImage.frame.size.height/2-10,25,25)];
    
    bgArrowView.image=[UIImage imageNamed:@"triangle.png"];
    [bgArrowView setFrame:CGRectMake(30,bgImage.frame.size.height/2-4,12,12)];

    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;


}



#pragma UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
/*
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
    [dateFormatter setDateFormat:@"dd MMMM, yyyy"];
    
    messageDetailsController.messageDate=[dateFormatter stringFromDate:date];
    
    messageDetailsController.messageDescription=[dealDescriptionArray objectAtIndex:[indexPath row]];
    
    messageDetailsController.messageId=[dealId objectAtIndex:[indexPath row]];
    
    
    [self.navigationController pushViewController:messageDetailsController animated:YES];
*/    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
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
    [dateFormatter setDateFormat:@"dd MMMM, yyyy"];
    
    NSString *dealDate=[dateFormatter stringFromDate:date];
    
    /**
    Create a substring and check for the first 5 Chars to Local for a newly uploaded
    image to set the height for the particular cell
    **/
    NSString *_imageUriString=[dealImageArray  objectAtIndex:[indexPath row]];
    
    NSString *imageUriSubString=[_imageUriString  substringToIndex:5];
    
    
    if ([[dealImageArray objectAtIndex:[indexPath row]]isEqualToString:@"/Deals/Tile/deal.png" ] )
    {
        NSString *stringData=[NSString stringWithFormat:@"%@\n\n%@\n",[dealDescriptionArray objectAtIndex:[indexPath row]],dealDate];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height,44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2);
    }
    
    
    else if ( [[dealImageArray objectAtIndex:[indexPath row]]isEqualToString:@"/BizImages/Tile/.jpg" ])
        
    {
        NSString *stringData=[NSString stringWithFormat:@"%@\n\n%@\n",[dealDescriptionArray objectAtIndex:[indexPath row]],dealDate];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height,44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2);
    }
    
    
    
    else if ([imageUriSubString isEqualToString:@"local"])
    {
    
        NSString *stringData=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n%@\n\n%@\n",[dealDescriptionArray objectAtIndex:[indexPath row]],dealDate];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height,44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2);

    }
    
    
    else
    {
        NSString *stringData=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n%@\n\n%@\n",[dealDescriptionArray objectAtIndex:[indexPath row]],dealDate];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height,44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2);
    }
    
    
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
        
        [loadMoreButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        
        [loadMoreButton setTitle:@"Tap here for older message's" forState:UIControlStateNormal];
        
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

    [self performSelector:@selector(fetchMessages) withObject:nil afterDelay:0.5];
    
}


-(void)fetchMessages
{
    [loadMoreButton setHidden:YES];
    
    
    NSString *urlString=[NSString stringWithFormat:
                         @"%@/bizFloats?clientId=DB96EA35A6E44C0F8FB4A6BAA94DB017C0DFBE6F9944B14AA6C3C48641B3D70&skipBy=%d&fpId=%@",appDelegate.apiWithFloatsUri,messageSkipCount,[userDetails objectForKey:@"userFpId"]];
    
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
        
        [dealImageArray addObject:[[[json objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"tileImageUri" ]];
        
    }
    
    
    NSLog(@"messageSkipCount before:%d",messageSkipCount);
    
    
    messageSkipCount=arrayToSkipMessage.count;
    
    
    NSLog(@"messageSkipCount After:%d",messageSkipCount);
    
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
