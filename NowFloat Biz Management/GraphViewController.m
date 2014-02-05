//
//  GraphViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 09/03/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "GraphViewController.h"
#import "UIColor+HexaString.h"
#import "AnalyticsViewController.h"

@interface GraphViewController ()
{
    NSString *versionString;
    NSMutableDictionary *sampleInfo;
}
@end

@implementation GraphViewController
@synthesize isPieChartSelected,isLineGraphSelected;


-(id)init
{

    self = [super init];
	if (self)
	{
    }
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];

    vistorCountArray=[[NSMutableArray alloc]init];
    vistorWeekArray=[[NSMutableArray alloc]init];
    
    versionString=[UIDevice currentDevice].systemVersion;
    
    if (versionString.floatValue<7.0)
    {

    self.navigationController.navigationBarHidden=NO;
    
    UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
        
    }
    
    @try
    {
        for (int i=0; i<[appDelegate.storeVisitorGraphArray count]-1; i++)
        {
            [vistorCountArray insertObject:[[appDelegate.storeVisitorGraphArray objectAtIndex:i]objectForKey:@"visitCount" ] atIndex:i];
            [vistorWeekArray insertObject:[[appDelegate.storeVisitorGraphArray objectAtIndex:i]objectForKey:@"WeekNumber" ] atIndex:i];
        }
    //For Max-Min Graph Value
    
    maxGraph= [[vistorCountArray valueForKeyPath:@"@max.intValue"] intValue];
    
    minGraph=[[vistorCountArray valueForKeyPath:@"@min.intValue"] intValue];
    
    //Populate a JSON TO FIT INSIDE THE GRAPH
    //WARNING---DO NOT MODIFY
    
    NSMutableDictionary *visitCountDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:vistorCountArray,@"data",[[appDelegate.storeDetailDictionary objectForKey:@"Tag"] lowercaseString],@"title", nil];
    
    NSMutableArray *sampleArray=[[NSMutableArray alloc]initWithObjects:visitCountDic, nil];
    
    sampleInfo=[[NSMutableDictionary alloc]initWithObjectsAndKeys:sampleArray,@"data",vistorWeekArray,@"x_labels", nil];
    
    }
    
    @catch (NSException *e)
    {
        UIAlertView *noDataAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"We could not fetch number of visits for your website." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [noDataAlert show];
        
        noDataAlert=nil;
    }
        
    if (isLineGraphSelected)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;

            if(result.height == 568)
            {
                [numberOfWeeksLabel setFrame:CGRectMake(122, 475, 127, 21)];
            }
        }

        [numberOfVisitsLabel setHidden:NO];
        [numberOfWeeksLabel setHidden:NO];
        
        [numberOfVisitsLabel setTransform:CGAffineTransformMakeRotation(-M_PI/ 2)];

        [self setTitle:@"Visits"];
        
        _lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(40,10,[self.view bounds].size.width-40,[self.view bounds].size.height-40)];
        
        [_lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        //_lineChartView.minValue = 0;
        
        /*---Do Not Modify---*/
        
        /*
        if (maxGraph<=600)
        {
            if (maxGraph<=30)
            {
                _lineChartView.maxValue =30;
                _lineChartView.interval = 5;
            }
            
            
            else if (maxGraph<=40)
            {
                _lineChartView.maxValue = 40;
                _lineChartView.interval = 5;
            }
            
            
            else if (maxGraph<=50)
            {
                _lineChartView.maxValue = 50;
                _lineChartView.interval = 10;
            }
            
            
            else if (maxGraph<=60)
            {
                _lineChartView.maxValue = 60;
                _lineChartView.interval = 10;
            }
            
            else if (maxGraph<=70)
            {
                _lineChartView.maxValue = 70;
                _lineChartView.interval = 10;
            }
            
            else if (maxGraph<=80)
            {
                _lineChartView.maxValue = 80;
                _lineChartView.interval = 10;
            }
            
            else if (maxGraph<=90)
            {
                _lineChartView.maxValue = 90;
                _lineChartView.interval = 10;
            }
            
            
            else if (maxGraph<=100)
            {
                _lineChartView.maxValue = 100;
                _lineChartView.interval = 20;
            }
            
            else if (maxGraph<=200)
            {
                _lineChartView.maxValue = 200;
                _lineChartView.interval = 40;
            }
            
            
            else if (maxGraph<=300)
            {
                _lineChartView.maxValue = 300;
                _lineChartView.interval = 40;            
            }
            
            
            else if (maxGraph<=400)
            {
                _lineChartView.maxValue = 400;
                _lineChartView.interval = 50;
            }
            
            else
            {
                _lineChartView.maxValue = 600;
                _lineChartView.interval = 100;
            }
        }
        
        else if (maxGraph>600 & maxGraph<900)
        {
                _lineChartView.maxValue = 900;
                _lineChartView.interval = 150;
            
        }

        else if (maxGraph>900)
        {        
            _lineChartView.maxValue = 1500;
            _lineChartView.interval = 500;
        }
         */
        
    
        @try
        {
            float div;
            
            if (maxGraph<100)
            {
                div=10;
                _lineChartView.maxValue=100;
                _lineChartView.minValue=0;
            }
            
            else if (maxGraph<300)
            {
                div=40;
                _lineChartView.maxValue=400;
                _lineChartView.minValue=40;
            }
            
            else if (maxGraph<700)
            {
                _lineChartView.maxValue = 600;
                _lineChartView.interval = 100;
            }
            
            else
            {
                div=roundf(maxGraph/3);
                _lineChartView.maxValue=maxGraph;
                _lineChartView.minValue=0;
            }

        _lineChartView.interval=div;
        
        [self.view addSubview:_lineChartView];
        
        NSMutableArray *components = [NSMutableArray array];
        
        PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];

        for (int i=0; i<[[sampleInfo objectForKey:@"data"] count]; i++)
        {
            NSDictionary *point = [[sampleInfo objectForKey:@"data"] objectAtIndex:i];
            
            [component setPoints:[point objectForKey:@"data"]];
            
            [component setShouldLabelValues:NO];
            
            [component setColour:PCColorYellow];
            
            [components addObject:component];
        }
        
        
        [_lineChartView setComponents:components];
        [_lineChartView setXLabels:[sampleInfo objectForKey:@"x_labels"]];
        }
        
        @catch (NSException *e)
        {
            [_lineChartView setHidden:YES];
        }
        
    }
        
    /*Pie chart*/
    if (isPieChartSelected)
    {
        [self setTitle:@"Pie Chart"];

        [numberOfVisitsLabel setHidden:YES];
        [numberOfWeeksLabel setHidden:YES];
        
        NSMutableArray *components = [NSMutableArray array];

        int height = [self.view bounds].size.width/3*2.; // 220;
        
        int width = [self.view bounds].size.width; //320;
        
        PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-width)/2,([self.view bounds].size.height-height)/2,width,height)];
        
        [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
        
        [pieChart setDiameter:width/2]
        ;
        [pieChart setShowArrow:YES];
        
        [pieChart setSameColorLabel:YES];
        
        [self.view addSubview:pieChart];
        
        @try
        {
            for (int i=0; i<[appDelegate.storeVisitorGraphArray  count]-1; i++)
            {
                
                NSString *titleString = [NSString stringWithFormat:@"Visits\nin Week %@",[[appDelegate.storeVisitorGraphArray objectAtIndex:i] objectForKey:@"WeekNumber"]];
                
                PCPieComponent *component = [PCPieComponent pieComponentWithTitle:titleString value:[[[appDelegate.storeVisitorGraphArray objectAtIndex:i] objectForKey:@"visitCount"] floatValue]];
                
                [components addObject:component];
                
                if (i==0)
                {
                    [component setColour:PCColorYellow];
                }
                else if (i==1)
                {
                    [component setColour:PCColorGreen];
                }
                else if (i==2)
                {
                    [component setColour:PCColorOrange];
                }
                else if (i==3)
                {
                    [component setColour:PCColorRed];

                }
                else if (i==4)
                {
                    [component setColour:PCColorBlue];
                }
                
            }
            
            [pieChart setComponents:components];
        }
        
        @catch (NSException *exception){}

    
    }
    
}

-(void)back
{
    
    AnalyticsViewController   *analyticsController=[[AnalyticsViewController alloc]initWithNibName:@"AnalyticsViewController" bundle:nil];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:analyticsController];
    [[self navigationController] setViewControllers:viewControllers animated:NO];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    numberOfVisitsLabel = nil;
    numberOfWeeksLabel = nil;
    [super viewDidUnload];
}
@end
