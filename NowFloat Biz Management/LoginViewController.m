//
//  LoginViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 05/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "LoginViewController.h"
#import "BizMessageViewController.h"
#import "SBJson.h"
#import "SBJsonWriter.h"
#import "GetFpDetails.h"
#import <QuartzCore/QuartzCore.h>


@interface LoginViewController ()

@end

#define kBackGroudQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)

@implementation LoginViewController
{
    CALayer *cloudLayer;
    CABasicAnimation *cloudLayerAnimation;
}

@synthesize backGroundImageView ;


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
    
    /*Set the left subview here*/
    
    [leftSubView setFrame:CGRectMake(-320,111, 320, 203)];
    [self.view addSubview:leftSubView];
    
    

    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [fetchingDetailsSubview setHidden:YES];
        
    self.title = NSLocalizedString(@"LOGIN", nil);

    self.navigationController.navigationBarHidden=YES;
    
    receivedData=[[NSMutableData alloc] initWithCapacity:1];
    
    validDictionary=[[NSMutableDictionary alloc]init];

    isForLogin=0;

    isForStore=0;
    
    [[NSNotificationCenter defaultCenter]
                                         addObserver:self
                                         selector:@selector(updateView)
                                         name:@"updateRoot" object:nil];
    
    [[NSNotificationCenter defaultCenter]
                                         addObserver:self
                                         selector:@selector(updateImage)
                                         name:@"changeImage" object:nil];

    imageNumber=0;
    
    [self cloudScroll];


    
}




-(void)cloudScroll
{
    
    
    if (imageNumber==0)
    {
        bgImage = [UIImage imageNamed:@"Image1.png"];
        imageNumber=1;

    }

    else if (imageNumber==1)
    {
        bgImage = [UIImage imageNamed:@"Image2.png"];
        imageNumber=2;
    }
    
    
    else if (imageNumber==2)
    {
        
        bgImage = [UIImage imageNamed:@"Image3.png"];
        imageNumber=3;
    }
    
    
    else if (imageNumber==3)
    {
        
        bgImage = [UIImage imageNamed:@"Image4.png"];
        imageNumber=4;
    }
    
    
    else if (imageNumber==4)
    {
        
        bgImage = [UIImage imageNamed:@"Image5.png"];
        imageNumber=5;
    }

    else if (imageNumber==5)
    {
        
        bgImage = [UIImage imageNamed:@"Image6.png"];
        imageNumber=6;
    }

    
    else if (imageNumber==6)
    {
        
        bgImage = [UIImage imageNamed:@"Image7.png"];
        imageNumber=7;
    }

    
    else if (imageNumber==7)
    {
        
        bgImage = [UIImage imageNamed:@"Image1.png"];
        imageNumber=0;
    }


    
    
    
    
    //UIImage *bgImage = [UIImage imageNamed:@"image1.png"];
    UIColor *bgImagePattern = [UIColor colorWithPatternImage:bgImage];
    cloudLayer = [CALayer layer];
    cloudLayer.backgroundColor = bgImagePattern.CGColor;
    cloudLayer.transform = CATransform3DMakeScale(1, -1, 1);
    cloudLayer.anchorPoint = CGPointMake(0, 1);
    CGSize viewSize = self.backGroundImageView.bounds.size;
    cloudLayer.frame = CGRectMake(0, 0, bgImage.size.width + viewSize.width, viewSize.height);
    
    [self.backGroundImageView.layer addSublayer:cloudLayer];
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(-bgImage.size.width, 0);
    cloudLayerAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    cloudLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    cloudLayerAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    cloudLayerAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    cloudLayerAnimation.repeatCount = HUGE_VALF;
    cloudLayerAnimation.duration = 100.0;
    [self applyCloudLayerAnimation];
    
}


