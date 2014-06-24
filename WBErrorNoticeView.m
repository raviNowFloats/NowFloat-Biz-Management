//
//  WBErrorNoticeView.m
//  NoticeView
//
//  Created by Tito Ciuro on 5/25/12.
//  Copyright (c) 2012 Tito Ciuro. All rights reserved.
//

#import "WBErrorNoticeView.h"
#import "WBNoticeView+ForSubclassEyesOnly.h"
#import "WBRedGradientView.h"
#import "UIColor+HexaString.h"


@implementation WBErrorNoticeView

+ (WBErrorNoticeView *)errorNoticeInView:(UIView *)view title:(NSString *)title message:(NSString *)message
{
    WBErrorNoticeView *notice = [[WBErrorNoticeView alloc]initWithView:view title:title refer:NO];
    
    notice.message = message;
    
    notice.sticky = NO;
    
    return notice;
}

- (void)show
{
    // Obtain the screen width
    CGFloat viewWidth = self.view.bounds.size.width;
    
    // Make and add the title label
   // float titleYOrigin = 10.0;
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100.0, 88.0, viewWidth-70.0, 14.0)];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    self.titleLabel.shadowColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:14.0];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.title;
    
    // Make the message label
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(100.0, 65.0, viewWidth - 70.0, 14.0)];
    self.messageLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    //self.messageLabel.textColor = [UIColor colorWithHexString:@"ffb900"];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.text = self.message;
    
    UILabel *subMessage = [[UILabel alloc] initWithFrame:CGRectMake(100.0,45.0,viewWidth - 70.0,16.0 )];
    subMessage.textColor = [UIColor whiteColor];
    subMessage.shadowOffset = CGSizeMake(0.0, -1.0);
    subMessage.shadowColor = [UIColor blackColor];
    subMessage.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
    subMessage.backgroundColor = [UIColor clearColor];
    subMessage.text = @"someone from";
    
    
    // Calculate the number of lines it'll take to display the text
    NSInteger numberOfLines = [[self.messageLabel lines]count];
    self.messageLabel.numberOfLines = numberOfLines;
    [self.messageLabel sizeToFit];
    //CGFloat messageLabelHeight = self.messageLabel.frame.size.height;
    
    CGRect r = self.messageLabel.frame;
    r.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    
    float noticeViewHeight = 0.0;

    // Add some bottom margin for the notice view
    noticeViewHeight += 151;
    
    // Make sure we hide completely the view, including its shadow
    float hiddenYOrigin = self.slidingMode == WBNoticeViewSlidingModeDown ? -noticeViewHeight - 20.0: self.view.bounds.size.height;
    
    // Make and add the notice view
    self.gradientView = [[WBRedGradientView alloc] initWithFrame:CGRectMake(0.0, hiddenYOrigin, viewWidth, noticeViewHeight + 10.0)];
    [self.view addSubview:self.gradientView];
    
    UIImageView *closeView = [[UIImageView alloc]initWithFrame:CGRectMake(290.0, 10.0, 15.0, 15.0)];
    closeView.image = [UIImage imageNamed:@"Cross.png"];
    closeView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *closeViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeViewBtn.frame = CGRectMake(280.0, 10.0, 25.0, 25.0);
    [closeViewBtn addTarget:self action:@selector(dismissNoticeInteractively) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    // Make and add the icon view
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(20.0, 45.0, 80.0, 60.0)];
    iconView.image = [UIImage imageNamed:@"Last-visitor-seen.png"];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
//    iconView.alpha = 0.8;
    
    //Add close view
    [self.gradientView addSubview:closeView];
    
    [self.gradientView addSubview:closeViewBtn];
    
    
    [self.gradientView addSubview:iconView];
    
    // Add the title label
    [self.gradientView addSubview:self.titleLabel];
    
    // Add the message label
    [self.gradientView addSubview:self.messageLabel];
    
    
    [self.gradientView addSubview:subMessage];
    
    // Add the drop shadow to the notice view
    CALayer *noticeLayer = self.gradientView.layer;
    noticeLayer.shadowColor = [[UIColor blackColor]CGColor];
    noticeLayer.shadowOffset = CGSizeMake(0.0, 3);
    noticeLayer.shadowOpacity = 0.50;
    noticeLayer.masksToBounds = NO;
    noticeLayer.shouldRasterize = YES;
    
    self.hiddenYOrigin = hiddenYOrigin;
    
    [self displayNotice];
}




@end
