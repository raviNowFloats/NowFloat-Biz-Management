//
//  SearchQueryViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 14/07/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"



@interface SearchQueryViewController : UIViewController
{

    AppDelegate *appDelegate;
    NSUserDefaults *userDefaults;
    NSMutableArray *searchQueryArray;
    NSMutableArray *searchDateArray;
}
@end
