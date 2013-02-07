//
//  BusinessContactViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BusinessContactViewController : UIViewController<UITextFieldDelegate>
{

    __weak IBOutlet UITextField *mobileNumTextField;

    __weak IBOutlet UITextField *landlineNumTextField;

    __weak IBOutlet UITextField *websiteTextField;
    
    __weak IBOutlet UITextField *emailTextField;
    
    int textFieldTag;
    
    AppDelegate *appDelegate;
}


@property (nonatomic,strong) NSMutableArray *storeContactArray;


@end
