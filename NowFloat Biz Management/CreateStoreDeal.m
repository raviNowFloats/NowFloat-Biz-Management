//
//  CreateStoreDeal.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 12/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "CreateStoreDeal.h"
#import "SBJson.h"
#import "SBJsonWriter.h"
#import "BizMessageViewController.h"
#import "UpdateFaceBook.h"
#import "UpdateFaceBookPage.h"
#import "UpdateTwitter.h"
#import <FacebookSDK/FacebookSDK.h>


@implementation CreateStoreDeal
@synthesize offerDetailDictionary,_PostMessageController,delegate;



-(void)createDeal:(NSMutableDictionary *)dictionary isFbShare:(BOOL)fbShare isFbPageShare:(BOOL)fbPageShare isTwitterShare:(BOOL)twitterShare
{

    isFbShare=fbShare;
    isFbPageShare=fbPageShare;
    isTwitterShare=twitterShare;
    
    _PostMessageController=[[PostMessageViewController alloc]initWithNibName:@"PostMessageViewController" bundle:nil];

    receivedData =[[NSMutableData alloc]init];

    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    dealTitle=[dictionary objectForKey:@"message"];

    /*Set the Uri here*/
        
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
    [appDelegate.addedFloatsArray insertObject:idString atIndex:0];
    [appDelegate.dealDescriptionArray insertObject:dealTitle atIndex:0];
    [appDelegate.dealDateArray insertObject:dealCreationDate atIndex:0];
    [appDelegate.dealImageArray insertObject:@"/Deals/Tile/deal.png" atIndex:0];
    
    
    if (isTwitterShare)
    {        
        UpdateTwitter *twitterUpdate=[[UpdateTwitter alloc]init];
        
        [twitterUpdate postToTwitter:idString messageString:dealTitle];
    }
    
    
    if (isFbShare)
    {
        UpdateFaceBook *statusUpdate=[[UpdateFaceBook  alloc]init];
        
        [statusUpdate postToFaceBook:dealTitle];     
    }
    
    
    if (isFbPageShare)
    {
        
        UpdateFaceBookPage *pageUpdate=[[UpdateFaceBookPage alloc]init];
        
        [pageUpdate postToFaceBookPage:dealTitle];
    }
    
        
    [delegate performSelector:@selector(downloadFinished)];

    
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMessage" object:nil];

  
    
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int code = [httpResponse statusCode];
    
    NSLog(@"Deal creation Success Code :%d",code);
    
    
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in CreateStoreDeal:%@",[error localizedFailureReason]);
    
}



-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}


#pragma mark TwitterEngineDelegate

- (void) requestSucceeded: (NSString *) requestIdentifier
{
	NSLog(@"Request %@ succeeded", requestIdentifier);
}


- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error
{
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}




@end
