//
//  LocateBusinessAddress.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 17/04/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "LocateBusinessAddress.h"
#import "AppDelegate.h"

#define GOOGLE_API_KEY @"AIzaSyDZ9bmIVhzbdmTDwwC81QQDe0mtlbbItoU"



@interface LocateBusinessAddress()
{
    AppDelegate *appDelegate;
    NSMutableData *receivedData;
}
@end

@implementation LocateBusinessAddress

-(void)findAddressWithLatitude:(float)lat andLongitude:(float)lng
{
    appDelegate = (AppDelegate*)[UIApplication  sharedApplication].delegate;
    
    receivedData =[[NSMutableData alloc]init];
    
    NSString *urlString=[NSString stringWithFormat:
                         @"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false&key=%@",lat,lng,GOOGLE_API_KEY];
    
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
    
    NSLog(@"jsonDictionary:%@",jsonDictionary);

}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    NSLog(@"code:%d",code);
    
    if (code!=200)
    {

    }
    
    
    
}

-(void)connection:(NSURLConnection *)connection   didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    
    NSLog (@"Connection Failed in getting address array :%@",[error localizedFailureReason]);
}


@end
