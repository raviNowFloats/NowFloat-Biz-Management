//
//  BusinessHoursViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//



#import "BusinessHoursViewController.h"
#import "SWRevealViewController.h"
#import "UIColor+HexaString.h"
#import "UpdateStoreData.h"
#import <QuartzCore/QuartzCore.h>
#import "Mixpanel.h"
#import "BusinessHoursCell.h"
#import "AlertViewController.h"

NSMutableArray *workingDays;
int startHr,endHr;
NSString *startPeriod,*endPeriod;
@interface BusinessHoursViewController ()<updateStoreDelegate>

@end

@implementation BusinessHoursViewController
@synthesize buisnesHourDatePicker,fromTextView,toTextView;
@synthesize pickerSubView,checkedIndexPath,timingCloseLabel;



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
    // Do any additional setup after loading the view from its nib
      

    [activitySubView setHidden:YES];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    storeTimingsArray=[[NSMutableArray alloc]init];
    version = [[UIDevice currentDevice] systemVersion];
    
    workingDays = [[NSMutableArray alloc]initWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday", nil];

    self.businessHrTable.bounces =NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            [pickerSubView setFrame:CGRectMake(0, 210, 320, 252)];
        }
        if(result.height == 568)
        {
            // iPhone 5
            [pickerSubView setFrame:CGRectMake(0, 296, 320, 252)];
            
        }
    }

    
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    mixPanel.showNotificationOnActive = NO;
    
    [closedDaySubView.layer setCornerRadius:6.0];
    [closedDaySubView.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    [closedDaySubView.layer setBorderWidth:1.0];
    
//    [toBgLabel.layer setCornerRadius:6.0];
//    [toBgLabel.layer  setBorderWidth:1.0];
//    
//    [fromBgLabel.layer setCornerRadius:6.0];
    [self.timingView.layer setBorderWidth:0.355];
//    
    [self.timingView.layer setBorderColor:[UIColor colorWithRed:(224/255.0) green:(224/255.0) blue:(224/255.0) alpha:1.0].CGColor];
//    [fromBgLabel.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];

    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;
    
    
   // [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    
    /*Design the NavigationBar here*/
    
    if (version.floatValue<7.0)
    {

    self.navigationController.navigationBarHidden=YES;
    
    CGFloat width = self.view.frame.size.width;
    
    navBar = [[UINavigationBar alloc] initWithFrame:
              CGRectMake(0,0,width,44)];
    
    [self.view addSubview:navBar];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 13,160, 20)];
    
    headerLabel.text=@"Business Hours";
    
    headerLabel.backgroundColor=[UIColor clearColor];
    
    headerLabel.textAlignment=NSTextAlignmentCenter;
    
    headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
    
    headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
    
    [navBar addSubview:headerLabel];
    
    UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
    
    [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
    
    [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:leftCustomButton];

    }
    
    else
    {
//        self.navigationController.navigationBarHidden=NO;
//        
//        self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
//        
//        self.navigationController.navigationBar.translucent = NO;
//        
//        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//        
       self.navigationItem.title=@"Business Hours";
//        
//        [contentSubView setFrame:CGRectMake(0,-44, contentSubView.frame.size.width, contentSubView.frame.size.height)];
//        
//        UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
//        
//        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
//        
//        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftCustomButton];
//        
//        self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    
    }
    
    
    
    //Set the RightRevealWidth 0
    revealController.rightViewRevealWidth=0;
    revealController.rightViewRevealOverdraw=0;

    [pickerSubView setHidden:YES];
    
    [storeTimingsArray addObjectsFromArray:appDelegate.storeTimingsArray];
    
    storeTimingsBoolArray=[[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    
    //TimePicker Array
    
    hoursArray=[[NSMutableArray alloc]                                                                       initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
    
    minutesArray=[[NSMutableArray alloc]initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    
    periodArray=[[NSMutableArray alloc]initWithObjects:@"AM",@"PM", nil ];
    
    if ([storeTimingsArray isEqual:[NSNull null]] || [storeTimingsArray count]==0 )
    {
        [fromTextView setText:@"00.00 AM"];
        [toTextView setText:@"00.00 PM"];
        fromTextView.frame = CGRectMake(-29,25,180,35);
        timingCloseLabel.frame = CGRectMake(230,5,180,35);
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
                
        /*Set the store from & to time*/
        
        [fromTextView setText:storeFromTime];
        [toTextView setText:storeToTime];
        
            
        
        if ([[storeTimingsBoolArray objectAtIndex:0] intValue]==0) {
            
            customSwitch0.on=NO;
        }
        
        else
        {
            customSwitch0.on=YES;
        }
        
        customSwitch0.onText=@"Open";
        customSwitch0.offText=@"Close";
        customSwitch0.tag=0;
        [customSwitch0 addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventAllTouchEvents];
        
        //
        
        
        if ([[storeTimingsBoolArray objectAtIndex:1] intValue]==0) {
            
            customSwitch1.on=NO;
        }
        
        else
        {
            customSwitch1.on=YES;
        }
        customSwitch1.onText=@"Open";
        customSwitch1.offText=@"Close";
        customSwitch1.tag=1;
        [customSwitch1 addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventAllTouchEvents];
        
        //

        
        if ([[storeTimingsBoolArray objectAtIndex:2] intValue]==0) {
            
            customSwitch2.on=NO;
        }
        
        else
        {
            customSwitch2.on=YES;
        }
        customSwitch2.onText=@"Open";
        customSwitch2.offText=@"Close";
        customSwitch2.tag=2;
        [customSwitch2 addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventAllTouchEvents];
        
        //
        
        
        
        if ([[storeTimingsBoolArray objectAtIndex:3] intValue]==0) {
            
            customSwitch3.on=NO;
        }
        
        else
        {
            customSwitch3.on=YES;
        }
        customSwitch3.onText=@"Open";
        customSwitch3.offText=@"Close";
        customSwitch3.tag=3;
        [customSwitch3 addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventAllTouchEvents];
        
        //
        
        
        if ([[storeTimingsBoolArray objectAtIndex:4] intValue]==0) {
            
            customSwitch4.on=NO;
        }
        
        else
        {
            customSwitch4.on=YES;
        }
        customSwitch4.onText=@"Open";
        customSwitch4.offText=@"Close";
        customSwitch4.tag=4;
        [customSwitch4 addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventAllTouchEvents];
        
        //
        
        
        
        
        if ([[storeTimingsBoolArray objectAtIndex:5] intValue]==0) {
            
            customSwitch6.on=NO;
        }
        
        else
        {
            customSwitch6.on=YES;
        }
        customSwitch6.onText=@"Open";
        customSwitch6.offText=@"Close";
        customSwitch6.tag=5;
        [customSwitch6 addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventAllTouchEvents];
        
        //
        
        
        
        if ([[storeTimingsBoolArray objectAtIndex:6] intValue]==0)
        {            
            customSwitch7.on=NO;
        }
        
        else
        {
            [customRighNavButton setHidden:YES];

            customSwitch7.on=YES;
        }
        customSwitch7.onText=@"Open";
        customSwitch7.offText=@"Close";
        customSwitch7.tag=6;
        
        [customSwitch7 addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventAllTouchEvents];

        //
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateView)
                                                 name:@"update" object:nil];
    
    
    [self setRighttNavBarButton];

    
}

- (void)switchToggled:(id)sender
{
    
    
    CGPoint switchPositionPoint = [sender convertPoint:CGPointZero toView:[self businessHrTable]];
    NSIndexPath *indexPath = [[self businessHrTable] indexPathForRowAtPoint:switchPositionPoint];
    
    BusinessHoursCell *cell = (BusinessHoursCell*)[self.businessHrTable cellForRowAtIndexPath:indexPath];
    
    int tag=indexPath.row;
    
   
    
    if (tag==0)
    {
       

        if (cell.workingDaySwitch.on)
        {
            [storeTimingsBoolArray replaceObjectAtIndex:0 withObject:@"1"];
             [customRighNavButton setHidden:NO];
        }
        
        else
        {
          
            [storeTimingsBoolArray replaceObjectAtIndex:0 withObject:@"0"];
            
        }
    }
    
    else if (tag==1)
    {
        

       if (cell.workingDaySwitch.on)
        {
            
            [storeTimingsBoolArray replaceObjectAtIndex:1 withObject:@"1"];
            [customRighNavButton setHidden:NO];
            
        }
        
        else
        {
            
            [storeTimingsBoolArray replaceObjectAtIndex:1 withObject:@"0"];
            
        }
    }
    
    
    else if (tag==2)
    {
        
       

        if (cell.workingDaySwitch.on)
        {
            
            [storeTimingsBoolArray replaceObjectAtIndex:2 withObject:@"1"];
             [customRighNavButton setHidden:NO];
            
        }
        
        else
        {
            
            [storeTimingsBoolArray replaceObjectAtIndex:2 withObject:@"0"];
            
        }
    }
    
    
    else if (tag==3)
    {
        

        if (cell.workingDaySwitch.on)        {
            
            [storeTimingsBoolArray replaceObjectAtIndex:3 withObject:@"1"];
            [customRighNavButton setHidden:NO];
        }
        
        else
        {
            
            [storeTimingsBoolArray replaceObjectAtIndex:3 withObject:@"0"];
            
        }
    }
    
    else if (tag==4)
    {
        

       if (cell.workingDaySwitch.on)
        {
            
            [storeTimingsBoolArray replaceObjectAtIndex:4 withObject:@"1"];
            [customRighNavButton setHidden:NO];
        }
        
        else
        {
            
            [storeTimingsBoolArray replaceObjectAtIndex:4 withObject:@"0"];
            
        }
    }
    
    
    
    else if (tag==5)
    {
        

        if (cell.workingDaySwitch.on)
        {
            [storeTimingsBoolArray replaceObjectAtIndex:5 withObject:@"1"];
            [customRighNavButton setHidden:NO];
        }
        
        else
        {
            [storeTimingsBoolArray replaceObjectAtIndex:5 withObject:@"0"];
            
        }
    }
    
     if (tag==6)
    {
        

        if (cell.workingDaySwitch.on)
        {
            [storeTimingsBoolArray replaceObjectAtIndex:6 withObject:@"1"];
            [customRighNavButton setHidden:NO];
        }
        
        else
        {
            [storeTimingsBoolArray replaceObjectAtIndex:6 withObject:@"0"];
            
        }
        
    }

    BOOL isDaysSel=NO;
    
    for(int i =0; i < 7 ;i++)
    {
        if([[storeTimingsBoolArray objectAtIndex:i]isEqualToString:@"1"])
        {
            isDaysSel = YES;
        }
            
    }
    if(!isDaysSel)
    {
        [customRighNavButton setHidden:YES];
    }
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BusinessHoursCell *cell = [self.businessHrTable dequeueReusableCellWithIdentifier:@"businessHour"];
    
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"BusinessHoursCell" bundle:nil] forCellReuseIdentifier:@"businessHour"];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"businessHour"];
    }
    
    
    cell.workingDayLabel.text = [workingDays objectAtIndex:[indexPath row]];
    
    [cell.workingDaySwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventAllTouchEvents];
    
    if(indexPath.row==0)
    {
        if ([[storeTimingsBoolArray objectAtIndex:0] intValue]==0) {
            
            cell.workingDaySwitch.on=NO;
        }
        
        else
        {
            cell.workingDaySwitch.on=YES;
        }
      
        cell.workingDaySwitch.tag=0;
   
    }
    
    
    if(indexPath.row==1)
    {
        if ([[storeTimingsBoolArray objectAtIndex:1] intValue]==0) {
            
            cell.workingDaySwitch.on=NO;
        }
        
        else
        {
            cell.workingDaySwitch.on=YES;
        }
       
        cell.workingDaySwitch.tag=1;
       
    }
    
    
    if(indexPath.row==2)
    {
        if ([[storeTimingsBoolArray objectAtIndex:2] intValue]==0) {
            
            cell.workingDaySwitch.on=NO;
        }
        
        else
        {
            cell.workingDaySwitch.on=YES;
        }
       
        cell.workingDaySwitch.tag=2;
        
        
    }
    
    
    if(indexPath.row==3)
    {
        if ([[storeTimingsBoolArray objectAtIndex:3] intValue]==0) {
            
            cell.workingDaySwitch.on=NO;
        }
        
        else
        {
            cell.workingDaySwitch.on=YES;
        }
       
        cell.workingDaySwitch.tag=3;
        
    }
    
    if(indexPath.row==4)
    {
        if ([[storeTimingsBoolArray objectAtIndex:4] intValue]==0) {
            
            cell.workingDaySwitch.on=NO;
        }
        
        else
        {
            cell.workingDaySwitch.on=YES;
        }
        
        cell.workingDaySwitch.tag=4;
       
    }
    
    
    if(indexPath.row==5)
    {
        if ([[storeTimingsBoolArray objectAtIndex:5] intValue]==0) {
            
            cell.workingDaySwitch.on=NO;
        }
        
        else
        {
            cell.workingDaySwitch.on=YES;
        }
        cell.workingDaySwitch.tag=5;
    }
    
    
    if(indexPath.row==6)
    {
        if ([[storeTimingsBoolArray objectAtIndex:6] intValue]==0)
        {
            cell.workingDaySwitch.on=NO;
        }
        
        else
        {
            [customRighNavButton setHidden:YES];
            
            cell.workingDaySwitch.on=YES;
        }
       
        cell.workingDaySwitch.tag=6;
    }
    
    
    return cell;
    
    
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


