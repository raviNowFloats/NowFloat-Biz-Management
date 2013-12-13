//
//  LogOutController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 02/12/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface LogOutController : NSObject
{
    AppDelegate *appDelegate;
    NSUserDefaults *userDefaults;
}

-(void)clearFloatingPointDetails;

@end
