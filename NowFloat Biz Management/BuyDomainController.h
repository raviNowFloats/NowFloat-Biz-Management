//
//  BuyDomainController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 06/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol BuyDomainDelegate <NSObject>

-(void)buyDomainDidSucceed;

-(void)buyDomainDidFail;

@end

@interface BuyDomainController : NSObject
{

    AppDelegate *appDelegate;
    NSUserDefaults *userDefaults;
    NSMutableData *msgData;
}

@property (nonatomic,strong) id<BuyDomainDelegate>delegate;

-(void)buyDomain:(NSDictionary *)detailsDictionary;



@end
