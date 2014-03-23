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

    IBOutlet UITextField *domainTypeTextBox;
    
    IBOutlet UIImageView *domainNameBg;
    
    IBOutlet UIImageView *domainTypeBg;
    
    NSCharacterSet *blockedCharacters;

    IBOutlet UIView *activitySubView;
    
    IBOutlet UIView *buyingDomainSubView;
    
    AppDelegate *appDelegate;
    
    NSUserDefaults *userDefaults;
    
    IBOutlet UIScrollView *contentScrollView;
    
    IBOutlet UIScrollView *buyDomainScrollView;
    
    IBOutlet UITextField *contactNameTxtField;
    
    IBOutlet UITextField *mobileNumberTxtField;
    
    IBOutlet UITextField *emailTxtField;
    
    IBOutlet UITextField *addressTxtField;
    
    IBOutlet UITextField *cityTxtField;
    
    IBOutlet UITextField *stateTxtField;
    
    IBOutlet UITextField *countryTxtField;
    
    IBOutlet UITextField *zipCodeTxtField;
    
    IBOutlet UIView *selectDomainSubView;
    
    IBOutlet UIView *contactInformationSubView;
    
    IBOutlet UIImageView *contactNameImgView;
    
    IBOutlet UIImageView *phoneNumberImgView;
    
    IBOutlet UIImageView *emailImgView;
    
    IBOutlet UIImageView *addressImgView;
    
    IBOutlet UIImageView *cityImgView;
    
    IBOutlet UIImageView *stateImgView;
    
    IBOutlet UIImageView *countryImgView;
    
    IBOutlet UIImageView *zipCodeImgView;
    
    IBOutlet UIView *nextViewOne;
    
    IBOutlet UIView *nextViewTwo;
}

- (IBAction)skipDomainPurchase:(id)sender;

- (IBAction)selectDomainTypeBtnClicked:(id)sender;

- (IBAction)dismissKeyboardBtnClicked:(id)sender;

- (IBAction)selectDomainNextButtonClicked:(id)sender;

- (IBAction)buyDomainBtnClicked:(id)sender;

- (IBAction)buyDomainBackBtnClicked:(id)sender;

- (IBAction)selectCountryBtnClicked:(id)sender;

@end
