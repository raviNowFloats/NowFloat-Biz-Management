//
//  SitemeterDetailView.m
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 25/08/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "SitemeterDetailView.h"
#import "sitemetercell.h"
#import "UIColor+HexaString.h"

@interface SitemeterDetailView ()
{
    float viewHeight;
    
    NSMutableArray *percentageArray, *headArray, *descArray;
    
    NSMutableArray *completedHeadArray, *completedPercentageArray, *completedDescArray;
}

@end

@implementation SitemeterDetailView

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
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    version = [[UIDevice currentDevice] systemVersion];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            viewHeight=480;
        }
        
        else
        {
            viewHeight=568;
        }
    }
    
    percentageArray = [[NSMutableArray alloc] init];
    
    headArray = [[NSMutableArray alloc] init];
    
    descArray = [[NSMutableArray alloc] init];
    
    completedDescArray = [[NSMutableArray alloc] init];
    
    completedHeadArray = [[NSMutableArray alloc] init];
    
    completedPercentageArray = [[NSMutableArray alloc] init];
    
    if([appDelegate.businessName length] == 0)
    {
        [percentageArray addObject:@"5 %"];
        [headArray addObject:@"Business Name"];
        [descArray addObject:@"Enter your Business name"];
    }
    else
    {
        [completedPercentageArray addObject:@"5 %"];
        [completedHeadArray addObject:@"Business Name"];
        [completedDescArray addObject:@"Enter your Business name"];
    }
    
    if([appDelegate.businessDescription length] == 0)
    {
        [percentageArray addObject:@"10 %"];
        [headArray addObject:@"Business Desc"];
        [descArray addObject:@"Enter your Business Desc"];
    }
    else
    {
        [completedPercentageArray addObject:@"10 %"];
        [completedHeadArray addObject:@"Business Desc"];
        [completedDescArray addObject:@"Enter your Business Desc"];
    }
    
    if([appDelegate.storeCategoryName length] == 0)
    {
        [percentageArray addObject:@"5 %"];
        [headArray addObject:@"Business Category"];
        [descArray addObject:@"Enter your Business category"];
    }
    else
    {
        [completedPercentageArray addObject:@"5 %"];
        [completedHeadArray addObject:@"Business Category"];
        [completedDescArray addObject:@"Enter your Business Category"];
    }
    
    if([appDelegate.primaryImageUri length] == 0)
    {
        [percentageArray addObject:@"10 %"];
        [headArray addObject:@"Featured Image"];
        [descArray addObject:@"Upload your featured image"];
    }
    else
    {
        [completedPercentageArray addObject:@"10 %"];
        [completedHeadArray addObject:@"Featured Image"];
        [completedDescArray addObject:@"Upload your featured image"];
    }
    
    if([appDelegate.storeDetailDictionary objectForKey:@"PrimaryNumber"] == NULL)
    {
        [percentageArray addObject:@"5 %"];
        [headArray addObject:@"Primary Number"];
        [descArray addObject:@"Enter your Primary number"];
    }
    else
    {
        [completedPercentageArray addObject:@"5 %"];
        [completedHeadArray addObject:@"Primary Number"];
        [completedDescArray addObject:@"Enter your Primary Number"];
    }
    if([appDelegate.storeDetailDictionary objectForKey:@"Email"] == NULL)
    {
        [percentageArray addObject:@"5 %"];
        [headArray addObject:@"Email"];
        [descArray addObject:@"Enter your Email"];
    }
    else
    {
        [completedPercentageArray addObject:@"5 %"];
        [completedHeadArray addObject:@"Email"];
        [completedDescArray addObject:@"Enter your Email"];
    }
    if([appDelegate.storeDetailDictionary objectForKey:@"Address"] == NULL)
    {
        [percentageArray addObject:@"10 %"];
        [headArray addObject:@"Business Address"];
        [descArray addObject:@"Enter your Business Address"];
    }
    else
    {
        [completedPercentageArray addObject:@"10 %"];
        [completedHeadArray addObject:@"Business Address"];
        [completedDescArray addObject:@"Enter your Business Address"];
    }
    if([appDelegate.storeDetailDictionary objectForKey:@"Timings"] == NULL)
    {
        [percentageArray addObject:@"5 %"];
        [headArray addObject:@"Business Timings"];
        [descArray addObject:@"Enter your Business Timings"];
    }
    else
    {
        [completedPercentageArray addObject:@"5 %"];
        [completedHeadArray addObject:@"Business Timings"];
        [completedDescArray addObject:@"Enter your Business Timings"];
    }
    if([appDelegate.socialNetworkNameArray objectAtIndex:0] == NULL)
    {
        [percentageArray addObject:@"10 %"];
        [headArray addObject:@"Facebook"];
        [descArray addObject:@"Connect to facebook/twitter"];
    }
    else
    {
        [completedPercentageArray addObject:@"10 %"];
        [completedHeadArray addObject:@"Facebook"];
        [completedDescArray addObject:@"Connect to facebook/twitter"];
    }
    
    if([appDelegate.dealDescriptionArray count] < 5)
    {
        [percentageArray addObject:@"10 %"];
        [headArray addObject:@"Update"];
        [descArray addObject:@"Update your website"];
    }
    else
    {
        [completedPercentageArray addObject:@"10 %"];
        [completedHeadArray addObject:@"Update"];
        [completedDescArray addObject:@"Update your website"];
    }
    if(![appDelegate.storeWidgetArray containsObject:@"SITESENSE"])
    {
        [percentageArray addObject:@"5 %"];
        [headArray addObject:@"Buy Auto SEO"];
        [descArray addObject:@"Boost your site with auto seo for free"];
    }
    else
    {
        [completedPercentageArray addObject:@"5 %"];
        [completedHeadArray addObject:@"Buy Auto SEO"];
        [completedDescArray addObject:@"Boost your site with auto seo for free"];
    }
    if([appDelegate.storeRootAliasUri isEqualToString:@""])
    {
        [percentageArray addObject:@"10 %"];
        [headArray addObject:@"Buy .com"];
        [descArray addObject:@"Book your own domain"];
    }
    else
    {
        [completedPercentageArray addObject:@"10 %"];
        [completedHeadArray addObject:@"Buy .com"];
        [completedDescArray addObject:@"Book your own domain"];
    }
    
    
    NSLog(@"Completed headtext array is %@ and completed desc array is %@", completedHeadArray, completedDescArray);
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        
        if(section == 0)
        {
            return 1;
        }
        else if(section == 1)
        {
            return headArray.count;
        }
        else
        {
            return completedHeadArray.count;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in number of rows is %@", exception);
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        static NSString *simpleTableIdentifier = @"Sitemetercell";
        
        sitemetercell *cell = (sitemetercell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"sitemetercell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        
        
        
        if(indexPath.section == 0)
        {
            if(indexPath.row ==0)
            {
                UITableViewCell *theCell = [[UITableViewCell alloc] init];
                theCell.frame = CGRectMake(theCell.frame.origin.x, theCell.frame.origin.y, 320, 77);
                
                theCell.contentView.backgroundColor = [UIColor colorFromHexCode:@"#ffb900"];
                
                return theCell;
            }
        }
        
        else if (indexPath.section == 1)
        {
            
            
            cell.percentage.textColor = [UIColor colorFromHexCode:@"#ffb900"];
            cell.percentage.font = [UIFont fontWithName:@"Helvetica" size:16];
            
            cell.headText.textColor = [UIColor colorFromHexCode:@"#6e6e6e"];
            cell.headText.font = [UIFont fontWithName:@"Helvetica" size:18];
            
            cell.descriptionText.textColor= [UIColor colorFromHexCode:@"#8f8f8f"];
            cell.descriptionText.font = [UIFont fontWithName:@"Helvetica" size:14];
            cell.descriptionText.numberOfLines = 2;
            
            cell.percentage.text = [percentageArray objectAtIndex:indexPath.row];
            cell.headText.text = [headArray objectAtIndex:indexPath.row];
            cell.descriptionText = [descArray objectAtIndex:indexPath.row];
            
        }
        else if (indexPath.section == 2)
        {
            cell.percentage.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
            cell.percentage.font = [UIFont fontWithName:@"Helvetica" size:16];
            
            cell.headText.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
            cell.headText.font = [UIFont fontWithName:@"Helvetica" size:18];
            
            cell.descriptionText.textColor= [UIColor colorFromHexCode:@"#b0b0b0"];
            cell.descriptionText.font = [UIFont fontWithName:@"Helvetica" size:14];
            cell.descriptionText.numberOfLines = 2;
            
            NSLog(@" head text is %@ and indexpath row is %d", [completedHeadArray objectAtIndex:indexPath.row], indexPath.row);
            
            cell.percentage.text = [completedPercentageArray objectAtIndex:indexPath.row];
            cell.headText.text = [completedHeadArray objectAtIndex:indexPath.row];
            cell.descriptionText.text = [completedDescArray objectAtIndex:indexPath.row];
        }
        
        
        return cell;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in cell for row is %@", exception);
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
