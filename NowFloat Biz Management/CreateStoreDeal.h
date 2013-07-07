//
//  CreateStoreDeal.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 12/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@class PostMessageViewController;


@protocol updateDelegate <NSObject>

-(void) downloadFinished;

@end


@interface CreateStoreDeal : NSObject
{
    AppDelegate *appDelegate;
    NSString *dealStartDate;
    NSString *dealTitle;
    NSMutableData *receivedData;
    BOOL isFbShare;
    BOOL isFbPageShare;
    BOOL isTwitterShare;
    id<updateDelegate> delegate;
}

-(void)createDeal:(NSMutableDictionary *)dictionary isFbShare:(BOOL)fbShare isFbPageShare:(BOOL)fbPageShare isTwitterShare:(BOOL)twitterShare;

@property (nonatomic,strong) NSMutableDictionary *offerDetailDictionary;

@property (nonatomic,strong) PostMessageViewController *_PostMessageController;

@property (nonatomic,strong) id<updateDelegate> delegate;

@end
