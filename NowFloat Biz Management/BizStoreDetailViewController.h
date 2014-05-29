//
//  BizStoreDetailViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 11/01/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BizStoreDetailViewController : UIViewController
{
    UINavigationBar *navBar;
    
    UIButton *customCancelButton;
    
    NSMutableArray *introductionArray;
    
    NSMutableArray *descriptionArray;
    
    NSMutableArray *widgetImageArray;
    
    NSMutableArray *howItWorksArray;
    
    IBOutlet UITableView *bizStoreDetailsTableView;

}


@property(nonatomic) int selectedWidget;

@property(nonatomic) BOOL isFromOtherViews;

@end
