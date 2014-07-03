//
//  PostToFBSuggestion.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/1/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@class FBLoginView;
@protocol PostToFBDelegate <NSObject>

-(void)posttoFBSuggestion:(NSMutableDictionary *)fb;

-(void)failedToGetFeedDetails;

@end

@interface PostToFBSuggestion : NSObject<FBLoginViewDelegate>
{
    id<PostToFBDelegate>delegate;
    
    AppDelegate *appDelegate;
        NSMutableData *msgData;
    
}

@property(strong, nonatomic) id<PostToFBDelegate>delegate;

-(void)getLatestFeedFB:(NSString*)url;
@end
