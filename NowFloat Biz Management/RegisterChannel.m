//
//  RegisterChannel.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 02/01/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "RegisterChannel.h"
#import "SBJson.h"
#import "SBJsonWriter.h"


@implementation RegisterChannel
@synthesize delegate;
-(void)registerNotificationChannel
{
    @try
    {
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];

    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];

    NSDictionary *uploadDictionary=
    @{
      @"clientId":appDelegate.clientId,
      @"DeviceType":@"IPHONE",
      @"Channel":[userDefaults objectForKey:@"apnsTokenNFBoost"],
      @"UserId":[appDelegate.storeDetailDictionary objectForKey:@"_id"],
      };
    
    NSString *uploadString=[jsonWriter stringWithObject:uploadDictionary];
    
    NSData *postData = [uploadString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSURL *registerUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/notification/registerChannel",appDelegate.apiWithFloatsUri]];
    
    NSMutableURLRequest *registerRequest=[NSMutableURLRequest requestWithURL:registerUrl];
    
    [registerRequest setHTTPMethod:@"PUT"];
    
    [registerRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [registerRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [registerRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [registerRequest setHTTPBody:postData];

    NSURLConnection *registerConnection;
    
    registerConnection=[[NSURLConnection alloc]initWithRequest:registerRequest delegate:self];
    }
    @catch (NSException *e)
    {
        [delegate performSelector:@selector(channelFailedToRegister)];
    }
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int code = [httpResponse statusCode];
        
    if (code==200)
    {
        [delegate performSelector:@selector(channelDidRegisterSuccessfully)];
    }
    
    else
    {
        [delegate performSelector:@selector(channelFailedToRegister)];
    }
}

-(void) connection:(NSURLConnection *)connection  didFailWithError: (NSError *)error
{
    [delegate performSelector:@selector(channelFailedToRegister)];
}


@end
