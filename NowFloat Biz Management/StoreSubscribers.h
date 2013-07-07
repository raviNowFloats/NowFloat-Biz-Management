//
//  StoreSubscribers.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/05/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol StoreSubscribersDelegate <NSObject>

-(void)showSubscribers:(NSString *)subscribers;

@end


@interface StoreSubscribers : NSObject


{
    
    AppDelegate *appDelegate;
    NSMutableData *msgData;
    NSString *recievedString;
    id<StoreSubscribersDelegate>delegate;
    NSString *subscriberCount;
}

@property (nonatomic,strong)     id<StoreSubscribersDelegate>delegate;

-(void)getStoreSubscribers;

@end
