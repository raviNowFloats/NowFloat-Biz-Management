//
//  WBSuccessNoticeView.m
//  NoticeView
//
//  Created by Tito Ciuro on 5/25/12.
//  Copyright (c) 2012 Tito Ciuro. All rights reserved.
//

#import "WBSuccessNoticeView.h"
#import "WBNoticeView+ForSubclassEyesOnly.h"
#import "WBBlueGradientView.h"
#import "WBRedGradientView.h"
#import "BizMessageViewController.h"
#import "Mixpanel.h"

@implementation WBSuccessNoticeView

+ (WBSuccessNoticeView *)successNoticeInView:(UIView *)view title:(NSString *)title message:(NSString *)msg
{
    WBSuccessNoticeView *notice = [[WBSuccessNoticeView alloc]initWithView:view title:title refer:YES];
    
    notice.message = msg;

    notice.sticky = YES;

    return notice;
}

- (void)show
{
    CGFloat viewWidth = self.view.bounds.size.width;
    
    // Make and add the title label
    // float titleYOrigin = 10.0;
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55.0, 25.0, viewWidth-70.0, 50.0)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    self.titleLabel.shadowColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.title;
    
    // Make the message label
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(55.0, 10.0, viewWidth - 70.0, 16.0)];
    self.messageLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.text = self.message;
    
    UILabel *subMessage = [[UILabel alloc] initWithFrame:CGRectMake(110.0,60.0,viewWidth - 70.0,16.0 )];
    subMessage.textColor = [UIColor whiteColor];
    subMessage.shadowOffset = CGSizeMake(0.0, -1.0);
    subMessage.shadowColor = [UIColor blackColor];
    subMessage.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
    subMessage.backgroundColor = [UIColor clearColor];
    subMessage.text = @"NowFloats Boost";
    
    
    
    UIButton *shareFriends = [UIButton buttonWithType:UIButtonTypeCustom];
    shareFriends.frame = CGRectMake(90, 95, 140, 40);
    shareFriends.backgroundColor = [UIColor colorFromHexCode:@"#ffb900"];
    shareFriends.tintColor = [UIColor blueColor];
    shareFriends.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    [shareFriends setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareFriends setTitle:@"Invite Friends" forState:UIControlStateNormal];
    [shareFriends addTarget:self action:@selector(referToFriends) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Calculate the number of lines it'll take to display the text
    NSInteger numberOfLines = [[self.messageLabel lines]count];
    self.messageLabel.numberOfLines = numberOfLines;
    [self.messageLabel sizeToFit];
    //CGFloat messageLabelHeight = self.messageLabel.frame.size.height;
    
    CGRect r = self.messageLabel.frame;
    r.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    
    float noticeViewHeight = 0.0;
    
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
    closeViewBtn.frame = CGRectMake(290.0, 0.0, 25.0, 25.0);
    [closeViewBtn addTarget:self action:@selector(dismissNoticeView) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.gradientView addSubview:closeViewBtn];
    
    //Add close view
    [self.gradientView addSubview:closeView];
    
    [self.gradientView addSubview:subMessage];
    
    // Add the title label
    [self.gradientView addSubview:self.titleLabel];
    
    // Add the message label
    [self.gradientView addSubview:self.messageLabel];
    
    
    [self.gradientView addSubview:shareFriends];
    
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

-(void)referToFriends
{
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    [mixPanel track:@"refer_A_friend_homeview"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isReferScreenHome"];
    [self dismissNotice];
   
}

-(void)dismissNoticeView
{
    [self dismissNotice];
}


@end
