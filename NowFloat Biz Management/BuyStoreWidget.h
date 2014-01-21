//
//  BuyStoreWidget.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 13/01/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol BuyStoreWidgetDelegate <NSObject>

-(void)buyStoreWidgetDidSucceed;

-(void)buyStoreWidgetDidFail;

@end

@interface BuyStoreWidget : NSObject

-(void)purchaseStoreWidget:(double) widgetIndex;


@property (nonatomic,strong) id<BuyStoreWidgetDelegate>delegate;

@end
