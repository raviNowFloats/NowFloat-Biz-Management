//
//  BusinessAddressViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BusinessAddressViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BusinessAddressViewController ()

@end

@implementation BusinessAddressViewController


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

    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];

    self.title = NSLocalizedString(@"Business Address", nil);
    
    
    
    
    
    [addressTextView.layer setCornerRadius:6.0f];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"detail-btn.png"]
                     style:UIBarButtonItemStyleBordered
                    target:revealController action:@selector(revealToggle:)];
    
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    
    if ([appDelegate.storeDetailDictionary objectForKey:@"Address"]!=[NSNull null])
    {
    
    addressTextView.text=[appDelegate.storeDetailDictionary objectForKey:@"Address"];
        
    }
    
    else
    {
    
    addressTextView.text=@"No Description";
    
    }

    
    UIButton *customButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customButton setFrame:CGRectMake(0, 0, 55, 30)];
    
    [customButton addTarget:self action:@selector(updateMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"update.png"]  forState:UIControlStateNormal];
    
    UIBarButtonItem *postMessageButtonItem = [[UIBarButtonItem alloc]initWithCustomView:customButton];
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;
    
}


-(void)updateMessage
{

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Uh-Oh" message:@"Please call our customer care to change your address" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert setTag:1];
    [alert show];
    alert=nil;

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    addressTextView = nil;
    [super viewDidUnload];
}




@end
