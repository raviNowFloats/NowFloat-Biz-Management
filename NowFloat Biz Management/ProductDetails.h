//
//  ProductDetails.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/28/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <StoreKit/StoreKit.h>

@protocol ProductDetailsDelegate <NSObject>

-(void)successProductDetailsFetching:(NSMutableDictionary *) productDetails;

@end

@interface ProductDetails : NSObject<SKProductsRequestDelegate>
{
    AppDelegate *appDelegate;
    
    id<ProductDetailsDelegate> delegate;
    
    NSMutableDictionary *productDictionary;
    
     NSSet * productIdentifiers;
    
     NSString *ttbComboPrice;
    
    SKProductsRequest *productRequest;
    
    
}

@property(strong, nonatomic) id<ProductDetailsDelegate> delegate;

-(void)getProductDetails;

@end
