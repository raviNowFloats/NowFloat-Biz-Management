//
//  NewVersionController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/17/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "NewVersionController.h"
#import "UIColor+HexaString.h"
#import "SWRevealViewController.h"

@interface NewVersionController ()<SWRevealViewControllerDelegate>
{
    float viewHeight;
}

@end

@implementation NewVersionController

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
    
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.navigationController.navigationBarHidden=YES;
        
}


- (IBAction)moveBack:(id)sender
{
    [appDelegate.storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"fromNewVersion"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}


@end
