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
    
    __weak IBOutlet UILabel *headLabel;
    
    IBOutlet UIView *submitView;
    
    __weak IBOutlet UIView *navigationBarView;
    
    NSString *version;
}

@property (strong, nonatomic) IBOutlet UIView *errorView;

- (IBAction)submitClicked:(id)sender;

@end
