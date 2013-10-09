//
//  DomainSelectViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 03/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface DomainSelectViewController : UIViewController<UIActionSheetDelegate>
{
    IBOutlet UIView *navBar;
    
    UIButton *customCancelButton;
    
    UIButton *customRighNavButton;
    
    IBOutlet UITextField *domainNameTextBox;

    IBOutlet UITextField *domainTypeTextBox;
    
    IBOutlet UIImageView *domainNameBg;
    
    IBOutlet UIImageView *domainTypeBg;
    
    NSCharacterSet *blockedCharacters;

    IBOutlet UIView *activitySubView;
    
    IBOutlet UIView *buyingDomainSubView;
    
    AppDelegate *appDelegate;
    
    NSUserDefaults *userDefaults;
}

- (IBAction)selectDomainTypeButtonClicked:(id)sender;

- (IBAction)dismissKeyboardButtonClicked:(id)sender;


@end
