//
//  TalkToBuisnessViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 25/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "TalkToBuisnessViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface TalkToBuisnessViewController ()

@end

@implementation TalkToBuisnessViewController
@synthesize talkToBuisnessTableView ;

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
    self.title = NSLocalizedString(@"Inbox", nil);
    
    SWRevealViewController *revealController = [self revealViewController];

    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:revealController action:@selector(revealToggle:)];

    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;

   
    
    
    //Dummy Array
    messageArray=[[NSMutableArray alloc]initWithObjects:@"Ajax",@"United",@"City",@"Saints",@"Magpies",@"The Blues",@"Gunners",@"Spurs",@"Toffees", nil];
    
    dateArray=[[NSMutableArray alloc]initWithObjects:@"/Date(1361320140000)/",@"/Date(1359829800000)/", @"/Date(1359354062847)/",@"/Date(1358249616884)/",@"/Date(1358243329249)/",@"/Date(1359829800000)/",@"/Date(1358249616884)/",@"/Date(1358249616884)/",@"/Date(1361320140000)/",nil];
    
    messageHeadingArray=[[NSMutableArray alloc]initWithObjects:@"Message From NowFloats",@"Message From NowFloats",@"Message From NowFloats",@"Message From NowFloats",@"Message From NowFloats",@"Message From NowFloats",@"Message From NowFloats",@"Message From NowFloats",@"Message From NowFloats", nil];
    
    
}


#pragma UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{

    return messageArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    NSString *staticIdentifier=@"Identifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:staticIdentifier];
    
    if (cell==nil)
    
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:staticIdentifier];
    
        
        UILabel *backgroundLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 280, 100)];
        
        backgroundLabel.tag=1;
        [backgroundLabel setBackgroundColor:[UIColor whiteColor]];
        [cell addSubview:backgroundLabel];
        [backgroundLabel.layer setCornerRadius:5.0 ];
        
        UILabel *underLine=[[UILabel alloc]initWithFrame:CGRectMake(30,30,259, 1)];
        [underLine setBackgroundColor:[UIColor blackColor]];
        [cell addSubview:underLine];
        
        
        UILabel *messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,31, 259,49)];
        messageLabel.tag=2;
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:messageLabel];
        
        
        UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,80, 259, 25)];
        dateLabel.tag=3;
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:dateLabel];
    
        
        UILabel *messageHeaderLabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 5, 234, 25)];
        [messageHeaderLabel setTag:4];
        [messageHeaderLabel setBackgroundColor:[UIColor clearColor ]];
        [cell addSubview:messageHeaderLabel];
        
        
        
        UIImageView *msgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(35,10, 15, 15)];
        
        [msgImageView setImage:[UIImage imageNamed:@"logo.png"]];
        [cell   addSubview:msgImageView];
        
    }
    
    
    
    
    NSString *dateString=[dateArray objectAtIndex:[indexPath row]];
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
    
    UILabel *msgLabel=(UILabel *)[cell viewWithTag:2];
    msgLabel.text=[messageArray objectAtIndex:[indexPath row]];
    [msgLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
    
    UILabel *dateLbl=(UILabel *)[cell viewWithTag:3];
    dateLbl.text=dealDate;
    [dateLbl setFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic" size:10]];
    [dateLbl setTextAlignment:NSTextAlignmentRight];
    
    UILabel *msgHeadingLbl=(UILabel *)[cell viewWithTag:4];
    msgHeadingLbl.text=[messageHeadingArray objectAtIndex:[indexPath row]];
    [msgHeadingLbl setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12]];
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

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

- (void)viewDidUnload {
    [self setTalkToBuisnessTableView:nil];
    [super viewDidUnload];
}
@end
