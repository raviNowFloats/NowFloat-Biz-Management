//
//  ForgotPasswordController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/7/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ForgotPasswordController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UITableView *forgotTableView;
    
    IBOutlet UIView *submitView;
    
    NSString *version;
}

- (IBAction)submitPassword:(id)sender;

- (IBAction)needHelp:(id)sender;

- (IBAction)submitClicked:(id)sender;

@end
