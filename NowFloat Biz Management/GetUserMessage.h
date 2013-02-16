//
//  GetUserMessage.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 16/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@interface GetUserMessage : NSObject
{

    AppDelegate *appDelegate;
    NSMutableData *receivedData;
}



-(void)fetchUserMessages:(NSURL *)url;


@end