- (IBAction)toBtnClicked:(id)sender
{
    
    if (![customRighNavButton isHidden])
    {
        
        [customRighNavButton setHidden:YES];
        
    }

    [closedDaySubView   setHidden:YES];
    [pickerSubView setHidden:NO];
    [closedDaySubView   setHidden:YES];
    [setFromStoreTimeButton setHidden:YES];
    [setToStoreTimeButton setHidden:NO];
    
    
    
}

- (IBAction)fromBtnClicked:(id)sender
{
    
    
    if (![customRighNavButton isHidden])
    {
        
        [customRighNavButton setHidden:YES];
        
    }

    [closedDaySubView   setHidden:YES];
    [setFromStoreTimeButton setHidden:NO];
    [setToStoreTimeButton setHidden:YES];
    [pickerSubView  setHidden:NO];
    
}

- (IBAction)setFromStoreTime:(id)sender
{
    [closedDaySubView   setHidden:NO];
    
    
    if ([storeTimingsArray isEqual:[NSNull null]] || [storeTimingsArray count]==0 )
    {
          [customRighNavButton setHidden:YES];
    }
    else
    {
          [customRighNavButton setHidden:NO];
        
    }
    
  
    
    if (hour==NULL)
    {
        hour=@"1";
    }
    
    
    if (min==NULL)
    {
        min=@"00";
    }
    
    
    if (period==NULL)
    {
        period=@"AM";
    }
    
    
    startHr = hour;
    startPeriod = period;
    
    
    
    
    NSString *fromTimeString=[NSString stringWithFormat:@"%@:%@ %@",hour,min,period];
    
    fromTextView.text=fromTimeString;
       if([hour isEqualToString:@"12"] || [hour isEqualToString:@"11"] || [hour isEqualToString:@"10"])
    {
        fromTextView.frame = CGRectMake(-30,25,180,35);
    }
    else
    {
        fromTextView.frame = CGRectMake(-35,25,180,35);

    }
    
    if([fromTextView.text isEqualToString:toTextView.text])
    {
        [AlertViewController CurrentView:self.view errorString:@"Start time and end time should be different" size:0 success:NO];
    }
    
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
        min=@"00";
    }
    
    
    if (period==NULL)
    {
        period=@"AM";
    }
    
    
    endHr = hour;
    endPeriod = period;
    
    if([endPeriod isEqualToString:@"AM"] && [startPeriod isEqualToString:@"AM"])
    {
      if(endHr-startHr<0)
      {
          [AlertViewController CurrentView:self.view errorString:@"Choose Valid Timing" size:0 success:NO];
          
          if ([storeTimingsArray isEqual:[NSNull null]] || [storeTimingsArray count]==0 )
          {
              [customRighNavButton setHidden:YES];
          }
          else
          {
              [customRighNavButton setHidden:NO];
              
          }
      }
    }
    else if([endPeriod isEqualToString:@"PM"] && [startPeriod isEqualToString:@"PM"])
    {
        if(endHr-startHr<0)
        {
            [AlertViewController CurrentView:self.view errorString:@"Choose Valid Timing" size:0 success:NO];
            
            if ([storeTimingsArray isEqual:[NSNull null]] || [storeTimingsArray count]==0 )
            {
                [customRighNavButton setHidden:YES];
            }
            else
            {
                [customRighNavButton setHidden:NO];
                
            }
        }
    }
    if([hour isEqualToString:@"12"] || [hour isEqualToString:@"11"] || [hour isEqualToString:@"10"])
    {
         timingCloseLabel.frame = CGRectMake(232,5,180,35);
    }
    else
    {
         timingCloseLabel.frame = CGRectMake(235,5,180,35);
    }
   
    
    NSString *toTimeString=[NSString stringWithFormat:@"%@:%@ %@",hour,min,period];
    
    toTextView.text=toTimeString;
    
    
    [pickerSubView setHidden:YES];
    if ([storeTimingsArray isEqual:[NSNull null]] || [storeTimingsArray count]==0 )
    {
        [customRighNavButton setHidden:YES];
    }
    else
    {
        [customRighNavButton setHidden:NO];
        
    }
    
    
    if([fromTextView.text isEqualToString:toTextView.text])
    {
        [AlertViewController CurrentView:self.view errorString:@"Start time and end time should be different" size:0 success:NO];
        
        [customRighNavButton setHidden:YES];
    }
    
    
}

