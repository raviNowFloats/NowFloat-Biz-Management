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
#import <MessageUI/MessageUI.h>
#import<Social/Social.h>
#import "UIColor+HexaString.h"
#import "MarqueeLabel.h"
#import "MultiStoreViewController.h"




@interface LoginViewController ()<updateDelegate,downloadStoreDetail>

@end


@implementation LoginViewController
{
    CALayer *cloudLayer;
    CABasicAnimation *cloudLayerAnimation;
}

@synthesize backGroundImageView ;

@synthesize _loginDelegate;

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
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            backGroundImageView.frame=CGRectMake(0, 0, 640, 460);
            backGroundImageView.image=[UIImage imageNamed:@"loginbg1.png"];
            
        }
        if(result.height == 568)
        {
            // iPhone 5
            backGroundImageView.frame=CGRectMake(0, 0, 640, 548);
            backGroundImageView.image=[UIImage imageNamed:@"loginbg2.png"];
        }
    }

    
    isLoginForAnotherUser=NO;
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    userdetails=[NSUserDefaults standardUserDefaults];
    
    /*Check if user has already logged in*/

    if ([userdetails objectForKey:@"userFpId"])
    {
        [loginSubView setHidden:YES];
        [enterSubView setHidden:NO];
        
    }
    else
    {
        [enterSubView setHidden:YES];
        [loginSubView setHidden:NO];
        
    }
    
    

    
    /*Set the left subview here*/
    
    [leftSubView setFrame:CGRectMake(-320,60, 320, 390)];
    [self.view addSubview:leftSubView];
    [signUpSubView setFrame:CGRectMake(-320,60, 320, 203)];
    [self.view addSubview:signUpSubView];
    

    
    [darkBgLabel setHidden:YES];

    
    [fetchingDetailsSubview setHidden:YES];
        
    self.title = NSLocalizedString(@"LOGIN", nil);

    self.navigationController.navigationBarHidden=YES;
    
    receivedData=[[NSMutableData alloc] initWithCapacity:1];
    

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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
    /*removeFetchingSubView*/
    
    [[NSNotificationCenter defaultCenter]
                             addObserver:self
                             selector:@selector(removeFetchSubView)
                             name:@"removeFetchingSubView" object:nil];
    
 

}



-(void)removeFetchSubView
{
    
    if (![enterButton isEnabled] )
    {
        
        [enterButton setEnabled:YES];
        [fetchingDetailsSubview setHidden:YES];
        [loginAnotherButton setEnabled:YES];
        
    }
    
     if (![loginButton isEnabled])
    {
    
        [loginButton setEnabled:YES];
        [fetchingDetailsSubview setHidden:YES];
        [signUpButton setEnabled:YES];
    
    
    }
    
    
}




-(void)cloudScroll
{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            bgImage=[UIImage imageNamed:@"loginbg1.png"];
            
        }
        if(result.height == 568)
        {
            // iPhone 5
            
            bgImage=[UIImage imageNamed:@"loginbg2.png"];
        }
    }

    
    if (imageNumber==0)
    {
        imageNumber=1;
    }

    
    else if (imageNumber==1)
    {
        imageNumber=0;        
    }
    
    
    UIColor *bgImagePattern = [UIColor colorWithPatternImage:bgImage];
    cloudLayer = [CALayer layer];
    cloudLayer.backgroundColor = bgImagePattern.CGColor;
    cloudLayer.transform = CATransform3DMakeScale(1, -1, 1);
    cloudLayer.anchorPoint = CGPointMake(0, 1);
    CGSize viewSize = self.backGroundImageView.bounds.size;
    cloudLayer.frame = CGRectMake(0, 0,bgImage.size.width + viewSize.width, viewSize.height);
    
    [self.backGroundImageView.layer addSublayer:cloudLayer];
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(-bgImage.size.width+320, 0);
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

//[self performSelector:@selector(sendNotification) withObject:nil afterDelay:5];
    
}


-(void )sendNotification
{
    
    [self cloudScroll];
    
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
    darkBgLabel = nil;
    bgClientName = nil;
    signUpSubView = nil;
    enterButton = nil;
    loginLabel = nil;
    loginSelectionButton = nil;
    signUpLabel = nil;
    getUrBizLabel = nil;
    signUpBgLabel = nil;
    signUpButton = nil;

    loginAnotherButton = nil;
    loginButton = nil;
    loginSubView = nil;
    enterSubView = nil;
    [super viewDidUnload];
}


