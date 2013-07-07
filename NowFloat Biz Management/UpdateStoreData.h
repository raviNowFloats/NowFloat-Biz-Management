//
//  UpdateStoreData.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 11/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@protocol updateStoreDelegate <NSObject>

-(void)storeUpdateComplete;

-(void)storeUpdateFailed;

@end



@interface UpdateStoreData : NSObject
{

    NSMutableData *receivedData;
    AppDelegate *appDelegate;
    id<updateStoreDelegate>delegate;
    
}

@property (nonatomic,strong) NSMutableDictionary *uploadDictionary;
@property (nonatomic,strong) NSMutableArray *uploadArray;
@property (nonatomic,retain)     id<updateStoreDelegate>delegate;
-(void)updateStore:(NSMutableArray *)array;





@end
