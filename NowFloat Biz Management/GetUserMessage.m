//
//  GetUserMessage.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 16/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "GetUserMessage.h"

@implementation GetUserMessage
@synthesize delegate;

-(void)fetchUserMessages:(NSURL *)url
{
        
    receivedData =[[NSMutableData alloc]init];

    getUserMessageUrl=url;

    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:url];
    
    [storeRequest setHTTPMethod:@"POST"];
    
    [storeRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [storeRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
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
    NSMutableArray* jsonArray = [NSJSONSerialization
                                 JSONObjectWithData:receivedData
                                 options:kNilOptions
                                 error:&error];
    
    //WARNING jsonArray.count can be zero
    //DO NOT DELETE OR MODIFY THIS SECTION 
    

    
/*In this case if the server returns a 0 array count we reproduce the previous array and display in the user screen */
    
    if ([jsonArray count]==0)
    {
        [delegate performSelector:@selector(downloadFinished)];
    }
    
    
/*If the count is not equal to zero then we repopulate the data display on the view */
    
    else
    {
        [appDelegate.inboxArray removeAllObjects];
        [appDelegate.userMessagesArray removeAllObjects];
        [appDelegate.userMessageContactArray removeAllObjects];
        [appDelegate.userMessageDateArray removeAllObjects];

        [appDelegate.inboxArray addObjectsFromArray:jsonArray];
        for (int i=0; i<[appDelegate.inboxArray count]; i++)
        {
            [appDelegate.userMessagesArray insertObject:[[appDelegate.inboxArray objectAtIndex:i]objectForKey:@"message" ] atIndex:i];
            
            [appDelegate.userMessageContactArray insertObject:[[appDelegate.inboxArray objectAtIndex:i]objectForKey:@"contact"] atIndex:i];
            
            [appDelegate.userMessageDateArray insertObject:[[appDelegate.inboxArray objectAtIndex:i]objectForKey:@"createdOn" ] atIndex:i];            
        }
                
        [delegate performSelector:@selector(downloadFinished)];
        
    }


}



- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int code = [httpResponse statusCode];
    
    if (code!=200)
    {
        [delegate performSelector:@selector(inboxMsgDownloadFailed)];
    }
    
}


-(void)connection:(NSURLConnection *)connection   didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    
    NSLog (@"Connection Failed in getting user message:%@",[error localizedFailureReason]);
    
}


@end
