//
//  BizMessage.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 21/06/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@protocol BizMessageControllerDelegate <NSObject>

-(void)updateBizMessage:(NSMutableDictionary *)responseDictionary;

@end




@interface BizMessage : NSObject
{


    AppDelegate *appDelegate;
    NSUserDefaults *userDefaults;
    NSMutableData *msgData;


}

@property(nonatomic,strong) id<BizMessageControllerDelegate>delegate;



-(void)downloadBizMessages:(NSURL *)uri;


@end
