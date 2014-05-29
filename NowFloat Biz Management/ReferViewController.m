//
//  ReferViewController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/27/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "ReferViewController.h"
#import "EmailShareController.h"
#import "MobileShareController.h"

@interface ReferViewController ()
{
    UITabBar *referEmailBar,*referMsgBar,*referFBBar,*referTwitterBar;
    UIScrollView *referScrollView;
    UITabBarItem *referEmail,*referMsg, *referFB,*referTwitter;
    float viewHeight;
    NSString *version;
}

@end

@implementation ReferViewController

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
    
    referScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, 480, 55)];
    
    referEmailBar = [[UITabBar alloc] initWithFrame:CGRectMake(0,0, 100, 55)];
    
    referMsgBar = [[UITabBar alloc] initWithFrame:CGRectMake(100, 0, 100, 55)];
    
    referFBBar = [[UITabBar alloc] initWithFrame:CGRectMake(200, 0, 100, 55)];
    
    referTwitterBar = [[UITabBar alloc] initWithFrame:CGRectMake(300, 0, 100, 55)];
    
    [referEmailBar setBackgroundImage:[UIImage imageNamed:@"Refer-mail1.png"]];
    
    [referMsgBar setBackgroundImage:[UIImage imageNamed:@"Refer-SMS1.png"]];
    
    [referFBBar setBackgroundImage:[UIImage imageNamed:@"refer-FB1.png"]];
    
    [referTwitterBar setBackgroundImage:[UIImage imageNamed:@"refer-twitter1.png"]];
    
    [referScrollView addSubview:referEmailBar];
    
    [referScrollView addSubview:referMsgBar];
    
    [referScrollView addSubview:referFBBar];
    
    [referScrollView addSubview:referTwitterBar];
    
    [referScrollView setContentSize:CGSizeMake(referScrollView.frame.size.width, referScrollView.frame.size.height)];
    
    
    [self.view addSubview:referScrollView];
    
   
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
