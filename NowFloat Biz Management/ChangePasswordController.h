//
//  ChangePasswordController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/1/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ChangePasswordController : UIViewController< UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>{
    
    AppDelegate *appDelegate;
    
    IBOutlet UITableView *passwordTableView;
    
    NSString *version;
}

@end
