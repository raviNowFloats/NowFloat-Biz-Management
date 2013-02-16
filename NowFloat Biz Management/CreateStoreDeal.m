//
//  CreateStoreDeal.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 12/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "CreateStoreDeal.h"
#import "SBJson.h"
#import "SBJsonWriter.h"
#import "BizMessageViewController.h"

@implementation CreateStoreDeal


-(void)createDeal:(NSMutableDictionary *)dictionary;
{    
    
    //    {"DiscountPercent":"0","Description":"this is float an offer","lng":"78.44375535","MerchantName":"Raj music store","Title":"this is float an offer","clientId":"39EB5FD120DC4394A10301B108030CB70FA553E91F984C829AB6ADE23B6767B7","MerchantContact":"","EndDate":"08-12-2013","StartDate":"02-12-2013","MerchantTag":"RAJMUSIC","MerchantId":"502f663d4ec0a417144900ee","Address":"Dilsukhnagar,\n\nGaddinaram,\n\nNear Venkatadri,\n\nHyderabad,\n\nAndhra Pradesh,\n\nIndia,\n\n500013","Uri":"http:\/\/www.RAJMUSIC.nowfloats.com\/","lat":"17.421910975"}
    

    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];

    /*Set the Uri here*/
    NSString *str1=[NSString stringWithFormat:@"www."];
    NSString *str2=[NSString stringWithFormat:@"%@",[appDelegate.storeDetailDictionary objectForKey:@"Tag"]];
    NSString *str3=[NSString stringWithFormat:@".nowfloats.com"];
    
    NSString *uriString=[NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
    
    /*Set the string for passing the values to BizMessageController*/
    dealStartDate=[dictionary objectForKey:@"StartDate"];
    dealTitle=[dictionary objectForKey:@"Title"];
    

    NSMutableDictionary *uploadDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"lng"],@"lng",
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"lat"],@"lat",
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"Name"],@"MerchantName",
                                                                                  
    [appDelegate.storeDetailDictionary objectForKey:@"Contact"],@"MerchantContact",
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"Tag"],@"MerchantTag",
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"_id"],@"MerchantId",
                                           
    [appDelegate.storeDetailDictionary   objectForKey:@"Address"],@"Address",
                                           
     uriString,@"Uri",
                                           
    @"39EB5FD120DC4394A10301B108030CB70FA553E91F984C829AB6ADE23B6767B7",@"clientId", nil];
    
    [uploadDictionary   addEntriesFromDictionary:dictionary];
    

    if ([uploadDictionary objectForKey:@"MerchantContact"  ]==[NSNull null])
    {
        [uploadDictionary setObject:@"" forKey:@"MerchantContact"];
    }
    
    if ([uploadDictionary objectForKey:@"Address"]==[NSNull null]) {
       
        [uploadDictionary setObject:@"" forKey:@"Address"];
        
    }
    
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];

    NSString *uploadString=[jsonWriter stringWithObject:uploadDictionary];

    NSLog(@"updateString:%@",uploadString);
    
    NSData *postData = [uploadString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];

    NSString *urlString=[NSString stringWithFormat:@"https://api.withfloats.com/Discover/v1/float/createDeal"];
    
    NSURL *createDealUrl=[NSURL URLWithString:urlString];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:createDealUrl];
    
    [theRequest setHTTPMethod:@"PUT"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody:postData];
    NSURLConnection *conn;
    conn= [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
    
    


    
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
    
    
    NSMutableString *receivedString=[[NSMutableString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    

    
    NSString *idString = [receivedString
                               stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    
    
    /*Create the deal creaton date*/

    
    
    
    NSDate *now = [NSDate date];
    
    long long unixTime = [now timeIntervalSince1970]*1000;

    NSLog(@"nowAsLong:%lld",unixTime);

    //For example :Make this  /Date(1360866600000)/ to have a date string
    
    NSString *d1=[NSString stringWithFormat:@"/Date("];
    NSString *d2=[NSString  stringWithFormat:@"%lld",unixTime];
    NSString *d3=[NSString stringWithFormat:@")/"];
    

    NSString *dealCreationDate=[NSString stringWithFormat:@"%@%@%@",d1,d2,d3];

    
    
    NSLog(@"dealCreationDate:%@",dealCreationDate);
    
    [appDelegate.dealId insertObject:idString atIndex:0];
    [appDelegate.dealDescriptionArray insertObject:dealTitle atIndex:0];
    [appDelegate.dealDateArray insertObject:dealCreationDate atIndex:0];
    
    
    
    

    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMessage" object:nil];

    
}




- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    NSLog(@"Deal creation Success Code :%d",code);
    
    if (code==200)
    
    {
        
        
//        NSLog(@"MsgController Message Description:%@",msgController.dealDescriptionArray);
        
        

        
    }
    
}




@end
