//
//  AnalyticsViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 14/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "StoreAnalytics.h"


@interface AnalyticsViewController : UIViewController
{

    AppDelegate *appDelegate;
    NSData *msgData;
    
    __weak IBOutlet UILabel *subscribersLabel;
    
    __weak IBOutlet UILabel *visitorsLabel;
    
    StoreAnalytics *strAnalytics;
    
    __weak IBOutlet UILabel *subscriberBg;
    
    __weak IBOutlet UILabel *visitorBg;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *subscriberActivity;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *visitorsActivity;


@end
