//
//  NFActivityView.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 05/01/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFActivityView : UIView

@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) IBOutlet UILabel *activityTitleLabel;

@property (strong, nonatomic) NSString *activityTitle;

-(void)showCustomActivityView;

-(void)hideCustomActivityView;

@end
