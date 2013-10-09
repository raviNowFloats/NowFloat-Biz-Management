//
//  CheckDomainAvailablityController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 03/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@protocol CheckDomainAvailablityDelegate <NSObject>


-(void)checkDomainDidSucceed:(NSString *) successString;

-(void)checkDomaindidFail;


@end


@interface CheckDomainAvailablityController : NSObject
{
    AppDelegate *appDelegate;
    
    NSMutableData *msgData;
}

@property(nonatomic,strong) id<CheckDomainAvailablityDelegate>delegate;

-(void)getDomainAvailability:(NSString *)domainName withType:(NSString *)domainType;


@end
