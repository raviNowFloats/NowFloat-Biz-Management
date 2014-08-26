//
//  ProPackController.h
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 13/08/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "Mixpanel.h"

@interface ProPackController : UIViewController
{
    AppDelegate *appDelegate;
    
    __weak IBOutlet UIScrollView *mainScroll;
    
    __weak IBOutlet UILabel *featureLabel;
    
    __weak IBOutlet UIButton *priceButton;
    
    Mixpanel *mixPanel;
    
    IBOutlet UIView *newBanner;
    
    __weak IBOutlet UITableView *mainTableView;
    
    UIButton *customCancelButton;
}


@property(nonatomic) BOOL isFromOtherViews;

- (IBAction)buyWidget:(id)sender;

@end
