//
//  CreatePictureDeal.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 09/04/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"



@protocol pictureDealDelegate <NSObject>


-(void)successOnDealUpload;

-(void)failedOnDealUpload;

@end



@interface CreatePictureDeal : NSObject{
    
    AppDelegate *appDelegate;
        
    NSString *dealStartDate;
    
    NSString *dealTitle;
    
    NSMutableData *receivedData;
    
    BOOL isFbShare;
    
    BOOL isTwitterShare;
    
}


@property (nonatomic,strong) NSMutableDictionary *offerDetailDictionary;

@property (nonatomic,strong)     id<pictureDealDelegate>dealUploadDelegate;



-(void)createDeal:(NSMutableDictionary *)dictionary postToTwitter:(BOOL)isTwitter;
@end
