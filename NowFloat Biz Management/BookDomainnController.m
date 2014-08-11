//
//  BookDomainnController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/31/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "BookDomainnController.h"
#import "VerifyUniqueNameController.h"
#import "Mixpanel.h"
#import "PopUpView.h"
#import "BizMessageViewController.h"
#import "Aarki.h"
#import "AarkiContact.h"
#import "RegisterChannel.h"
#import "FileManagerHelper.h"
#import "RIATipsController.h"
#import "DomainSelectViewController.h"


@interface BookDomainnController ()<RegisterChannelDelegate,PopUpDelegate>

@end

@implementation BookDomainnController
@synthesize domianChkImage,domianChkLabel,suggestedUrltextView;
@synthesize userName,BusinessName,city,emailID,phono,country,pincode,category,suggestedURL,countryCode;
@synthesize addressValue,fbpageName;

@synthesize longt,latt;
@synthesize primaryImageURL,pageDescription;

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
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view from its nib.
    
    suggestedUrltextView.text = suggestedURL;
}
-(void)textViewDidChange:(UITextView *)textView
{
    if([textView.text isEqualToString:@""])
    {
        self.domianChkImage.image = [UIImage imageNamed:@"domain_not_available.png"];
        self.domianChkLabel.text = @"Please enter a valid Sub-Domain";
    }
    else
    {
        
        if(textView==suggestedUrltextView)
        {
            VerifyUniqueNameController *uniqueNameController=[[VerifyUniqueNameController alloc]init];
            
            uniqueNameController.delegate=self;
            
            [uniqueNameController verifyWithFpName:BusinessName andFpTag:suggestedUrltextView.text];
        }
    }
    
    
}

-(void)verifyUniqueNameDidComplete:(NSString *)responseString
{
     
    if ([[responseString lowercaseString] isEqualToString:suggestedUrltextView.text])
    {
        
        self.domianChkImage.image = [UIImage imageNamed:@"domain_available.png"];
        self.domianChkLabel.text  = @"Chosen Sub-Domain is Available";
        
    }
    
    
    else
    {
        self.domianChkImage.image = [UIImage imageNamed:@"domain_not_available.png"];
        self.domianChkLabel.text  = @"Chosen Sub-Domain is not Available";
        
    }
    
    
}

-(void)verifyuniqueNameDidFail:(NSString *)responseString
{
   
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createMysite:(id)sender {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Create Website"];
    
    [self.view endEditing:YES];
    
    if (suggestedUrltextView.text.length==0)
    {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Store domain cannot be empty" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        alertView=nil;
        
    }
    
    else
    {
        NSMutableDictionary *regiterDetails;
       
        regiterDetails=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                        appDelegate.clientId,@"clientId",
                        suggestedUrltextView.text,@"tag",
                        userName,@"contactName",
                        BusinessName,@"name",
                        pageDescription,@"desc",
                        [NSString stringWithFormat:@"%@",city],@"city",
                        [NSString stringWithFormat:@"%@",pincode],@"pincode",
                        country,@"country",
                        addressValue,@"address",
                        phono,@"primaryNumber",
                        [NSString stringWithFormat:@"%@",countryCode],@"primaryNumberCountryCode",
                        [NSString stringWithFormat:@"%@",emailID],@"email",
                        [NSString stringWithFormat:@""],@"Uri",
                        fbpageName,@"fbPageName",
                        category,@"primaryCategory",
                        [NSString stringWithFormat:@"%@",longt],@"lat",
                        [NSString stringWithFormat:@"%@",latt],@"lng",
                        nil];
        
        
        SignUpController *signUpController=[[SignUpController alloc]init];
        
        signUpController.delegate=self;
        
        [signUpController withCredentials:regiterDetails];
        
    }

    
    
}

-(void)signUpDidSucceedWithFpId:(NSString *)responseString
{
    [self showBizMessageView:responseString];
}

-(void)signUpDidFailWithError
{
   
    
    UIAlertView *fpCreationFailError=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Sorry something went wrong while creating your website" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [fpCreationFailError show];
    
    fpCreationFailError=nil;
    
}

-(void)showBizMessageView:(NSString *)responseString
{
    
   // createdFpName = responseString;
    
    NSUserDefaults  *userDefaults=[NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:responseString  forKey:@"userFpId"];
    
    [userDefaults synchronize];
    
    /*Get all the messages and store details*/
    
    GetFpDetails *getDetails=[[GetFpDetails alloc]init];
    
    getDetails.delegate=self;
    
    [getDetails fetchFpDetail];
}

