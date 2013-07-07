//
//  StoreVisits.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/05/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@protocol StoreVisitDelegate <NSObject>

-(void)showVisitors:(NSString *)visits;

-(void)showSubscribers:(NSString *)subscribers;

@end

@interface StoreVisits : NSObject
{

    AppDelegate *appDelegate;
    NSMutableData *msgData;
    NSString *recievedString;
    id<StoreVisitDelegate>delegate;
    NSString *visitorCount;
    NSString *subscriberCount;
}


@property (nonatomic,strong)     id<StoreVisitDelegate>delegate;


-(void)getStoreVisits;



@end
