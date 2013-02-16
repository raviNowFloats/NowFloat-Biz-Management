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
#import "SelectMessageViewController.h"
#import "AppDelegate.h"



@interface BizMessageViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate>
{

    NSMutableArray *a;
    TimeScroller *_timeScroller;
    PostMessageViewController *postMessageController;
    NSMutableArray *dealsArray;
    AppDelegate *appDelegate;
    NSMutableData *data;
    
    

    NSMutableArray *dealId;
    NSMutableDictionary *fpMessageDictionary;
    int messageSkipCount;
    
    UIButton *loadMoreButton;
    bool ismoreFloatsAvailable;
    NSMutableArray *arrayToSkipMessage;
    
    SelectMessageViewController *selectMsgTypeController;

}
@property (weak, nonatomic) IBOutlet UIView *parallax;

@property(nonatomic,strong) NSMutableDictionary *storeDetailDictionary;

@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@property (nonatomic,strong)     NSMutableArray *dealDescriptionArray;

@property (nonatomic,strong)     NSMutableArray *dealDateArray;

@property (nonatomic,strong) NSMutableString *dealIdString;
@property (nonatomic,strong) NSMutableString *dealDateString;
@property (nonatomic,strong) NSMutableString *dealDescriptionString;









@end