- (IBAction)hidePickerView:(id)sender
{
    [closedDaySubView setHidden:NO];
    [pickerSubView  setHidden:YES];
    
}

-(void)setRighttNavBarButton
{
    
    customRighNavButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [customRighNavButton addTarget:self action:@selector(updateMessage) forControlEvents:UIControlEventTouchUpInside];
    
    //[customRighNavButton setBackgroundImage:[UIImage imageNamed:@"checkmark.png"]  forState:UIControlStateNormal];
    
    [customRighNavButton setFrame:CGRectMake(260,21, 60, 30)];
    
    
    [customRighNavButton setTitle:@"Save" forState:UIControlStateNormal];
    [customRighNavButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    customRighNavButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue-Regular" size:17.0f];

    
    if (version.floatValue<7.0) {

        [customRighNavButton setFrame:CGRectMake(280,5,30,30)];
        
        [navBar addSubview:customRighNavButton];

    }
    
    else
    {
        [customRighNavButton setFrame:CGRectMake(260,21, 60, 30)];
        
        [navBar addSubview:customRighNavButton];

        UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithCustomView:customRighNavButton];
        
        self.navigationItem.rightBarButtonItem=rightBarBtn;

    }
    
    [customRighNavButton setHidden:YES];
}


-(void)updateMessage
{
    if([fromTextView.text isEqualToString:toTextView.text])
    {
        [AlertViewController CurrentView:self.view errorString:@"Start time and end time should be different" size:0 success:NO];
    }
   else if([endPeriod isEqualToString:@"AM"] && [startPeriod isEqualToString:@"AM"])
    {
        if(endHr-startHr<0)
        {
            [AlertViewController CurrentView:self.view errorString:@"Choose Valid Timing" size:0 success:NO];
            
            [customRighNavButton setHidden:YES];
        }
        else
        {
            [self performSelector:@selector(UpdateTimings) withObject:nil afterDelay:0.1];
        }
    }
    else if([endPeriod isEqualToString:@"PM"] && [startPeriod isEqualToString:@"PM"])
    {
        if(endHr-startHr<0)
        {
            [AlertViewController CurrentView:self.view errorString:@"Choose Valid Timing" size:0 success:NO];
            
            [customRighNavButton setHidden:YES];
        }
        else
        {
            [self performSelector:@selector(UpdateTimings) withObject:nil afterDelay:0.1];
        }
    }
    else
    {
        [self performSelector:@selector(UpdateTimings) withObject:nil afterDelay:0.1];
    }
    
    
}


