//
//  StoreAnalytics.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 14/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreAnalytics : NSObject

{

    NSString *subscriberString;
}

-(NSString *)getStoreAnalytics:(NSData *)data;



@end
