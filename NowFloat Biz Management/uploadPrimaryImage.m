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
        
    NSString *postLength = [NSString stringWithFormat:@"%d", [imageData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    
    NSString *urlString=[NSString stringWithFormat:@"https://api.withfloats.com/Discover/v1/FloatingPoint/createImage?clientId=%@&fpId=%@&reqType=parallel&reqtId=%@&totalChunks=%d&currentChunkNumber=%d",appDelegate.clientId,[userDetails objectForKey:@"userFpId"],uniqueId,numberOfChunks,currentChunk];
    
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"binary/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setCachePolicy:NSURLCacheStorageAllowed];
    [request setHTTPBody:imageData];
    
    
    NSURLConnection *theConnection;
    theConnection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    if (code==200)
    {
        NSLog(@"Success to upload image:%d",code);
    }
    
    else
    {
    
        NSLog(@"code to upload image:%d",code);

    }


}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in GetFpDetails:%d",[error code]);
    
}

@end
