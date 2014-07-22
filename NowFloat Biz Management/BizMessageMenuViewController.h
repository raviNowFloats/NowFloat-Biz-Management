//
//  BizMessageMenuViewController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/17/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTumblrMenuView.h"

@interface BizMessageMenuViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *postUpdateView;
@property (strong, nonatomic) IBOutlet UITextView *postUpdateTextView;
- (IBAction)close:(id)sender;

@end
