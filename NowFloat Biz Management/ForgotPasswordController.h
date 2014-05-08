//
//  ForgotPasswordController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/7/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ForgotPasswordController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, UIAlertViewDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UITableView *forgotTableView;
    
    NSString *version;
}

- (IBAction)submitPassword:(id)sender;

@end
