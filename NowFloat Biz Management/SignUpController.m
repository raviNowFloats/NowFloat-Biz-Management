//
//  SignUpController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 02/08/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "SignUpController.h"
#import "SBJson.h"
#import "SBJsonWriter.h"

@implementation SignUpController
@synthesize delegate;

-(void)withCredentials:(NSMutableDictionary *)signUpDetails
{
    
    successCode=0;
    
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];

    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    receivedData=[[NSMutableData alloc]init];
    
    NSString *updateString=[jsonWriter stringWithObject:signUpDetails];
    
    NSData *postData = [updateString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSString *urlString=[NSString stringWithFormat:
                         @"%@/Discover/v3/FloatingPoint/create",appDelegate.apiUri];
    
    NSURL *uploadUrl=[NSURL URLWithString:urlString];
    
    NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:uploadUrl];

    [uploadRequest setHTTPMethod:@"PUT"];
    
    [uploadRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [uploadRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [uploadRequest setHTTPBody:postData];

    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:uploadRequest delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    
    [receivedData appendData:data1];
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSString *str=[[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];

    str=[str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    if (successCode==200)
    {
        
        if (str==NULL)
        {
            [delegate performSelector:@selector(signUpDidFailWithError)];
           
            
        }
        
        else
        {
            [delegate performSelector:@selector(signUpDidSucceedWithFpId:) withObject:str];


        }
            
        
    }
    
    
    
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
        
    if (code==200)
    {
        successCode=200;
    }
    
    
    else
    {
    
        [delegate performSelector:@selector(signUpDidFailWithError)];
    
    }
    
    
}




-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    
    [errorAlert show];
    
    [delegate performSelector:@selector(signUpDidFailWithError)];
    
    NSLog (@"Connection Failed in Create FpID:%@",[error localizedFailureReason]);
    
}


@end
