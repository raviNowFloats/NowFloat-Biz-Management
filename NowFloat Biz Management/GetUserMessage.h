//
//  GetUserMessage.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 16/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol updateInboxDelegate <NSObject>

-(void)downloadFinished;

-(void)inboxMsgDownloadFailed;

@end


@interface GetUserMessage : NSObject

{

    AppDelegate *appDelegate;
    NSMutableData *receivedData;
    NSURL *getUserMessageUrl;
    id<updateInboxDelegate>delegate;
    
}

@property(nonatomic,strong)id<updateInboxDelegate>delegate;

-(void)fetchUserMessages:(NSURL *)url;


@end
