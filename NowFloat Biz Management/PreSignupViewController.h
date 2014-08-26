//
//  PreSignupViewController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 8/12/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "SuggestBusinessDomain.h"

@interface PreSignupViewController : UIViewController<FBLoginViewDelegate,UIActionSheetDelegate,SuggestBusinessDomainDelegate>
{
     AppDelegate *appDelegate;
     NSUserDefaults *userDefaults;
}
@property (strong, nonatomic) IBOutlet FBLoginView *facebookLogin;

- (IBAction)mailRegisteration:(id)sender;
- (IBAction)goBack:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *backLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong,nonatomic)  UIActivityIndicatorView *activity;
@end
