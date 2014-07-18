 //
//  LoginViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 05/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "BizMessageViewController.h"
#import "SBJson.h"
#import "SBJsonWriter.h"
#import "GetFpDetails.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "UIColor+HexaString.h"
#import "MarqueeLabel.h"
#import "SignUpViewController.h"
#import "TutorialViewController.h"
#import "FileManagerHelper.h"
#import "Mixpanel.h"
#import "RegisterChannel.h"
#import "ForgotPasswordController.h"

NSMutableArray *fbb;

@interface LoginViewController ()<updateDelegate,RegisterChannelDelegate>

@end


@implementation LoginViewController
{
    CALayer *cloudLayer;
    CABasicAnimation *cloudLayerAnimation;
    NSString *versionString;
    double viewHeight;
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
    
    versionString = [[UIDevice currentDevice] systemVersion];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        float width=[[UIScreen mainScreen] bounds].size.width;
        
        viewHeight=result.height;
        
        Mixpanel *mixPanel = [Mixpanel sharedInstance];
        
        mixPanel.showNotificationOnActive = NO;
        
        if(result.height == 480)
        {
            // iPhone Classic
            if (versionString.floatValue<7.0)
            {
                backGroundImageView.frame=CGRectMake(0,0, width, 460);
                enterSubView.frame=CGRectMake(0, 343, enterSubView.frame.size.width, enterSubView.frame.size.height);
                loginSubView.frame=CGRectMake(0, 343, loginSubView.frame.size.width, loginSubView.frame.size.height);
            }
            
            else
            {
                backGroundImageView.frame=CGRectMake(0,0, width, 480);
                enterSubView.frame=CGRectMake(0, 343, enterSubView.frame.size.width, enterSubView.frame.size.height);
                loginSubView.frame=CGRectMake(0, 343, loginSubView.frame.size.width, loginSubView.frame.size.height);
            }
            
            [activityIndicatorSubView.layer setCornerRadius:6.0];
            [activitySubViewBgLabel.layer setCornerRadius:6.0];
            
            [activityIndicatorSubView setFrame:CGRectMake(activityIndicatorSubView.frame.origin.x,315, activityIndicatorSubView.frame.size.width, activityIndicatorSubView.frame.size.height)];
            
        }
        
        if(result.height == 568)
        {
            // iPhone 5
            
            boostIconImgView.frame=CGRectMake(boostIconImgView.frame.origin.x, boostIconImgView.frame.origin.y+30, boostIconImgView.frame.size.width, boostIconImgView.frame.size.height);
            
            [activityIndicatorSubView.layer setCornerRadius:6.0];
            [activitySubViewBgLabel.layer setCornerRadius:6.0];
            
            [activityIndicatorSubView setFrame:CGRectMake(activityIndicatorSubView.frame.origin.x,350, activityIndicatorSubView.frame.size.width, activityIndicatorSubView.frame.size.height)];
            
            if (versionString.floatValue<7.0)
            {
                backGroundImageView.frame=CGRectMake(0,0,width,548);
                enterSubView.frame=CGRectMake(0, 430, enterSubView.frame.size.width, enterSubView.frame.size.height);
                loginSubView.frame=CGRectMake(0, 430, loginSubView.frame.size.width, loginSubView.frame.size.height);
            }
            else
            {
                backGroundImageView.frame=CGRectMake(0,0,width, 568);
                enterSubView.frame=CGRectMake(0, 442, enterSubView.frame.size.width, enterSubView.frame.size.height);
                loginSubView.frame=CGRectMake(0, 442, loginSubView.frame.size.width, loginSubView.frame.size.height);
            }
        }
    }
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"656565"]];
    
    UIImage *buttonImage = [UIImage imageNamed:@"_back.png"];
    
    leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftCustomButton setFrame:CGRectMake(-10,0,90,44)];
    
    [leftCustomButton setImage:buttonImage forState:UIControlStateNormal];
    
    [leftCustomButton setTitleColor:[UIColor whiteColor ] forState:UIControlStateNormal];
    
    [leftCustomButton setShowsTouchWhenHighlighted:YES];
    
    [leftCustomButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:leftCustomButton];
    
    isLoginForAnotherUser=NO;
    
    isFromEnterScreen=NO;
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    userdetails=[NSUserDefaults standardUserDefaults];
    
    
    [loginNameTextField setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    [passwordTextField setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    
    
    
    
    
    /*Check if user has already logged in*/
    
    if ([userdetails objectForKey:@"userFpId"])
    {
        isFromEnterScreen=YES;
        [loginSubView setHidden:YES];
        [enterSubView setHidden:NO];
        [leftCustomButton setHidden:YES];
    }
    
    else
    {
        [enterSubView setHidden:YES];
        [loginSubView setHidden:NO];
        [leftCustomButton setHidden:NO];
    }
    
    
    /*Set the left subview here*/
    
    [leftSubView setFrame:CGRectMake(-320,60, 320, 390)];
    [self.view addSubview:leftSubView];
    [signUpSubView setFrame:CGRectMake(-320,60, 320, 203)];
    [self.view addSubview:signUpSubView];
    
    [darkBgLabel setHidden:YES];
    
    [fetchingDetailsSubview setHidden:YES];
    
    self.title = NSLocalizedString(@"Login", nil);
    
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
    
    //[self cloudScroll];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    /*removeFetchingSubView*/
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(removeFetchSubView)
     name:@"removeFetchingSubView" object:nil];
    
    /*
     [loginNameTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
     */
    
    [passwordTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //Set up border for Background ImageView
    //[self setUpBorder];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![userdetails objectForKey:@"userFpId"])
    {
        
        [loginNameTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if(versionString.floatValue < 7.0)
    {
        
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES];
    }
}


-(void)setUpBorder
{
    loginImageViewBg.layer.masksToBounds = NO;
    loginImageViewBg.backgroundColor=[UIColor clearColor];
    loginImageViewBg.layer.opaque=YES;
    loginImageViewBg.layer.cornerRadius = 6.0f;
    loginImageViewBg.layer.needsDisplayOnBoundsChange=YES;
    loginImageViewBg.layer.shouldRasterize=YES;
    [loginImageViewBg.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    loginImageViewBg.layer.borderColor = [[UIColor colorWithHexString:@"dcdcda"] CGColor];
    loginImageViewBg.layer.borderWidth = 1.0f;
    
    passwordImageViewBg.layer.masksToBounds = NO;
    passwordImageViewBg.backgroundColor=[UIColor clearColor];
    passwordImageViewBg.layer.opaque=YES;
    passwordImageViewBg.layer.cornerRadius = 6.0f;
    passwordImageViewBg.layer.needsDisplayOnBoundsChange=YES;
    passwordImageViewBg.layer.shouldRasterize=YES;
    [passwordImageViewBg.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    passwordImageViewBg.layer.borderColor = [[UIColor colorWithHexString:@"dcdcda"] CGColor];
    passwordImageViewBg.layer.borderWidth = 1.0f;
    
    
    loginButton.layer.masksToBounds = NO;
    loginButton.layer.opaque=YES;
    loginButton.layer.cornerRadius = 6.0f;
    loginButton.layer.needsDisplayOnBoundsChange=YES;
    loginButton.layer.shouldRasterize=YES;
    [loginButton.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    loginButton.layer.borderColor = [[UIColor colorWithHexString:@"dcdcda"] CGColor];
    loginButton.layer.borderWidth = 1.0f;
    //[loginButton setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"5a5a5a"]] forState:UIControlStateHighlighted];
    
    
    enterButton.layer.masksToBounds = NO;
    enterButton.layer.opaque=YES;
    enterButton.layer.cornerRadius = 6.0f;
    enterButton.layer.needsDisplayOnBoundsChange=YES;
    enterButton.layer.shouldRasterize=YES;
    [enterButton.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    enterButton.layer.borderColor = [[UIColor colorWithHexString:@"dcdcda"] CGColor];
    enterButton.layer.borderWidth = 1.0f;
    //[enterButton setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"5a5a5a"]] forState:UIControlStateHighlighted];
    
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(void)textFieldFinished:(id)sender
{
    
    [sender resignFirstResponder];
    
}


-(void)removeFetchSubView
{
    
    [loginSubView setHidden:NO];
    
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


-(void)sendNotification
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
    activitySubViewBgLabel = nil;
    activityIndicatorSubView = nil;
    navBar = nil;
    loginImageViewBg = nil;
    passwordImageViewBg = nil;
    enterButton = nil;
    [super viewDidUnload];
}


- (IBAction)forgotPasswordBtnClicked:(id)sender
{
    
    [self.view endEditing:YES];
    
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    [mixPanel track:@"Forgot password clicked"];
    
    ForgotPasswordController *forgotPassword = [[ForgotPasswordController alloc] initWithNibName:@"ForgotPasswordController" bundle:nil];
    
    [self.navigationController pushViewController:forgotPassword animated:YES];
    
    
    
}

- (IBAction)loginBtnClicked:(id)sender
{
    receivedData=[[NSMutableData alloc]init];
    
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"login_buttonClicked"];
    
    [self loginBtnClicked];
}


-(void)loginBtnClicked
{
    [loginButton setEnabled:NO];
    [loginNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    
    if ([loginNameTextField.text length]==0 && [passwordTextField.text length]==0)
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Please enter username and password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [loginButton setEnabled:YES];
        
        [alert show];
        alert=nil;
        
    }
    
    else if ([loginNameTextField.text length]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Please enter username" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [loginButton setEnabled:YES];
        [alert show];
        alert=nil;
    }
    
    else if ([passwordTextField.text length]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Please enter password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [loginButton setEnabled:YES];
        [alert show];
        alert=nil;
    }
    
    
    else
    {
        
        if ([userdetails objectForKey:@"userFpId"])
        {
            [userdetails removeObjectForKey:@"userFpId"];
        }
        
        
        NSMutableDictionary *dic=[[NSMutableDictionary  alloc]initWithObjectsAndKeys:
                                  loginNameTextField.text,@"loginKey",
                                  passwordTextField.text,@"loginSecret",
                                  appDelegate.clientId,@"clientId", nil];
        
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
        
        [loginSubView setHidden:YES];
        
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
    receivedData=nil;
    
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
                
                /*Call the fetch store details here*/;
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
                
                [self removeFetchSubView];
                [loginButton setEnabled:YES];
                [loginSubView setHidden:NO];
            }
            
            else
            {
                if ([dic objectForKey:@"ValidFPIds"]!=[NSNull null])
                {
                    
                    if ([[dic objectForKey:@"ValidFPIds"]objectAtIndex:0 ] != [NSNull null])
                    {
                        
                        [userdetails setObject:[[dic objectForKey:@"ValidFPIds"]objectAtIndex:0 ]  forKey:@"userFpId"];
                        
                        [userdetails synchronize];
                        
                        /*Call the fetch store details here*/
                        
                        GetFpDetails *getDetails=[[GetFpDetails alloc]init];
                        getDetails.delegate=self;
                        [getDetails fetchFpDetail];
                    }
                    else
                    {
                        UIAlertView *validFpAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Login failed no user found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
                        
                        [validFpAlert show];
                        
                        validFpAlert=Nil;
                        [self removeFetchSubView];
                        [loginButton setEnabled:YES];
                        [loginSubView setHidden:NO];
                    }
                    
                }
                
                else{
                    UIAlertView *validFpAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Login failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
                    
                    [validFpAlert show];
                    
                    validFpAlert=Nil;
                    [self removeFetchSubView];
                    [loginButton setEnabled:YES];
                    [loginSubView setHidden:NO];
                }
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
        [loginSubView setHidden:NO];
    }
}

#pragma updateDelegate

-(void)downloadFinished
{
    [self updateView];
}


-(void)downloadFailedWithError
{
    [self removeFetchSubView];
    
    UIAlertView *failedAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not fetch website details." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil , nil];
    
    [failedAlert show];
    
    failedAlert=nil;
    
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
}


- (void)updateView
{
    
    [appDelegate.storeDetailDictionary setObject:appDelegate.storeCategoryName forKey:@"Categories"];
    
    if([appDelegate.storeDetailDictionary objectForKey:@"isFromNotification"] == [NSNumber numberWithBool:YES])
    {
        NSMutableDictionary *pushPayload = [appDelegate.storeDetailDictionary objectForKey:@"pushPayLoad"];        
        
        [[[UIApplication sharedApplication] delegate]application:[UIApplication sharedApplication] didReceiveRemoteNotification:pushPayload];
    }  
    else
    {
        if (appDelegate.storeTag.length!=0 && appDelegate.storeTag!=NULL)
        {
            @try
            {
                [self setRegisterChannel];
                
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                [mixpanel identify:appDelegate.storeTag]; //username
                
                NSString *countryCode = [appDelegate.storeDetailDictionary objectForKey:@"CountryPhoneCode"];
                
                 NSNumber *noads = [NSNumber numberWithBool:NO];
                if([[appDelegate.storeDetailDictionary objectForKey:@"PaymentLevel"] floatValue]<10)
                {
                    noads = [NSNumber numberWithBool:YES];
                }
                
                NSArray *widgetsArray = [appDelegate.storeDetailDictionary objectForKey:@"FPWebWidgets"];
             
                
                 NSNumber *TOB = [NSNumber numberWithBool:NO];
                if([widgetsArray containsObject:@"TOB"])
                {
                    TOB = [NSNumber numberWithBool:YES];
                }
                
                 NSNumber *imageGallery = [NSNumber numberWithBool:NO];
                
                if([widgetsArray containsObject:@"IMAGEGALLERY"])
                {
                    imageGallery = [NSNumber numberWithBool:YES];
                }
                
                 NSNumber *fblikebox = [NSNumber numberWithBool:NO];
                
                if([widgetsArray containsObject:@"FBLIKEBOX"])
                {
                    fblikebox = [NSNumber numberWithBool:YES];
                }
                
                 NSNumber *businessTimings = [NSNumber numberWithBool:NO];
                
                if([widgetsArray containsObject:@"TIMINGS"])
                {
                    businessTimings = [NSNumber numberWithBool:YES];
                }
                
                NSNumber *domainOrder = [NSNumber numberWithBool:NO];
                
                if([appDelegate.storeRootAliasUri isEqualToString:@""])
                {
                    domainOrder = [NSNumber numberWithBool:YES];
                }
                
                NSNumber *storeImage = [NSNumber numberWithBool:NO];
                
                if(![appDelegate.primaryImageUri isEqualToString:@""])
                {
                    storeImage = [NSNumber numberWithBool:YES];
                }
            
                NSNumber *storeDesc = [NSNumber numberWithBool:NO];
                
                if(![appDelegate.businessDescription isEqualToString:@""])
                {
                    storeDesc = [NSNumber numberWithBool:YES];
                }
                
                NSDictionary *specialProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   appDelegate.storeEmail, @"$email",
                                                   appDelegate.businessName, @"$name",
                                                   countryCode,@"$FpCountryCode",
                                                   noads,@"$NoAds",
                                                   TOB,@"$TTB",
                                                   imageGallery,@"$ImageGallery",
                                                   fblikebox,@"$FBLIKEBOX",
                                                   businessTimings,@"$TIMINGS",
                                                   domainOrder,@"$DomainOrder",
                                                   storeImage,@"$FeaturedImage",
                                                   storeDesc,@"$BusinessDescription",
                                                   nil];
                
                [mixpanel.people set:specialProperties];
                [mixpanel.people addPushDeviceToken:appDelegate.deviceTokenData];
            }
            @catch (NSException *e){
                
            }
            
            FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
            
            fHelper.userFpTag=appDelegate.storeTag;
            
            [fHelper createUserSettings];
            
            [appDelegate.storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"showLatestVisitorsInfo"];
            
            BizMessageViewController *frontController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
            
            frontController.isLoadedFirstTime=YES;
            
            [self.navigationController pushViewController:frontController animated:YES];
            
            frontController=nil;
        }
    }

    

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField.tag==1)
    {
        [textField resignFirstResponder];
    }
    
    
    else
    {
        [textField resignFirstResponder];
        
        [self loginBtnClicked];
    }
    return YES;
}


/*To show the slide animation*/

- (IBAction)dismissKeyboard:(id)sender
{
    
    [loginNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
}


- (IBAction)enterBtnClicked:(id)sender
{
    
    receivedData=[[NSMutableData alloc]init];
    
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"enterBtnClicked"];
    
    [fetchingDetailsSubview setHidden:NO];
    
    [enterSubView setHidden:YES];
    
    [enterButton setEnabled:NO];
    
    [loginAnotherButton setEnabled:NO];
    
    GetFpDetails *getDetails=[[GetFpDetails alloc]init];
    
    getDetails.delegate=self;
    
    [getDetails fetchFpDetail];
}


- (IBAction)logoutBtnClicked:(id)sender
{
    
    [userdetails removeObjectForKey:@"userFpId"];
    [userdetails   synchronize];//Remove the old user fpId from userdefaults
    
    [enterSubView setHidden:YES];
    [loginSubView setHidden:NO];
    
    
    [orLabel setHidden:YES];
    [backButton setHidden:YES];
    
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"logout"];
}


- (IBAction)loginViewBackBtnClicked:(id)sender
{
    
    if (isFromEnterScreen)
    {
        TutorialViewController *tutorialController=[[TutorialViewController alloc]initWithNibName:@"TutorialViewController" bundle:nil];
        
        [self.navigationController pushViewController:tutorialController animated:YES];
    }
    
    else
    {
        Mixpanel *mixPanel=[Mixpanel sharedInstance];
        
        [mixPanel track:@"login dropped"];
        
        id rootVC = [[self.navigationController viewControllers] objectAtIndex:0];
        
        if([rootVC isKindOfClass:[TutorialViewController class]])
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        else
        {
            TutorialViewController *tutorialController=[[TutorialViewController alloc]initWithNibName:@"TutorialViewController" bundle:nil];
            
            [self.navigationController pushViewController:tutorialController animated:YES];
        }
    }
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
    
    
    if (versionString.floatValue<7.0)
    {
        rect.origin.y -= 210;
    }
    
    else
    {
        if (viewHeight==480)
        {
            rect.origin.y -= 190;
        }
        
        else
        {
            rect.origin.y -= 200;
        }
    }
    
    [[self view] setFrame: rect];
    
    [UIView commitAnimations];
}


- (void) keyboardWillHide: (NSNotification*) aNotification
{
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:0.2];
    
    CGRect rect = [[self view] frame];
    
    if (versionString.floatValue<7.0)
    {
        rect.origin.y += 210;
    }
    
    else
    {
        if (viewHeight==480)
        {
            rect.origin.y += 190;
        }
        
        else
        {
            rect.origin.y += 200;
        }
    }
    
    [[self view] setFrame: rect];
    
    [UIView commitAnimations];
}


-(void)backBtnClicked
{
    if (isFromEnterScreen)
    {
        NSLog(@"Hello");
    }
    
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma RegisterChannel

-(void)setRegisterChannel
{
    RegisterChannel *regChannel=[[RegisterChannel alloc]init];
    
    regChannel.delegate=self;
    
    [regChannel registerNotificationChannel];
}

#pragma RegisterChannelDelegate

-(void)channelDidRegisterSuccessfully
{
    //    NSLog(@"channelDidRegisterSuccessfully");
}

-(void)channelFailedToRegister
{
    //    NSLog(@"channelFailedToRegister");
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)viewWillDisappear:(BOOL)animated
{

}


-(void)viewDidDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [cloudLayer removeAnimationForKey:@"position"];
    [cloudLayer removeFromSuperlayer];
    [cloudLayer removeAllAnimations];
}



@end