-(void)downloadFinished
{
    
    
    if (BOOST_PLUS)
    {
        PopUpView *buyDomainPopUp = [[PopUpView alloc]init];
        buyDomainPopUp.delegate=self;
        buyDomainPopUp.tag=102;
        buyDomainPopUp.successBtnText=@"Book Now";
        buyDomainPopUp.cancelBtnText=@"May be Later";
        buyDomainPopUp.titleText = @"Book your Domain";
        buyDomainPopUp.descriptionText = @"Your NowFloats website is now ready.You can now dress it up with your own domain name reflecting your business identity. Choose your free .com or .net now.";
        buyDomainPopUp.descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        buyDomainPopUp.popUpImage=[UIImage imageNamed:@"storeDomain2.png"];
        [buyDomainPopUp showPopUpView];
    }
    
    else
    {
        [self navigateBizMessageView];
    }
}

-(void)navigateBizMessageView
{
    @try
    {
        [self setRegisterChannel];
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel identify:appDelegate.storeTag]; //username
        
        NSDate *createdDate = [NSDate date];
        
        NSDictionary *specialProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                           appDelegate.storeEmail, @"$email",
                                           appDelegate.businessName, @"$name",
                                           createdDate,@"$Created On",
                                           nil];
        
        [mixpanel.people set:specialProperties];
        [mixpanel.people addPushDeviceToken:appDelegate.deviceTokenData];
        
        
        
    }
    
    @catch (NSException *e){}
    
    FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
    
    fHelper.userFpTag=appDelegate.storeTag;
    
    [fHelper createUserSettings];
    
    [fHelper updateUserSettingWithValue:[NSDate date] forKey:@"1stSignUpDate"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *startTime = [NSDate date];
    
    [userDefaults setObject:startTime forKey:@"appStartDate"];
    
    [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"showTutorialView"];
    
    [AarkiContact registerEvent:@"26D69ACEA3F720D5OU"];
    
    
//    BizMessageViewController *frontController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
//    
//    frontController.isLoadedFirstTime=YES;
//    
//    [self.navigationController pushViewController:frontController animated:YES];
    
    
    NSLog(@"NAvigation : %@",self.navigationController);
    
     RIATipsController *ria = [[RIATipsController alloc]initWithNibName:@"RIATipsController" bundle:nil];
     [self.navigationController pushViewController:ria animated:YES];
    
    
    // frontController=nil;
}

-(void)setRegisterChannel
{
    RegisterChannel *regChannel=[[RegisterChannel alloc]init];
    
    regChannel.delegate=self;
    
    [regChannel registerNotificationChannel];
}

#pragma PopUpDelegate

-(void)successBtnClicked:(id)sender
{
    if ([[sender objectForKey:@"tag"] intValue]==101)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Cancel SignUp"];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    else if ([[sender objectForKey:@"tag"] intValue]==102)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"goto_domainPurchasefromSignUp"];
        
        DomainSelectViewController *selectController=[[DomainSelectViewController alloc]initWithNibName:@"DomainSelectViewController" bundle:Nil];
        
        selectController.isFromOtherViews = YES;
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:selectController];
        
        [self presentViewController:navController animated:YES completion:nil];
    }
}


-(void)cancelBtnClicked:(id)sender
{
    if ([[sender objectForKey:@"tag"] intValue]==102)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"cancel_domainPurchasefromSignUp"];
        
        NSMutableDictionary *userSetting=[[NSMutableDictionary alloc]init];
        
        FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
        
        fHelper.userFpTag = appDelegate.storeTag;
        
        if ([userSetting objectForKey:@"isDomainPurchaseCancelled"]==nil)
        {
            [fHelper updateUserSettingWithValue:[NSNumber numberWithBool:NO] forKey:@"isDomainPurchaseCancelled"];
        }
        
        [self navigateBizMessageView];
    }
}

-(void)downloadFailedWithError
{
    
       UIAlertView *downloadAlertView = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong during download. Please kill the application and click Login In" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
    
    [downloadAlertView show];
    
    downloadAlertView = nil;
    
}

-(void)channelDidRegisterSuccessfully
{
}

-(void)channelFailedToRegister
{
}
@end
