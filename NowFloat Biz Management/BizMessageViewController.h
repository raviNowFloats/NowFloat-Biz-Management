//
//  BizMessageViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 26/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeScroller.h"
#import "PostMessageViewController.h"
#import "AppDelegate.h"



@interface BizMessageViewController : UIViewController<UIScrollViewDelegate>
{

    NSMutableArray *a;
    TimeScroller *_timeScroller;
    PostMessageViewController *postMessageController;
    NSMutableArray *dealsArray;
    NSMutableArray *dealDateArray;
    NSMutableArray *dealDescriptionArray;
    AppDelegate *appDelegate;
    
}
@property (weak, nonatomic) IBOutlet UIView *parallax;

@property(nonatomic,strong) NSMutableDictionary *storeDetailDictionary;

@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@end
