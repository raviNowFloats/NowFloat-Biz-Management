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

@interface CreateStoreDeal : NSObject
{
    AppDelegate *appDelegate;
    NSString *dealStartDate;
    NSString *dealTitle;
    NSMutableData *receivedData;
    BOOL isFbShare;
    BOOL isFbPageShare;
    
}

-(void)createDeal:(NSMutableDictionary *)dictionary isFbShare:(BOOL)fbShare isFbPageShare:(BOOL)fbPageShare;

@property (nonatomic,strong) NSMutableDictionary *offerDetailDictionary;

@property (nonatomic,strong) PostMessageViewController *_PostMessageController;

@end
