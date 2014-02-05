//
//  StoreVisits.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/05/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "StoreVisits.h"

@implementation StoreVisits
@synthesize delegate;

-(void)getStoreVisits
{
    @try
    {
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    msgData=[[NSMutableData alloc]init];
    
    visitorCount=[[NSString alloc]init];    

    NSString  *visitorCountUrlString=[NSString stringWithFormat:@"%@/%@/visitorCount?clientId=%@",appDelegate.apiWithFloatsUri,[appDelegate.storeDetailDictionary objectForKey:@"Tag"],appDelegate.clientId];
    
    NSURL *visitorCountUrl=[NSURL URLWithString:visitorCountUrlString];

    NSMutableURLRequest *getFloatDetailsRequest = [NSMutableURLRequest requestWithURL:visitorCountUrl];
        
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:getFloatDetailsRequest delegate:self];
    }
    
    @catch (NSException *e) {

    }
}


-(void)getStoreSubscribers
{

    msgData=[[NSMutableData alloc]init];

    subscriberCount=[[NSString alloc]init];
    
    NSString *subscriberUrlString=[NSString stringWithFormat:@"%@/%@/subscriberCount?clientId=%@",appDelegate.apiWithFloatsUri,[appDelegate.storeDetailDictionary objectForKey:@"Tag"],appDelegate.clientId];
    
    NSURL *subscriberUrl=[NSURL URLWithString:subscriberUrlString];
    
    NSMutableURLRequest *getFloatDetailsRequest = [NSMutableURLRequest requestWithURL:subscriberUrl];
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:getFloatDetailsRequest delegate:self];

}


-(NSString *)getStoreAnalytics:(NSData *)data
{
    recievedString=[[NSString alloc]init];
    
    if (data==nil)
        
    {
        recievedString=@"***";
    }
    else
    {
        NSMutableString *str=[[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        recievedString=str;
    }
    return recievedString;
    
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
        [delegate performSelector:@selector(showVisitors:) withObject:str];
    }
    
    
    else
    {    
        [delegate performSelector:@selector(showVisitors:) withObject:str];

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
