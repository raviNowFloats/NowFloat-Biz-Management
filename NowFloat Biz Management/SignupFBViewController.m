//
//  SignupFBViewController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 8/1/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "SignupFBViewController.h"

@interface SignupFBViewController ()

@end

@implementation SignupFBViewController
@synthesize text;

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
    
   
    
    [self align];
}


-(void)align
{
     text.frame = CGRectMake(150, 150, 320, 400);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
