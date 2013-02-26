//
//  TalkToBuisnessViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 25/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNMPullToRefreshManager.h"
#import "AppDelegate.h"
#import "GetUserMessage.h"

@interface TalkToBuisnessViewController : UIViewController<MNMPullToRefreshManagerClient>
{
    NSUserDefaults *userDetails;
    NSMutableArray *messageArray;
    NSMutableArray *dateArray;
    NSMutableArray *messageHeadingArray;
    AppDelegate *appDelegate;
    GetUserMessage *userMsgController;
    
    __weak IBOutlet UIActivityIndicatorView *loadingActivityView;
    
    
    BOOL isPullTriggered;

}




@property (weak, nonatomic) IBOutlet UITableView *talkToBuisnessTableView;
@property (nonatomic, readwrite, strong) MNMPullToRefreshManager *pullToRefreshManager;
@property (nonatomic, readwrite, assign) NSUInteger reloads;



@end
