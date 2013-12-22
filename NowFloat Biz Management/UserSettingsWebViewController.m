//
//  UserSettingsWebViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 02/12/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "UserSettingsWebViewController.h"
#import "UIColor+HexaString.h"

@interface UserSettingsWebViewController ()
{
    float viewHeight;
}
@end

@implementation UserSettingsWebViewController
@synthesize displayParameter=_displayParameter;


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
    version = [[UIDevice currentDevice] systemVersion];

    activitySubView.center=self.view.center;
    
    if (version.floatValue<7.0)
    {
        
    }
    
    else
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;

        [self.navigationController.navigationBar setTranslucent:NO];
    
    }


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

    
    
    if (viewHeight==480.0)
    {

        if (version.floatValue<7.0)
        {
            [contentWebView setFrame:CGRectMake(10, 56, 300,395)];
        }
        
    }

    else
    {
    
        if(version.floatValue<7.0)
        {
            [contentWebView setFrame:CGRectMake(10,54, 300,484)];
        }
        
        
    }
    
    
    
    
    
    
    //Create NavBar here
    if (version.floatValue<7.0)
    {
        
        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:
                                   CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(85, 13, 150, 20)];
        
        headerLabel.text=_displayParameter;
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textAlignment=NSTextAlignmentCenter;
        
        headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
        
        [navBar addSubview:headerLabel];

        
        if ([_displayParameter isEqualToString:@"Terms & Conditions"])
        {
            headerLabel.text=@"T & C";
        }
        
        //Create the custom back bar button here....
        
        UIImage *buttonImage = [UIImage imageNamed:@"cancelCross1.png"];
        
        UIImageView *btnImgView=[[UIImageView alloc]initWithImage:buttonImage];
        
        [btnImgView setFrame:CGRectMake(15, 11, 20, 20)];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
                
        backButton.frame = CGRectMake(0,0,40,40);
        
        [backButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:btnImgView];
        
        [navBar addSubview:backButton];
        
        
    }
    
    else
    {
        self.navigationController.navigationBarHidden=NO;

        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        
        UIImage *buttonCancelImage = [UIImage imageNamed:@"cancelCross1.png"];
        
        UIImageView *btnImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 20, 20)];
        
        [btnImgView setBackgroundColor:[UIColor clearColor]];
        
        [btnImgView setImage:buttonCancelImage];
        
        UIButton  *customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [customCancelButton setFrame:CGRectMake(5,9,30,30)];
        
        [customCancelButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [customCancelButton setShowsTouchWhenHighlighted:YES];

        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:customCancelButton];
        
        [self.navigationController.navigationBar addSubview:btnImgView];
        
        self.navigationItem.leftBarButtonItem = leftBtnItem;

        
        
        
    }

    
    if ([_displayParameter isEqualToString:@"Terms & Conditions"])
    {
        self.navigationItem.title=@"T & C";
    }
    
    else
    {
        self.navigationItem.title=_displayParameter;
    }

    
    
    if ([_displayParameter isEqualToString:@"About Us"])
    {
        [contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://nowfloats.com"]]]];
    }
    
    
    if ([_displayParameter isEqualToString:@"Privacy Policy"])
    {
        //

        [contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://nowfloats.com/privacy/"]]]];

    }

    if ([_displayParameter isEqualToString:@"Terms & Conditions"])
    {
        [contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://nowfloats.com/tnc/"]]]];
    }
}



-(void)backBtnClicked
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma webViewDelegate

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;
    
    [self dismissModalViewControllerAnimated:YES];
        
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activitySubView setHidden:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
