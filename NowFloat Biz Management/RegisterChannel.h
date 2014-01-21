//
//  RegisterChannel.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 02/01/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@protocol RegisterChannelDelegate <NSObject>

-(void)channelDidRegisterSuccessfully;

-(void)channelFailedToRegister;

@end

@interface RegisterChannel : NSObject
{
    AppDelegate *appDelegate;
    NSUserDefaults *userDefaults;
}

-(void)registerNotificationChannel;

@property(nonatomic,strong) id<RegisterChannelDelegate>delegate;

@end
