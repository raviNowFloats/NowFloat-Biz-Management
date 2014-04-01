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
    UIButton *customCancelButton;
    
    UIButton *customRighNavButton;
    
    IBOutlet UITextField *domainNameTextBox;
    
    IBOutlet UIImageView *domainNameBg;
    
    NSCharacterSet *blockedCharacters;

    IBOutlet UIView *activitySubView;
    
    IBOutlet UIView *buyingDomainSubView;
    
    AppDelegate *appDelegate;
    
    NSUserDefaults *userDefaults;
    
    IBOutlet UIScrollView *contentScrollView;
    
    IBOutlet UIView *selectDomainSubView;
    
    IBOutlet UIView *nextViewOne;
    
    IBOutlet UIButton *successdomainButton;
    
    IBOutlet UIButton *comBtn;
    
    IBOutlet UIButton *netBtn;
    
}


- (IBAction)selectDomainTypeBtnClicked:(id)sender;

- (IBAction)dismissKeyboardBtnClicked:(id)sender;

- (IBAction)selectDomainNextButtonClicked:(id)sender;


@end
