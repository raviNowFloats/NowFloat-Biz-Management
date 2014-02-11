//
//  TwitterImageUpload.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 17/05/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "TwitterImageUpload.h"
#import "SBJson.h"
#import "SBJsonWriter.h"
#import "SA_OAuthTwitterEngine.h"


#define kOAuthConsumerKey	  @"h5lB3rvjU66qOXHgrZK41Q"
#define kOAuthConsumerSecret  @"L0Bo08aevt2U1fLjuuYAMtANSAzWWi8voGuvbrdtcY4"




@implementation TwitterImageUpload
@synthesize tweetMessage;


-(void)postToTwitter:(NSString *)messageId messageString:(NSString *)msg
{
    
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
    
    tweetMessage=[NSString stringWithFormat:@"%@",msg];
    
    _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
    _engine.consumerKey    = kOAuthConsumerKey;
    _engine.consumerSecret = kOAuthConsumerSecret;
    [_engine isAuthorized];
    

        recievedData=[[NSMutableData alloc]init];
        
        NSString *urlString=@"https://www.googleapis.com/urlshortener/v1/url";
        
        NSURL *postUrl=[NSURL URLWithString:urlString];
        
        messageUrl=[NSString stringWithFormat:@"http://%@.nowfloats.com/bizfloat/%@",[[appDelegate.storeDetailDictionary objectForKey:@"Tag"] lowercaseString],messageId];
        
        NSDictionary *uploadDictionary=@{@"longUrl":messageUrl};
        
        NSString *updateString=[jsonWriter stringWithObject:uploadDictionary];
        
        NSData *postData = [updateString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:postUrl];
        
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
    NSLog(@"response for urlshortner:%d",code);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [recievedData appendData:data1];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    
    if ([tweetMessage length]>140)
    {
        NSError* error;
        
        NSMutableDictionary* json = [NSJSONSerialization
                                     JSONObjectWithData:recievedData
                                     options:kNilOptions
                                     error:&error];
        
        NSRange range = NSMakeRange (0,75);
        
        NSString *truncatedString=[NSString stringWithFormat:@"%@..[PIC]",[tweetMessage substringWithRange:range]];
        
        [_engine sendUpdate:[NSString stringWithFormat:@"%@%@",truncatedString,[json  objectForKey:@"id"]]];
    }
    
    else
    {
        NSError* error;
        
        NSMutableDictionary* json = [NSJSONSerialization
                                     JSONObjectWithData:recievedData
                                     options:kNilOptions
                                     error:&error];
        
        NSString *uploadString=[NSString stringWithFormat:@"%@..[PIC]",tweetMessage];
        
        [_engine sendUpdate:[NSString stringWithFormat:@"%@%@",uploadString,[json  objectForKey:@"id"]]];
    }
}








-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
}


//#pragma mark TwitterEngineDelegate
//
//- (void) requestSucceeded: (NSString *) requestIdentifier
//{
//	NSLog(@"Request %@ succeeded", requestIdentifier);
//}
//
//
//- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error
//{
//	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
//}


#pragma mark SA_OAuthTwitterEngineDelegate

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username
{
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}




@end

