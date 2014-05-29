//
//  LoginViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 05/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@protocol LoginDelegate<NSObject>

-(void)pushLoginViewController;

-(void)loginDidScucceed;

-(void)loginDidFail;

@end



@interface LoginViewController : UIViewController<UITextFieldDelegate>
{

    NSMutableData *data;
    

    IBOutlet UINavigationBar *navBar;
    
    UIButton *leftCustomButton;
    
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
    
    BOOL isFromEnterScreen;
    
    __weak IBOutlet UIButton *loginButton;
    
        
    IBOutlet UIView *loginSubView;
    
    IBOutlet UIView *enterSubView;
    
    IBOutlet UILabel *activitySubViewBgLabel;
    
    IBOutlet UIView *activityIndicatorSubView;
    
    IBOutlet UIImageView *loginImageViewBg;
    
    IBOutlet UIImageView *passwordImageViewBg;
    
    IBOutlet UILabel *orLabel;
    
    IBOutlet UIButton *backButton;
    
    IBOutlet UIImageView *boostIconImgView;
    
}
- (IBAction)forgotPasswordBtnClicked:(id)sender;

-(void)updateView;


- (IBAction)loginBtnClicked:(id)sender;


- (IBAction)dismissKeyboard:(id)sender;


- (IBAction)enterBtnClicked:(id)sender;


- (IBAction)logoutBtnClicked:(id)sender;


- (IBAction)loginViewBackBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;


-(void)cloudScroll;


@property (nonatomic, retain) id <LoginDelegate> _loginDelegate;


@end
