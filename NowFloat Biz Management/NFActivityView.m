//
//  NFActivityView.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 05/01/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "NFActivityView.h"
#import <QuartzCore/QuartzCore.h>
@implementation NFActivityView
@synthesize containerView=_containerView;
@synthesize activityTitleLabel=_activityTitleLabel;
@synthesize activityTitle=_activityTitle;

-(id)init
{
    NFActivityView *customActivity=[[[NSBundle mainBundle] loadNibNamed:@"NFActivityView"
            owner:self
            options:nil]
            lastObject];
    
    if ([customActivity isKindOfClass:[customActivity class]])
    {
        return customActivity;
    }
    else
    {
        return nil;
    }

}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _containerView.center=self.window.center;
    
    _activityTitleLabel.text=[NSString stringWithFormat:@"%@...",_activityTitle];
    
    [_containerView.layer setCornerRadius:6.0 ];
}

-(void)showCustomActivityView
{
    [[[[UIApplication sharedApplication] delegate] window]addSubview:self ];
}


-(void)hideCustomActivityView
{
    [self removeFromSuperview];
}



@end
