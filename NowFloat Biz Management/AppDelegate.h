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

@property (nonatomic,strong) NSString *clientId;

@property (nonatomic,strong) NSMutableString *businessName;

@property (nonatomic,strong) NSMutableString *businessDescription;

@property (nonatomic,strong) NSMutableArray *dealDescriptionArray;

@property (nonatomic,strong) NSMutableArray *dealDateArray;

@property (nonatomic,strong) NSMutableArray *dealId;

@property (nonatomic,strong) NSMutableArray *arrayToSkipMessage;

@property (nonatomic,strong) NSMutableArray *inboxArray;

@property (nonatomic,strong) NSMutableArray *userMessagesArray;

@property (nonatomic,strong) NSMutableArray *userMessageContactArray;

@property (nonatomic,strong) NSMutableArray *userMessageDateArray;

@property (nonatomic,strong) NSMutableArray *storeTimingsArray;

@property (nonatomic,strong) NSMutableArray *storeContactArray;

@property (nonatomic,strong) NSString *storeTag;

@property ( nonatomic ,strong) NSString *storeEmail;

@property (nonatomic,strong) NSString *storeWebsite;

@property (nonatomic,strong) NSString *storeFacebook;


@end
