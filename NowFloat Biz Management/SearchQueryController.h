//
//  SearchQueryController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 11/07/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@protocol SearchQueryProtocol <NSObject>


@optional

-(void)saveSearchQuerys:(NSMutableArray *)jsonArray;

-(void)getSearchQueryDidSucceedWithArray:(NSArray *)jsonArray;

-(void)getSearchQueryDidFail;


@end

@interface SearchQueryController : NSObject
{

    AppDelegate *appDelegate;
    NSUserDefaults *userDefaults;
    NSMutableData *receivedData;


}

@property(nonatomic,strong) id<SearchQueryProtocol>delegate;


-(void)getSearchQueriesWithOffset:(int)offset;


@end
