//
//  IAPHelper.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 23/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>



UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

UIKIT_EXTERN NSString *const IAPHelperProductPurchaseFailedNotification;

UIKIT_EXTERN NSString *const IAPHelperProductPurchaseRestoredNotification;

UIKIT_EXTERN NSString *const kSubscriptionExpirationDateKey;


typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);


@protocol IAPHelperDelegate <NSObject>


-(void)trasactionDidComplete;

-(void)trasactionDidRestore;

-(void)trasactionDidFail;


@end


@interface IAPHelper : NSObject

@property (nonatomic,strong) id<IAPHelperDelegate>delegate;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

- (void)buyProduct:(SKProduct *)product;

- (BOOL)productPurchased:(NSString *)productIdentifier;


@end
