//
//  SitemeterDetailView.h
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 25/08/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SitemeterDetailView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    AppDelegate *appDelegate;
    
    __weak IBOutlet UITableView *mainTableView;
    
    NSString *version;
    
}

@end
