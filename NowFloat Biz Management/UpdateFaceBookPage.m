//
//  UpdateFaceBookPage.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 22/04/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "UpdateFaceBookPage.h"
#import "SBJson.h"
#import "SBJsonWriter.h"


@implementation UpdateFaceBookPage


-(void)postToFaceBookPage:(NSString *)dealDescription
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication ]delegate];
        
    request=[[NSMutableURLRequest alloc] init];

    for (int i=0;i<appDelegate.socialNetworkNameArray.count; i++)
    {
        
        NSString *accessTokenString=[NSString stringWithFormat:@"%@",[appDelegate.socialNetworkAccessTokenArray objectAtIndex:i]];
        
        NSString *accessIdString=[NSString stringWithFormat:@"%@",[appDelegate.socialNetworkIdArray objectAtIndex:i]];
        
        NSString *uploadString=[NSString stringWithFormat:@"access_token=%@&message=%@",accessTokenString,dealDescription];
                
        NSMutableData *tempData =[[NSMutableData alloc]initWithData:[uploadString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]] ;

        NSString *postLength = [NSString stringWithFormat:@"%d", [tempData length]];

        NSString *urlString=[NSString stringWithFormat:@"https://graph.facebook.com/%@/feed",accessIdString];
        
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:tempData];
        
        NSURLConnection *theConnection;
        
        theConnection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        
    }
    
}



- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    NSLog(@"code for facebook Page:%d",code);
    
    
    if (code==200)
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMessage" object:nil];
        
    }
    
    else
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMessage" object:nil];
        
    }
    
    
    
    
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in UpdateFacebook Status:%@",[error localizedFailureReason]);
    
}






@end
