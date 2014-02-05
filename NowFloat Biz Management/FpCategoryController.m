//
//  FpCategoryController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 30/07/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "FpCategoryController.h"



@implementation FpCategoryController
@synthesize delegate;


-(void)downloadFpCategoryList
{

    appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    receivedData =[[NSMutableData alloc]init];
        
    NSString *urlString=[NSString stringWithFormat:
                         @"%@/categories",appDelegate.apiWithFloatsUri];
        
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
    NSArray* json = [NSJSONSerialization
                                 JSONObjectWithData:receivedData
                                 options:kNilOptions
                                 error:&error];

    [delegate performSelector:@selector(fpCategoryDidFinishDownload:) withObject:json];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    if (code!=200)
    {
        [delegate performSelector:@selector(fpCategoryDidFailWithError) withObject:nil];
    }
}

-(void)connection:(NSURLConnection *)connection   didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    [delegate performSelector:@selector(fpCategoryDidFailWithError) withObject:nil];
}



@end
