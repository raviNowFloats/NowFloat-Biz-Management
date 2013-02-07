//
//  LoginViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 05/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController
{

    NSMutableData *data;
    
    __weak IBOutlet UITextField *loginNameTextField;

    __weak IBOutlet UITextField *passwordTextField;

    IBOutlet UIView *fetchingDetailsSubview;
    
    AppDelegate *appDelegate;
    
}

- (IBAction)loginButtonClicked:(id)sender;



@end
