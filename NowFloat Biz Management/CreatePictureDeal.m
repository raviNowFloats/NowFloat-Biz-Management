//
//  CreatePictureDeal.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 09/04/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "CreatePictureDeal.h"
#import "SBJson.h"
#import "SBJsonWriter.h"
#import "FacebookImageUpload.h"
#import "TwitterImageUpload.h"
#import "fbPageImageUpload.h"


@implementation CreatePictureDeal
@synthesize offerDetailDictionary;
@synthesize dealUploadDelegate;

-(void)createDeal:(NSMutableDictionary *)dictionary postToTwitter:(BOOL)isTwitter postToFB:(BOOL)isFb postToFbPage:(BOOL)isFbPage
{
    receivedData =[[NSMutableData alloc]init];
    
    faceDictionary = [[NSDictionary alloc] init];
    
    faceDictionary = dictionary;
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    isTwitterShare=isTwitter;
    
    isFbShare = isFb;
    
    isFbPageShare = isFbPage;
    
    picMsg = [dictionary objectForKey:@"pictureMessage"];
    
    [dictionary removeObjectForKey:@"pictureMessage"];
    
    dealTitle=[dictionary objectForKey:@"message"];

    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
    
    NSString *uploadString=[jsonWriter stringWithObject:dictionary];
    
    NSData *postData = [uploadString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Discover/v1/FloatingPoint/createBizMessage",appDelegate.apiUri];
    
    NSURL *createDealUrl=[NSURL URLWithString:urlString];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:createDealUrl];
    
    [theRequest setHTTPMethod:@"PUT"];
    
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [theRequest setHTTPBody:postData];
    
    NSURLConnection *conn;
    
    conn= [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];

}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    
    [receivedData appendData:data1];
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSMutableString *receivedString=[[NSMutableString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSString *idString = [receivedString
                          stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    /*Create the deal creaton date*/
    
    NSDate *now = [NSDate date];
    
    long long unixTime = [now timeIntervalSince1970]*1000;
    
    //For example :Make this  /Date(1360866600000)/ to have a date string
    
    NSString *d1=[NSString stringWithFormat:@"/Date("];
    NSString *d2=[NSString  stringWithFormat:@"%lld",unixTime];
    NSString *d3=[NSString stringWithFormat:@")/"];
        
    NSString *dealCreationDate=[NSString stringWithFormat:@"%@%@%@",d1,d2,d3];
    
    [appDelegate.dealId insertObject:idString atIndex:0];
    [appDelegate.arrayToSkipMessage insertObject:idString atIndex:0];
    [appDelegate.dealDescriptionArray insertObject:dealTitle atIndex:0];
    [appDelegate.dealDateArray insertObject:dealCreationDate atIndex:0];
    
    
    
    
    if (isTwitterShare)
    {
        
        TwitterImageUpload *tweetImage=[[TwitterImageUpload alloc]init];
        
        [tweetImage postToTwitter:idString messageString:dealTitle];
        
        tweetImage=nil;
        
    }
    
    if(isFbShare)
    {
        
        FacebookImageUpload *postMessage = [[FacebookImageUpload alloc] init];
        
        [postMessage posttoFacebookUser:dealTitle withImage:picMsg];
        
        postMessage = nil;
    
        
    }
    
    if(isFbPageShare)
    {
        fbPageImageUpload *postToPage = [[fbPageImageUpload alloc] init];
        
        [postToPage postToPage:dealTitle withImage:picMsg];
        
        postToPage = nil;
    }
    

    [dealUploadDelegate performSelector:@selector(successOnDealUpload)];

}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int code = [httpResponse statusCode];
    
    if (code!=200)
    {
        [dealUploadDelegate performSelector:@selector(failedOnDealUpload)];        
    }
    
    
}






-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    [dealUploadDelegate performSelector:@selector(failedOnDealUpload)];
}


@end
