//
//  StoreViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 26/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface StoreViewController : UIViewController
{

    IBOutlet UIView *talkToBusinessSubview;

    IBOutlet UIView *pictureMessageSubview;
    
    IBOutlet UIView *websiteDomainSubView;

    IBOutlet UIView *storeImageGallery;
    
    IBOutlet UIView *storeSocialSharing;
    
    IBOutlet UIView *navBar;

    IBOutlet UIView *bottomBarSubView;

    UIButton *customCancelButton;

    IBOutlet UIView *talkToBusinessSubViewiPhone4;

    IBOutlet UIView *pictureMessageSubviewiPhone4;
    
    IBOutlet UIView *websiteDomainSubviewiPhone4;
    
    IBOutlet UIView *storeImageGalleryiPhone4;
    
    IBOutlet UIView *storeSocialSharingiPhone4;
    
    UIImageView *buttonImageView;

    UIImageView *imgView;
    
    AppDelegate *appDelegate;
    
    NSUserDefaults *userDefaults;
    
    IBOutlet UIView *activitySubView;
    
    IBOutlet UIView *childActivitySubview;
    
    
    
    IBOutletCollection(UIButton) NSArray *purchaseDomainButton;
    
    IBOutletCollection(UIButton) NSArray *purchaseTtbButton;
    
    
    IBOutletCollection(UIButton) NSArray *purchaseImageGallery;
    
    
}


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIScrollView *bottomBarScrollView;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property(nonatomic,strong) NSArray *productSubViewsArray;

@property(nonatomic,strong) NSArray *bottomBarImageArray;

@property(nonatomic,strong) NSMutableArray *pageViews;

@property(nonatomic) int currentScrollPage;


- (IBAction)moreInfoButtonClicked:(id)sender;

- (IBAction)buyButtonClicked:(id)sender;


@end
