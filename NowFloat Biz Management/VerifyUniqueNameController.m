//
//  VerifyUniqueNameController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 30/07/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "VerifyUniqueNameController.h"
#import "SBJson.h"
#import "SBJsonWriter.h"


@implementation VerifyUniqueNameController
@synthesize delegate;



-(void)verifyWithFpName:(NSString *)fpName andFpTag:(NSString *)fpTag;
{

    isSuccess=NO;
    
    appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    receivedData =[[NSMutableData alloc]init];
    
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
    
    NSDictionary *uploadDictionary=@{@"fpName":fpName,@"fpTag":fpTag,@"clientId":appDelegate.clientId};
    
    NSString *updateString=[jsonWriter stringWithObject:uploadDictionary];

    
    NSData *postData = [updateString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSString *urlString=[NSString stringWithFormat:
                         @"%@/verifyUniqueTag",appDelegate.apiWithFloatsUri];
    
    NSURL *uploadUrl=[NSURL URLWithString:urlString];
    
    NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:uploadUrl];
    
    [uploadRequest setHTTPMethod:@"POST"];
    
    [uploadRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [uploadRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [uploadRequest setHTTPBody:postData];
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:uploadRequest delegate:self];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [receivedData appendData:data1];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (isSuccess)
    {
    
    NSString *receivedString=[[NSMutableString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    receivedString = [receivedString
                               stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    [delegate performSelector:@selector(verifyUniqueNameDidComplete:) withObject:receivedString];
    
    }
    
    
    else
    {
    
        NSString *failedString=@"";
        [delegate performSelector:@selector(verifyuniqueNameDidFail:) withObject:failedString];

    }
    
    
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    isSuccess=NO;
    if (code!=200)
    {
        isSuccess=NO;
        
        NSString *failedString=@"";
        
        [delegate performSelector:@selector(verifyuniqueNameDidFail:) withObject:failedString];        
    }
    
    else
    {
        isSuccess=YES;
        
    }
    
    
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    
}




@end
