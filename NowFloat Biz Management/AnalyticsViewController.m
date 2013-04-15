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

#define kBackGroudQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)

@interface AnalyticsViewController ()

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
 
    if ([appDelegate.storeAnalyticsArray count]==0)
    {
        
        NSString  *visitorCountUrlString=[NSString stringWithFormat:@"%@/%@/visitorCount?clientId=DB96EA35A6E44C0F8FB4A6BAA94DB017C0DFBE6F9944B14AA6C3C48641B3D70",appDelegate.apiWithFloatsUri,[appDelegate.storeDetailDictionary objectForKey:@"Tag"]];
        
        NSURL *visitorCountUrl=[NSURL URLWithString:visitorCountUrlString];
        
        msgData = [NSData dataWithContentsOfURL: visitorCountUrl];
        
        visitorsLabel.text=[strAnalytics getStoreAnalytics:msgData];
        
        NSString *visitorString = [visitorsLabel.text
                                   stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        visitorsLabel.text=[NSString stringWithFormat:@"%@ visits",visitorString];
        
        NSString *subscriberUrlString=[NSString stringWithFormat:@"%@/%@/subscriberCount?clientId=DB96EA35A6E44C0F8FB4A6BAA94DB017C0DFBE6F9944B14AA6C3C48641B3D70",appDelegate.apiWithFloatsUri,[appDelegate.storeDetailDictionary objectForKey:@"Tag"]];
        
        NSURL *subscriberUrl=[NSURL URLWithString:subscriberUrlString];
        
        msgData = [NSData dataWithContentsOfURL: subscriberUrl];
        
        subscribersLabel.text=[NSString stringWithFormat:@"%@ subscribers",[strAnalytics getStoreAnalytics:msgData]];
                
        if ([visitorsLabel.text length])
        {
            [visitorsActivity stopAnimating];
        }
        
        if ([subscribersLabel.text length])
        {
            [subscriberActivity stopAnimating];
        }
        
    }
    
    
    
    else
    {
        
        if ([subscribersLabel.text isEqualToString:@"No Description visits"] && [visitorsLabel.text isEqualToString:@"No Description subscribers"])
        {
            [appDelegate.storeAnalyticsArray removeAllObjects];
        }
        
        else
        {
            subscribersLabel.text=[appDelegate.storeAnalyticsArray objectAtIndex:0];
            visitorsLabel.text=[appDelegate.storeAnalyticsArray objectAtIndex:1];
            [visitorsActivity stopAnimating];
            [subscriberActivity stopAnimating];
        }
                
    }
    
    

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [lineGraphButton setHidden:YES];
    [pieChartButton setHidden:YES];

    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    strAnalytics=[[StoreAnalytics  alloc]init];
    
    isButtonPressed=NO;
    
    [dismissButton setHidden:YES];

    self.title = NSLocalizedString(@"Analytics", nil);
    
    self.navigationController.navigationBarHidden=NO;
    
    SWRevealViewController *revealController = [self revealViewController];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                        style:UIBarButtonItemStyleBordered
                        target:revealController
                        action:@selector(revealToggle:)];
    
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];

    /*Design the background labels here*/
    
    [visitorBg.layer setCornerRadius:6 ];
    [subscriberBg.layer setCornerRadius:6 ];
    
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
    [super viewDidUnload];
}


- (IBAction)viewButtonClicked:(id)sender
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




@end
