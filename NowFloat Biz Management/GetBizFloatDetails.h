//
//  GetBizFloatDetails.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 29/05/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol getFloatDetailsProtocol <NSObject>

@optional
-(void)getKeyWords:(NSDictionary *)responseDictionary;

-(void)getActualImageUri:(NSDictionary *)responseDictionary;

-(void)getFloatDetailFailed;
@end

@interface GetBizFloatDetails : NSObject
{

    NSMutableDictionary *bizFloatDetailDictionary;
    
    NSMutableArray *keywordsArray;
    
    AppDelegate *appDelegate;
    
    NSMutableData *floatData;
    
    id<getFloatDetailsProtocol>delegate;

}


@property (nonatomic,strong) id<getFloatDetailsProtocol>delegate;


-(void)getBizfloatDetails:(NSString *)floatID;


@end
