//
//  BusinessHoursViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BusinessHoursViewController.h"
#import "SWRevealViewController.h"
#import "SVSegmentedControl.h"
#import "UIColor+HexaString.h"  


@interface BusinessHoursViewController ()

@end

@implementation BusinessHoursViewController
@synthesize buisnesHourDatePicker,fromTextView,toTextView;
@synthesize pickerSubView,buisnessHourTableView,checkedIndexPath;



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
    
    
    
    
    self.title = NSLocalizedString(@"Business Hours", nil);
    SWRevealViewController *revealController = [self revealViewController];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:revealController action:@selector(revealToggle:)];
    
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Post"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self     action:@selector(updateMessage)];
    
    
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    
    
    
    
    
    [pickerSubView setHidden:YES];
    
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    storeTimingsArray=[appDelegate.storeDetailDictionary objectForKey:@"Timings"];

    
    NSMutableArray *storeTimingsBoolArray=[[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    
    
    
    //TimePicker Array
    
    hoursArray=[[NSMutableArray alloc]
                initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
    
    minutesArray=[[NSMutableArray alloc]initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"00",nil];
    
    
    periodArray=[[NSMutableArray alloc]initWithObjects:@"AM",@"PM", nil ];
    
    holidayArray=[[NSMutableArray alloc]initWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday", nil];
    
    
    
    
    if ([storeTimingsArray isEqual:[NSNull null]])
    {
        
        [fromTextView setText:@"----"];
        [toTextView setText:@"----"];
        
        
        int y=56;
        
        for (int i=0; i<[holidayArray count]; i++)
        {
            
            
            
            SVSegmentedControl *yellowRC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"Closed", @"Open", nil]];
            [yellowRC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
            
            [yellowRC setFrame:CGRectMake(170,y,130, 25)];
            yellowRC.crossFadeLabelsOnDrag = YES;
            yellowRC.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15];
            yellowRC.titleEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 14);
            yellowRC.height = 40;
            yellowRC.selectedIndex =1;
            
            yellowRC.thumb.tintColor = [UIColor colorWithHexString:@"478ee1"];
            yellowRC.thumb.textColor = [UIColor whiteColor];
            yellowRC.thumb.textShadowColor = [UIColor colorWithWhite:1 alpha:0.5];
            yellowRC.thumb.textShadowOffset = CGSizeMake(0, 1);
            
            [closedDaySubView addSubview:yellowRC];
            
            
            yellowRC.tag =i;
            
            y=y+38;
        }

        
    }
    
    
    
    else
    {
    
        for (int i =0;i< [storeTimingsArray count]; i++)
        {
            
            if ([[[storeTimingsArray objectAtIndex:i]objectForKey:@"From" ]intValue ]>0 && [[[storeTimingsArray objectAtIndex:i]objectForKey:@"To" ]intValue ]>0)
            {
                
                storeToTime=[[storeTimingsArray objectAtIndex:i]objectForKey:@"To" ];
                storeFromTime=[[storeTimingsArray objectAtIndex:i]objectForKey:@"From" ];
                
                [storeTimingsBoolArray replaceObjectAtIndex:i withObject:@"1"];
            }
            
            
        }
        
        
        
        [fromTextView setText:storeFromTime];
        [toTextView setText:storeToTime];
        
        NSLog(@"storeTimingsBoolArray:%@",storeTimingsBoolArray);
        
        
        /*Set the store from & to time*/
        
        
        
        
        int y=56;
        
        for (int i=0; i<[holidayArray count]; i++)
        {
            
            
            
            SVSegmentedControl *yellowRC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"Closed", @"Open", nil]];
            [yellowRC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
            
            [yellowRC setFrame:CGRectMake(170,y,130, 25)];
            yellowRC.crossFadeLabelsOnDrag = YES;
            yellowRC.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15];
            yellowRC.titleEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 14);
            yellowRC.height = 40;
            yellowRC.selectedIndex =[[storeTimingsBoolArray objectAtIndex:i] intValue];
            
            yellowRC.thumb.tintColor = [UIColor colorWithHexString:@"478ee1"];
            yellowRC.thumb.textColor = [UIColor whiteColor];
            yellowRC.thumb.textShadowColor = [UIColor colorWithWhite:1 alpha:0.5];
            yellowRC.thumb.textShadowOffset = CGSizeMake(0, 1);
            
            [closedDaySubView addSubview:yellowRC];
            
            
            yellowRC.tag =i;
            
            y=y+38;
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    NSLog(@"storeTimingsArray:%@",storeTimingsArray);
    
    
    
    
        
       
    
    
}


