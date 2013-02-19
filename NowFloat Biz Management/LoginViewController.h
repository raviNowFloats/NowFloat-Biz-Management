//
//  LoginViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 05/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{

    NSMutableData *data;
    
    __weak IBOutlet UITextField *loginNameTextField;

    __weak IBOutlet UITextField *passwordTextField;

    IBOutlet UIView *fetchingDetailsSubview;
    
    AppDelegate *appDelegate;
    
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
    
    NSUserDefaults *userdetails;
    
}

- (IBAction)loginButtonClicked:(id)sender;

- (IBAction)loginSelectionButtonClicked:(id)sender;

- (IBAction)closeButtonClicked:(id)sender;

- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)signUpButtonClicked:(id)sender;

- (IBAction)signUpCloseButtonClicked:(id)sender;

- (IBAction)enterButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;


@end
