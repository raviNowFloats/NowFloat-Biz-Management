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

-(void)getSearchQueriesWithOffset:(int)offset
{
    receivedData =[[NSMutableData alloc]init];
    
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];

    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Search/v1/queries/report?offset=%d",appDelegate.apiUri,offset];
    
    NSURL *searchUrl=[NSURL URLWithString:urlString];

    NSDictionary *postDictionary = @{@"fpTag":[appDelegate.storeDetailDictionary objectForKey:@"Tag"],@"clientId":appDelegate.clientId};
    
    
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
    
        
        if ([delegate respondsToSelector:@selector(saveSearchQuerys:)])
        {
         
            [delegate performSelector:@selector(saveSearchQuerys:) withObject:jsonArray];
            
        }
            
            
        if ([delegate respondsToSelector:@selector(getSearchQueryDidSucceedWithArray:)])
        {
        
            [delegate performSelector:@selector(getSearchQueryDidSucceedWithArray:) withObject:jsonArrayImmutable];
            
        }

        
        if ([delegate respondsToSelector:@selector(getSearchQueryDidFail)])
        {
            
            [delegate performSelector:@selector(getSearchQueryDidFail) withObject:nil];
            
        }
    
    
                
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
    

    
    [delegate performSelector:@selector(getSearchQueryDidFail)];
    
    
    NSLog(@"Error in Searching Query");
    
}


@end
