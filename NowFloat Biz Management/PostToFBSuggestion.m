//
//  PostToFBSuggestion.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/1/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "PostToFBSuggestion.h"

@implementation PostToFBSuggestion
@synthesize delegate;


-(void)getLatestFeedFB:(NSString *)url
{
    
    msgData=[[NSMutableData alloc]init];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication ]delegate];

    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
  NSString  *urlString=[NSString stringWithFormat:@"https://graph.facebook.com/%@/feed?access_token=%@",url,[userDefaults objectForKey:@"NFManageFBAccessToken"]];
    
 
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
   
    
  
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    
    [msgData appendData:data1];
    
}

-(void)connection:(NSURLConnection *)connection   didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in getting GETBIZFLOAT :%@",[error localizedFailureReason]);
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
        NSError *error;
        NSMutableDictionary* json = [NSJSONSerialization
                                     JSONObjectWithData:msgData //1
                                     options:kNilOptions
                                     error:&error];
        
     [delegate performSelector:@selector(posttoFBSuggestion:) withObject:json];
   
   
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
  
    
}


@end
