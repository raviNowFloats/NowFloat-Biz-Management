//
//  BookDomainController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 27/03/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol BookDomainDelegate <NSObject>

-(void)bookDomainDidSucceedWithObject:(id)responseObject;

-(void)bookDomainDidFail;

@end

@interface BookDomainController : NSObject
{
    AppDelegate *appDelegate;
    NSUserDefaults *userDefaults;
    NSMutableData *msgData;
    
}

@property (nonatomic,strong) id<BookDomainDelegate>delegate;

-(void)bookDomain:(NSDictionary *)detailsDictionary;

@end
