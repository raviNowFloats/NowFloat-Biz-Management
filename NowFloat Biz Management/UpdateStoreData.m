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


@implementation UpdateStoreData
@synthesize uploadDictionary,uploadArray;


-(void)updateStore:(NSMutableArray *)array
{

    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication ]delegate];
    
    NSDictionary *updateDic = @{@"fpTag":[appDelegate.storeDetailDictionary objectForKey:@"Tag"],@"clientId":@"DB96EA35A6E44C0F8FB4A6BAA94DB017C0DFBE6F9944B14AA6C3C48641B3D70",@"updates":array};

    NSString *updateString=[jsonWriter stringWithObject:updateDic];
    
    [uploadArray removeAllObjects];
    
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


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in UpdateStoreData:%@",[error localizedFailureReason]);
    
}


@end
 