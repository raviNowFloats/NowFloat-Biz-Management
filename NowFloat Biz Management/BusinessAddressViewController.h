//
//  BusinessAddressViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BusinessAddressViewController : UIViewController<UIAlertViewDelegate>
{

    IBOutlet UITextView *addressTextView;
    AppDelegate *appDelegate;
        
}
@end
