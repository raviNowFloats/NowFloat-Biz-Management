//
//  RegisterContactDetailsViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 15/08/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface RegisterContactDetailsViewController : UIViewController

{
    AppDelegate *appDelegate;
    
    IBOutlet UINavigationBar *navBar;
    
    UIButton *customCancelButton;
    
    UIButton *customNextButton;
    
}

@end
