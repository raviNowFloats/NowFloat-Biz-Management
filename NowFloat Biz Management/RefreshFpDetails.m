//
//  RefreshFpDetails.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 15/04/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "RefreshFpDetails.h"

@implementation RefreshFpDetails
@synthesize delegate;

-(void)fetchFpDetail
{
    
    userdetails=[NSUserDefaults standardUserDefaults];
    
    receivedData =[[NSMutableData alloc]init];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *urlString=[NSString stringWithFormat:
                         @"%@/%@",appDelegate.apiWithFloatsUri,[userdetails objectForKey:@"userFpId"]];
    
    
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
    [receivedData appendData:data1];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    /*Store Details are saved here*/
    
    
    
        
    NSError* error;
    NSMutableDictionary* json = [NSJSONSerialization
                                 JSONObjectWithData:receivedData
                                 options:kNilOptions
                                 error:&error];
    
    
    
    if ([[json objectForKey:@"SecondaryImages"] count] !=[appDelegate.secondaryImageArray count]) {
        
        if ([[json objectForKey:@"SecondaryImages"] count])
        {
            [appDelegate.secondaryImageArray removeAllObjects];
            
            [appDelegate.secondaryImageArray addObjectsFromArray:[json objectForKey:@"SecondaryImages"] ];
            
            for (int i=0; i<[[json objectForKey:@"SecondaryImages"] count]; i++)
            {
                NSString *imageStringUrl=[NSString stringWithFormat:@"%@%@",appDelegate.apiUri,[appDelegate.secondaryImageArray objectAtIndex:i]];
                
                [appDelegate.secondaryImageArray replaceObjectAtIndex:i withObject:imageStringUrl];
            }
                        
            [delegate performSelector:@selector(updateView)];
            
        }

        
    }
    
    
    
    
    else
    {
    
        [self fetchFpDetail];
    
    
    }

    
    
    
}










-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    NSLog (@"Connection Failed in GetFpDetails:%d",[error code]);
    
}


@end
