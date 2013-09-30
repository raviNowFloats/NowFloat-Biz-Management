//
//  SuggestBusinessDomain.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 06/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "SuggestBusinessDomain.h"
#import "SBJson.h"
#import "SBJsonWriter.h"

@implementation SuggestBusinessDomain
@synthesize delegate;


-(void)suggestBusinessDomainWith:(NSDictionary *)requestObject
{
    
    isSuccess=NO;
    
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    receivedData =[[NSMutableData alloc]init];
    
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
        
    NSString *updateString=[jsonWriter stringWithObject:requestObject];
        
    NSData *postData = [updateString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSString *suggestString=[NSString stringWithFormat:@"%@/suggestTag",appDelegate.apiWithFloatsUri];
    
    NSURL *suggestUrl=[NSURL URLWithString:suggestString];
            
    NSMutableURLRequest *getSuggestRequest = [NSMutableURLRequest requestWithURL:suggestUrl];
    
    [getSuggestRequest setHTTPMethod:@"POST"];
    
    [getSuggestRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [getSuggestRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [getSuggestRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [getSuggestRequest setHTTPBody:postData];
    
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:getSuggestRequest delegate:self];
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [receivedData appendData:data1];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
        
    if (isSuccess)
    {
        
        NSString *receivedString=[[NSMutableString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        if (receivedString.length==0 || receivedString==NULL)
        {
            NSString *failedString=@"";
            
            [delegate performSelector:@selector(suggestBusinessDomainDidComplete:) withObject:failedString];            
        }
        
        else
        {
        receivedString = [receivedString
                          stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        
        [delegate performSelector:@selector(suggestBusinessDomainDidComplete:) withObject:receivedString];
        }
        
    }
    
    
    else
    {        
        NSString *failedString=@"";
        [delegate performSelector:@selector(suggestBusinessDomainDidComplete:) withObject:failedString];
    }
        
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];

    isSuccess=NO;
    
    if (code!=200)
    {
        isSuccess=NO;
        
        NSString *failedString=@"";
        [delegate performSelector:@selector(suggestBusinessDomainDidComplete:) withObject:failedString];

    }
    
    else
    {
        isSuccess=YES;
        
    }
    
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    
    NSString *failedString=@"";
    
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    [delegate performSelector:@selector(suggestBusinessDomainDidComplete:) withObject:failedString];

}


@end
