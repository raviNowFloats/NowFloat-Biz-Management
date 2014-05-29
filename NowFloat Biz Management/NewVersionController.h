//
//  NewVersionController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/17/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//
#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface NewVersionController : UIViewController
{
    AppDelegate *appDelegate;
    
    NSString *version;
    
    IBOutlet UIScrollView *newScreenScroll;
    
    IBOutlet UILabel *doneButtonClick;
    
}
- (IBAction)moveBack:(id)sender;

@end
