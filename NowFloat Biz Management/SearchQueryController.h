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


-(void)saveSearchQuerys:(NSMutableArray *)jsonArray;


@end

@interface SearchQueryController : NSObject
{

    AppDelegate *appDelegate;
    NSUserDefaults *userDefaults;
    NSMutableData *receivedData;


}

@property(nonatomic,strong) id<SearchQueryProtocol>delegate;


-(void)getSearchQueries;


@end
