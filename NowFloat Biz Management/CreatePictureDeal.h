//
//  CreatePictureDeal.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 09/04/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "PostImageViewController.h"

@interface CreatePictureDeal : NSObject
{
    AppDelegate *appDelegate;
    NSString *dealStartDate;
    NSString *dealTitle;
    NSMutableData *receivedData;
    BOOL isFbShare;
    
}

@property (nonatomic,strong) PostImageViewController *_postImageViewController;
@property (nonatomic,strong) NSMutableDictionary *offerDetailDictionary;



-(void)createDeal:(NSMutableDictionary *)dictionary;
@end
