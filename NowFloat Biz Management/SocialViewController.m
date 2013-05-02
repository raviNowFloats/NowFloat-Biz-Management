//
//  SocialViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 25/04/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "SocialViewController.h"
#import "SettingsController.h"

@interface SocialViewController ()

@end

@implementation SocialViewController

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
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];

    isEdit=NO;
    
    listOfItems=[[NSMutableArray alloc]init];
    
    socialNetworksArray=[[NSMutableArray alloc]init];
    
    fbPageNameArray=[[NSMutableArray alloc]init];
    
    fbPageIdArray=[[NSMutableArray alloc]init];
    
    fbPageAccessTokenArray=[[NSMutableArray alloc]init];
    
    
    sectionNameArray=[[NSMutableArray alloc]initWithObjects:@"Facebook",@"Facebook page's", nil];
    
    
    if ([userDefaults objectForKey:@"NFManageFBAccessToken"] && [userDefaults objectForKey:@"NFManageFBUserId"])
    {
        
        [socialNetworksArray addObject:[userDefaults objectForKey:@"NFFacebookName"]];
        
    }
    
    
    NSDictionary *s1=[NSDictionary dictionaryWithObject:socialNetworksArray forKey:@"SocialNetworks"];

    
    
    if (appDelegate.socialNetworkNameArray.count)
    {
        [fbPageNameArray addObjectsFromArray:appDelegate.socialNetworkNameArray];
        [fbPageAccessTokenArray addObjectsFromArray:appDelegate.socialNetworkAccessTokenArray];
        [fbPageIdArray addObjectsFromArray:appDelegate.socialNetworkIdArray];            
    }
        
    
    NSDictionary *s2=[NSDictionary dictionaryWithObject:fbPageNameArray forKey:@"SocialNetworks"];
    
    [listOfItems addObject:s1];
    [listOfItems addObject:s2];
    
    UIBarButtonItem *editButton=[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editMode) ];
    self.navigationItem.rightBarButtonItem=editButton;
            
}





-(void)editMode
{
    if (!isEdit)
    {
        isEdit=YES;
        [socialNetworkTableView setEditing:YES  animated:YES];
    }
    else
    {
        isEdit=NO;
        [socialNetworkTableView setEditing:NO  animated:YES];
    }

}


#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;// Default is 1 if not implemented
{
    return [listOfItems count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{

    NSString *sectionName;
    
    sectionName=[sectionNameArray objectAtIndex:section];

    return sectionName;

}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSDictionary *dictionary = [listOfItems objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"SocialNetworks"];
    return [array count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"SocialNetworks"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    
    return cell;
}


#pragma UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}



- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionName;
    
    sectionName=[sectionNameArray objectAtIndex:section];

    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
    label.text = sectionName;
    label.font=[UIFont fontWithName:@"Helvetica" size:18.0];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    return headerView;
}
                      




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==0)
    {
        [socialNetworksArray removeObjectAtIndex:indexPath.row];
        
        NSMutableArray *_selectedArray=[NSMutableArray arrayWithArray:sectionNameArray];
        
        [_selectedArray removeObjectAtIndex:[indexPath section]];
        
        [sectionNameArray addObjectsFromArray:_selectedArray];
        
        [userDefaults removeObjectForKey:@"NFFacebookName"];
        
        [userDefaults removeObjectForKey:@"NFManageFBUserId"];
        
        [userDefaults removeObjectForKey:@"NFManageFBAccessToken"];
        
        [userDefaults synchronize];

        [tableView reloadData];
    }
    
    else if ([indexPath section]==1)
    {
        [fbPageNameArray removeObjectAtIndex:indexPath.row];

        [fbPageIdArray removeObjectAtIndex:indexPath.row];
        
        [fbPageAccessTokenArray removeObjectAtIndex:indexPath.row];
        
        [appDelegate.socialNetworkNameArray removeAllObjects];
        
        [appDelegate.socialNetworkIdArray removeAllObjects];
        
        [appDelegate.socialNetworkAccessTokenArray removeAllObjects];
        
        [appDelegate.socialNetworkNameArray addObjectsFromArray:fbPageNameArray];
        
        [appDelegate.socialNetworkIdArray addObjectsFromArray:fbPageIdArray];
        
        [appDelegate.socialNetworkAccessTokenArray addObjectsFromArray:fbPageAccessTokenArray];
        [tableView reloadData];
    }
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section==0)
    {
       
        [tableView reloadData];

    }
    
    
    else if (indexPath.section==1)
    {

        [tableView reloadData];

    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    socialNetworkTableView = nil;
    [super viewDidUnload];
}
@end
