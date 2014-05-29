//
//  LatestVisitorDetails.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/13/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol LatestVisitorDelegate <NSObject>

-(void)lastVisitDetails;

@end


@interface LatestVisitorDetails : UIViewController
{
    AppDelegate *appDelegate;
    NSMutableData *msgData;
    NSString *recievedString;
    id<LatestVisitorDelegate>delegate;
    NSString *visitorCount;
    NSString *subscriberCount;
}

@property(strong, nonatomic) id<LatestVisitorDelegate>delegate;

-(void)getVisitorDetails;

@end
