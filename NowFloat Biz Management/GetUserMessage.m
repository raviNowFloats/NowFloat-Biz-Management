//
//  GetUserMessage.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 16/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "GetUserMessage.h"

@implementation GetUserMessage


-(void)fetchUserMessages:(NSURL *)url
{

    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSMutableString *clientIdString=[[NSMutableString alloc]initWithFormat:@"\"%@\"",appDelegate.clientId];
    
    NSData *postData = [clientIdString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:url];
    
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
    
    [appDelegate.inboxArray removeAllObjects];
    [appDelegate.userMessagesArray removeAllObjects];
    [appDelegate.userMessageContactArray removeAllObjects];
    [appDelegate.userMessageDateArray removeAllObjects];
    

    
    
    /*Store Details are saved here*/
    NSError* error;
    NSMutableArray* jsonArray = [NSJSONSerialization
                                 JSONObjectWithData:receivedData
                                 options:kNilOptions
                                 error:&error];
    
    [appDelegate.inboxArray addObjectsFromArray:jsonArray];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserMessage" object:nil];

    
    
}




@end
