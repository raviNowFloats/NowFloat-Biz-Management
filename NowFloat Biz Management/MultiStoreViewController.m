//
//  MultiStoreViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 22/05/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "MultiStoreViewController.h"
#import "LoginViewController.h"
#import "GetFpDetails.h"
#import "BizMessageViewController.h"

@interface MultiStoreViewController ()<updateDelegate>

@end

@implementation MultiStoreViewController
@synthesize delegate;


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
    
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        
    userdetails=[NSUserDefaults standardUserDefaults];
    
    storeArray=[[NSMutableArray alloc]initWithArray:appDelegate.multiStoreArray];
    
}



#pragma UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    
    return storeArray.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{


    static  NSString *identifier = @"TableViewCell";
    

    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];    
    
    if (!cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text=[storeArray objectAtIndex:[indexPath row]];
    
    return cell;
    

}


#pragma UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{

    [userdetails setObject:[storeArray objectAtIndex:[indexPath row]] forKey:@"userFpId"];
    [userdetails synchronize];
    
    [self dismissModalViewControllerAnimated:YES];

    [delegate performSelector:@selector(downloadStoreDetails)];
    
}



-(void)downloadFinished
{    
    
    
    //BizMessageViewController *bizController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
    
    
}


-(void)downloadFailedWithError
{

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    multiStoreTableView = nil;
    [super viewDidUnload];
}
@end
