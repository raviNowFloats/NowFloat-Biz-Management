//
//  UpdateTwitter.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 16/05/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "SA_OAuthTwitterController.h"


@class SA_OAuthTwitterEngine;

@interface UpdateTwitter : NSObject<SA_OAuthTwitterControllerDelegate,SA_OAuthTwitterControllerDelegate>
{

    AppDelegate *appDelegate;
    
    NSUserDefaults *userDefaults;
    
    NSMutableData *recievedData;

    SA_OAuthTwitterEngine *_engine;

    NSString *truncatedString;

    NSString *messageUrl;
    
    NSString *tweetMessage;
    
}

-(void)postToTwitter:(NSString *)messageId messageString:(NSString *)msg;

@end
