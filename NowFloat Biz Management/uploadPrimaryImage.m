//
//  uploadPrimaryImage.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 19/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "uploadPrimaryImage.h"

@implementation uploadPrimaryImage


-(void)uploadImage:(NSData *)imageData uuid:(NSString *)uniqueId numberOfChunks:(int)numberOfChunks currentChunk:(int)currentChunk;
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    userDetails=[NSUserDefaults standardUserDefaults];
    
    NSString *postLength1 = [NSString stringWithFormat:@"%d",[imageData length]];
    
    NSString *postLength=[[NSString alloc]initWithString:postLength1];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
//    NSString *urlString=[NSString stringWithFormat:@"%@/createImage?clientId=%@&fpId=%@&reqType=parallel&reqtId=%@&totalChunks=%d&currentChunkNumber=%d",appDelegate.apiWithFloatsUri,appDelegate.clientId,[userDetails objectForKey:@"userFpId"],uniqueId,numberOfChunks,currentChunk];
    
    
    NSString *urlString=[NSString stringWithFormat:@"ec2-54-242-250-105.compute-1.amazonaws.com/Discover/v1/floatingPoint/createImage?clientId=%@&fpId=%@&reqType=parallel&reqtId=%@&totalChunks=%d&currentChunkNumber=%d",appDelegate.clientId,[userDetails objectForKey:@"userFpId"],uniqueId,numberOfChunks,currentChunk];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *imageUploadUrl=[[NSString alloc]initWithString:urlString];
    
    NSURL *uploadUrl=[NSURL URLWithString:imageUploadUrl];
    
    [request setURL:uploadUrl];
    [request setHTTPMethod:@"PUT"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"binary/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setCachePolicy:NSURLCacheStorageAllowed];
    [request setHTTPBody:imageData];
    
    NSURLConnection *theConnection;
    //theConnection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
  
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int code = [httpResponse statusCode];
    
    if (code==200)
    {        
        NSLog(@"code to upload image:%d",code);
    }
    
    else
    {
        NSLog(@"code to upload image:%d",code);
        
        UIAlertView *imageUploadFailAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Yikes! Image upload failed please try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [imageUploadFailAlert  show];
        
        imageUploadFailAlert=nil;
    }
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in GetFpDetails:%d",[error code]);
    
}

@end
