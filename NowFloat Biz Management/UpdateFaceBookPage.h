//
//  UpdateFaceBookPage.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 22/04/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface UpdateFaceBookPage : NSObject
{
    AppDelegate *appDelegate;
    
    NSMutableURLRequest *request;
}

-(void)postToFaceBookPage:(NSString *)dealDescription;



@end