-(void)UpdateTimings
{
    
    [activitySubView setHidden:NO];
    
    NSMutableArray *_timingArray=[[NSMutableArray alloc]init];
    
    
    for (int i=0; i<[storeTimingsBoolArray count]; i++)
    {
        
        if ([[storeTimingsBoolArray objectAtIndex:i] isEqualToString:@"0"])
        {
            [_timingArray insertObject:@"00,00" atIndex:i];
        }
        
        
        else
        {
            
            [_timingArray insertObject:[NSString stringWithFormat:@"%@,%@",fromTextView.text,toTextView.text] atIndex:i];
            
        }
        
    }
    
    
    
    NSString *uploadString=[NSString stringWithFormat:@"%@#%@#%@#%@#%@#%@#%@",[_timingArray objectAtIndex:0],[_timingArray objectAtIndex:1],[_timingArray objectAtIndex:2],[_timingArray objectAtIndex:3],[_timingArray objectAtIndex:4],[_timingArray objectAtIndex:5],[_timingArray objectAtIndex:6]];
    
    NSDictionary *upLoadDictionary=[[NSDictionary alloc]init];
    
    upLoadDictionary=@{@"value":uploadString,@"key":@"TIMINGS"};
    
    NSMutableArray *uploadArray=[[NSMutableArray alloc]init];
    
    [uploadArray addObject:upLoadDictionary];
    
    UpdateStoreData *strData=[[UpdateStoreData  alloc]init];
    
    strData.delegate=self;
    
    strData.uploadArray=[[NSMutableArray alloc]init];
    
    [strData.uploadArray addObjectsFromArray:uploadArray];
    
    [strData updateStore:uploadArray];
    
    [uploadArray removeAllObjects];
    
        
}


