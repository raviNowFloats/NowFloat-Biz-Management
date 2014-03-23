//
//  BuyDomainController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 06/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BuyDomainController.h"
#import "SBJson.h"
#import "SBJsonWriter.h"

@implementation BuyDomainController
@synthesize delegate;

-(void)buyDomain:(NSDictionary *)detailsDictionary
{
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    msgData=[[NSMutableData alloc]init];

    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];

    NSString *urlString=[NSString stringWithFormat:
                         @"%@/domainservice/v1/domainWithWebsite/create",appDelegate.apiUri];
    
    NSString *uploadString=[jsonWriter stringWithObject:detailsDictionary];
    
    NSData *postData = [uploadString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
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


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int code = [httpResponse statusCode];
        
    if (code==200)
    {
        [delegate performSelector:@selector(buyDomainDidSucceed)];
    }
    
    else
    {
        [delegate performSelector:@selector(buyDomainDidFail)];
    }
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    
    NSLog(@"error:%@",error.localizedDescription);
    
    [delegate performSelector:@selector(buyDomainDidFail)];
    
}


@end
