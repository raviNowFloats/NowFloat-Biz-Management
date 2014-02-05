//
//  StoreSubscribers.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/05/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "StoreSubscribers.h"

@implementation StoreSubscribers
@synthesize delegate;


-(void)getStoreSubscribers
{
    @try
    {
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    msgData=[[NSMutableData alloc]init];
    
    subscriberCount=[[NSString alloc]init];
    
    NSString *subscriberUrlString=[NSString stringWithFormat:@"%@/%@/subscriberCount?clientId=%@",appDelegate.apiWithFloatsUri,[appDelegate.storeDetailDictionary objectForKey:@"Tag"],appDelegate.clientId];
        
    NSURL *subscriberUrl=[NSURL URLWithString:subscriberUrlString];
        
    NSMutableURLRequest *getFloatDetailsRequest = [NSMutableURLRequest requestWithURL:subscriberUrl];
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:getFloatDetailsRequest delegate:self];
    }
    @catch (NSException *e) {
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    
    [msgData appendData:data1];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    NSMutableString *str=[[NSMutableString alloc]initWithData:msgData encoding:NSUTF8StringEncoding];
    
    
    if (str==NULL)
    {
        str=[NSMutableString stringWithFormat:@"***"];
        [delegate performSelector:@selector(showSubscribers:) withObject:str];
    }
    
    
    else
    {
        [delegate performSelector:@selector(showSubscribers:) withObject:str];
        
    }
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    //    int code = [httpResponse statusCode];
    
    
}

-(void)connection:(NSURLConnection *)connection   didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in getting GETBIZFLOAT :%@",[error localizedFailureReason]);
    
}

@end
