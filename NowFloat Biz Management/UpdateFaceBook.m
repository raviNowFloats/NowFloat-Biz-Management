//
//  UpdateFaceBook.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 12/03/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "UpdateFaceBook.h"
#import "SBJson.h"
#import "SBJsonWriter.h"

@implementation UpdateFaceBook



-(void)postToFaceBook:(NSMutableDictionary *)uploadDictionary
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication ]delegate];

    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString *urlString;
    
    NSString *uploadString;
    
    if (![[uploadDictionary objectForKey:@"isPictureDeal"] boolValue])
    {
        uploadString=[NSString stringWithFormat:@"access_token=%@&message=%@",[userDefaults objectForKey:@"NFManageFBAccessToken"],[uploadDictionary objectForKey:@"dealDescription"]];
        
        urlString=[NSString stringWithFormat:@"https://graph.facebook.com/%@/feed",[userDefaults objectForKey:@"NFManageFBUserId"]];
    }
    
    else
    {
        uploadString=[NSString stringWithFormat:@"access_token=%@&message=%@&url=%@",[userDefaults objectForKey:@"NFManageFBAccessToken"],[uploadDictionary objectForKey:@"dealDescription"],[NSString stringWithFormat:@"%@%@",appDelegate.apiUri,[uploadDictionary objectForKey:@"imageUri"]]];
        
        urlString=[NSString stringWithFormat:@"https://graph.facebook.com/%@/photos",[userDefaults objectForKey:@"NFManageFBUserId"]];
    }
    
    
    NSData *postData = [uploadString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:request delegate:self];


}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    NSLog(@"code for facebook:%d",code);
    
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in UpdateFacebook Status:%@",[error localizedFailureReason]);
    
}





@end
