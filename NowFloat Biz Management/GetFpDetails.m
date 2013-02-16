//
//  GetFpDetails.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 13/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "GetFpDetails.h"
#import "SBJson.h"
#import "SBJsonWriter.h"
#import "AppDelegate.h"
#import "BizMessageViewController.h"


#define kBackGroudQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)

@implementation GetFpDetails

@synthesize fpId;



-(void)fetchFpDetail:(NSMutableDictionary *)dictionary
{
    //502f663d4ec0a417144900ee
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *urlString=[NSString stringWithFormat:
                         @"https://api.withfloats.com/discover/v1/floatingPoint/%@",[[dictionary objectForKey:@"ValidFPIds"]objectAtIndex:0 ]];

    
//    NSString *urlString=[NSString stringWithFormat:
//                         @"https://api.withfloats.com/discover/v1/floatingPoint/502f663d4ec0a417144900ee"];

    
    NSMutableString *clientIdString=[[NSMutableString alloc]initWithFormat:@"\"%@\"",appDelegate.clientId];
        
    NSData *postData = [clientIdString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [storeRequest setHTTPMethod:@"POST"];
    
    [storeRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [storeRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [storeRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [storeRequest setHTTPBody:postData];
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:storeRequest delegate:self];

}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    

    
    if (data1==nil)
    {

        NSLog(@" data parameter is nil");
        
    }
    
    else
    {
        receivedData =[[NSMutableData alloc]init];
        
        [receivedData appendData:data1];
    }
    
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    /*Store Details are saved here*/
    NSError* error;
    NSMutableDictionary* json = [NSJSONSerialization
                                 JSONObjectWithData:receivedData
                                 options:kNilOptions
                                 error:&error];
    
    [appDelegate.storeDetailDictionary addEntriesFromDictionary:json];
    
    [self SaveStoreDetails:json];
    
    
    /*fetch store messages here*/
    //502f663d4ec0a417144900ee
    NSString *urlString=[NSString stringWithFormat:@"https://api.withfloats.com/Discover/v1/floatingPoint/bizFloats?clientId=%@&skipBy=0&fpId=%@",appDelegate.clientId,fpId];

    
//    NSString *urlString=[NSString stringWithFormat:@"https://api.withfloats.com/Discover/v1/floatingPoint/bizFloats?clientId=%@&skipBy=0&fpId=502f663d4ec0a417144900ee",appDelegate.clientId];

    NSURL *url=[NSURL URLWithString:urlString];
    
    dispatch_async(kBackGroudQueue, ^{
        
        msgData = [NSData dataWithContentsOfURL: url];
        
        [self performSelectorOnMainThread:@selector(fetchStoreMessage:)
                               withObject:msgData waitUntilDone:YES];
        
        
    });
    

    
    
}



- (void)fetchStoreMessage:(NSData *)responseData
{
    
    NSError* error;
    NSMutableDictionary* json = [NSJSONSerialization
                                 JSONObjectWithData:responseData //1
                                 options:kNilOptions
                                 error:&error];
    
    if ([json count])
    {
        
        /*Save the fpDetailDictionary in AppDelegate (Messages And Dates of Msg's)*/
        
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate.fpDetailDictionary addEntriesFromDictionary:json];
        
        
        
        for (int i=0; i<[[appDelegate.fpDetailDictionary objectForKey:@"floats"]count]; i++)
            
        {
            
            [appDelegate.dealDescriptionArray insertObject:[[[appDelegate.fpDetailDictionary objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"message" ] atIndex:i];
            
            
            [appDelegate.dealDateArray insertObject:[[[appDelegate.fpDetailDictionary objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"createdOn" ] atIndex:i];
            
            [appDelegate.dealId insertObject:[[[appDelegate.fpDetailDictionary objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"_id" ] atIndex:i];
            
            
            [appDelegate.arrayToSkipMessage insertObject:[[[appDelegate.fpDetailDictionary objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"_id" ] atIndex:i];
            
        }
        
                
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRoot" object:nil];

    }
    
    
}




-(void)SaveStoreDetails:(NSMutableDictionary *)dictionary
{

    if ([appDelegate.storeDetailDictionary  objectForKey:@"Name"]==[NSNull null])
    {
        
        
        appDelegate.businessName=[[NSMutableString alloc]initWithFormat:@"No Description"];
        
    }
    
    else
        
    {
        
        appDelegate.businessName=[appDelegate.storeDetailDictionary  objectForKey:@"Name"];
        
    }
    
    
    if ([appDelegate.storeDetailDictionary  objectForKey:@"Description"]==[NSNull null])
    {
        appDelegate.businessDescription=[[NSMutableString alloc]initWithFormat:@"No Description"];
        
    }
    
    
    else
    {
        
        appDelegate.businessDescription=[appDelegate.storeDetailDictionary  objectForKey:@"Description"];
        
    }

    
}

@end
