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


@implementation UpdateStoreData
@synthesize uploadDictionary,uploadArray;


-(void)updateStore:(NSMutableDictionary *)dictionary;
{
    
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
        
    NSDictionary *a=@{@"value":[dictionary objectForKey:@"DESCRIPTION"],@"key":@"DESCRIPTION"};
    
    NSArray *arrayJson=[[NSMutableArray alloc]initWithObjects:a, nil];
    
    NSDictionary *updateDic = @{@"fpTag":@"RAJMUSIC",@"clientId":@"39EB5FD120DC4394A10301B108030CB70FA553E91F984C829AB6ADE23B6767B7",@"updates":arrayJson};

    NSString *updateString=[jsonWriter stringWithObject:updateDic];

    NSLog(@"updateString:%@",updateString);
        
    NSData *postData = [updateString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSString *urlString=[NSString stringWithFormat:
                         @"https://api.withfloats.com/Discover/v1/FloatingPoint/update/"];

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
 
    NSLog(@"Upload Success Code :%d",code);
    
}

@end
 