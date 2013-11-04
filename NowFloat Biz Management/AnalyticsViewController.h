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



@interface AnalyticsViewController : UIViewController<UIActionSheetDelegate,SWRevealViewControllerDelegate>
{

    AppDelegate *appDelegate;
    
    NSData *msgData;
    
    __weak IBOutlet UILabel *subscribersLabel;
    
    __weak IBOutlet UILabel *visitorsLabel;
    
    StoreAnalytics *strAnalytics;
    
    __weak IBOutlet UILabel *subscriberBg;
    
    __weak IBOutlet UILabel *visitorBg;
    
    __weak IBOutlet UIView *topSubView;
    
    __weak IBOutlet UIView *bottomSubview;
    
    BOOL isButtonPressed;
    
    __weak IBOutlet UIButton *dismissButton;
    
    __weak IBOutlet UIButton *viewGraphButton;
    
    __weak IBOutlet UIButton *lineGraphButton;
    
    __weak IBOutlet UIButton *pieChartButton;
    
    IBOutlet UIButton *revealFrontControllerButton;
 
    NSString *frontViewPosition;
    
    
    IBOutlet UIImageView *notificationImageView;
    
    
    IBOutlet UILabel *notificationLabel;
    
    
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *subscriberActivity;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *visitorsActivity;

- (IBAction)viewBtnClicked:(id)sender;


- (IBAction)revealFrontController:(id)sender;

- (IBAction)searchQueryBtnClicked:(id)sender;

@end
