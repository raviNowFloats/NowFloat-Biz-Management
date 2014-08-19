//
//  AppDelegate.h
//  NowFloat Biz Management
//
//  Created by Sumanta Roy on 25/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import <FacebookSDK/FacebookSDK.h>


@class MessageDetailsViewController;
@class FBSession;
@class Mixpanel;
@class SettingsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,SWRevealViewControllerDelegate,UIAlertViewDelegate>
{
    
    NSUserDefaults *userDefaults;
    BOOL isForFBPageAdmin;
    BOOL isFBPageAdminDeSelected;
    BOOL isFBDeSelected;
    UINavigationController *frntNavigationController;

}
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
@property (strong, nonatomic) SettingsViewController *SettingsViewController;
@property (strong, nonatomic) UIWindow *window;

@property(strong, nonatomic) NSMutableDictionary *productDetailsDictionary;

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

@property (strong, nonatomic) NSDate *startTime;

@property (nonatomic) UIBackgroundTaskIdentifier bgTask;

@property (nonatomic,strong) NSMutableArray *searchQueryArray;

@property(nonatomic) BOOL isNotified;

@property (nonatomic,strong) NSString *storeCategoryName;

@property(nonatomic,strong) NSMutableArray *storeWidgetArray;

@property(nonatomic,strong) NSMutableString *storeRootAliasUri;

@property(nonatomic,strong) NSMutableString *storeLogoURI;

@property(nonatomic,strong) SettingsViewController *settingsController;

@property(nonatomic,strong) NSMutableData *deviceTokenData;

@property(nonatomic,strong) NSMutableDictionary *feedFacebook;

extern NSString *const bundleUrl;

extern NSString *const businessProfileUrl;

extern NSString *const updateLink;

extern NSString *const buySeo;

extern NSString *const buyTtb;

extern NSString *const buyFeatureImage;

extern NSString *const analyticsUrl;

extern NSString *const storeUrl;

extern NSString *const ttbUrl;

extern NSString *const settingsUrl;

extern NSString *const googlePlacesUrl;

extern NSString *const referAfriendUrl;

extern NSString *const noAdsUrl;

extern NSString *const changePasswordUrl;

extern BOOL isReferScreen;

- (void)openSession:(BOOL)isAdmin;

-(void)connectAsFbPageAdmin;

-(void)closeSession;

-(void)DeepLinkUrl:(NSURL *)url;


@end
