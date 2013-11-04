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





@interface AnalyticsViewController ()<StoreVisitDelegate,StoreSubscribersDelegate>

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



-(void)viewDidAppear:(BOOL)animated
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
    
    strAnalytics=[[StoreAnalytics  alloc]init];
    
    isButtonPressed=NO;
    
    [dismissButton setHidden:YES];

    self.title = NSLocalizedString(@"Analytics", nil);
    
    self.navigationController.navigationBarHidden=YES;
    
    CGFloat width = self.view.frame.size.width;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:
                               CGRectMake(0,0,width,44)];
    
    [self.view addSubview:navBar];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 13, 120, 20)];
    
    headerLabel.text=@"Analytics";
    
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

    
    /*Design the background labels here*/
    
    [visitorBg.layer setCornerRadius:6 ];
    [subscriberBg.layer setCornerRadius:6 ];
    
    
    StoreVisits *strVisits=[[StoreVisits alloc]init];
    strVisits.delegate=self;
    [strVisits getStoreVisits];

    
    StoreSubscribers *strSubscribers=[[StoreSubscribers alloc]init];
    strSubscribers.delegate=self;
    [strSubscribers getStoreSubscribers];
    
    
    
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

    UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:@"Select from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Line chart",@"Pie chart", nil];
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
    
    [self.navigationController pushViewController:searchViewController animated:YES];
    
    searchViewController=nil;
    
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



@end
