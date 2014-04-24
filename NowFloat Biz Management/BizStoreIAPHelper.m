//
//  BizStoreIAPHelper.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 23/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BizStoreIAPHelper.h"

@implementation BizStoreIAPHelper

+ (BizStoreIAPHelper *)sharedInstance
{
    static dispatch_once_t once;
    
    static BizStoreIAPHelper * sharedInstance;
    
    dispatch_once
    (&once, ^{
        NSSet * productIdentifiers;
        
        if (BOOST_PLUS) {
            productIdentifiers = [NSSet setWithObjects:
                                  @"com.biz.boostplus.tob",
                                  @"com.biz.boostplus.imagegallery",
                                  @"com.biz.boostplus.businesstimings",

                                  nil];

        }
        else{
        productIdentifiers = [NSSet setWithObjects:
                                      @"com.biz.ttbdomaincombo",
                                      @"com.biz.nowfloats.tob",
                                      @"com.biz.nowfloats.imagegallery",
                                      @"com.biz.nowfloats.businesstimings",
                                      @"com.biz.nowfloats.noads",                              
                                      nil];
        }
        
        
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
