//
//  SocialSettingsFBHelper.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 23/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "SocialSettingsFBHelper.h"

@implementation SocialSettingsFBHelper


+(SocialSettingsFBHelper *)sharedInstance
{
    static SocialSettingsFBHelper * sharedInstance;
    
    sharedInstance=[[self alloc]init];
    
    return sharedInstance;
}



@end
