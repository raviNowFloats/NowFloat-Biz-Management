//
//  UserSettingsWebViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 02/12/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "UserSettingsWebViewController.h"
#import "UIColor+HexaString.h"
#import "NFActivityView.h"

@interface UserSettingsWebViewController ()
{
    float viewHeight;
    NFActivityView *nfActivity;
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

    nfActivity=[[NFActivityView alloc]init];
    
    nfActivity.activityTitle=@"Loading";
    
    [nfActivity showCustomActivityView];

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
        
       // UIImage *buttonImage = [UIImage imageNamed:@"cancelCross2.png"];
        
     //   UIImageView *btnImgView=[[UIImageView alloc]initWithImage:buttonImage];
        
       // [btnImgView setFrame:CGRectMake(13,11,25,25)];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
                
        backButton.frame = CGRectMake(0,0,200,40);
        
        [backButton setTitle:@"Cancel" forState:UIControlStateNormal];
        
        [backButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
      //  [navBar addSubview:btnImgView];
        
        [navBar addSubview:backButton];
        
        
    }
    
    else
    {
        self.navigationController.navigationBarHidden=NO;

        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        
        /*
        UIImage *buttonCancelImage = [UIImage imageNamed:@"cancelCross1.png"];
        
        UIImageView *btnImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 20, 20)];
        
        [btnImgView setBackgroundColor:[UIColor clearColor]];
        
        [btnImgView setImage:buttonCancelImage];
        
        UIButton  *customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [customCancelButton setFrame:CGRectMake(5,9,30,30)];
        
        [customCancelButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [customCancelButton setShowsTouchWhenHighlighted:YES];
        
        [customCancelButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];                
        
        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:customCancelButton];
        
        [self.navigationController.navigationBar addSubview:btnImgView];
        
        self.navigationItem.leftBarButtonItem = leftBtnItem;
         */
        
        
     //   UIImage *buttonImage = [UIImage imageNamed:@"cancelCross2.png"];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [backButton setTitle:@"Cancel" forState:UIControlStateNormal];
        
        backButton.frame = CGRectMake(13,11,60,25);
        
        [backButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                
        [self.navigationController.navigationBar addSubview:backButton];

    }

    
    if ([_displayParameter isEqualToString:@"Terms & Conditions"])
    {
        self.navigationItem.title=@"Terms of use";
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
    
    
    if ([_displayParameter isEqualToString:@"Follow Us"])
    {
        [contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/NowFloatsBoost"]]]];    
    }
}



-(void)backBtnClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma webViewDelegate

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
        
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [nfActivity hideCustomActivityView];    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
