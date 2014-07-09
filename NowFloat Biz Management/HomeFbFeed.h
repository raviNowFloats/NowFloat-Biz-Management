//
//  HomeFbFeed.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/4/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostToFBSuggestion.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PostFBSuggestion.h"

@interface HomeFbFeed : UIViewController<PostToFBDelegate,FBLoginViewDelegate>
{
    NSMutableData *msgData;
    AppDelegate *appdelegate;
}
@end
