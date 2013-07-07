//
//  DeleteFloatController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 30/05/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@protocol updateBizMessage <NSObject>

-(void)updateBizMessage;

@end


@interface DeleteFloatController : NSObject
{

    AppDelegate *appDelegate;
    NSMutableData *receivedData;
    id<updateBizMessage>DeleteBizFloatdelegate;

}

-(void)deletefloat:(NSString *)dealId;

@property (nonatomic,strong) id<updateBizMessage>DeleteBizFloatdelegate;


@end


