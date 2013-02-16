//
//  StoreAnalytics.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 14/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "StoreAnalytics.h"

@implementation StoreAnalytics


-(NSString *)getStoreAnalytics:(NSData *)data
{

    subscriberString=[[NSString alloc]init];
    
    if (data==nil)
    
    {
        
        subscriberString=@"No Description";
        
    }
    
    
    else
    {
    
        NSMutableString *str=[[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        
        subscriberString=str;

    }
    
    
    return subscriberString;

}

@end
