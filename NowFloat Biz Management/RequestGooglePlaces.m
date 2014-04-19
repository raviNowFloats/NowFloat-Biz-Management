//
//  RequestGooglePlaces.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 17/04/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "RequestGooglePlaces.h"
#import "AppDelegate.h"

@interface RequestGooglePlaces()
{
    AppDelegate *appDelegate;
    NSMutableData *receivedData;
    BOOL isSuccess;
}

@end


@implementation RequestGooglePlaces
@synthesize delegate;


-(void)requestGooglePlaces
{
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    receivedData = [[NSMutableData alloc]init];
    
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/CreateGooglePlaces/?clientId=%@&fpTag=%@",appDelegate.apiWithFloatsUri,appDelegate.clientId,appDelegate.storeTag]];
    
    NSMutableURLRequest *placesRequest = [[NSMutableURLRequest alloc]initWithURL:requestUrl];

    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:placesRequest delegate:self];

}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    
    [receivedData appendData:data1];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    if (isSuccess)
    {
        NSString *receivedString=[[NSMutableString alloc]initWithData:receivedData  encoding:NSUTF8StringEncoding];
        
        if (receivedString.length==0 || receivedString==NULL)
        {
            [delegate performSelector:@selector(requestGooglePlaceDidFail)];
        }
        
        else
        {
//            receivedString = [receivedString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            [delegate performSelector:@selector(requestGooglePlacesDidSucceed)];

        }
    }
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int code = [httpResponse statusCode];
    
    NSLog(@"code to requestplace:%d",code);
    
    isSuccess=NO;
    
    if (code!=200)
    {
        [delegate performSelector:@selector(requestGooglePlaceDidFail)];
    }
    
    else
    {
        isSuccess =YES;
    }
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    NSLog(@"error:%@",error.localizedDescription);
    [delegate performSelector:@selector(requestGooglePlaceDidFail)];
}



@end
