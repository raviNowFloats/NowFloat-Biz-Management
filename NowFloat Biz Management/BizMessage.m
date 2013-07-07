//
//  BizMessage.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 21/06/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BizMessage.h"

@implementation BizMessage
@synthesize delegate;



-(void)downloadBizMessages:(NSURL *)uri
{
    
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    msgData=[[NSMutableData alloc]init];
    
    NSMutableURLRequest *getBizMessage = [NSMutableURLRequest requestWithURL:uri];
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:getBizMessage delegate:self];

    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    
    [msgData appendData:data1];
    
}




- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* error;
    NSMutableDictionary* json = [NSJSONSerialization
                                 JSONObjectWithData:msgData //1
                                 options:kNilOptions
                                 error:&error];
        
        [delegate updateBizMessage:json];
    
}



-(void)connection:(NSURLConnection *)connection   didFailWithError:(NSError *)error
{
    
    NSMutableDictionary* json =NULL;
    
    [delegate updateBizMessage:json];

    
    
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in getting GETBIZMESSGE :%@",[error localizedFailureReason]);
    
}










@end
