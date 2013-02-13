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


@implementation CreateStoreDeal


-(void)createDeal:(NSMutableDictionary *)dictionary;
{    
    
    //    {"DiscountPercent":"0","Description":"this is float an offer","lng":"78.44375535","MerchantName":"Raj music store","Title":"this is float an offer","clientId":"39EB5FD120DC4394A10301B108030CB70FA553E91F984C829AB6ADE23B6767B7","MerchantContact":"","EndDate":"08-12-2013","StartDate":"02-12-2013","MerchantTag":"RAJMUSIC","MerchantId":"502f663d4ec0a417144900ee","Address":"Dilsukhnagar,\n\nGaddinaram,\n\nNear Venkatadri,\n\nHyderabad,\n\nAndhra Pradesh,\n\nIndia,\n\n500013","Uri":"http:\/\/www.RAJMUSIC.nowfloats.com\/","lat":"17.421910975"}
    

    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];


    NSMutableDictionary *uploadDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"lng"],@"lng",
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"lat"],@"lat",
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"Name"],@"MerchantName",
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"Contact"],@"MerchantContact",
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"Tag"],@"MerchantTag",
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"_id"],@"MerchantId",
                                           
    [appDelegate.storeDetailDictionary   objectForKey:@"Address"],@"Address",
                                           
    [appDelegate.storeDetailDictionary objectForKey:@"Uri"],@"Uri",
                                           
    @"39EB5FD120DC4394A10301B108030CB70FA553E91F984C829AB6ADE23B6767B7",@"clientId", nil];
    
    [uploadDictionary   addEntriesFromDictionary:dictionary];
    
    
    
    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];

    NSString *uploadString=[jsonWriter stringWithObject:uploadDictionary];

    NSLog(@"updateString:%@",uploadString);
    
    
    
    

}

@end
