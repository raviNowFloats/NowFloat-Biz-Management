//
//  WidgetViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 02/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "WidgetViewController.h"
#import "UIColor+HexaString.h"



@interface WidgetViewController ()

@end

@implementation WidgetViewController

- (void)viewDidLoad {
    
	[super viewDidLoad];
    
    UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    
    backButton.frame = CGRectMake(5,0,50,44);
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.navigationBar addSubview:backButton];
    
    widgetTableView.backgroundView=nil;
    
    widgetTableView.opaque=NO;
    
    widgetTableView.backgroundColor=[UIColor blueColor];
    
    
    /*
     Populate array.
	 */
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"3e3e3e"]];
    
	if (arrayOfItems == nil)
    {
		arrayOfItems = [[NSMutableArray alloc] initWithObjects:@"DEFAULT IMAGE",@"PANAROMA",@"CONTACT DETAILS",@"TIMINGS",@"RATINGS",@"TALK TO BUSINESS",@"SITE-SENSE TAG",@"SUBSCRIBERS COUNT",@"VISITORS COUNT",@"SHARE WITH OTHERS", nil];
	}
    
}




-(void)back
{
    
    NSLog(@"Back Button Clicked");
    
    
}





- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.tableView flashScrollIndicators];
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	/*
     Disable reordering if there's one or zero items.
     For this example, of course, this will always be YES.
	 */
	[self setReorderingEnabled:( arrayOfItems.count > 1 )];
	
	return arrayOfItems.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        [cell setBackgroundColor:[UIColor colorWithHexString:@"3e3e3e"]];
        cell.layer.masksToBounds = NO;
        
        cell.layer.cornerRadius = 8.0f;
        
        //Check for the version as opaque does make the BackGround dissapear from iOS==7
        
        NSString *version = [[UIDevice currentDevice] systemVersion];
        
        if ([version floatValue]>=7.0)
        {
            cell.layer.opaque=YES;
        }
        
        cell.layer.needsDisplayOnBoundsChange=YES;
        
        cell.layer.shouldRasterize=YES;
        
        [cell.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
        
        UILabel *backgroundLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 230, 80)];
        backgroundLabel.tag=1;
        
        [cell addSubview:backgroundLabel];
        
    }
    
	
    
    UILabel *bgLabel=(UILabel *)[cell viewWithTag:1];
    
    bgLabel.text = [arrayOfItems objectAtIndex:indexPath.row];
    bgLabel.layer.masksToBounds = YES;
    bgLabel.backgroundColor=[UIColor whiteColor];
    bgLabel.layer.opaque=YES;
    bgLabel.layer.cornerRadius = 8.0f;
    bgLabel.layer.needsDisplayOnBoundsChange=YES;
    bgLabel.layer.shouldRasterize=YES;
    [bgLabel.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    bgLabel.layer.borderWidth = 1.0f;
    bgLabel.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

// should be identical to cell returned in -tableView:cellForRowAtIndexPath:
- (UITableViewCell *)cellIdenticalToCellAtIndexPath:(NSIndexPath *)indexPath forDragTableViewController:(ATSDragToReorderTableViewController *)dragTableViewController
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
	
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.layer.masksToBounds = NO;
    //        [cell setClipsToBounds:YES];
    cell.layer.cornerRadius = 8.0f;
    cell.layer.opaque=YES;
    cell.layer.needsDisplayOnBoundsChange=YES;
    cell.layer.shouldRasterize=YES;
    [cell.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    
    UILabel *bgLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 230, 80)];
    
    bgLabel.text = [arrayOfItems objectAtIndex:indexPath.row];
    bgLabel.layer.masksToBounds = YES;
    bgLabel.backgroundColor=[UIColor whiteColor];
    bgLabel.layer.opaque=YES;
    bgLabel.layer.cornerRadius = 8.0f;
    bgLabel.layer.needsDisplayOnBoundsChange=YES;
    bgLabel.layer.shouldRasterize=YES;
    [bgLabel.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    bgLabel.layer.borderWidth = 1.0f;
    bgLabel.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    [cell addSubview:bgLabel];
    
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
	return cell;
}

/*
 Required for drag tableview controller
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
	NSString *itemToMove = [arrayOfItems objectAtIndex:fromIndexPath.row];
	[arrayOfItems removeObjectAtIndex:fromIndexPath.row];
	[arrayOfItems insertObject:itemToMove atIndex:toIndexPath.row];
    
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}



@end

