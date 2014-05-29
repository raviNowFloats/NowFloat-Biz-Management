//
//  AnalyticsViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 14/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "AnalyticsViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GraphViewController.h"
#import "UIColor+HexaString.h"
#import "StoreVisits.h"
#import "StoreSubscribers.h"
#import "SearchQueryViewController.h"
#import "Mixpanel.h"
#import "LatestVisitors.h"




@interface AnalyticsViewController ()<StoreVisitDelegate,StoreSubscribersDelegate,LatestVisitorDelegate>

@end

@implementation AnalyticsViewController
@synthesize subscriberActivity,visitorsActivity;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
            }
    return self;
}



-(void)viewWillAppear:(BOOL)animated
{


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    
    
    [lineGraphButton setHidden:YES];
    [pieChartButton setHidden:YES];

    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    version = [[UIDevice currentDevice] systemVersion];

    strAnalytics=[[StoreAnalytics  alloc]init];
    
    isButtonPressed=NO;
    
    [dismissButton setHidden:YES];

    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;
    
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    mixPanel.showNotificationOnActive = NO;

    //Navigation Bar Here
    
    if (version.floatValue<7.0)
    {
        
        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        [topSubView setFrame:CGRectMake(20,120,topSubView.frame.size.width, topSubView.frame.size.height)];
        
        headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 13, 120, 20)];
        
        headerLabel.text=@"Analytics";
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textAlignment=NSTextAlignmentCenter;
        
        headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
        
        [navBar addSubview:headerLabel];

        leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:leftCustomButton];
        
    }
    
    else
    {
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        
        self.navigationController.navigationBar.translucent = NO;
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
        self.navigationItem.title=@"Analytics";
        
        leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftCustomButton];
        
        self.navigationItem.leftBarButtonItem = leftBtnItem;

    }

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            if (version.floatValue>=7.0)
            {
                [topSubView setFrame:CGRectMake(20,120-44,topSubView.frame.size.width, topSubView.frame.size.height)];
            }
        }
        
    }

    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];

    //Set the RightRevealWidth 0
    revealController.rightViewRevealWidth=0;
    revealController.rightViewRevealOverdraw=0;

    
    /*Design the background labels here*/
    
    [visitorBg.layer setCornerRadius:6 ];
    [subscriberBg.layer setCornerRadius:6 ];
    
    
    StoreVisits *strVisits=[[StoreVisits alloc]init];
    strVisits.delegate=self;
    [strVisits getStoreVisits];

    
    StoreSubscribers *strSubscribers=[[StoreSubscribers alloc]init];
    strSubscribers.delegate=self;
    [strSubscribers getStoreSubscribers];

/*
    if (![appDelegate.storeWidgetArray containsObject:@"SUBSCRIBERCOUNT"])
    {
        [subscriberActivity stopAnimating];
        
        UIImageView *lockedImageView=[[UIImageView alloc]initWithFrame:CGRectMake(232,27, 26, 26)];
        
        [lockedImageView setImage:[UIImage imageNamed:@"lock.png"]];
        
        [lockedImageView setBackgroundColor:[UIColor clearColor]];
        
        [topSubView addSubview:lockedImageView];
    }

    else
    {
        
        StoreSubscribers *strSubscribers=[[StoreSubscribers alloc]init];
        strSubscribers.delegate=self;
        [strSubscribers getStoreSubscribers];
    }
*/
    
    if (appDelegate.searchQueryArray.count>0)
    {        
        notificationLabel.text=[NSString stringWithFormat:@"%d",appDelegate.searchQueryArray.count];
        
        [notificationImageView setHidden:NO];
        
        [notificationLabel setHidden:NO];
    }
    
    else
    {
        [notificationImageView setHidden:YES];
        
        [notificationLabel setHidden:YES];
    }
    
    [self lastVisitorDetails];
}

