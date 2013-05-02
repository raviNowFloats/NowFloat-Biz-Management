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




@interface SettingsViewController : UIViewController
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
}



- (IBAction)facebookButtonClicked:(id)sender;

- (IBAction)twitterButtonClicked:(id)sender;

- (IBAction)disconnectFacebookButtonClicked:(id)sender;

- (IBAction)fbAdminButtonClicked:(id)sender;

- (IBAction)disconnectFbPageAdminButtonClicked:(id)sender;




- (IBAction)closeFbAdminPageSubView:(id)sender;


- (IBAction)selectFbPages:(id)sender;



@end
