//
//  BizStoreViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 23/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface BizStoreViewController : UIViewController
{
    AppDelegate *appDelegate;

    NSUserDefaults *userDefaults;
    
    IBOutlet UITableView *bizStoreTableView;
    
    __weak IBOutlet UITableView *mach1TableView;
    
    __weak IBOutlet UITableView *mach3TableView;
    
    UINavigationBar *navBar;

    UILabel *headerLabel;

    UIButton *customCancelButton;
    
    NSString *version;
    
    NSMutableArray *sectionNameArray;
    
    UIButton *leftCustomButton;
    
    NSString *frontViewPosition;
    
    UIScrollView *recommendedAppScrollView;
    
    NSMutableArray *recommendedAppArray;
    
    NSMutableArray *topPaidAppArray;
    
    NSMutableArray *topFreeAppArray;
    
    IBOutlet UIView *talkTobusinessSubView;
    
    IBOutlet UIView *businessTimingsSubView;
    
    IBOutlet UIView *imageGallerySubView;
    
    IBOutlet UIView *autoSeoSubView;
    
    IBOutlet UIView *noAdsSubView;
    
    IBOutlet UIView *InTouchApp;
    
    IBOutlet UIView *gPlacesSubView;
    
    IBOutlet UIView *mach1Screen;
    
    IBOutlet UIView *storeTabBarView;
    
    IBOutlet UIView *mach3Screen;
    
    IBOutletCollection(UIButton) NSArray *recommendedBuyBtnCollection;
    
    IBOutlet UIView *purchasedWidgetOverlay;
    
    NSMutableArray *productSubViewsArray;
    
    IBOutlet UIView *noWidgetView;
    
    IBOutlet UIView *googlePlacesBannerSubView;
    
    IBOutlet UIView *ttbdomainComboBannerSubView;
    
    IBOutlet UIView *internationalPack;
    
    IBOutletCollection(UIButton) NSArray *bannerBtnCollection;
}

- (IBAction)revealFrontController:(id)sender;

@property(nonatomic,strong) NSMutableArray *pageViews;

@property (nonatomic, strong) id currentPopTipViewTarget;

@property (nonatomic, strong) NSMutableArray *visiblePopTipViews;

@property (nonatomic, strong) NSMutableDictionary *popUpContentDictionary;

@property(nonatomic) BOOL isFromOtherViews;

- (IBAction)buyRecommendedWidgetBtnClicked:(id)sender;

- (IBAction)detailRecommendedBtnClicked:(id)sender;

- (IBAction)dismissOverlay:(id)sender;

- (IBAction)detailBannerBtnClicked:(id)sender;

@end
