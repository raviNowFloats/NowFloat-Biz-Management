//
//  ReferFriendViewController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/4/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ReferFriendViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    AppDelegate *appDelegate;
    
    NSString *version;
    
    IBOutlet UITableView *referTableView;
}

@end
