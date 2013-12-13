//
//  SettingsViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 11/03/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//com.${PRODUCT_NAME:rfc1034identifier}

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SA_OAuthTwitterController.h"

@protocol SettingsViewDelegate <NSObject>

@optional
-(void)settingsViewUserDidComplete;

@end


@class SA_OAuthTwitterEngine;

@interface SettingsViewController : UIViewController<SA_OAuthTwitterControllerDelegate,SA_OAuthTwitterControllerDelegate,SWRevealViewControllerDelegate>
{
    AppDelegate *appDelegate;
    
    NSUserDefaults *userDefaults;

    __weak IBOutlet UIButton *disconnectFacebookButton;
    
    __weak IBOutlet UIButton *facebookButton;
    
    IBOutlet UIButton *disconnectFacebookAdmin;

    IBOutlet UIButton *facebookAdminButton;
    
    IBOutlet UIView *fbAdminPageSubView;
    
    BOOL isForFBPageAdmin;
        
    IBOutlet UIView *activitySubView;
    
    NSMutableArray *userFbAdminDetailsArray;
    
    IBOutlet UITableView *fbAdminTableView;
    
    NSIndexPath* checkedIndexPath;
    
    IBOutlet UILabel *titleBgLabel;
    
    IBOutlet UIButton *fbPageOkBtn;
    
    IBOutlet UIButton *fbPageClose;

    UITableViewCell *cell;
    
    IBOutlet UILabel *bgLabel;
    
    IBOutlet UILabel *fbUserNameLabel;
    
    IBOutlet UILabel *fbPageNameLabel;
    
    SA_OAuthTwitterEngine *_engine;

    IBOutlet UIButton *disconnectTwitterButton;
    
    IBOutlet UIButton *twitterButton;
    
    IBOutlet UILabel *twitterUserNameLabel;
    
    NSString *frontViewPosition;
    
    IBOutlet UIButton *revealFrontControllerButton;
    
    NSString *version ;
    
    UINavigationBar *navBar;
    
    IBOutlet UIView *placeHolderBg;
    
}



- (IBAction)facebookBtnClicked:(id)sender;

- (IBAction)twitterBtnClicked:(id)sender;

- (IBAction)disconnectFacebookBtnClicked:(id)sender;

- (IBAction)fbAdminBtnClicked:(id)sender;

- (IBAction)disconnectFbPageAdminBtnClicked:(id)sender;


- (IBAction)closeFbAdminPageSubView:(id)sender;


//- (IBAction)selectFbPages:(id)sender;

- (IBAction)disconnectTwitterBtnClicked:(id)sender;

- (IBAction)revealFrontController:(id)sender;


@property(nonatomic) BOOL isGestureAvailable;

@property(nonatomic,strong) id<SettingsViewDelegate>delegate;

@end