-(void)lastVisitDetails:(NSMutableDictionary *)visits
{
    NSString *cityName = [[visits objectForKey:@"city"] lowercaseString];
    NSString *countryName = [[visits objectForKey:@"country"] lowercaseString];
    
    NSString *timeStamp = [visits objectForKey:@"ArrivalTimeStamp"];
    
    NSDate *newStartDate = [self mfDateFromDotNetJSONString:timeStamp];
    NSDate *currentdate = [NSDate date];
    
    int dayDifference = -[self daysBetween:currentdate and:newStartDate];
    
    dayDifference = dayDifference < 0? 0: dayDifference;
    
    int hoursDifference = -[self hoursBetween:currentdate and:newStartDate];
    
    hoursDifference = hoursDifference < 0? 0:hoursDifference;
    
    int minDifference = -[self minutesBetween:currentdate and:newStartDate];
    
    minDifference = minDifference < 0? 0: minDifference;
    
    int monthDifference = [self monthsBetween:currentdate and:newStartDate];
    
    monthDifference = monthDifference < 0? 0: monthDifference;
    
    int yearDifference = [self yearsBetween:currentdate and:newStartDate];
    
    yearDifference =  yearDifference < 0 ? 0 : yearDifference;
    

 
    NSString *lastSeen;
    
    if(minDifference < 60)
    {
        if(minDifference == 0)
        {
            lastSeen = [NSString stringWithFormat:@"few seconds ago"];
        }
        else if(minDifference == 1)
        {
            lastSeen = [NSString stringWithFormat:@"%d minute ago", minDifference];
        }
        else
        {
            lastSeen = [NSString stringWithFormat:@"%d minutes ago",minDifference];
        }
    }
    else
    {
        if(hoursDifference < 24)
        {
            if(hoursDifference <= 1)
            {
                lastSeen = [NSString stringWithFormat:@"1 hour ago"];
            }
            else
            {
                lastSeen = [NSString stringWithFormat:@"%d hours ago",hoursDifference];
            }
            
        }
        else
        {
            if(dayDifference < 30)
            {
                if(dayDifference <= 1)
                {
                    lastSeen = [NSString stringWithFormat:@"1 days ago"];
                }
                else
                {
                    lastSeen = [NSString stringWithFormat:@"%d days ago",dayDifference];
                }
            }
            else
            {
                if(monthDifference < 12)
                {
                    if(monthDifference <= 1)
                    {
                        lastSeen = [NSString stringWithFormat:@"1 month ago"];
                    }
                    else
                    {
                        lastSeen = [NSString stringWithFormat:@"%d months ago",monthDifference];
                    }
                }
                else
                {
                    if(yearDifference == 1)
                    {
                        lastSeen = [NSString stringWithFormat:@"1 year ago"];
                    }
                    else
                    {
                        lastSeen = [NSString stringWithFormat:@"%d years ago",yearDifference];
                    }
                }
                
            }
            
        }
    }
    
  
    
    cityName = [cityName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[cityName substringToIndex:1] uppercaseString]];
    countryName = [countryName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[countryName substringToIndex:1] uppercaseString]];
    
    UILabel *visitorInfo = [[UILabel alloc] init];
    visitorInfo.text =@"Last Visitor Info";
    [visitorInfo setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [visitorInfo setFrame:CGRectMake(25, 275, 275, 25)];
    visitorInfo.textColor = [UIColor grayColor];
    
    UILabel *placeName = [[UILabel alloc] init];
    placeName.text = [NSString stringWithFormat:@"Someone from %@, %@ visited %@",cityName,countryName,lastSeen];
    [placeName setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:14]];
    [placeName setFrame:CGRectMake(25,295,275, 50)];
    placeName.textColor = [UIColor grayColor];
    [placeName setLineBreakMode:NSLineBreakByCharWrapping];
    placeName.numberOfLines = 2;
 
    
    [self.view addSubview:visitorInfo];
    [self.view addSubview:placeName];

    
    
}

-(NSDate *)mfDateFromDotNetJSONString:(NSString *)string {
    static NSRegularExpression *dateRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateRegEx = [[NSRegularExpression alloc] initWithPattern:@"^\\/date\\((-?\\d++)(?:([+-])(\\d{2})(\\d{2}))?\\)\\/$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    NSTextCheckingResult *regexResult = [dateRegEx firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (regexResult) {
        // milliseconds
        NSTimeInterval seconds = [[string substringWithRange:[regexResult rangeAtIndex:1]] doubleValue] / 1000.0;
        // timezone offset
        if ([regexResult rangeAtIndex:2].location != NSNotFound) {
            NSString *sign = [string substringWithRange:[regexResult rangeAtIndex:2]];
            // hours
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:3]]] doubleValue] * 60.0 * 60.0;
            // minutes
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:4]]] doubleValue] * 60.0;
        }
        
        return [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    return nil;
}

- (int)hoursBetween:(NSDate *)firstDate and:(NSDate *)secondDate {
    NSUInteger unitFlags = NSHourCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:firstDate toDate:secondDate options:0];
    return [components hour]-5;
}

