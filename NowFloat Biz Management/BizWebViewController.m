//
//  BizWebViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 16/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BizWebViewController.h"
#import "UIColor+HexaString.h"


@interface BizWebViewController ()

@end

@implementation BizWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;

    UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];

    customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];

    [customCancelButton setImage:buttonImage forState:UIControlStateNormal];
    
    [customCancelButton setTitleColor:[UIColor colorWithHexString:@"464646"] forState:UIControlStateNormal];
    
    customCancelButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12.0];
    
    [customCancelButton setFrame:CGRectMake(5,0,50,44)];
    
    [customCancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [customCancelButton setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customCancelButton];
    
    if ([appDelegate.storeDetailDictionary objectForKey:@"Tag"]!=[NSNull null])
    {
        [storeWebVIew loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@.nowfloats.com",[[appDelegate.storeDetailDictionary objectForKey:@"Tag"]  lowercaseString]]]]];
    }
    
    else
    {
        [storeWebVIew loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://nowfloats.com"]]]];
        
    }
        
    
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            /*For iphone 3,3gS,4,42*/

            [storeWebVIew setFrame:CGRectMake(10, 56, 300, 394)];
            
        }
    }

    
}


-(void)back
{
    
    [self dismissModalViewControllerAnimated:YES];
    
}


 -(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webViewActivityView setHidden:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{


    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;
    
    [self dismissModalViewControllerAnimated:YES];


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    navBar = nil;
    storeWebVIew = nil;
    webViewActivityView = nil;
    [super viewDidUnload];
}
@end
