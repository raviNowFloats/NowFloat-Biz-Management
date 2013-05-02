//
//  SettingsController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 25/04/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface SettingsController : UIViewController
{

    AppDelegate *appDelegate;
    
    NSUserDefaults *userDefaults;

    BOOL isForFBPageAdmin;
    
    NSMutableArray *socialNetworksArray;
    
    NSMutableArray *socialNetworkImageArray;
        
    NSMutableArray *listOfItems;
    
    NSMutableArray *manageArray;
    

    
}
@end
