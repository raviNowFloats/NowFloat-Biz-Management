//
//  RegisterBusinessAddressViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 15/08/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface RegisterBusinessAddressViewController : UIViewController
{

    AppDelegate *appDelegate;
    
    IBOutlet UINavigationBar *navBar;
    
    UIButton *customCancelButton;
    
    UIButton *customNextButton;
    
    IBOutlet UIView *stepSubView;
    
}
@end
