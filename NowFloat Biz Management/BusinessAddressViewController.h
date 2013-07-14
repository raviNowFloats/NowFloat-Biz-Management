//
//  BusinessAddressViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BusinessAddressViewController : UIViewController<UIAlertViewDelegate,SWRevealViewControllerDelegate>
{

    IBOutlet UITextView *addressTextView;
    AppDelegate *appDelegate;
    NSString *frontViewPosition;
    
    IBOutlet UIButton *revealFrontControllerButton;

    IBOutlet UITextView *noteTextView;
    
}


- (IBAction)revealFrontController:(id)sender;

@end
