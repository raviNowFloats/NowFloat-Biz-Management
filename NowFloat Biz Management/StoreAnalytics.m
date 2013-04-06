//
//  StoreAnalytics.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 14/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "StoreAnalytics.h"

@implementation StoreAnalytics




-(NSString *)getStoreAnalytics:(NSData *)data
{

    subscriberString=[[NSString alloc]init];
    
    if (data==nil)
    
    {
        subscriberString=@"No Description";
    }
    
    
    else
    {
        NSMutableString *str=[[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
        subscriberString=str;
    }
    
    
    return subscriberString;

}



-(void)getVistorPattern
{
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    receivedData=[[NSMutableData alloc]init];
    NSString *vistorPatternUrlString=[NSString stringWithFormat:
    @"%@/monthlyvisits/%@",appDelegate.apiWithFloatsUri,[appDelegate.storeDetailDictionary objectForKey:@"Tag"]];
    
    NSURL *visitorPatternUrl=[NSURL URLWithString:vistorPatternUrlString];
    
    vistorPatternData=[[NSMutableData alloc]init];
    
    vistorPatternData=[NSData dataWithContentsOfURL:visitorPatternUrl];
    
    NSMutableString *clientIdString=[[NSMutableString alloc]initWithFormat:@"\"%@\"",appDelegate.clientId];
    
    NSData *postData = [clientIdString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:visitorPatternUrl];
    
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

    [receivedData appendData:data1];


}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSError* error;
    NSMutableArray* json = [NSJSONSerialization
                                 JSONObjectWithData:receivedData //1
                                 options:kNilOptions
                                 error:&error];
    
    [appDelegate.storeVisitorGraphArray addObjectsFromArray:json];
    
    
    json=nil;
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{


    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
        
    if (code==200)
    {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRoot" object:nil];

    }



}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{

    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeFetchingSubView" object:nil];
    
    
    NSLog (@"Connection Failed in storeAnalytics:%d",[error code]);


}






@end
