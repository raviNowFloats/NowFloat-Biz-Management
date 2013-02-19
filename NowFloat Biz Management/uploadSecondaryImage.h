//
//  uploadSecondaryImage.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 19/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@interface uploadSecondaryImage : NSObject
{
    
    NSUserDefaults *userDetails;
    AppDelegate *appDelegate;
}

-(void)uploadImage:(NSData *)imageData uuid:(NSString *)uniqueId numberOfChunks:(int)numberOfChunks currentChunk:(int)currentChunk;



@end
