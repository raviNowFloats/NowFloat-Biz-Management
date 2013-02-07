//
//  MasterController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MasterController : UITableViewController
{
    BOOL _didDownloadData;
    NSArray *dataArray;
    NSArray *manageStoreDetails;
    NSArray *imageSelectionArray;
    IBOutlet UITableView *masterTableView;
}



@property(nonatomic,strong)     NSString *tileImageurl;

@end