- (IBAction)loginButtonClicked:(id)sender
{
    [loginButton setEnabled:NO];
    
    [loginNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    if ([loginNameTextField.text length]==0 && [passwordTextField.text length]==0)
    {

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Ooops" message:@"Please enter Login and Password" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [loginButton setEnabled:YES];

        [alert show];
        alert=nil;
        
    }
    
    else if ([loginNameTextField.text length]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Ooops" message:@"Please enter Username" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [loginButton setEnabled:YES];
        [alert show];
        alert=nil;
    
    
    }
    
    
    
    else if ([passwordTextField.text length]==0)
    {
    
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Ooops" message:@"Please enter Password" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [loginButton setEnabled:YES];
        [alert show];
        alert=nil;

    }
    
    
    else
    {
    
    
    NSMutableDictionary *dic=[[NSMutableDictionary  alloc]initWithObjectsAndKeys:loginNameTextField.text,@"loginKey",passwordTextField.text,@"loginSecret",@"DB96EA35A6E44C0F8FB4A6BAA94DB017C0DFBE6F9944B14AA6C3C48641B3D70",@"clientId", nil];
    
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
    
    NSString *uploadString=[jsonWriter stringWithObject:dic];
    
    NSData *postData = [uploadString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];

    NSString *urlString=[NSString stringWithFormat:
                         @"%@/verifyLogin",appDelegate.apiWithFloatsUri];

    NSURL *loginUrl=[NSURL URLWithString:urlString];
    
    NSMutableURLRequest *loginRequest = [NSMutableURLRequest requestWithURL:loginUrl];
        
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
    
    if (loginSuccessCode==200)
    {
       /*Check if it is a login for another user in if-else*/
        
        if (isLoginForAnotherUser)
        {
            if (dic==NULL)
            {
                
                UIAlertView *loginFail=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Login Failed" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [loginFail show];
                
                loginFail=nil;
                
                [fetchingDetailsSubview setHidden:YES];
                [loginButton setEnabled:YES];
            }

            

            else
            {
            
            [userdetails removeObjectForKey:@"userFpId"];
            [userdetails   synchronize];//Remove the old user fpId from userdefaults
 
            /*Set the new fpId in the userdefaults*/
            [userdetails setObject:[[dic objectForKey:@"ValidFPIds"]objectAtIndex:0 ]  forKey:@"userFpId"];
            [userdetails synchronize];
                
                

                
            /*Call the fetch store details here*/
            GetFpDetails *getDetails=[[GetFpDetails alloc]init];
                getDetails.delegate=self;
            [getDetails fetchFpDetail];
                
                
                
                
                
            }
        }
        
        
        else
        {
        /*Save FpId in userDefaults*/
            
            if (dic==NULL)
            {
                
                UIAlertView *loginFail=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Login Failed" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [loginFail show];
                
                loginFail=nil;
                
                [fetchingDetailsSubview setHidden:YES];
                [loginButton setEnabled:YES];
            }
            
             else
             {
                 //513f25884ec0a40ca41ef8a7---sumanta.nowfloats.com
                 //503b28ee4ec0a42fc4a2ba77---neeraj.nowfloats.com
                [userdetails setObject:[[dic objectForKey:@"ValidFPIds"]objectAtIndex:0 ]  forKey:@"userFpId"];

                //[userdetails setObject:@"503b28ee4ec0a42fc4a2ba77"  forKey:@"userFpId"];
                 
                [userdetails synchronize];

                /*Call the fetch store details here*/
                                 
                GetFpDetails *getDetails=[[GetFpDetails alloc]init];
                 getDetails.delegate=self;
                [getDetails fetchFpDetail];
        
            
             }
            
        }
        
    }
    
    
    
    
    else
    {
        [fetchingDetailsSubview setHidden:YES];
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Ooops" message:@"NF Manage is unable to fetch details" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        [fetchingDetailsSubview setHidden:YES];
        
        alertView=nil;

    }
    
        

}


-(void)downloadFinished
{
    [self updateView];
}



-(void)downloadStoreDetails
{

    GetFpDetails *getDetails=[[GetFpDetails alloc]init];
    
    getDetails.delegate=self;
    
    [getDetails fetchFpDetail];


}



- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];

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


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    
    [errorAlert show];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeFetchingSubView" object:nil];

    NSLog (@"Connection Failed in LoginScreen:%@",[error localizedFailureReason]);
    
}


