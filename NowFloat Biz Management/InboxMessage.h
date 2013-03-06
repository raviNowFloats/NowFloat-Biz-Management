//
//  InboxMessage.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 03/03/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@interface InboxMessage : NSObject

{
    
    AppDelegate *appDelegate;
    NSMutableData *receivedData;
    NSURL *getUserMessageUrl;
}



-(void)fetchUserMessages:(NSURL *)url;


@end
