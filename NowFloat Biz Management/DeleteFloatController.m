//
//  DeleteFloatController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 30/05/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "DeleteFloatController.h"
#import "SBJson.h"
#import "SBJsonWriter.h"

@implementation DeleteFloatController
@synthesize DeleteBizFloatdelegate;

-(void)deletefloat:(NSString *)dealId
{

    appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    receivedData=[[NSMutableData alloc]init];
    
    NSMutableDictionary *dic=[[NSMutableDictionary  alloc]initWithObjectsAndKeys:dealId,@"dealId",appDelegate.clientId,@"clientId", nil];
    
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
    
    NSString *uploadString=[jsonWriter stringWithObject:dic];
    
    NSData *postData = [uploadString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSString *urlString=[NSString stringWithFormat:
                         @"%@/archiveMessage",appDelegate.apiWithFloatsUri];
    
    NSURL *archiveUrl=[NSURL URLWithString:urlString];
    
    NSMutableURLRequest *archiveRequest = [NSMutableURLRequest requestWithURL:archiveUrl];
    
    [archiveRequest setHTTPMethod:@"DELETE"];
    
    [archiveRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [archiveRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [archiveRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [archiveRequest setHTTPBody:postData];
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:archiveRequest delegate:self];

}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [receivedData appendData:data1];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{


    

}



- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int code = [httpResponse statusCode];
        
    if (code==200) {
        
        
        [DeleteBizFloatdelegate performSelector:@selector(updateBizMessage)];
        
    }
    


}

-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    
    
    
}



@end
