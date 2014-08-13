//
//  AsyncDowloadImages.h
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 13/08/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol AsyncDownloadDelegate <NSObject>

-(void) AsyncDownloadDidFinishWithImage: (UIImage *)downloadedImage atIndex:(NSNumber *) imageIndex;
-(void) AsyncDownloadDidFail:(NSNumber *) imageIndex;


@end

@interface AsyncDowloadImages : NSObject
{
    id <AsyncDownloadDelegate> delegate;
    
    AppDelegate *appDelegate;
    
}

@property (strong, nonatomic) id <AsyncDownloadDelegate> delegate;

-(void) downloadImage:(NSString *) imageUrl andIndex:(NSNumber *) imageIndex;

@end