#pragma UIPickerView 
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{


    if(component == 1)
        return [minutesArray count];
    
    else if(component == 2)
        return [periodArray count];
    else
        return [hoursArray count];

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    

    if(component == 1)
    {

        return [minutesArray objectAtIndex:row];
        
    }

    else if(component == 2)
    {
        return [periodArray objectAtIndex:row];

    }
    
    
    else
        return [hoursArray objectAtIndex:row];


    

}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if(component == 1)
    {
        min=[minutesArray objectAtIndex:row];
        
    }
    
    else if(component == 2)
    {
        period=[periodArray objectAtIndex:row];
        
    }
    
    
    else
        hour=[hoursArray objectAtIndex:row];
    



}




#pragma mark -
#pragma mark SPSegmentedControl

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl;
{

	//NSLog(@"segmentedControl %i did select index %i (via UIControl method)", segmentedControl.tag, segmentedControl.selectedIndex);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{

    [self setFromTextView:nil];
    [self setToTextView:nil];
    [self setBuisnesHourDatePicker:nil];
    [self setPickerSubView:nil];
    setFromStoreTimeButton = nil;
    setToStoreTimeButton = nil;
    [self setBuisnessHourTableView:nil];
    closedDaySubView = nil;
    [super viewDidUnload];
}

- (IBAction)toButtonClicked:(id)sender
{
    [closedDaySubView   setHidden:YES];
    [pickerSubView setHidden:NO];
    [closedDaySubView   setHidden:YES];
    [setFromStoreTimeButton setHidden:YES];
    [setToStoreTimeButton setHidden:NO];
    
    

}

- (IBAction)fromButtonClicked:(id)sender
{
        [closedDaySubView   setHidden:YES];
    [setFromStoreTimeButton setHidden:NO];
    [setToStoreTimeButton setHidden:YES];
        [pickerSubView  setHidden:NO];
    
}

- (IBAction)setFromStoreTime:(id)sender
{
    
    [closedDaySubView   setHidden:NO];
    if (hour==NULL)
    {
        hour=@"1";
    }
    
    
    if (min==NULL)
    {
        min=@"01";
    }
    
    
    if (period==NULL)
    {
        period=@"A.M";
    }
    
    NSString *fromTimeString=[NSString stringWithFormat:@"%@:%@ %@",hour,min,period];
    
    fromTextView.text=fromTimeString;
    
    
    [pickerSubView setHidden:YES];
    
    
}

- (IBAction)setToStoreTime:(id)sender;
{
    [closedDaySubView   setHidden:NO];
    if (hour==NULL)
    {
        hour=@"1";
    }
    
    
    if (min==NULL)
    {
        min=@"01";
    }
    
    
    if (period==NULL)
    {
        period=@"A.M";
    }
    
    NSString *toTimeString=[NSString stringWithFormat:@"%@:%@ %@",hour,min,period];
    
    toTextView.text=toTimeString;
    
    [pickerSubView setHidden:YES];


}

- (IBAction)hidePickerView:(id)sender
{
    [closedDaySubView setHidden:NO];
    [pickerSubView  setHidden:YES];
    
}



-(void)updateMessage
{
    
    NSLog(@"update message");
    
}

@end
