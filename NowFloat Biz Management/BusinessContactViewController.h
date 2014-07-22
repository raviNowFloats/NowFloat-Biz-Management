//
//  BusinessContactViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BusinessContactViewController : UIViewController<UITextFieldDelegate,SWRevealViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{

    __weak IBOutlet UITextField *mobileNumTextField;

    __weak IBOutlet UITextField *landlineNumTextField;
    
    __weak IBOutlet UITextField *secondaryPhoneTextField;
    
    __weak IBOutlet UITextField *websiteTextField;
    
    __weak IBOutlet UITextField *emailTextField;
    
    __weak IBOutlet UITextField *facebookTextField;
    
    
    int textFieldTag;
    
    AppDelegate *appDelegate;
    
   
    BOOL isContact1Changed;
    BOOL isContact2Changed;
    BOOL isContact3Changed;
    BOOL isWebSiteChanged;
    BOOL isEmailChanged;
    BOOL isFBChanged;

    
    
    BOOL isContact1Changed1;
    BOOL isContact2Changed1;
    BOOL isContact3Changed1;
    BOOL isWebSiteChanged1;
    BOOL isEmailChanged1;
    BOOL isFBChanged1;
    
    
    NSMutableDictionary *_contactDictionary1;
    NSMutableDictionary *_contactDictionary2;
    NSMutableDictionary *_contactDictionary3;
    NSMutableArray *_contactsArray;
    
    
    NSString *contactNameString1;
    NSString *contactNameString2;
    NSString *contactNameString3;

    
    NSString *contactNumberOne;
    NSString *contactNumberTwo;
    NSString *contactNumberThree;
    
    NSMutableDictionary *keyboardInfo;
    
    IBOutlet UIScrollView *contactScrollView;
    
    UINavigationBar *navBar;
    
    UIButton *customButton;
    
    NSString *frontViewPosition;
    
    IBOutlet UIButton *revealFrontControllerButton;
    
    IBOutlet UILabel *businessDescriptionPlaceHolderLabel;
    
    IBOutlet UILabel *businessNamePlaceHolderLabel;
    
    IBOutlet UIView *contentSubView;
    
    NSString *version ;
}

@property (nonatomic,strong) NSMutableArray *storeContactArray;

@property (nonatomic) int successCode;

@property(nonatomic) BOOL isFromOtherViews;

- (IBAction)dismissKeyBoard:(id)sender;

- (IBAction)registeredPhoneNumberBtnClicked:(id)sender;

- (IBAction)revealFrontController:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *ContactInfoTable;



@end
