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
}

- (IBAction)facebookButtonClicked:(id)sender;

- (IBAction)twitterButtonClicked:(id)sender;

- (IBAction)disconnectFacebookButtonClicked:(id)sender;

- (IBAction)fbAdminButtonClicked:(id)sender;



@end
