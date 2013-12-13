//
//  UserSettingsWebViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 02/12/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSettingsWebViewController : UIViewController
{

    NSString *version;
    
    UILabel *headerLabel;
    
    IBOutlet UIWebView *contentWebView;

    IBOutlet UIView *activitySubView;
}


@property(nonatomic,strong) NSString *displayParameter;


@end
