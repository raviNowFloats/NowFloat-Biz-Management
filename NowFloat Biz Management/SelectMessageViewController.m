//
//  SelectMessageViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 12/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "SelectMessageViewController.h"
#import "PostMessageViewController.h"
#import "PostImageViewController.h"

@interface SelectMessageViewController ()

@end

@implementation SelectMessageViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)floatAMessageButtonClicked:(id)sender {
    
    PostMessageViewController *postController=[[PostMessageViewController    alloc]initWithNibName:@"PostMessageViewController" bundle:nil];
    
    
    [self.navigationController pushViewController:postController animated:YES];
    
}

- (IBAction)floatAnImageButtonClicked:(id)sender
{
    PostImageViewController *postImageController=[[PostImageViewController alloc]initWithNibName:@"PostImageViewController" bundle:nil];
    
    
    [self.navigationController pushViewController:postImageController animated:YES];
    
}

- (IBAction)floatAnOfferButtonClicked:(id)sender {
}
@end
