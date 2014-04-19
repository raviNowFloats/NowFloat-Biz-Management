//
//  GetFpDetails.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 13/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "GetFpDetails.h"
#import "SBJson.h"
#import "SBJsonWriter.h"
#import "AppDelegate.h"
#import "BizMessageViewController.h"
#import "GetUserMessage.h"
#import "StoreAnalytics.h"


@implementation GetFpDetails
@synthesize delegate;

-(void)fetchFpDetail
{
    
    userdetails=[NSUserDefaults standardUserDefaults];
    
    receivedData =[[NSMutableData alloc]init];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *urlString=[NSString stringWithFormat:
                         @"%@/nf-app/%@",appDelegate.apiWithFloatsUri,[userdetails objectForKey:@"userFpId"]];    

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
    
    if (data1==nil)
    {
        
        [self performSelector:@selector(fetchFpDetail) withObject:nil afterDelay:2];
    }
    
    else
    {
        
        [receivedData appendData:data1];
    }
    
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    /*Store Details are saved here*/
    NSError* error;
    NSMutableDictionary* json = [NSJSONSerialization
                                 JSONObjectWithData:receivedData
                                 options:kNilOptions
                                 error:&error];
    //NSLog(@"json:%@",json);
    
    if (!error)
    {
        [appDelegate.storeDetailDictionary addEntriesFromDictionary:json];
        
        [self SaveStoreDetails:json];
        
        /*download store messages here*/
        [self downloadStoreMessage];
    }
    
    
    else
    {
        [delegate performSelector:@selector(downloadFailedWithError)];
    }
    
}


/*Function to download the store messages*/

-(void)downloadStoreMessage
{
    NSString *urlString=[NSString stringWithFormat:@"%@/bizFloats?clientId=%@&skipBy=0&fpId=%@",appDelegate.apiWithFloatsUri,appDelegate.clientId,[userdetails objectForKey:@"userFpId"]];
    
    NSURL *url=[NSURL URLWithString:urlString];
    
    msgData = [NSData dataWithContentsOfURL: url];
    
    if (msgData ==nil)
    {
        [self downloadStoreMessage];
    }
    
    else
    {
        [self performSelector:@selector(fetchStoreMessage:) withObject:msgData ];
    }    
}



