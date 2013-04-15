//
//  GraphViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 09/03/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "GraphViewController.h"
#import "UIColor+HexaString.h"


@interface GraphViewController ()

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
    
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f4f4f4"]];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
      
    vistorCountArray=[[NSMutableArray alloc]init];
    vistorWeekArray=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[appDelegate.storeVisitorGraphArray count]; i++)
    {
        
        [vistorCountArray insertObject:[[appDelegate.storeVisitorGraphArray objectAtIndex:i]objectForKey:@"visitCount" ] atIndex:i];
        [vistorWeekArray insertObject:[[appDelegate.storeVisitorGraphArray objectAtIndex:i]objectForKey:@"WeekNumber" ] atIndex:i];
        
    }
    
    //For Max-Min Graph Value
    
    maxGraph= [[vistorCountArray valueForKeyPath:@"@max.intValue"] intValue];
    
    minGraph=[[vistorCountArray valueForKeyPath:@"@min.intValue"] intValue];

    
    NSLog(@"maxGraph:%d ,minGraph:%d",maxGraph,minGraph);
    
    
    //Populate a JSON TO FIT INSIDE THE GRAPH
    //WARNING---DO NOT MODIFY
    
    NSMutableDictionary *visitCountDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:vistorCountArray,@"data",[[appDelegate.storeDetailDictionary objectForKey:@"Tag"] lowercaseString],@"title", nil];
    
    NSMutableArray *sampleArray=[[NSMutableArray alloc]initWithObjects:visitCountDic, nil];
    
    NSMutableDictionary *sampleInfo=[[NSMutableDictionary alloc]initWithObjectsAndKeys:sampleArray,@"data",vistorWeekArray,@"x_labels", nil];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    
    if (isLineGraphSelected)
    {
        [numberOfVisitsLabel setHidden:NO];
        [numberOfWeeksLabel setHidden:NO];
        
        [numberOfVisitsLabel setTransform:CGAffineTransformMakeRotation(-M_PI/ 2)];

        [self setTitle:@"Line Chart"];
        
        _lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(40,10,[self.view bounds].size.width-40,[self.view bounds].size.height-40)];
        [_lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        _lineChartView.minValue = 0;
//      _lineChartView.minValue = minGraph-20;
        
        /*---Do Not Modify---*/
        
        if (maxGraph<=600)
        {
                _lineChartView.maxValue = 600;
                _lineChartView.interval = 50;
        }
        
        
        else if (maxGraph>600 & maxGraph<900)
        {
                _lineChartView.maxValue = 900;
                _lineChartView.interval = 100;
            
        }
        
        else if (maxGraph>900)
        {
        
            _lineChartView.maxValue = 1500;
            _lineChartView.interval = 100;

        
        }
        
        
        [self.view addSubview:_lineChartView];
        
        NSMutableArray *components = [NSMutableArray array];
        
        for (int i=0; i<[[sampleInfo objectForKey:@"data"] count]; i++)
        {
            NSDictionary *point = [[sampleInfo objectForKey:@"data"] objectAtIndex:i];
            PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
            [component setPoints:[point objectForKey:@"data"]];
            
            [component setShouldLabelValues:NO];
            
            [component setColour:PCColorRed];
            
            [components addObject:component];
        }
        [_lineChartView setComponents:components];
        [_lineChartView setXLabels:[sampleInfo objectForKey:@"x_labels"]];
        
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
        
        
        for (int i=0; i<[appDelegate.storeVisitorGraphArray  count]; i++)
        {
            
            NSString *titleString = [NSString stringWithFormat:@"Week %@",[[appDelegate.storeVisitorGraphArray objectAtIndex:i] objectForKey:@"WeekNumber"]];
            
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
