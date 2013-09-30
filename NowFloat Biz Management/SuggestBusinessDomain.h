//
//  SuggestBusinessDomain.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 06/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@protocol SuggestBusinessDomainDelegate <NSObject>

-(void)suggestBusinessDomainDidComplete:(NSString *)suggestedDomainString;

@end


@interface SuggestBusinessDomain : NSObject
{
    AppDelegate *appDelegate;
    NSMutableData *receivedData;
    BOOL isSuccess;
}


@property (nonatomic,strong) id<SuggestBusinessDomainDelegate>delegate;

-(void)suggestBusinessDomainWith:(NSDictionary *)requestObject;



@end
