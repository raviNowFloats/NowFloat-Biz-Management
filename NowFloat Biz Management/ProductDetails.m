//
//  ProductDetails.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/28/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "ProductDetails.h"


@implementation ProductDetails
@synthesize delegate;


-(void)getProductDetails
{
    
    productIdentifiers = [NSSet setWithObjects:@"com.biz.ttbdomaincombo",@"com.biz.nowfloats.tob",@"com.biz.nowfloats.imagegallery",@"com.biz.nowfloats.businesstimings",@"com.biz.nowfloats.noads",nil];
    
    productDictionary = [[NSMutableDictionary alloc] init];
    
    productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productRequest.delegate = self;
    [productRequest start];
   
    
}



-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    
    [delegate performSelector:@selector(successProductDetailsFetching) withObject:productDictionary];
}

@end
