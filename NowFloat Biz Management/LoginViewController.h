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
    
    NSMutableDictionary *validDictionary;
    
    int loginSuccessCode;
    
    int fpDetailSuccessCode;
    
}

- (IBAction)loginButtonClicked:(id)sender;



@end