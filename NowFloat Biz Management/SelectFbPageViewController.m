//
//  SelectFbPageViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 26/04/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "SelectFbPageViewController.h"

@interface SelectFbPageViewController ()

@end

@implementation SelectFbPageViewController

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

    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return appDelegate.fbUserAdminIdArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static  NSString *identifier = @"TableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=[appDelegate.fbUserAdminArray objectAtIndex:[indexPath row]];
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    
    return cell;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([selectedCell accessoryType] == UITableViewCellAccessoryNone)
    {
        [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        NSArray *a1=[NSArray arrayWithObject:[appDelegate.fbUserAdminArray objectAtIndex:[indexPath  row]]];
        
        NSArray *a2=[NSArray arrayWithObject:[appDelegate.fbUserAdminAccessTokenArray objectAtIndex:[indexPath row]]];
        
        NSArray *a3=[NSArray arrayWithObject:[appDelegate.fbUserAdminIdArray objectAtIndex:[indexPath row]]];
        
        [appDelegate.socialNetworkNameArray addObjectsFromArray:a1];
        [appDelegate.socialNetworkAccessTokenArray addObjectsFromArray:a2];
        [appDelegate.socialNetworkIdArray addObjectsFromArray:a3];
        
        
        
    }
    else
    {
        [selectedCell setAccessoryType:UITableViewCellAccessoryNone];
        [appDelegate.socialNetworkNameArray removeObject:[appDelegate.fbUserAdminArray   objectAtIndex:[indexPath row ]]];
        [appDelegate.socialNetworkIdArray removeObject:[appDelegate.fbUserAdminIdArray objectAtIndex:[indexPath row]]];
        [appDelegate.socialNetworkAccessTokenArray removeObject:[appDelegate.fbUserAdminAccessTokenArray objectAtIndex:[indexPath row] ]];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
