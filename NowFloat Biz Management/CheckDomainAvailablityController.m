//
//  CheckDomainAvailablityController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 03/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "CheckDomainAvailablityController.h"

@implementation CheckDomainAvailablityController
@synthesize delegate;

-(void)getDomainAvailability:(NSString *)domainName withType:(NSString *)domainType
{

    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    msgData=[[NSMutableData alloc]init];
    
//    NSString *urlString=[NSString stringWithFormat:@"%@/DomainService/v1/checkAvailability/%@?clientId=%@&domainType=%@",appDelegate.apiUri,domainName,appDelegate.clientId,domainType];

    NSString *urlString=[NSString stringWithFormat:@"https://api.withfloats.com/DomainService/v1/checkAvailability/%@?clientId=%@&domainType=%@",domainName,appDelegate.clientId,domainType];

    
    NSURL *domainAvailabilityUrl=[NSURL URLWithString:urlString];
    
    NSMutableURLRequest *domainAvailabilityRequest=[[NSMutableURLRequest alloc]initWithURL:domainAvailabilityUrl];
    
    NSURLConnection *connection;
    
    
    connection=[[NSURLConnection alloc]initWithRequest:domainAvailabilityRequest delegate:self];
    

}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{

    [msgData appendData:data1];

}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSError *error;
    NSString *stringResponse = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding];
    
    NSLog(@"stringResponse:%@",stringResponse);
    
    [delegate performSelector:@selector(checkDomainDidSucceed:) withObject:stringResponse];
    
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];

    if (code!=200) {

        [delegate performSelector:@selector(checkDomaindidFail)];
        
    }
    
    
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{

    UIAlertView *availabilityError=[[UIAlertView alloc]initWithTitle:@"Oops" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [availabilityError show];
    
    [delegate performSelector:@selector(checkDomaindidFail)];
    
    availabilityError=nil;

}



@end
