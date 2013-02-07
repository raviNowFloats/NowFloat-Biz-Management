//
//  LoginViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 05/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "LoginViewController.h"
#import "BizMessageViewController.h"

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
    
    
    [fetchingDetailsSubview setHidden:NO];

    
    NSString *urlString=[NSString stringWithFormat:
                         @"https://api.withfloats.com/Discover/v1/floatingPoint/musaddilalandsons?clientId=5C5C061C6B1F48129AF284A5D0CDFBDD5DC3A7547D3345CFA55C0300160A829A"];
    
    NSURL *url=[NSURL URLWithString:urlString];
    
    dispatch_async(kBackGroudQueue, ^{
        
        data = [NSData dataWithContentsOfURL: url];
        
        
        if (data==nil)
        {
            NSLog(@"NIL DATA");
            dispatch_async(kBackGroudQueue, ^{
                
                data = [NSData dataWithContentsOfURL: url];
                
                [self performSelectorOnMainThread:@selector(fetchStoreDetails:)
                                       withObject:data waitUntilDone:YES];
            });
            
        }
        
        
        else{
            
            [self performSelectorOnMainThread:@selector(fetchStoreDetails:)
                                   withObject:data waitUntilDone:YES];
        }
        
        
    });
    
    

    
}





- (void)fetchStoreDetails:(NSData *)responseData
{
        
    NSError* error;
    NSMutableDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          options:kNilOptions
                          error:&error];
        
    /*Push the MessageController here*/
    
    
    NSLog(@"Json:%@",json);
    
    if ([json count])
    {
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
