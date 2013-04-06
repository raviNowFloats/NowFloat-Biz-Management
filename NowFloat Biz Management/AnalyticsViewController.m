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
        
        
        [appDelegate.storeAnalyticsArray insertObject:subscribersLabel.text atIndex:0];
        [appDelegate.storeAnalyticsArray insertObject:visitorsLabel.text atIndex:1];
        
        
    }
    
    
    
    else
    {
        subscribersLabel.text=[appDelegate.storeAnalyticsArray objectAtIndex:0];
        visitorsLabel.text=[appDelegate.storeAnalyticsArray objectAtIndex:1];
        [visitorsActivity stopAnimating];
        [subscriberActivity stopAnimating];


    }
    
    

}


-(void)removeActivityIndicators
{
    
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

        [UIView beginAnimations:nil context:NULL];
        [bottomSubview setBackgroundColor:[UIColor clearColor]];
        [UIView setAnimationDuration:0.20];
        [topSubView setFrame:CGRectMake(20,-80,280,149)];
        [bottomSubview setFrame:CGRectMake(0,67,320,150)];
        [UIView commitAnimations];
        [lineGraphButton setHidden:NO];
        [pieChartButton setHidden:NO];
        [viewGraphButton setHidden:YES];
        [dismissButton setHidden:NO];

}

- (IBAction)dismissButtonClicked:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.20];
    [bottomSubview setBackgroundColor:[UIColor clearColor]];
    [topSubView setFrame:CGRectMake(20,47, 280,149)];
    [bottomSubview setFrame:CGRectMake(0,187,320,0)];
    [UIView commitAnimations];
    [lineGraphButton setHidden:YES];
    [pieChartButton setHidden:YES];
    [viewGraphButton setHidden:NO];
    [dismissButton setHidden:YES];

}

- (IBAction)lineGraphButtonClicked:(id)sender
{
    
    GraphViewController *graphController=[[GraphViewController alloc]initWithNibName:@"GraphViewController" bundle:nil];
    graphController.isLineGraphSelected=YES;
    graphController.isPieChartSelected=NO;
    [lineGraphButton setHidden:NO];
    [pieChartButton setHidden:NO];

    [self.navigationController pushViewController:graphController animated:YES];
    
    graphController=nil;

}

- (IBAction)pieChartButtonClicked:(id)sender
{
    GraphViewController *graphController=[[GraphViewController alloc]initWithNibName:@"GraphViewController" bundle:nil];
    graphController.isLineGraphSelected=NO;
    graphController.isPieChartSelected=YES;
    [self.navigationController pushViewController:graphController animated:YES];
    
    graphController=nil;

}


@end
