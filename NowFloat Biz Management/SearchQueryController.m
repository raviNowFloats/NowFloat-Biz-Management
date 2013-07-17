//
//  SearchQueryController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 11/07/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "SearchQueryController.h"
#import "SBJson.h"
#import "SBJsonWriter.h"

@implementation SearchQueryController
@synthesize delegate;

-(void)getSearchQueries
{
    receivedData =[[NSMutableData alloc]init];
    
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];

    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Search/v1/queries/report?offset=0",appDelegate.apiUri];
    
    NSURL *searchUrl=[NSURL URLWithString:urlString];
    
    NSDictionary *postDictionary = @{@"fpTag":[appDelegate.storeDetailDictionary objectForKey:@"Tag"],@"clientId":@"DB96EA35A6E44C0F8FB4A6BAA94DB017C0DFBE6F9944B14AA6C3C48641B3D70"};
    
    NSString *postString=[jsonWriter stringWithObject:postDictionary];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];

    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:searchUrl];

    [postRequest setHTTPMethod:@"POST"];
    
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [postRequest setHTTPBody:postData];
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:postRequest delegate:self];

}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    
    
        [receivedData appendData:data1];
    
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSError* error;
    NSArray *jsonArrayImmutable= [NSJSONSerialization
                         JSONObjectWithData:receivedData
                         options:kNilOptions
                         error:&error];
    

    
    NSMutableArray *jsonArray=[[NSMutableArray alloc]initWithArray:jsonArrayImmutable];


    if (jsonArray!=NULL)
    {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
        
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@SearchQuery.plist",appDelegate.storeTag]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableArray *plistArray=[[NSMutableArray alloc]init];
        
    if (![fileManager fileExistsAtPath: path])
    {
        path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@SearchQuery.plist",appDelegate.storeTag]];
        
        [jsonArray writeToFile:path atomically: TRUE];
                
    }
    
    else
    {
        [plistArray addObjectsFromArray:[NSMutableArray arrayWithContentsOfFile:path]];
        
        if (plistArray.count>0)
        {                        
            [jsonArray removeObjectsInArray:plistArray];

            if (jsonArray.count>0)
            {                
                [plistArray addObjectsFromArray:jsonArray];
                [plistArray writeToFile:path atomically:YES];
            }        
        }
        
        
        else
        {
            [jsonArray writeToFile:path atomically: TRUE];
        }
        
        [plistArray removeAllObjects];    
    }
    
    [delegate performSelector:@selector(saveSearchQuerys:) withObject:jsonArray];
    
    }
    
    
    
}






- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
/*
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    NSLog(@"code in :%d",code);
*/    
}



-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    

    
    NSLog(@"Error in Searching Query");
    
}


@end
