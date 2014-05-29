//
//  LatestVisitors.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/13/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol LatestVisitorDelegate <NSObject>

-(void)lastVisitDetails:(NSMutableDictionary *)visits;

-(void)failedToGetVisitDetails;

@end

@interface LatestVisitors : NSObject
{
    AppDelegate *appDelegate;
    NSMutableArray *muteData;
    NSString *cityName;
    NSString *countryName;
    NSMutableData *msgData;
    NSString *recievedString;
    int statusCode;
    
    id<LatestVisitorDelegate>delegate;
    
}

@property(strong, nonatomic) id<LatestVisitorDelegate>delegate;

-(void)getLastVisitorDetails;

@end