- (void)updateView
{
    
    BizMessageViewController *frontController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
    
    frontController.isLoadedFirstTime=YES;
    
    
        
    [self.navigationController pushViewController:frontController animated:YES];
    
    frontController=nil;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{

    [textField resignFirstResponder];
    
    return YES;
    
}

/*To show the slide animation*/
- (IBAction)loginSelectionButtonClicked:(id)sender
{
    
    [self slideAnimation];
}


- (IBAction)loginAnotherButtonClicked:(id)sender
{
    isLoginForAnotherUser=YES;
    [self slideAnimation];
}


- (IBAction)closeButtonClicked:(id)sender
{
    [darkBgLabel setHidden:YES];
    
    [loginNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.20];
    [rightSubView setFrame:CGRectMake(90, 111, 231, 234)];
    
    [leftSubView setFrame:CGRectMake(-320, 60, 320, 390)];
    [self.view addSubview:leftSubView];
    
    [UIView commitAnimations];
    
}


- (IBAction)dismissKeyboard:(id)sender
{
    
    [loginNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];

}


- (IBAction)signUpButtonClicked:(id)sender
{
    [self slideAnimationSignUp];
}


- (IBAction)signUpCloseButtonClicked:(id)sender
{
    [darkBgLabel setHidden:YES];
    
    [loginNameTextField resignFirstResponder];
    
    [passwordTextField resignFirstResponder];
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:0.20];
    
    [rightSubView setFrame:CGRectMake(90, 111, 231, 234)];

    [signUpSubView setFrame:CGRectMake(-320,60, 320, 390)];
    
    [self.view addSubview:leftSubView];
    
    [UIView commitAnimations];
}


- (IBAction)enterButtonClicked:(id)sender
{

    /*Call the fetch store details here*/
    
    [fetchingDetailsSubview setHidden:NO];
        
    [enterButton setEnabled:NO];
    
    [loginAnotherButton setEnabled:NO];
    
    GetFpDetails *getDetails=[[GetFpDetails alloc]init];
    
    getDetails.delegate=self;
    
    [getDetails fetchFpDetail];

}


-(void)slideAnimation
{

    [darkBgLabel setHidden:NO];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.20];
    [rightSubView setFrame:CGRectMake(320, 111, 160, 207)];
    [leftSubView setFrame:CGRectMake(0,60, 320, 390)];
    [self.view addSubview:leftSubView];
    [UIView commitAnimations];

}


-(void)slideAnimationSignUp
{
    
    [darkBgLabel setHidden:NO];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.20];
    [rightSubView setFrame:CGRectMake(320, 111, 160, 207)];
    [signUpSubView setFrame:CGRectMake(0,60, 320, 390)];
    [self.view addSubview:signUpSubView];
    [UIView commitAnimations];
    
}


- (void) keyboardWillShow: (NSNotification*) aNotification
{
    
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y -= 150;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];
   
}


- (void) keyboardWillHide: (NSNotification*) aNotification
{
    
    
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y += 150;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];
        

}


- (IBAction)smsButtonClicked:(id)sender
{

    MFMessageComposeViewController *pickerSMS = [[MFMessageComposeViewController alloc] init];
    
    pickerSMS.messageComposeDelegate = self;
    
    pickerSMS.recipients=[NSArray arrayWithObject:@"56765858"]; 
    
    pickerSMS.body = @"float";
    
    [self presentModalViewController:pickerSMS animated:YES];
    
}


- (IBAction)callButtonClicked:(id)sender
{

    UIDevice *device = [UIDevice currentDevice];
    
    if ([[device model] isEqualToString:@"iPhone"] )
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:09160004303"]]];
    }
    
    else
    {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
        
    }
    
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
        [self dismissModalViewControllerAnimated:YES];
    
}


- (void)viewWillDisappear:(BOOL)animated
{


}


-(void)viewDidDisappear:(BOOL)animated
{
    [cloudLayer removeAnimationForKey:@"position"];
    [cloudLayer removeFromSuperlayer];
    [cloudLayer removeAllAnimations];

}



@end
