//
//  UpdateStoreData.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 11/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "UpdateStoreData.h"
#import "SBJson.h"
#import "SBJsonWriter.h"
#import "BusinessDetailsViewController.h"
#import "Mixpanel.h"


@implementation UpdateStoreData
@synthesize uploadDictionary,uploadArray;
@synthesize delegate;


-(void)updateStore:(NSMutableArray *)array
{
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];

    appDelegate=(AppDelegate *)[[UIApplication sharedApplication ]delegate];
    
    NSDictionary *updateDic =
                @{
                @"fpTag":[appDelegate.storeDetailDictionary objectForKey:@"Tag"],
                @"clientId":appDelegate.clientId,
                @"updates":array
                };

    NSString *updateString=[jsonWriter stringWithObject:updateDic];

    [uploadArray removeAllObjects];
    
    NSData *postData = [updateString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSString *urlString=[NSString stringWithFormat:
                         @"%@/update/",appDelegate.apiWithFloatsUri];
    
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
    
    NSLog(@"code:%d",code);
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Edit Store"];
    
    if (code==200)
    {
        [delegate performSelector:@selector(storeUpdateComplete)];        
    }
    
    else
    {        
        [delegate performSelector:@selector(storeUpdateFailed)];
        
    }
    
    
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    
    [delegate performSelector:@selector(storeUpdateFailed)];

}


@end
 