- (void)fetchStoreMessage:(NSData *)responseData
{
    
    NSError* error;
    NSMutableDictionary* json = [NSJSONSerialization
                                 JSONObjectWithData:responseData //1
                                 options:kNilOptions
                                 error:&error];
    
    if ([json count])
    {
        
        /*Save the fpDetailDictionary in AppDelegate (Messages And Dates of Msg's)*/
        
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate.fpDetailDictionary addEntriesFromDictionary:json];
        
        for(int i=0; i<[[appDelegate.fpDetailDictionary objectForKey:@"floats"]count];i++)
        {
            
            [appDelegate.dealDescriptionArray insertObject:[[[appDelegate.fpDetailDictionary objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"message" ] atIndex:i];
            
            
            [appDelegate.dealDateArray insertObject:[[[appDelegate.fpDetailDictionary objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"createdOn" ] atIndex:i];
            
            [appDelegate.dealId insertObject:[[[appDelegate.fpDetailDictionary objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"_id" ] atIndex:i];
            
            [appDelegate.arrayToSkipMessage insertObject:[[[appDelegate.fpDetailDictionary objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"_id" ] atIndex:i];
            
            
            
            [appDelegate.dealImageArray insertObject:[[[appDelegate.fpDetailDictionary objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"tileImageUri" ] atIndex:i];
            
        }
        
        
        StoreAnalytics *_storeAnalytics=[[StoreAnalytics alloc]init];
        
        [_storeAnalytics getVistorPattern];
        
        [delegate performSelector:@selector(downloadFinished)];
        
    }
    
    
}


-(void)SaveStoreDetails:(NSMutableDictionary *)dictionary
{
    if ([appDelegate.storeDetailDictionary  objectForKey:@"Name"]==[NSNull null])
    {
        appDelegate.businessName=[[NSMutableString alloc]initWithFormat:@"No Description"];
    }
    
    else
    {
        appDelegate.businessName=[appDelegate.storeDetailDictionary  objectForKey:@"Name"];
    }    
    
    if ([appDelegate.storeDetailDictionary  objectForKey:@"Description"]==[NSNull null])
    {
        appDelegate.businessDescription=[[NSMutableString alloc]initWithFormat:@"No Description"];
    }
    
    else
    {
        appDelegate.businessDescription=[appDelegate.storeDetailDictionary  objectForKey:@"Description"];
    }
    
        
    //Add objects for storeTimings in appDelegate
    if ([appDelegate.storeDetailDictionary objectForKey:@"Timings"]==[NSNull null])
    {
    
            
        
    }

    else
    {
    [appDelegate.storeTimingsArray addObjectsFromArray: [appDelegate.storeDetailDictionary objectForKey:@"Timings"] ];
    }
    
    //Add objects for contacts in appdelegate
    
    
    if ([appDelegate.storeDetailDictionary objectForKey:@"Contacts"]==[NSNull null])
    {
        
        
        
    }

    else
    {                
        if ([[appDelegate.storeDetailDictionary objectForKey:@"Contacts"] count])
        {
            [appDelegate.storeContactArray addObjectsFromArray:[appDelegate.storeDetailDictionary objectForKey:@"Contacts"]];
        }
    }
    
    
    
    //Save the Tag in appdelegate
    appDelegate.storeTag=[appDelegate.storeDetailDictionary objectForKey:@"Tag"];
    
    
    if ([appDelegate.storeDetailDictionary objectForKey:@"ImageUri"]!=[NSNull null])
    {
        appDelegate.primaryImageUri=[appDelegate.storeDetailDictionary  objectForKey:@"ImageUri"];
    }
    
    
    else
    {
    
        appDelegate.primaryImageUri=[NSMutableString stringWithFormat:@""];
    
    }
    
    
    //Set the Store FaceBook,Email,Website here
    if ([appDelegate.storeDetailDictionary   objectForKey:@"Email"]==[NSNull null] || [[appDelegate.storeDetailDictionary   objectForKey:@"Email"]length]==0)
    {
        
        appDelegate.storeEmail=@"";
        
    }
    
    else
    {
        
        
        appDelegate.storeEmail=[appDelegate.storeDetailDictionary objectForKey:@"Email"];
        
    }
    
    
    if ([appDelegate.storeDetailDictionary  objectForKey:@"Uri"]==[NSNull null] ||
        [[appDelegate.storeDetailDictionary  objectForKey:@"Uri"] length]==0)
        
    {
        
        appDelegate.storeWebsite=@"No Description";
    }
    
    else
    {
        
        appDelegate.storeWebsite=[appDelegate.storeDetailDictionary objectForKey:@"Uri"];
        
    }
    
    
    if ([appDelegate.storeDetailDictionary  objectForKey:@"FBPageName"]==[NSNull null] ||
        [[appDelegate.storeDetailDictionary  objectForKey:@"FBPageName"] length]==0)
        
    {
        appDelegate.storeFacebook=@"No Description";
    }
    
    else
    {
        appDelegate.storeFacebook=[appDelegate.storeDetailDictionary objectForKey:@"FBPageName"];
    }
    
    
    
    if ([appDelegate.storeDetailDictionary objectForKey:@"SecondaryImages"]!=[NSNull null])
    {
        
        [appDelegate.secondaryImageArray addObjectsFromArray:[appDelegate.storeDetailDictionary objectForKey:@"SecondaryImages"] ];
        
        for (int i=0; i<[[appDelegate.storeDetailDictionary objectForKey:@"SecondaryImages"] count]; i++)
        {
            NSString *imageStringUrl=[NSString stringWithFormat:@"%@%@",appDelegate.apiUri,[appDelegate.secondaryImageArray objectAtIndex:i]];
            
            [appDelegate.secondaryImageArray replaceObjectAtIndex:i withObject:imageStringUrl];
        }
        
    }
    
    
    if ([appDelegate.storeDetailDictionary objectForKey:@"Category"]!=[NSNull null])
    {
        if ([[appDelegate.storeDetailDictionary objectForKey:@"Category"] count]>0)
        {
            appDelegate.storeCategoryName=[[[appDelegate.storeDetailDictionary objectForKey:@"Category"]objectAtIndex:0 ] uppercaseString];
        }
        else
        {
            appDelegate.storeCategoryName=@"GENERAL" ;
        }
    }
    
    else
    {
        appDelegate.storeCategoryName=@"GENERAL";    
    }
    
    
    if ([appDelegate.storeDetailDictionary objectForKey:@"FPWebWidgets"]!=[NSNull null])
    {
        
        for (int i=0; i<[[appDelegate.storeDetailDictionary objectForKey:@"FPWebWidgets"] count]; i++)
        {
            [appDelegate.storeWidgetArray insertObject:[[appDelegate.storeDetailDictionary objectForKey:@"FPWebWidgets"] objectAtIndex:i] atIndex:i];
        }
        
    }
    
    if ([appDelegate.storeDetailDictionary objectForKey:@"RootAliasUri"]==[NSNull null])
    {
        appDelegate.storeRootAliasUri=[NSMutableString stringWithFormat:@""];
    }
    
    else
    {
        appDelegate.storeRootAliasUri=[appDelegate.storeDetailDictionary objectForKey:@"RootAliasUri"];
    }

    
    if ([appDelegate.storeDetailDictionary objectForKey:@"LogoUrl"]==[NSNull null])
    {
        appDelegate.storeLogoURI=[NSMutableString stringWithFormat:@""];
    }
    
    else
    {
        appDelegate.storeLogoURI=[appDelegate.storeDetailDictionary objectForKey:@"LogoUrl"];
    }
    
    

    //Check UserDetails for Facebook Page details and populate the array.
    
    if ([userdetails objectForKey:@"FBUserPageAdminName"]!=Nil)
    {
        [appDelegate.socialNetworkNameArray addObjectsFromArray:[userdetails objectForKey:@"FBUserPageAdminName"]];
        [appDelegate.socialNetworkAccessTokenArray addObjectsFromArray:[userdetails objectForKey:@"FBUserPageAdminAccessToken"]];
        [appDelegate.socialNetworkIdArray addObjectsFromArray:[userdetails objectForKey:@"FBUserPageAdminId"]];
    }
    
    
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    if (code!=200)
    {
        [delegate performSelector:@selector(downloadFailedWithError)];
    }
    
    
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeFetchingSubView" object:nil];
    
    NSLog (@"Connection Failed in GetFpDetails:%d",[error code]);
    
}


@end
