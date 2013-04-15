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



@implementation CreatePictureDeal
@synthesize _postImageViewController;
@synthesize offerDetailDictionary;

-(void)createDeal:(NSMutableDictionary *)dictionary
{
    _postImageViewController=[[PostImageViewController alloc]initWithNibName:@"PostImageViewController" bundle:nil];
    
    receivedData =[[NSMutableData alloc]init];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    /*Set the Uri here*/
    NSString *str1=[NSString stringWithFormat:@"www."];
    
    NSString *str2=[NSString stringWithFormat:@"%@",[[appDelegate.storeDetailDictionary
                                                      objectForKey:@"Tag"] lowercaseString]];
    
    NSString *str3=[NSString stringWithFormat:@".nowfloats.com"];
    
    NSString *uriString=[NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
    
    /*Set the string for passing the values to BizMessageController*/
    dealStartDate=[dictionary objectForKey:@"StartDate"];
    
    dealTitle=[dictionary objectForKey:@"Title"];
    
    NSMutableDictionary *uploadDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           
        @"",@"EndDate",@"",@"StartDate",
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"lng"],@"lng",
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"lat"],@"lat",
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"Name"],@"MerchantName",
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"Contact"],@"MerchantContact",
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"Tag"],@"MerchantTag",
    
    [appDelegate.storeDetailDictionary objectForKey:@"_id"],@"MerchantId",
                                           
    [appDelegate.storeDetailDictionary   objectForKey:@"Address"],@"Address",
                                           
                                           uriString,@"Uri",
                                           
    @"DB96EA35A6E44C0F8FB4A6BAA94DB017C0DFBE6F9944B14AA6C3C48641B3D70",@"clientId", nil];
    
    [uploadDictionary  addEntriesFromDictionary:dictionary];
    
    
    if ([uploadDictionary objectForKey:@"MerchantContact"  ]==[NSNull null])
    {
        [uploadDictionary setObject:@"" forKey:@"MerchantContact"];
    }
    
    if ([uploadDictionary objectForKey:@"Address"]==[NSNull null])
    {
        
        [uploadDictionary setObject:@"" forKey:@"Address"];
        
    }
    
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
    
    NSString *uploadString=[jsonWriter stringWithObject:uploadDictionary];
    
    NSData *postData = [uploadString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Discover/v1/float/createDeal",appDelegate.apiUri];
    
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
    
    if (data1==nil)
    {
        
        [self createDeal:offerDetailDictionary];
    }
    
    else
    {
        [receivedData appendData:data1];
    }
    
    
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
    [appDelegate.dealDescriptionArray insertObject:dealTitle atIndex:0];
    [appDelegate.dealDateArray insertObject:dealCreationDate atIndex:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postPicture" object:nil];

}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int code = [httpResponse statusCode];
    
    if (code!=200)
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FailedImageDeal" object:nil];
    }
    
    
}






-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in CreateImageDeal:%@",[error localizedFailureReason]);
    
}


@end
