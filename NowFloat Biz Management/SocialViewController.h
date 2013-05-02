//
//  SocialViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 25/04/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"



@interface SocialViewController : UIViewController

{
    
    AppDelegate *appDelegate;
    
    NSUserDefaults *userDefaults;
    
    NSMutableArray *listOfItems;

    NSMutableArray *socialNetworksArray;
    
    NSMutableArray *fbPageNameArray;
    
    NSMutableArray *fbPageIdArray;
    
    NSMutableArray *fbPageAccessTokenArray;
    
    NSMutableArray *sectionNameArray;

    IBOutlet UITableView *socialNetworkTableView;
    
    BOOL isEdit;
    
    
}


@end
