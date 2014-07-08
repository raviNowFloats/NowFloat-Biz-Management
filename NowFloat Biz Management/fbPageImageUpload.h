//
//  fbPageImageUpload.h
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 01/07/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface fbPageImageUpload : NSObject
{
    AppDelegate *appDelegate;
}


-(void)postToPage:(NSString *)dealTitle withImage:(UIImage *)dealImage;

@end
