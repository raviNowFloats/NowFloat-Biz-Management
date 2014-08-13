//
//  DownloadControl.m
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 13/08/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "DownloadControl.h"

@implementation DownloadControl

@synthesize delegate, receivedData;

-(void)startDownload
{
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSUserDefaults *userdetails=[NSUserDefaults standardUserDefaults];
    
    NSString *loginScriptURL = [NSString stringWithFormat:@"%@/nf-app/%@",appDelegate.apiWithFloatsUri,[userdetails objectForKey:@"userFpId"]];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loginScriptURL]];
    NSString *str = appDelegate.clientId;
    NSString *postString = [NSString stringWithFormat:@"\"%@\"",str];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody:postData];
    // Create the actual connection using the request.
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection)
    {
        NSLog(@"theConnection is succesful");
    }
    else
    {
        NSLog(@"theConnection failed");
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSUInteger responseStatusCode = [httpResponse statusCode];
    if(responseStatusCode != 200){
        if ([delegate respondsToSelector:@selector(downloadDidFail)])
        {
            [delegate performSelector:@selector(downloadDidFail)];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError *e = nil;
    receivedData = data;
    NSDictionary *fpDetails = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    NSLog(@"dictionary is %@", fpDetails);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"connectionDidFinishLoading");
    NSDictionary *fpDetails = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"Downloaded data is  %@",fpDetails);
    
    if ([delegate respondsToSelector:@selector(downloadDidSucceed:)])
    {
        [delegate performSelector:@selector(downloadDidSucceed:) withObject:fpDetails];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error in connecting");
    
    if ([delegate respondsToSelector:@selector(downloadDidFail)])
    {
        [delegate performSelector:@selector(downloadDidFail)];
    }
}

@end
