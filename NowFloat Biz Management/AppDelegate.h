//
//  AppDelegate.h
//  NowFloat Biz Management
//
//  Created by Sumanta Roy on 25/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,SWRevealViewControllerDelegate>
{


}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SWRevealViewController *viewController;

@property(nonatomic,strong) NSMutableDictionary *storeDetailDictionary;

@property (nonatomic,strong) NSMutableDictionary *fpDetailDictionary;

@property (nonatomic,strong) NSMutableArray *msgArray;

@end
