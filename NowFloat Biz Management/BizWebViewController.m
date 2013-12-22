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
    
    version = [[UIDevice currentDevice] systemVersion];

    
    if ([version intValue] < 7)
    {
        self.navigationController.navigationBarHidden=YES;
     
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,320,44)];
        
        [self.view addSubview:navBar];
        
        UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];
        
        customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [customCancelButton setImage:buttonImage forState:UIControlStateNormal];
        
        [customCancelButton setTitleColor:[UIColor colorWithHexString:@"464646"] forState:UIControlStateNormal];
        
        customCancelButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        
        [customCancelButton setFrame:CGRectMake(5,0,50,44)];
        
        [customCancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [customCancelButton setShowsTouchWhenHighlighted:YES];
        
        [navBar addSubview:customCancelButton];
        
        
        [storeWebVIew setFrame:CGRectMake(storeWebVIew.frame.origin.x, 54, storeWebVIew.frame.size.width, storeWebVIew.frame.size.height)];

    }

    else
    {
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];

        customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [customCancelButton setImage:buttonImage forState:UIControlStateNormal];
        
        [customCancelButton setTitleColor:[UIColor colorWithHexString:@"464646"] forState:UIControlStateNormal];
        
        customCancelButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        
        [customCancelButton setFrame:CGRectMake(5,0,50,44)];
        
        [customCancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [customCancelButton setShowsTouchWhenHighlighted:YES];
        
        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:customCancelButton];
        
        self.navigationItem.leftBarButtonItem = leftBtnItem;
    }
    
    
    
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
            if (version.floatValue<7.0) {

                [storeWebVIew setFrame:CGRectMake(10,56, storeWebVIew.frame.size.width, storeWebVIew.frame.size.height-87)];

            }
            else
            {
                [storeWebVIew setFrame:CGRectMake(10,10, storeWebVIew.frame.size.width, storeWebVIew.frame.size.height-20)];
            }
        }
        
        else
        {
            if (version.floatValue<7.0) {

                [storeWebVIew setFrame:CGRectMake(10,56, storeWebVIew.frame.size.width, storeWebVIew.frame.size.height)];

            }
            
            else
            {
                [storeWebVIew setFrame:CGRectMake(storeWebVIew.frame.origin.x, storeWebVIew.frame.origin.y, storeWebVIew.frame.size.width, storeWebVIew.frame.size.height+68)];
            }
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
