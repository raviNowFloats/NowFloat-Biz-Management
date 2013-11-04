//
//  BusinessContactViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BusinessContactViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,SWRevealViewControllerDelegate>
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

    IBOutlet UIView *activitySubView;
    
    UINavigationBar *navBar;
    
    UIButton *customButton;
    
    NSString *frontViewPosition;
    
    IBOutlet UIButton *revealFrontControllerButton;

}


@property (nonatomic,strong) NSMutableArray *storeContactArray;
@property (nonatomic) int successCode;

- (IBAction)dismissKeyBoard:(id)sender;

- (IBAction)registeredPhoneNumberBtnClicked:(id)sender;

- (IBAction)revealFrontController:(id)sender;



@end