- (int)minutesBetween:(NSDate *)firstDate and:(NSDate *)secondDate {
    NSUInteger unitFlags = NSMinuteCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:firstDate toDate:secondDate options:0];
    return [components minute]-330;
}

- (int)yearsBetween:(NSDate *)firstDate and:(NSDate *)secondDate {
    NSUInteger unitFlags = NSYearCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:firstDate toDate:secondDate options:0];
    return [components year];
}

- (int)daysBetween:(NSDate *)firstDate and:(NSDate *)secondDate {
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:firstDate toDate:secondDate options:0];
    return [components day];
}

- (int)monthsBetween:(NSDate *)firstDate and:(NSDate *)secondDate {
    NSUInteger unitFlags = NSMonthCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:firstDate toDate:secondDate options:0];
    return [components month];
}

-(void)lastVisitorDetails
{
    LatestVisitors *visitorDetails = [[LatestVisitors alloc] init];
    
    visitorDetails.delegate = self;
    
    [visitorDetails getLastVisitorDetails];
}

-(void)failedToGetVisitDetails
{
    UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong in fetching last visitor details" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    
    [alerView show];
    
    alerView=nil;
}
#pragma StoreVistsDelegate



-(void)showVisitors:(NSString *)visits
{

    [visitorsActivity stopAnimating];
    
    
    visitorsLabel.text=[NSString stringWithFormat:@"%@",visits];

    NSString *visitorString = [visitorsLabel.text
                               stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    visitorsLabel.text=[NSString stringWithFormat:@"%@",visitorString];
    
}


-(void)showSubscribers:(NSString *)subscribers
{

    [subscriberActivity stopAnimating];
    
    subscribersLabel.text=subscribers;
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    subscribersLabel = nil;
    visitorsLabel = nil;
    [self setSubscriberActivity:nil];
    [self setVisitorsActivity:nil];
    subscriberBg = nil;
    visitorBg = nil;
    topSubView = nil;
    bottomSubview = nil;
    dismissButton = nil;
    viewGraphButton = nil;
    lineGraphButton = nil;
    pieChartButton = nil;
    revealFrontControllerButton = nil;
    notificationImageView = nil;
    notificationImageView = nil;
    notificationLabel = nil;
    [super viewDidUnload];
}


- (IBAction)viewBtnClicked:(id)sender
{
    /*
    UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:@"Select from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"No. of visit's", nil];
    selectAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    selectAction.tag=1;
    [selectAction showInView:self.view];
     */
    
    GraphViewController *graphController=[[GraphViewController alloc]initWithNibName:@"GraphViewController" bundle:nil];
    graphController.isLineGraphSelected=YES;
    graphController.isPieChartSelected=NO;
    [lineGraphButton setHidden:NO];
    [pieChartButton setHidden:NO];
    
    [self.navigationController pushViewController:graphController animated:YES];
    
    graphController=nil;

}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1)
    {
        if(buttonIndex == 0)
        {
            GraphViewController *graphController=[[GraphViewController alloc]initWithNibName:@"GraphViewController" bundle:nil];
            graphController.isLineGraphSelected=YES;
            graphController.isPieChartSelected=NO;
            [lineGraphButton setHidden:NO];
            [pieChartButton setHidden:NO];
            
            [self.navigationController pushViewController:graphController animated:YES];
            
            graphController=nil;

        }
        
        
        if (buttonIndex==1)
        {
            GraphViewController *graphController=[[GraphViewController alloc]initWithNibName:@"GraphViewController" bundle:nil];
            graphController.isLineGraphSelected=NO;
            graphController.isPieChartSelected=YES;
            [self.navigationController pushViewController:graphController animated:YES];
            
            graphController=nil;
        }
        
    }
    
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

- (IBAction)searchQueryBtnClicked:(id)sender
{

    [appDelegate.searchQueryArray removeAllObjects];
    [notificationLabel setHidden:YES];
    [notificationImageView setHidden:YES];

    SearchQueryViewController  *searchViewController=[[SearchQueryViewController alloc]initWithNibName:@"SearchQueryViewController" bundle:nil];


    [headerView setHidden:YES];
    
    [self.navigationController pushViewController:searchViewController animated:YES];
    

    
    
    //[self presentModalViewController:searchViewController animated:YES];

    
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
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"])
    {
        [revealFrontControllerButton setHidden:NO];
    }
    
}



@end
