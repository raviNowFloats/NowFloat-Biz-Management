//
//  PostFBSuggestion.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/1/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostToFBSuggestion.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CreatePictureDeal.h"
#import "AppDelegate.h"

@interface PostFBSuggestion : UIViewController<UITableViewDataSource,UITableViewDelegate,PostToFBDelegate,FBLoginViewDelegate,pictureDealDelegate>

{
    NSMutableData *msgData;
    AppDelegate *appdelegate;
}

@property (strong, nonatomic) IBOutlet UITableView *FBpostTable;

@end
