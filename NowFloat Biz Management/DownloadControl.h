//
//  DownloadControl.h
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 13/08/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@protocol DownloadDelegate <NSObject>

@required

-(void) downloadDidSucceed:(NSDictionary *) imageDict;
-(void) downloadDidFail;

@end

@interface DownloadControl : NSObject <NSURLConnectionDelegate>
{
    id<DownloadDelegate> delegate;
    
    AppDelegate *appDelegate;
}

@property (nonatomic, strong) id <DownloadDelegate> delegate;

@property(nonatomic, retain) NSData *receivedData;

-(void)startDownload;


@end
