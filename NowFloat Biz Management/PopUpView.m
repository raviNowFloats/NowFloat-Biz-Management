//
//  PopUpView.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 22/11/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "PopUpView.h"


@interface PopUpView()
{

    float viewHeight;
    
}



@end

@implementation PopUpView
@synthesize titleLabel=_titleLabel;
@synthesize descriptionLabel=_descriptionLabel;
@synthesize popUpImage=_popUpImage;
@synthesize titleText=_titleText;
@synthesize descriptionText=_descriptionText;
@synthesize containerView=_containerView;
@synthesize popUpImageView=_popUpImageView;
@synthesize successBtnText=_successBtnText;
@synthesize cancelBtnText=_cancelBtnText;
@synthesize successBtn=_successBtn;
@synthesize cancelBtn=_cancelBtn;
@synthesize freeBadgeView=_freeBadgeView;
@synthesize badgeImage=_badgeImage;
@synthesize tag;
@synthesize delegate;

-(id)init
{
    PopUpView *customPopUp=[[[NSBundle mainBundle] loadNibNamed:@"PopUpView"
              owner:self
            options:nil]
            lastObject];
    
    if ([customPopUp isKindOfClass:[customPopUp class]])
    {
        return customPopUp;
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
    
    _titleLabel.text=_titleText;
    _descriptionLabel.text=_descriptionText;
    _popUpImageView.image=_popUpImage;
    _freeBadgeView.image=_badgeImage;
    
    popUpDetails=[[NSMutableDictionary  alloc]init];
    
    [popUpDetails setValue:[NSNumber numberWithInt:tag] forKey:@"tag"];
    
    [_successBtn setTitle:_successBtnText.uppercaseString forState:UIControlStateNormal];

    [_cancelBtn setTitle:_cancelBtnText.uppercaseString forState:UIControlStateNormal];
/*
    self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:
     ^
    {
        self.containerView.transform = CGAffineTransformIdentity;
    }
        completion:^(BOOL finished)
    {

    }];
*/
    
    self.containerView.alpha = 1;
    
    [UIView animateWithDuration:0.5 animations:^{self.containerView.alpha = 1.0;}];
    
    self.containerView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.8],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = 0.5;
    bounceAnimation.removedOnCompletion = NO;
    [self.containerView.layer addAnimation:bounceAnimation forKey:@"bounce"];
    
    self.containerView.layer.transform = CATransform3DIdentity;
}

-(void)showPopUpView
{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
}

-(void)removePopupView
{
    [self.bgLabel setHidden:YES];
    [UIView beginAnimations:@"hideAlert" context:nil];
    [UIView setAnimationDelegate:self];
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha = 0;    
    [UIView commitAnimations];
    [self performSelector:@selector(hidePopUp) withObject:Nil afterDelay:1.0];
}


-(void)hidePopUp
{
    [self removeFromSuperview];
}


- (IBAction)successBtnClicked:(id)sender
{
    [delegate performSelector:@selector(successBtnClicked:) withObject:popUpDetails];
    [self removePopupView];
}

- (IBAction)cancelBtnClicked:(id)sender
{
    [delegate performSelector:@selector(cancelBtnClicked:) withObject:popUpDetails];
    [self removePopupView];
}

@end
