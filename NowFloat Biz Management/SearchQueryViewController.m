//
//  SearchQueryViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 14/07/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "SearchQueryViewController.h"
#import "UIColor+HexaString.h"
#import "Mixpanel.h"

@interface SearchQueryViewController ()

@end


#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 25.0f


@implementation SearchQueryViewController

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
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    
    self.navigationController.navigationBarHidden=YES;
    
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    searchQueryArray=[[NSMutableArray alloc]init];
    
    searchDateArray=[[NSMutableArray alloc]init];
    
    
    //Create NavBar here
    
    CGFloat width = self.view.frame.size.width;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:
                               CGRectMake(0,0,width,44)];
    
    [self.view addSubview:navBar];
    
    //Create the custom back bar button here....
    
    UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    
    backButton.frame = CGRectMake(5,0,50,44);
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:backButton];
    
    //Create a custom title here
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(85, 13, 150, 20)];
    
    headerLabel.text=@"Search Queries";
    
    headerLabel.backgroundColor=[UIColor clearColor];
    
    headerLabel.textAlignment=NSTextAlignmentCenter;
    
    headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
    
    headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
    
    [navBar addSubview:headerLabel];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@SearchQuery.plist",appDelegate.storeTag]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSMutableArray *plistArray=[[NSMutableArray alloc]init];
    
    
    
    if (![fileManager fileExistsAtPath: path])
    {
        
        plistArray=[NSMutableArray arrayWithObject:@""];
        
    }
    
    else
    {
        
        [plistArray addObjectsFromArray:[NSArray arrayWithContentsOfFile:path]];
        
    }
        
    for (int i=0; i<[plistArray count]; i++)
    {
        
        [searchQueryArray insertObject:[[plistArray objectAtIndex:i]objectForKey:@"keyword" ] atIndex:i];
     
        [searchDateArray insertObject:[[plistArray objectAtIndex:i]objectForKey:@"createdOn" ] atIndex:i];
        
    }
    
    
}

#pragma UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{

    return searchQueryArray.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    NSString *identifierString=@"IdentifierString";
    
    UILabel *label = nil;
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierString];
    
    if (cell==nil) {
        
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
        
        
        UIImageView *imageViewArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewArrow setTag:6];
        [imageViewArrow   setBackgroundColor:[UIColor clearColor] ];
        [cell addSubview:imageViewArrow];
        
        UIImageView *searchImage=[[UIImageView alloc]initWithFrame:CGRectZero];
        [searchImage setTag:7];
        [cell addSubview:searchImage];

        
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

    
    
    if (!label)
        
    label = (UILabel*)[cell viewWithTag:1];
    UIImageView *topImage=(UIImageView *)[cell viewWithTag:8];
    UIImageView *bottomImage=(UIImageView *)[cell viewWithTag:9];
    UIImageView *bgImage=(UIImageView *)[cell viewWithTag:2];
    UILabel *dateLabel=(UILabel *)[cell viewWithTag:4];
    UIImageView *searchImageView=(UIImageView *)[cell viewWithTag:7];
    UIImageView *bgArrowView=(UIImageView *)[cell viewWithTag:6];

    
    
    NSString *dateString=[searchDateArray objectAtIndex:[indexPath row] ];
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
    
    NSString *searchDate=[dateFormatter stringFromDate:date];
    
    NSString *text = [searchQueryArray objectAtIndex:[indexPath row]];
    
    NSString *stringData;
    
    stringData=[NSString stringWithFormat:@"%@\n\n%@\n",text,searchDate];

    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]  constrainedToSize:constraint lineBreakMode:nil];

    [label setText:stringData];
    [label setFrame:CGRectMake(52,CELL_CONTENT_MARGIN+2,254, MAX(size.height, 44.0f)+5)];
    label.textColor=[UIColor colorWithHexString:@"3c3c3c"];
    [label setBackgroundColor:[UIColor whiteColor]];
    
    [dateLabel setText:searchDate];
    [dateLabel setBackgroundColor:[UIColor whiteColor]];
    [dateLabel setFrame:CGRectMake(52,label.frame.size.height,230,30)];
    dateLabel.textColor=[UIColor colorWithHexString:@"afafaf"];
    [dateLabel setTextAlignment:NSTextAlignmentLeft];
    [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
    [dateLabel setAlpha:1];
    
    [topImage setFrame:CGRectMake(42,CELL_CONTENT_MARGIN-5, 269,5)];
    [topImage setImage:[UIImage imageNamed:@"top_cell.png"]];
    
    [bottomImage setFrame:CGRectMake(42, MAX(size.height, 44.0f)+30, 269, 5)];
    [bottomImage setImage:[UIImage imageNamed:@"bottom_cell.png"]];
    
    [bgImage setFrame:CGRectMake(42,CELL_CONTENT_MARGIN,269, MAX(size.height+5, 44.0f))];
    [bgImage setImage:[UIImage imageNamed:@"middle_cell.png"]];
    
    [searchImageView setImage:[UIImage imageNamed:@"searchicon.png"]];
    [searchImageView setFrame:CGRectMake(5,40,25,25)];

    bgArrowView.image=[UIImage imageNamed:@"triangle.png"];
    [bgArrowView setFrame:CGRectMake(30,50,12,12)];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}



#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSString *dateString=[searchDateArray objectAtIndex:[indexPath row] ];
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
    
    NSString *searchDate=[dateFormatter stringFromDate:date];

    NSString *stringData=[NSString stringWithFormat:@"%@\n\n%@\n",[searchQueryArray objectAtIndex:[indexPath row]],searchDate];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height,44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);

    
    
}



#pragma Convert Unix Timestamp
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

-(void)back
{
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Back from Search Query"];
    
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
