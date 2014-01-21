//
//  BuyStoreWidget.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 13/01/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "BuyStoreWidget.h"
#import "AppDelegate.h"
#import "AddWidgetController.h"


#define BusinessTimingsTag 1006
#define ImageGalleryTag 1004
#define AutoSeoTag 1008
#define TalkToBusinessTag 1002

@interface BuyStoreWidget()<AddWidgetDelegate>
{
    AppDelegate *appDelegate;
    NSUserDefaults *userDefaults;
    double clickedIndex;
}
@end


@implementation BuyStoreWidget
@synthesize delegate;


-(void)purchaseStoreWidget:(double)widgetIndex
{
    clickedIndex=widgetIndex;
    
    appDelegate= (AppDelegate *)[UIApplication  sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    if (widgetIndex==TalkToBusinessTag) {
        NSDictionary *productDescriptionDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:
        appDelegate.clientId,@"clientId",
        [NSString stringWithFormat:@"com.biz.nowfloats.tob"],@"clientProductId",
        [NSString stringWithFormat:@"Talk to business"],@"NameOfWidget" ,
        [userDefaults objectForKey:@"userFpId"],@"fpId",
        [NSNumber numberWithInt:12],@"totalMonthsValidity",
        [NSNumber numberWithDouble:3.99],@"paidAmount",
        [NSString stringWithFormat:@"TOB"],@"widgetKey",
        nil];
        
        
        AddWidgetController *addController=[[AddWidgetController alloc]init];
        
        addController.delegate=self;
        
        [addController addWidgetsForFp:productDescriptionDictionary];

    }
    
    if (widgetIndex== ImageGalleryTag) {

        
        NSDictionary *productDescriptionDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:
        appDelegate.clientId,@"clientId",
        [NSString stringWithFormat:@"com.biz.nowfloats.imagegallery"],@"clientProductId",
        [NSString stringWithFormat:@"Image gallery"],@"NameOfWidget" ,
        [userDefaults objectForKey:@"userFpId"],@"fpId",
        [NSNumber numberWithInt:12],@"totalMonthsValidity",
        [NSNumber numberWithDouble:2.99],@"paidAmount",
        [NSString stringWithFormat:@"IMAGEGALLERY"],@"widgetKey",
        nil];
        
        AddWidgetController *addController=[[AddWidgetController alloc]init];
        
        addController.delegate=self;
        
        [addController addWidgetsForFp:productDescriptionDictionary];

    }
    
    if (widgetIndex == BusinessTimingsTag) {

        NSDictionary *productDescriptionDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:
        appDelegate.clientId,@"clientId",
        [NSString stringWithFormat:@"com.biz.nowfloats.businesstimings"],@"clientProductId",
        [NSString stringWithFormat:@"Business timings"],@"NameOfWidget" ,
        [userDefaults objectForKey:@"userFpId"],@"fpId",
        [NSNumber numberWithInt:12],@"totalMonthsValidity",
        [NSNumber numberWithDouble:0.99],@"paidAmount",
        [NSString stringWithFormat:@"TIMINGS"],@"widgetKey",
        nil];
        
        AddWidgetController *addController=[[AddWidgetController alloc]init];
        
        addController.delegate=self;
        
        [addController addWidgetsForFp:productDescriptionDictionary];

    }
    
    if (widgetIndex == AutoSeoTag) {
        NSDictionary *productDescriptionDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:
        appDelegate.clientId,@"clientId",
        [NSString stringWithFormat:@"com.biz.nowfloats.sitesense"],@"clientProductId",
        [NSString stringWithFormat:@"Auto-SEO"],@"NameOfWidget" ,
        [userDefaults objectForKey:@"userFpId"],@"fpId",
        [NSNumber numberWithInt:12],@"totalMonthsValidity",
        [NSNumber numberWithDouble:0.00],@"paidAmount",
        [NSString stringWithFormat:@"SITESENSE"],@"widgetKey",
        nil];

        
        AddWidgetController *addController=[[AddWidgetController alloc]init];
        
        addController.delegate=self;
        
        [addController addWidgetsForFp:productDescriptionDictionary];
    }
}


#pragma AddWidgetDelegate
-(void)addWidgetDidSucceed;
{
    [delegate performSelector:@selector(buyStoreWidgetDidSucceed)];
}

-(void)addWidgetDidFail;
{
    [delegate performSelector:@selector(buyStoreWidgetDidFail)];
}

@end
