//
//  LoginViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 05/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>




@interface LoginViewController : UIViewController<UITextFieldDelegate,MFMessageComposeViewControllerDelegate>
{

    NSMutableData *data;
    
    NSUserDefaults *userdetails;
    
    AppDelegate *appDelegate;

    __weak IBOutlet UITextField *loginNameTextField;

    __weak IBOutlet UITextField *passwordTextField;

    IBOutlet UIView *fetchingDetailsSubview;
    
    __weak IBOutlet UILabel *signUpLabel;
    
    __weak IBOutlet UILabel *getUrBizLabel;
    
    __weak IBOutlet UILabel *signUpBgLabel;
    
    NSMutableData *receivedData;
    
    bool isForLogin;
    
    bool isForStore;
    
    int loginSuccessCode;
    
    int fpDetailSuccessCode;
    
    BOOL isConnectedProperly;
    
    int imageNumber;
    
    UIImage *bgImage;
    
    __weak IBOutlet UIView *rightSubView;
    
    IBOutlet UIView *leftSubView;
    
    __weak IBOutlet UILabel *darkBgLabel;
    
    __weak IBOutlet UILabel *bgClientName;
    
    IBOutlet UIView *signUpSubView;
    
    __weak IBOutlet UIButton *enterButton;
    
    __weak IBOutlet UIButton *loginSelectionButton;
    
    __weak IBOutlet UILabel *loginLabel;
    
    __weak IBOutlet UIButton *signUpButton;
    
    __weak IBOutlet UIButton *loginAnotherButton;
    
    BOOL isLoginForAnotherUser;
    
    __weak IBOutlet UIButton *loginButton;
    
    
}

- (IBAction)loginButtonClicked:(id)sender;

- (IBAction)loginSelectionButtonClicked:(id)sender;

- (IBAction)closeButtonClicked:(id)sender;

- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)signUpButtonClicked:(id)sender;

- (IBAction)signUpCloseButtonClicked:(id)sender;

- (IBAction)enterButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;

- (IBAction)smsButtonClicked:(id)sender;

- (IBAction)callButtonClicked:(id)sender;

- (IBAction)loginAnotherButtonClicked:(id)sender;




@end
