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
@interface BookDomainnController ()

@end

@implementation BookDomainnController
@synthesize domianChkImage,domianChkLabel,suggestedUrltextView;
@synthesize userName,BusinessName,city,emailID,phono,country,pincode,category,suggestedURL;

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
                        [NSString stringWithFormat:@""],@"contactName",
                        userName,@"name",
                        [NSString stringWithFormat:@""],@"desc",
                        [NSString stringWithFormat:@"%@",city],@"city",
                        [NSString stringWithFormat:@"%@",pincode],@"pincode",
                        country,@"country",
                       // addressString,@"address",
                       // businessPhoneNumberTextField.text,@"primaryNumber",
                        //[NSString stringWithFormat:@"%@",countryCodeTextField.text],@"primaryNumberCountryCode",
                        [NSString stringWithFormat:@"%@",emailID],@"email",
                        [NSString stringWithFormat:@""],@"Uri",
                        [NSString stringWithFormat:@""],@"fbPageName",
                        category,@"primaryCategory",
                       // [NSString stringWithFormat:@"%f",storeLatitude],@"lat",
                      //  [NSString stringWithFormat:@"%f",storeLongitude],@"lng",
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
@end
