//
//  GetFpDetails.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 13/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"



@protocol updateDelegate <NSObject>

-(void)downloadFinished;

-(void)downloadFailedWithError;

@end



@interface GetFpDetails : NSObject
{

    NSMutableData *receivedData;
    AppDelegate *appDelegate;
    NSData *msgData;
    NSUserDefaults *userdetails;
    NSMutableArray *imageFileArray;
    id<updateDelegate>delegate;

    
}

@property(nonatomic,strong) id<updateDelegate>delegate;


-(void)fetchFpDetail;


@end
