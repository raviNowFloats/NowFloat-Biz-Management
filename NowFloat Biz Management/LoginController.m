//
//  LoginController.m
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 28/07/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "LoginController.h"
#import "SBJson.h"
#import "SBJsonWriter.h"
#import "GetFpDetails.h"
#import "Mixpanel.h"
#import "FileManagerHelper.h"
#import "RegisterChannel.h"
#import "TutorialViewController.h"
#import "ForgotPasswordController.h"
#import "BizMessageViewController.h"

@interface LoginController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,updateDelegate,RegisterChannelDelegate>
{
    UITextField *currentPasswd, *userName;
    UIButton *leftCustomButton,*signInButton,*forgotButton;
    NSUserDefaults *userdetails;
    int loginSuccessCode;
}

@end

@implementation LoginController

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
    
   
    navigationBarView.frame = CGRectMake(0, 0, 320, 65);
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    userdetails=[NSUserDefaults standardUserDefaults];
    
    signInButton = [[UIButton alloc] init];
    
    forgotButton = [[UIButton alloc] init];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height == 480)
        {
            signInButton.frame = CGRectMake(10, 215, 300, 45);
            forgotButton.frame = CGRectMake(60, 270, 200, 30);
        }
        else
        {
            signInButton.frame = CGRectMake(10, 250, 300, 45);
            forgotButton.frame = CGRectMake(60, 305, 200, 30);
        }
    }
    
    [leftCustomButton setFrame:CGRectMake(10,34,15,15)];
    
    [leftCustomButton setImage:[UIImage imageNamed:@"goBack.png"] forState:UIControlStateNormal];
    
    [leftCustomButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationBarView addSubview:leftCustomButton];
    
    isLoginForAnotherUser=NO;
    
    
    [forgotButton setTitle:@"Forgot your password?" forState:UIControlStateNormal];
    forgotButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    [forgotButton addTarget:self action:@selector(forgotPasswordClicked:) forControlEvents:UIControlEventTouchUpInside];
    [forgotButton setTitleColor:[UIColor colorFromHexCode:@"#9a9a9a"] forState:UIControlStateNormal];
    
    titleView.text = @"Welcome Back!";
    titleView.textColor = [UIColor colorFromHexCode:@"#969696"];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:18];
    
    [signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signInButton setTitle:@"Sign in" forState:UIControlStateNormal];
    [signInButton addTarget:self action:@selector(signInClicked:) forControlEvents:UIControlEventTouchUpInside];
    signInButton.backgroundColor = [UIColor colorFromHexCode:@"#ffb900"];
    
    signInButton.layer.cornerRadius = 5.0;
    signInButton.layer.masksToBounds = YES;
    
    signInTableView.delegate = self;
    signInTableView.dataSource = self;
    signInTableView.scrollEnabled = NO;
    
    signInTableView.separatorColor = [UIColor colorFromHexCode:@"#d4d4d4"];
    
    
    
    
    [self.view addSubview:signInButton];
    [self.view addSubview:forgotButton];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)goBack
{
    if([appDelegate.storeDetailDictionary objectForKey:@"toLoginScreen"] == [NSNumber numberWithBool:YES])
    {
        [appDelegate.storeDetailDictionary removeObjectForKey:@"toLoginScreen"];
        TutorialViewController *tuteControl = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
        [self.navigationController pushViewController:tuteControl animated:NO];
        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"String Identifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil)
    {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        
    }
    
        if(indexPath.row == 0)
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            lineView.backgroundColor = [UIColor colorFromHexCode:@"#d4d4d4"];
            
            [cell.contentView addSubview:lineView];
            
            UIView *MiddleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
            MiddleLineView.backgroundColor = [UIColor colorFromHexCode:@"#d4d4d4"];
            
            [cell.contentView addSubview:MiddleLineView];
            
            userName = [[UITextField alloc] initWithFrame:CGRectMake(15, 2, 320, 40)];
            userName.tag = 101;
            userName.font = [UIFont fontWithName:@"Helvetica-Light" size:15.0];
            userName.textColor = [UIColor colorFromHexCode:@"#b3b3b3"];
            [userName setPlaceholder:@"Username"];
            userName.delegate = self;
            userName.autocorrectionType = UITextAutocorrectionTypeNo;
            [cell.contentView addSubview:userName];
            
        }
        if(indexPath.row == 1)
        {
            currentPasswd = [[UITextField alloc] initWithFrame:CGRectMake(15, 2, 320, 40)];
            currentPasswd.tag = 102;
            currentPasswd.font = [UIFont fontWithName:@"Helvetica-Light" size:15.0];
            currentPasswd.delegate = self;
            [currentPasswd setPlaceholder:@"Password"];
            currentPasswd.textColor = [UIColor colorFromHexCode:@"#b3b3b3"];
            currentPasswd.secureTextEntry = YES;
            currentPasswd.autocorrectionType = UITextAutocorrectionTypeNo;
            [cell.contentView addSubview:currentPasswd];
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
            lineView.backgroundColor = [UIColor colorFromHexCode:@"#d4d4d4"];
            
            [cell.contentView addSubview:lineView];
        }

  
    [cell setSelected:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


- (IBAction)signInClicked:(id)sender
{
   
     signInButton.backgroundColor = [UIColor colorFromHexCode:@"#ebaa00"];
    [currentPasswd resignFirstResponder];
    [userName resignFirstResponder];
    
    receivedData=[[NSMutableData alloc]init];
    
    if ([userName.text length]==0 && [currentPasswd.text length]==0)
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Please enter username and password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        signInButton.backgroundColor = [UIColor colorFromHexCode:@"#ffb900"];
        alert=nil;
        
    }
    
    else if ([userName.text length]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Please enter username" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        signInButton.backgroundColor = [UIColor colorFromHexCode:@"#ffb900"];
        alert=nil;
    }
    
    else if ([currentPasswd.text length]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Please enter password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        signInButton.backgroundColor = [UIColor colorFromHexCode:@"#ffb900"];
        alert=nil;
    }
    
    
    else
    {
    
        if ([userdetails objectForKey:@"userFpId"])
        {
            [userdetails removeObjectForKey:@"userFpId"];
        }
        
        
        NSMutableDictionary *dic=[[NSMutableDictionary  alloc]initWithObjectsAndKeys:
                                  userName.text,@"loginKey",
                                  currentPasswd.text,@"loginSecret",
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
        
    }
}

- (IBAction)forgotPasswordClicked:(id)sender
{
    ForgotPasswordController *forgotControl = [[ForgotPasswordController alloc] initWithNibName:@"ForgotPasswordController" bundle:nil];
    
    [self.navigationController pushViewController:forgotControl animated:YES];
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
            }
            
            else
            {
                if ([dic objectForKey:@"ValidFPIds"]!=[NSNull null])
                {
                    
                    if ([[dic objectForKey:@"ValidFPIds"]objectAtIndex:0 ] != [NSNull null])
                    {
                        
                        [userdetails setObject:[[dic objectForKey:@"ValidFPIds"]objectAtIndex:0 ]  forKey:@"userFpId"];
                        
                        [userdetails synchronize];
                        
                        signInButton.backgroundColor = [UIColor colorFromHexCode:@"#ffb900"];
                        
                        /*Call the fetch store details here*/
                        
                        GetFpDetails *getDetails=[[GetFpDetails alloc]init];
                        getDetails.delegate=self;
                        [getDetails fetchFpDetail];
                    }
                    else
                    {
                        UIAlertView *validFpAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Login failed no user found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
                        
                        [validFpAlert show];
                        
                        signInButton.backgroundColor = [UIColor colorFromHexCode:@"#ffb900"];
                        
                        validFpAlert=Nil;
                    }
                    
                }
                
                else{
                    UIAlertView *validFpAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Login failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
                    
                    [validFpAlert show];
                    
                    signInButton.backgroundColor = [UIColor colorFromHexCode:@"#ffb900"];
                    
                    validFpAlert=Nil;
                }
            }
        }
        
    }
    
    else
    {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Ooops" message:@"NF Manage is unable to fetch details" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        signInButton.backgroundColor = [UIColor colorFromHexCode:@"#ffb900"];
        
        alertView=nil;
    }

}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    
    if (code==200)
    {
        loginSuccessCode=200;
    }
    else
    {
        loginSuccessCode=code;
    }
    
    
}

-(void)downloadFinished
{
    [self updateView];
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
                
                NSNumber *isLoggedOn = [NSNumber numberWithBool:YES];
                
                NSDate *lastLoginDate = [NSDate date];
                
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
                                                   isLoggedOn,@"$LoggedIn",
                                                   lastLoginDate,@"$lastLoginDate",
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

-(void)downloadFailedWithError
{
    
    UIAlertView *failedAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not fetch website details." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil , nil];
    
    [failedAlert show];
    
    failedAlert=nil;
    
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
