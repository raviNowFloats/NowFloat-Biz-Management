//
//  FacebookImageUpload.h
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 26/06/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface FacebookImageUpload : NSObject
{
    AppDelegate *appDelegate;
}

@property(nonatomic,strong) NSString *postMessage;

-(void)posttoFacebookUser:(NSString *)message withImage:(UIImage *)postImage;


@end
