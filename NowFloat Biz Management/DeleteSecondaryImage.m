//
//  DeleteSecondaryImage.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 23/06/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "DeleteSecondaryImage.h"
#import "SBJson.h"
#import "SBJsonWriter.h"


@implementation DeleteSecondaryImage
@synthesize delegate;


-(void)deleteImage:(NSString *)imageName
{

    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];

    NSMutableDictionary *dic=[[NSMutableDictionary  alloc]initWithObjectsAndKeys:imageName,@"secondaryImageFilename",appDelegate.clientId,@"clientId",[appDelegate.storeDetailDictionary objectForKey:@"_id"],@"fpId", nil];

    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
    
    NSString *uploadString=[jsonWriter stringWithObject:dic];
    
    NSData *postData = [uploadString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];

    NSString *urlString=[NSString stringWithFormat:
                         @"%@/removeSecondaryImage",appDelegate.apiWithFloatsUri];
    
    NSURL *deleteSecondaryImageUrl=[NSURL URLWithString:urlString];
    
    NSMutableURLRequest *deleteSecondaryImageRequest = [NSMutableURLRequest requestWithURL:deleteSecondaryImageUrl];
    
    [deleteSecondaryImageRequest setHTTPMethod:@"DELETE"];
    
    [deleteSecondaryImageRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [deleteSecondaryImageRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [deleteSecondaryImageRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [deleteSecondaryImageRequest setHTTPBody:postData];
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:deleteSecondaryImageRequest delegate:self];

    
    
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int code = [httpResponse statusCode];
    
    NSLog(@"Secondary Image Deletion Success Code :%d",code);
    
    if (code==200) {
        
        
        [delegate performSelector:@selector(updateSecondaryImage:) withObject:[NSNumber numberWithInt:code].stringValue];
        
    }
    
    
    else
    {
    
    [delegate performSelector:@selector(updateSecondaryImage:) withObject:[NSNumber numberWithInt:code].stringValue];
    
    }
    
    
    
}




@end
