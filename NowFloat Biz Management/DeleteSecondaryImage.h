//
//  DeleteSecondaryImage.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 23/06/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol DeleteSecondaryImageDelegate <NSObject>


-(void)updateSecondaryImage:(NSString *)responseCode;


@end


@interface DeleteSecondaryImage : NSObject
{
    
    AppDelegate *appDelegate;
    
    NSUserDefaults *userDefaults;
    

}


@property (nonatomic,strong) id<DeleteSecondaryImageDelegate>delegate;

-(void)deleteImage:(NSString *)imageName;
@end
