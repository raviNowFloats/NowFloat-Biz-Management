//
//  FBImageOpen.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/2/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "FBImageOpen.h"

@interface FBImageOpen ()

@end

@implementation FBImageOpen

@synthesize FbImage,ImageUrl;

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
    
    [self.view setBackgroundColor:[[UIColor blackColor]
                                   colorWithAlphaComponent:0.65]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",ImageUrl]];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    
    FbImage.image = tmpImage;

    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(260, 20, 50, 50)];
    button.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)close
{
    [self.view removeFromSuperview];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
