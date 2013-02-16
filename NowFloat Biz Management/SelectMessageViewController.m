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
#import "PostOfferViewController.h" 
#import <QuartzCore/QuartzCore.h>

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
    
        [bgLabel.layer setCornerRadius:8];
        [lineLabel.layer setCornerRadius:8];
        [floatImgButton.layer setCornerRadius:8];
        [floatMsgButton.layer setCornerRadius:8];
        [floatOfferButton.layer setCornerRadius:8];
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)floatAMessageButtonClicked:(id)sender {
    
    PostMessageViewController *postController=[[PostMessageViewController    alloc]initWithNibName:@"PostMessageViewController" bundle:nil];
    
    
    [self.navigationController pushViewController:postController animated:YES];
    
    postController=nil;
    
}

- (IBAction)floatAnImageButtonClicked:(id)sender
{
    PostImageViewController *postImageController=[[PostImageViewController alloc]initWithNibName:@"PostImageViewController" bundle:nil];
    
    
    [self.navigationController pushViewController:postImageController animated:YES];
    
    
    postImageController=nil;
}

- (IBAction)floatAnOfferButtonClicked:(id)sender
{
    
    PostOfferViewController *postOfferController=[[PostOfferViewController alloc]initWithNibName:@"PostOfferViewController" bundle:nil];
    
    
    [self.navigationController pushViewController:postOfferController animated:YES];
    
    postOfferController=nil;
    
    
}




- (void)viewDidUnload
{
    bgLabel = nil;
    floatMsgButton = nil;
    floatImgButton = nil;
    floatOfferButton = nil;
    lineLabel = nil;
    [super viewDidUnload];
}
@end
