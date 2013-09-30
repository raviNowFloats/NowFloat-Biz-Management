//
//  FpCategoryController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 30/07/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"



@protocol FpCategoryDelegate <NSObject>

-(void)fpCategoryDidFinishDownload :(NSArray *)downloadedArray;

-(void)fpCategoryDidFailWithError;

@end


@interface FpCategoryController : NSObject
{

    AppDelegate *appDelegate;
    
    NSUserDefaults *userDefaults;
    
    NSMutableData *receivedData;

}


@property(nonatomic,strong) id<FpCategoryDelegate>delegate;

-(void)downloadFpCategoryList;


@end
