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
}



- (IBAction)facebookButtonClicked:(id)sender;

- (IBAction)twitterButtonClicked:(id)sender;

- (IBAction)disconnectFacebookButtonClicked:(id)sender;

- (IBAction)fbAdminButtonClicked:(id)sender;

- (IBAction)disconnectFbPageAdminButtonClicked:(id)sender;


- (IBAction)closeFbAdminPageSubView:(id)sender;


//- (IBAction)selectFbPages:(id)sender;

- (IBAction)disconnectTwitterButtonClicked:(id)sender;

- (IBAction)revealFrontController:(id)sender;


@end