- (void)applyCloudLayerAnimation
{
    
    [cloudLayer addAnimation:cloudLayerAnimation forKey:@"position"];
    
    [self performSelector:@selector(sendNotification) withObject:nil afterDelay:5];
    
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    loginNameTextField = nil;
    passwordTextField = nil;
    fetchingDetailsSubview = nil;
    [self setBackGroundImageView:nil];
    rightSubView = nil;
    leftSubView = nil;
    [super viewDidUnload];
}


- (IBAction)loginButtonClicked:(id)sender
{
    
    NSMutableDictionary *dic=[[NSMutableDictionary  alloc]initWithObjectsAndKeys:loginNameTextField.text,@"loginKey",passwordTextField.text,@"loginSecret",@"DB96EA35A6E44C0F8FB4A6BAA94DB017C0DFBE6F9944B14AA6C3C48641B3D70",@"clientId", nil];
    
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
    
    NSString *uploadString=[jsonWriter stringWithObject:dic];
    
    NSData *postData = [uploadString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];

    NSString *urlString=[NSString stringWithFormat:
                         @"https://api.withfloats.com/discover/v1/floatingPoint/verifyLogin"];

    NSURL *loginUrl=[NSURL URLWithString:urlString];
    
//    NSMutableURLRequest *loginRequest = [NSMutableURLRequest requestWithURL:loginUrl];
    
    
    NSMutableURLRequest *loginRequest=[NSMutableURLRequest requestWithURL:loginUrl cachePolicy:NSURLCacheStorageAllowed timeoutInterval:100];
    
    [loginRequest setHTTPMethod:@"POST"];
    
    [loginRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [loginRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [loginRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [loginRequest setHTTPBody:postData];

    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:loginRequest delegate:self];

    isForLogin=1;
    
    [fetchingDetailsSubview setHidden:NO];


    
}




- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{    

    [receivedData appendData:data1];

}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    NSError *error;

    NSMutableDictionary *dic=[NSJSONSerialization
                              JSONObjectWithData:receivedData //1
                              options:kNilOptions
                              error:&error];

    
    [validDictionary addEntriesFromDictionary:dic];
    
    [appDelegate.fpId addEntriesFromDictionary:dic];
    
    
    
    if (loginSuccessCode==200)
    {

        /*Call the fetch store details here*/
                
    
        GetFpDetails *getDetails=[[GetFpDetails alloc]init];
        
        [getDetails setFpId:[[dic objectForKey:@"ValidFPIds"]objectAtIndex:0 ]];
                
        [getDetails fetchFpDetail:validDictionary];
        

        
    }
    
    else
    {
    
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Ooops" message:@"NF Manage is unable to fetch details" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [alertView show];
        alertView=nil;

        
    }
    
        

}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];

    NSLog(@"Code:%d",code);


        if (isForLogin==1)
        {
               
            if (code==200)
            {
                    
                loginSuccessCode=200;
                
            
            }

        
            else
            {
            
                loginSuccessCode=code;
            }
            
            
        }
    
    
}


- (void)updateView
{

    
    BizMessageViewController *frontController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
    
    [self.navigationController pushViewController:frontController animated:YES];
    
    frontController=nil;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{

    [textField resignFirstResponder];
    
    return YES;
    
}


-(void )sendNotification
{
    
    [self cloudScroll];
    
}


/*To show the slide animation*/
- (IBAction)loginSelectionButtonClicked:(id)sender
{
    
    [self slideAnimation];
}

- (IBAction)closeButtonClicked:(id)sender
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.20];
    [rightSubView setFrame:CGRectMake(160, 111, 160, 207)];
    
    
    [leftSubView setFrame:CGRectMake(-320, 111, 320, 203)];
    [self.view addSubview:leftSubView];
    
    [UIView commitAnimations];
    

}

- (IBAction)dismissKeyboard:(id)sender
{
    
    [loginNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];

}


-(void)slideAnimation
{

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.20];
    [rightSubView setFrame:CGRectMake(320, 111, 160, 207)];
    
    
    [leftSubView setFrame:CGRectMake(0, 111, 320, 203)];
    [self.view addSubview:leftSubView];
    
    [UIView commitAnimations];

}



@end
