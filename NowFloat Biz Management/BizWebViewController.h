//
//  BizWebViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 16/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface BizWebViewController : UIViewController
{

    AppDelegate *appDelegate;
    
    IBOutlet UINavigationBar *navBar;

    IBOutlet UIWebView *storeWebVIew;

    UIButton *customCancelButton;

    IBOutlet UIView *webViewActivityView;
}

@end
