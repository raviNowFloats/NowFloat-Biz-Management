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

    isForLogin=0;

    isForStore=0;
    
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

//adharwajewellery

- (IBAction)loginButtonClicked:(id)sender
{
    
    NSMutableDictionary *dic=[[NSMutableDictionary  alloc]initWithObjectsAndKeys:@"Hello",@"loginKey",@"Hello",@"loginSecret",@"DB96EA35A6E44C0F8FB4A6BAA94DB017C0DFBE6F9944B14AA6C3C48641B3D70",@"clientId", nil];
    
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
    NSLog(@"receivedData:%@",receivedData);
    
    [receivedData appendData:data1];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    NSError *error;

    NSMutableDictionary *dic=[NSJSONSerialization
                              JSONObjectWithData:receivedData //1
                              options:kNilOptions
                              error:&error];

    
    NSLog(@"Dic:%@",dic);
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
        
    if (isForLogin==1)
        

    {
        NSLog(@"response code for login:%d",code);
        if (code==200)
        {
            
            
            [fetchingDetailsSubview setHidden:NO];
            
            //50efb6e24ec0a4121cb05032
            
            //NSString *urlString=[NSString stringWithFormat:@"https://api.withfloats.com/Discover/v1/floatingPoint/thecourtyard?clientId=5C5C061C6B1F48129AF284A5D0CDFBDD5DC3A7547D3345CFA55C0300160A829A"];
            
            
            NSString *urlString=[NSString stringWithFormat:@"https://api.withfloats.com/Discover/v1/floatingPoint/bizFloats?clientId=DB96EA35A6E44C0F8FB4A6BAA94DB017C0DFBE6F9944B14AA6C3C48641B3D70&skipBy=0&fpId=50dc45724ec0a40c547b7d75"];
            
            NSURL *url=[NSURL URLWithString:urlString];

            dispatch_async(kBackGroudQueue, ^{
                
                data = [NSData dataWithContentsOfURL: url];
                
            
                [self performSelectorOnMainThread:@selector(fetchStoreDetails:)
                                           withObject:data waitUntilDone:YES];
                
                
            });

            
            
            
//            NSString *urlString=[NSString stringWithFormat:
//                                 @"https://api.withfloats.com/Discover/v1/floatingPoint/502f663d4ec0a417144900ee"];
//            
//            
//            NSMutableDictionary *dic=[[NSMutableDictionary  alloc]initWithObjectsAndKeys:@"DB96EA35A6E44C0F8FB4A6BAA94DB017C0DFBE6F9944B14AA6C3C48641B3D70",@"clientId", nil];
//            
//            SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
//            
//            NSString *uploadString=[jsonWriter stringWithObject:dic];
//            
//            NSData *postData = [uploadString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//            
//            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
//            
//            NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//            
//            [storeRequest setHTTPMethod:@"POST"];
//            
//            [storeRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//            
//            [storeRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//            
//            [storeRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
//            
//            [storeRequest setHTTPBody:postData];
//            
//            NSURLConnection *theConnection;
//            
//            theConnection =[[NSURLConnection alloc] initWithRequest:storeRequest delegate:self];
//
//            isForLogin=0;
//            isForStore=1;
            
        }

        
    }
    
    
   else if (isForStore==1)
    {
        
        NSLog(@"response code for store:%d",code);
    
    }
    
}





- (void)fetchStoreDetails:(NSData *)responseData
{
        
    NSError* error;
    NSMutableDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          options:kNilOptions
                          error:&error];
        
    /*Push the MessageController here*/
    
   // NSLog(@"Fp Messages:%@",json);

    
    
    
    
    
    
    
    if ([json count])
    {
        

        
//        NSString *urlString=[NSString stringWithFormat:@"https://api.withfloats.com/Discover/v1/floatingPoint/50efb6e24ec0a4121cb05032"];
//        
//        NSURL *url=[NSURL URLWithString:urlString];
//        
//        dispatch_async(kBackGroudQueue, ^{
//            
//            data = [NSData dataWithContentsOfURL: url];
//            
//            
//            [self performSelectorOnMainThread:@selector(fetchFpDetails:)
//                                   withObject:data waitUntilDone:YES];
//            
//            
//        });
        
        
        
        [fetchingDetailsSubview setHidden:YES];
        
        /*Save the StoreDetailDictionary in AppDelegate*/
        
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        appDelegate.storeDetailDictionary=json;
        
        BizMessageViewController *frontController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
        
        [self.navigationController pushViewController:frontController animated:YES];
        
        frontController=nil;
        
        
                
    }
    
    
}




-(void)fetchFpDetails:(NSData *)responseData
{


    NSError* error;
    NSMutableDictionary* json = [NSJSONSerialization
                                 JSONObjectWithData:responseData //1
                                 options:kNilOptions
                                 error:&error];
    
    /*Push the MessageController here*/
    
    NSLog(@"FpData:%@",json);
    
    
    
    if ([json count]) {
        
        
        [fetchingDetailsSubview setHidden:YES];

        /*Save the StoreDetailDictionary in AppDelegate*/
        
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        appDelegate.storeDetailDictionary=json;
        
        BizMessageViewController *frontController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
        
        [self.navigationController pushViewController:frontController animated:YES];
        
        frontController=nil;

        
    }

}

@end
