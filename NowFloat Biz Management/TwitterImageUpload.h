//
//  TwitterImageUpload.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 17/05/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "SA_OAuthTwitterController.h"


@class SA_OAuthTwitterEngine;

@interface TwitterImageUpload : NSObject<SA_OAuthTwitterControllerDelegate,SA_OAuthTwitterControllerDelegate>
{
    
    AppDelegate *appDelegate;
    
    NSUserDefaults *userDefaults;
    
    NSMutableData *recievedData;
    
    SA_OAuthTwitterEngine *_engine;
        
    NSString *messageUrl;
    
    
}


@property (nonatomic,strong)     NSString *tweetMessage;


-(void)postToTwitter:(NSString *)messageId messageString:(NSString *)msg;


@end
