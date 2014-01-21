//
//  AddWidgetController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 04/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "AddWidgetController.h"
#import "SBJson.h"
#import "SBJsonWriter.h"

@implementation AddWidgetController
@synthesize delegate,buttonTag;


-(void)addWidgetsForFp:(NSDictionary *)detailsDictionary
{

    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
    
    msgData=[[NSMutableData alloc]init];
    
    NSString *urlString=[NSString stringWithFormat:
                         @"%@/addWidget",appDelegate.apiWithFloatsUri];
    
    NSDictionary *uploadDictionary=
    @{
     @"clientId":appDelegate.clientId,
     @"clientProductId":[detailsDictionary objectForKey:@"clientProductId"],
     @"NameOfWidget":[detailsDictionary objectForKey:@"NameOfWidget"],
     @"widgetKey":[detailsDictionary objectForKey:@"widgetKey"],
     @"fpId":[appDelegate.storeDetailDictionary objectForKey:@"_id"],
     @"paidAmount":[detailsDictionary objectForKey:@"paidAmount"],
     @"totalMonthsValidity":[detailsDictionary objectForKey:@"totalMonthsValidity"]
     };
    
    NSString *uploadString=[jsonWriter stringWithObject:uploadDictionary];
    
    NSData *postData = [uploadString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];

    NSURL *uploadUrl=[NSURL URLWithString:urlString];

    NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:uploadUrl];
    
    [uploadRequest setHTTPMethod:@"POST"];
    
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
        [delegate performSelector:@selector(addWidgetDidSucceed)];
    }
    
    
    else
    {
        [delegate performSelector:@selector(addWidgetDidFail)];        
    }
    
    
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
        
    [delegate performSelector:@selector(addWidgetDidFail)];
    
}



@end
