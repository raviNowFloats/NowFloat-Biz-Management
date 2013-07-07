//
//  AppDelegate.h
//  NowFloat Biz Management
//
//  Created by Sumanta Roy on 25/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"



@class MessageDetailsViewController;
@class FBSession;
@class Mixpanel;

@interface AppDelegate : UIResponder <UIApplicationDelegate,SWRevealViewControllerDelegate>
{
    
    NSUserDefaults *userDefaults;
    BOOL isForFBPageAdmin;
    BOOL isFBPageAdminDeSelected;
    BOOL isFBDeSelected;

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

@property (nonatomic,strong) NSMutableArray *storeAnalyticsArray;

@property (nonatomic,strong) NSMutableArray *storeVisitorGraphArray;

@property (nonatomic,strong) NSString *apiWithFloatsUri;

@property (nonatomic,strong) NSString *apiUri;

@property (nonatomic,strong) NSMutableArray *secondaryImageArray;

@property (nonatomic,strong) NSMutableArray *dealImageArray;

@property (nonatomic,strong) NSMutableString *localImageUri;

@property (nonatomic,strong) NSMutableString *primaryImageUploadUrl;

@property (nonatomic,strong) NSMutableString *primaryImageUri;

@property (nonatomic,strong) NSMutableArray *fbUserAdminArray;

@property (nonatomic,strong) NSMutableArray *fbUserAdminAccessTokenArray;

@property (nonatomic,strong) NSMutableArray *fbUserAdminIdArray;

@property (nonatomic,strong) NSMutableArray *fbPageAdminSelectedIndexArray;

@property (nonatomic,strong) NSMutableArray *socialNetworkNameArray;

@property (nonatomic,strong) NSMutableArray *socialNetworkIdArray;

@property (nonatomic,strong) NSMutableArray *socialNetworkAccessTokenArray;

@property (nonatomic,strong) NSMutableArray *multiStoreArray;

@property (nonatomic,strong) NSMutableArray *addedFloatsArray;

@property (nonatomic,strong) NSMutableArray *deletedFloatsArray;


@property (strong, nonatomic) Mixpanel *mixpanel;

@property (strong, nonatomic, retain) NSDate *startTime;

@property (nonatomic) UIBackgroundTaskIdentifier bgTask;





- (void)openSession:(BOOL)isAdmin;

-(void)connectAsFbPageAdmin;

-(void)closeSession;

@end
