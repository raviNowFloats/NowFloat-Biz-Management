//
//  BookDomainController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 27/03/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "BookDomainController.h"
#import "SBJson.h"
#import "SBJsonWriter.h"

@interface BookDomainController()
{
   BOOL isSuccess;
    NSURLConnection *theConnection;
}
@end

@implementation BookDomainController
@synthesize delegate;

-(void)bookDomain:(NSDictionary *)detailsDictionary
{
    @try
    {
        appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        
        userDefaults=[NSUserDefaults standardUserDefaults];
        
        msgData=[[NSMutableData alloc]init];
        
        SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
//https://api.withfloats.com
        
        NSString *urlString=[NSString stringWithFormat:
                             @"%@/domainservice/v1/requestdomainpurchase",appDelegate.apiUri];
        
//        NSString *urlString=[NSString stringWithFormat:
//                             @"https://api.withfloats.com/domainservice/v1/requestdomainpurchase"];
        
        NSString *uploadString=[jsonWriter stringWithObject:detailsDictionary];
        
        NSData *postData = [uploadString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSURL *uploadUrl=[NSURL URLWithString:urlString];
        
        NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:uploadUrl];
        
        [uploadRequest setHTTPMethod:@"POST"];
        
        [uploadRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [uploadRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        [uploadRequest setHTTPBody:postData];
        
        theConnection =[[NSURLConnection alloc] initWithRequest:uploadRequest delegate:self];
    }
    
    @catch (NSException *exception)
    {
        NSLog(@"exception:%@",exception.description);
        [delegate bookDomainDidFail];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [msgData appendData:data1];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (isSuccess)
    {
        
        NSString *receivedString=[[NSMutableString alloc]initWithData:msgData encoding:NSUTF8StringEncoding];
        
        if (receivedString.length==0 || receivedString==NULL)
        {
            NSString *failedString=@"";
            
            [delegate performSelector:@selector(bookDomainDidSucceedWithObject:) withObject:failedString];
        }
        
        else
        {
            receivedString = [receivedString
                              stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            [delegate performSelector:@selector(bookDomainDidSucceedWithObject:) withObject:receivedString];
        }
        
    }
    
}



- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int code = [httpResponse statusCode];
    
    NSLog(@"code to bookdomain:%d",code);
    
    isSuccess=NO;
    
    if (code!=200)
    {
        theConnection=Nil;
        [delegate performSelector:@selector(bookDomainDidFail)];
    }
    
    else
    {
        isSuccess =YES;
    }
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    
    NSLog(@"error:%@",error.localizedDescription);
    
    theConnection=nil;
    
    [delegate performSelector:@selector(bookDomainDidFail)];
    
}


@end
