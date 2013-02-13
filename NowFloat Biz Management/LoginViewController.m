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


@interface LoginViewController ()

@end

#define kBackGroudQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)

@implementation LoginViewController

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
    
    NSMutableURLRequest *loginRequest = [NSMutableURLRequest requestWithURL:loginUrl];
    
    [loginRequest setHTTPMethod:@"POST"];
    
    [loginRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [loginRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [loginRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [loginRequest setHTTPBody:postData];

    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:loginRequest delegate:self];

    isForLogin=1;
    
    
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
                
        [fetchingDetailsSubview setHidden:NO];
    
        GetFpDetails *getDetails=[[GetFpDetails alloc]init];
        
        [getDetails setFpId:[[dic objectForKey:@"ValidFPIds"]objectAtIndex:0 ]];
        
        [getDetails fetchFpDetail:validDictionary];
        

        
    }
    
    
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];

//    NSLog(@"Code:%d",code);


        if (isForLogin==1)
        {
               
            if (code==200)
            {
                    
                loginSuccessCode=200;
                
            
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




@end