-(void)storeUpdateComplete
{
    
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"update_Business timings"];

    NSDictionary *closedDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:@"00",@"From",@"00",@"To", nil];
    
    NSDictionary *openDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:fromTextView.text,@"From",toTextView.text,@"To",nil];
    
    NSMutableArray *timingReplacementArray=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[storeTimingsBoolArray count]; i++)
    {
        
        if ([[storeTimingsBoolArray objectAtIndex:i] isEqualToString:@"0"])
        {
            [timingReplacementArray insertObject:closedDictionary atIndex:i];
        }
        
        else
        {
            [timingReplacementArray insertObject:openDictionary atIndex:i];
        }
        
    }
    
    
    [appDelegate.storeTimingsArray removeAllObjects];
    
    [appDelegate.storeTimingsArray addObjectsFromArray:timingReplacementArray];
    
    

    [self updateView];
    
}


-(void)storeUpdateFailed;
{

    UIAlertView *failedAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Business information  could not be updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [failedAlert show];
    
    failedAlert=nil;

    
}


-(void)updateView
{
    
    [self removeSubView];
    
}


-(void)removeSubView
{


        [activitySubView setHidden:YES];
        
        [closedDaySubView setHidden:NO];
        
        [customRighNavButton setHidden:YES];
        
//        UIAlertView *succcessAlert=[[UIAlertView alloc]initWithTitle:@"Business Hours Updated!" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        
//        [succcessAlert show];
    
    [AlertViewController CurrentView:self.view errorString:@"Business Hours Updated" size:0 success:YES];
        
//        succcessAlert=nil;
    
    
    
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
    closedDaySubView = nil;
    activitySubView = nil;
    customSwitch0 = nil;
    customSwitch3 = nil;
    customSwitch4 = nil;
    customSwitch2 = nil;
    customSwitch6 = nil;
    customSwitch7 = nil;
    [super viewDidUnload];
}


-(void)viewWillDisappear:(BOOL)animated
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];


}


@end
