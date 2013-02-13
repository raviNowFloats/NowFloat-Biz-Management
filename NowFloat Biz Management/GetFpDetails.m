//
//  GetFpDetails.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 13/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "GetFpDetails.h"
#import "SBJson.h"
#import "SBJsonWriter.h"
#import "AppDelegate.h"
#import "BizMessageViewController.h"


#define kBackGroudQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)

@implementation GetFpDetails

@synthesize fpId;



-(void)fetchFpDetail:(NSMutableDictionary *)dictionary
{
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *urlString=[NSString stringWithFormat:
                         @"https://api.withfloats.com/discover/v1/floatingPoint/%@",[[dictionary objectForKey:@"ValidFPIds"]objectAtIndex:0 ]];
        
    NSMutableString *clientIdString=[[NSMutableString alloc]initWithFormat:@"\"%@\"",appDelegate.clientId];
        
    NSData *postData = [clientIdString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [storeRequest setHTTPMethod:@"POST"];
    
    [storeRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [storeRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [storeRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [storeRequest setHTTPBody:postData];
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:storeRequest delegate:self];

}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    

    
    if (data1==nil)
    {

        NSLog(@" data parameter is nil");
        
    }
    
    else
    {
        receivedData =[[NSMutableData alloc]init];
        
        [receivedData appendData:data1];
    }
    
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError* error;
    NSMutableDictionary* json = [NSJSONSerialization
                                 JSONObjectWithData:receivedData
                                 options:kNilOptions
                                 error:&error];
    
    [appDelegate.storeDetailDictionary addEntriesFromDictionary:json];
    
    /*fetch store messages here*/
    
    NSString *urlString=[NSString stringWithFormat:@"https://api.withfloats.com/Discover/v1/floatingPoint/bizFloats?clientId=%@&skipBy=0&fpId=%@",appDelegate.clientId,fpId];
    
    NSURL *url=[NSURL URLWithString:urlString];
    
    dispatch_async(kBackGroudQueue, ^{
        
        msgData = [NSData dataWithContentsOfURL: url];
        
        [self performSelectorOnMainThread:@selector(fetchStoreMessage:)
                               withObject:msgData waitUntilDone:YES];
        
        
    });
    

    
    
}



- (void)fetchStoreMessage:(NSData *)responseData
{
    
    NSError* error;
    NSMutableDictionary* json = [NSJSONSerialization
                                 JSONObjectWithData:responseData //1
                                 options:kNilOptions
                                 error:&error];
    
    if ([json count])
    {
        
        /*Save the StoreDetailDictionary in AppDelegate*/
        
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate.fpDetailDictionary addEntriesFromDictionary:json];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRoot" object:nil];

    }
    
    
}



@end
