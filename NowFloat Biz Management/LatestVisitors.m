//
//  LatestVisitors.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/13/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "LatestVisitors.h"


@implementation LatestVisitors
@synthesize delegate;


-(void)getLastVisitorDetails
{
    @try
    {
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        msgData=[[NSMutableData alloc]init];
        
        NSString  *visitorDetailsUrlString=[NSString stringWithFormat:@"%@/%@/latestVisitorDetails?clientId=%@",appDelegate.apiWithFloatsUri,[appDelegate.storeDetailDictionary objectForKey:@"Tag"],appDelegate.clientId];
        
        NSURL *visitorDetailUrl=[NSURL URLWithString:visitorDetailsUrlString];
        
        NSMutableURLRequest *getFloatDetailsRequest = [NSMutableURLRequest requestWithURL:visitorDetailUrl];
        
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
    if(statusCode == 200)
    {
        NSError *error;
        NSMutableDictionary* json = [NSJSONSerialization
                                     JSONObjectWithData:msgData //1
                                     options:kNilOptions
                                     error:&error];
        
        [delegate performSelector:@selector(lastVisitDetails:) withObject:json];
    }
    else
    {
        [delegate performSelector:@selector(failedToGetVisitDetails)];
    }
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    statusCode = [httpResponse statusCode];
    
}

-(void)connection:(NSURLConnection *)connection   didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in getting GETBIZFLOAT :%@",[error localizedFailureReason]);
    
}

@end
