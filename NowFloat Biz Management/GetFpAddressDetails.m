//
//  GetFpAddressDetails.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/07/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "GetFpAddressDetails.h"

@implementation GetFpAddressDetails
@synthesize delegate;



-(void)downloadFpAddressDetails:(NSString *)addressString
{

    appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    receivedData =[[NSMutableData alloc]init];

    NSString *urlString=[NSString stringWithFormat:
                         @"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false",addressString];

    NSLog(@"urlString:%@",urlString);
    
    urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSMutableURLRequest *getFpCategoryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:getFpCategoryRequest delegate:self];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    
    [receivedData appendData:data1];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError* error;
    
    NSDictionary* jsonDictionary = [NSJSONSerialization
                     JSONObjectWithData:receivedData
                     options:kNilOptions
                     error:&error];
    
    NSString *statusString = [jsonDictionary valueForKey:@"status"];

    if ([statusString isEqualToString:@"OK"])
    {
        
        NSArray *locationArray = [[[jsonDictionary valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"];
        
        locationArray = [locationArray objectAtIndex:0];

        [delegate performSelector:@selector(fpAddressDidFetchLocationWithLocationArray:) withObject:locationArray];
    
    }
    
    else
    {
        [delegate performSelector:@selector(fpAddressDidFail)];
    }
    
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    if (code!=200)
    {
        [delegate performSelector:@selector(fpAddressDidFail)];
    }
    
    
    
}

-(void)connection:(NSURLConnection *)connection   didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    [delegate performSelector:@selector(fpAddressDidFail)];

    NSLog (@"Connection Failed in getting address array :%@",[error localizedFailureReason]);
}



@end
