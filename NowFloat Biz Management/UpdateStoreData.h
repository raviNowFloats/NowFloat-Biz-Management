//
//  UpdateStoreData.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 11/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UpdateStoreData : NSObject
{

    NSMutableData *receivedData;

}
@property (nonatomic,strong) NSMutableDictionary *uploadDictionary;
@property (nonatomic,strong) NSMutableArray *uploadArray;

-(void)updateStore:(NSMutableDictionary *)dictionary;


@end
